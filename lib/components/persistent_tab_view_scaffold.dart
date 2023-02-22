part of persistent_bottom_nav_bar_v2;

class PersistentTabViewScaffold extends StatefulWidget {
  const PersistentTabViewScaffold({
    required this.tabBar,
    required this.tabBuilder,
    required this.controller,
    required this.tabCount,
    Key? key,
    this.opacities = const [],
    this.backgroundColor,
    this.avoidBottomPadding = true,
    this.margin = EdgeInsets.zero,
    this.resizeToAvoidBottomInset = true,
    this.stateManagement = false,
    this.gestureNavigationEnabled = false,
    this.screenTransitionAnimation,
    this.hideNavigationBar = false,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.drawerEdgeDragWidth,
  }) : super(key: key);

  final Widget tabBar;

  final Widget? drawer;

  final double? drawerEdgeDragWidth;

  final PersistentTabController controller;

  final IndexedWidgetBuilder tabBuilder;

  final Color? backgroundColor;

  final bool resizeToAvoidBottomInset;

  final int tabCount;

  final bool avoidBottomPadding;

  final EdgeInsets margin;

  final List<double> opacities;

  final bool hideNavigationBar;

  final bool stateManagement;

  final bool gestureNavigationEnabled;

  final NavBarOverlap navBarOverlap;

  final ScreenTransitionAnimation? screenTransitionAnimation;

  final Widget? floatingActionButton;

  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  State<PersistentTabViewScaffold> createState() =>
      _PersistentTabViewScaffoldState();
}

class _PersistentTabViewScaffoldState extends State<PersistentTabViewScaffold>
    with TickerProviderStateMixin {
  late bool _navBarFullyShown;
  late final AnimationController _hideNavBarAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );
  late final Animation<Offset> slideAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 1),
  ).animate(
    CurvedAnimation(
      parent: _hideNavBarAnimationController,
      curve: Curves.ease,
    ),
  );

  @override
  void initState() {
    super.initState();
    _navBarFullyShown = !widget.hideNavigationBar;
    if (widget.hideNavigationBar) {
      _hideNavBarAnimationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(PersistentTabViewScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hideNavigationBar != oldWidget.hideNavigationBar) {
      if (widget.hideNavigationBar) {
        _hideNavBarAnimationController.forward();
        setState(() {
          _navBarFullyShown = false;
        });
      } else {
        _hideNavBarAnimationController.reverse().whenComplete(() {
          setState(() {
            _navBarFullyShown = true;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _hideNavBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: widget.controller.scaffoldKey,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        backgroundColor: widget.backgroundColor,
        extendBody: true,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        drawer: widget.drawer,
        body: Builder(
          builder: (context) => _TabSwitchingView(
            currentTabIndex: widget.controller.index,
            tabCount: widget.tabCount,
            controller: widget.controller,
            gestureNavigationEnabled: widget.gestureNavigationEnabled,
            tabBuilder: (context, index) {
              double overlap = 0;
              final bool isNotOpaque = index > widget.opacities.length
                  ? false
                  : widget.opacities[index] != 1.0;
              if ((isNotOpaque &&
                      widget.navBarOverlap.fullOverlapWhenNotOpaque) ||
                  !_navBarFullyShown ||
                  widget.margin.bottom != 0) {
                overlap = double.infinity;
              } else {
                overlap = widget.navBarOverlap.overlap;
              }

              return PersistentTab(
                bottomMargin: max(
                  0,
                  MediaQuery.of(context).padding.bottom - overlap,
                ),
                child: widget.tabBuilder(context, index),
              );
            },
            stateManagement: widget.stateManagement,
            screenTransitionAnimation: widget.screenTransitionAnimation,
          ),
        ),
        bottomNavigationBar: SlideTransition(
          position: slideAnimation,
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: Padding(
              padding: widget.margin,
              child: MediaQuery.removePadding(
                context: context,
                // safespace should be ignored, so the bottom inset is removed before it could be applied by any safearea child (e.g. in DecoratedNavBar).
                removeBottom: !widget.avoidBottomPadding,
                child: SafeArea(
                  top: false,
                  right: false,
                  left: false,
                  bottom:
                      widget.avoidBottomPadding && widget.margin.bottom != 0,
                  child: widget.tabBar,
                ),
              ),
            ),
          ),
        ),
      );
}

class PersistentTab extends StatelessWidget {
  const PersistentTab({
    Key? key,
    this.child,
    this.bottomMargin = 0.0,
  }) : super(key: key);

  final Widget? child;
  final double bottomMargin;

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(bottom: bottomMargin),
        child: child,
      );
}

class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    required this.currentTabIndex,
    required this.tabCount,
    required this.stateManagement,
    required this.tabBuilder,
    required this.screenTransitionAnimation,
    required this.controller,
    required this.gestureNavigationEnabled,
    Key? key,
  })  : assert(tabCount > 0, "tabCount must be greater 0"),
        super(key: key);

  final int currentTabIndex;
  final int tabCount;
  final IndexedWidgetBuilder tabBuilder;
  final bool stateManagement;
  final ScreenTransitionAnimation? screenTransitionAnimation;
  final PersistentTabController controller;
  final bool gestureNavigationEnabled;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.currentTabIndex);
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentTabIndex != oldWidget.currentTabIndex &&
        _pageController.page == _pageController.page?.roundToDouble()) {
      _pageController.animateToPage(
        widget.currentTabIndex,
        duration: widget.screenTransitionAnimation?.duration ?? Duration.zero,
        curve: widget.screenTransitionAnimation?.curve ?? Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PageView(
        controller: _pageController,
        scrollBehavior: const ScrollBehavior().copyWith(
          overscroll: false,
        ),
        physics: widget.gestureNavigationEnabled
            ? null
            : const NeverScrollableScrollPhysics(),
        children: List.generate(
          widget.tabCount,
          (index) => FocusScope(
            node: FocusScopeNode(),
            child: widget.stateManagement
                ? KeepAlivePage(
                    child: widget.tabBuilder(context, index),
                  )
                : widget.tabBuilder(context, index),
          ),
        ),
        onPageChanged: (i) {
          FocusManager.instance.primaryFocus?.unfocus();
          widget.controller.index = i;
        },
      );
}

class KeepAlivePage extends StatefulWidget {
  const KeepAlivePage({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  _KeepAlivePageState createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
