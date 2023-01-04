part of persistent_bottom_nav_bar_v2;

class PersistentTabViewScaffold extends StatefulWidget {
  PersistentTabViewScaffold({
    Key? key,
    required this.tabBar,
    required this.tabBuilder,
    required this.controller,
    required this.tabCount,
    this.opacities = const [],
    this.backgroundColor,
    this.avoidBottomPadding = true,
    this.margin = EdgeInsets.zero,
    this.resizeToAvoidBottomInset = true,
    this.stateManagement,
    this.screenTransitionAnimation,
    this.hideNavigationBar = false,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  final Widget tabBar;

  final PersistentTabController controller;

  final IndexedWidgetBuilder tabBuilder;

  final Color? backgroundColor;

  final bool resizeToAvoidBottomInset;

  final int tabCount;

  final bool avoidBottomPadding;

  final EdgeInsets margin;

  final List<double> opacities;

  final bool hideNavigationBar;

  final bool? stateManagement;

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
    duration: Duration(milliseconds: 500),
  );
  late final Animation<Offset> slideAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(0, 1),
  ).animate(CurvedAnimation(
    parent: _hideNavBarAnimationController,
    curve: Curves.ease,
  ));

  initState() {
    super.initState();
    _navBarFullyShown = !widget.hideNavigationBar;
    if (widget.hideNavigationBar) {
      _hideNavBarAnimationController.value = 1.0;
    }
  }

  didUpdateWidget(PersistentTabViewScaffold oldWidget) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      backgroundColor: widget.backgroundColor,
      extendBody: true,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      body: Builder(builder: (context) {
        return _TabSwitchingView(
          currentTabIndex: widget.controller.index,
          tabCount: widget.tabCount,
          tabBuilder: (context, index) {
            double overlap = 0.0;
            bool isNotOpaque = index > widget.opacities.length
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
              child: widget.tabBuilder(context, index),
              bottomMargin:
                  max(0, MediaQuery.of(context).padding.bottom - overlap),
            );
          },
          stateManagement: widget.stateManagement,
          screenTransitionAnimation: widget.screenTransitionAnimation,
        );
      }),
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
                bottom: widget.avoidBottomPadding && widget.margin.bottom != 0,
                child: widget.tabBar,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PersistentTab extends StatelessWidget {
  final Widget? child;
  final double bottomMargin;

  PersistentTab({
    this.child,
    this.bottomMargin = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomMargin),
      child: child,
    );
  }
}

class _TabSwitchingView extends StatefulWidget {
  const _TabSwitchingView({
    Key? key,
    required this.currentTabIndex,
    required this.tabCount,
    required this.stateManagement,
    required this.tabBuilder,
    required this.screenTransitionAnimation,
  })  : assert(tabCount != null && tabCount > 0),
        super(key: key);

  final int currentTabIndex;
  final int? tabCount;
  final IndexedWidgetBuilder tabBuilder;
  final bool? stateManagement;
  final ScreenTransitionAnimation? screenTransitionAnimation;

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
    if (widget.currentTabIndex != oldWidget.currentTabIndex) {
      _pageController.animateToPage(
        widget.currentTabIndex,
        duration:
            widget.screenTransitionAnimation?.duration ?? Duration(seconds: 0),
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
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: List.generate(widget.tabCount!, (int index) {
        return FocusScope(
          node: FocusScopeNode(),
          child: KeepAlivePage(
            child: widget.tabBuilder(context, index),
          ),
        );
      }),
      onPageChanged: (i) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
    );
  }
}

class KeepAlivePage extends StatefulWidget {
  KeepAlivePage({
    Key? key,
    required this.child,
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
