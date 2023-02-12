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
    this.stateManagement,
    this.screenTransitionAnimation,
    this.hideNavigationBar = false,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
  }) : super(key: key);

  final Widget tabBar;

  final Widget? drawer;

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
        drawer: widget.drawer,
        body: Builder(
          builder: (context) => _TabSwitchingView(
            currentTabIndex: widget.controller.index,
            tabCount: widget.tabCount,
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
    Key? key,
  })  : assert(tabCount != null && tabCount > 0, "tabCount must be greater 0"),
        super(key: key);

  final int currentTabIndex;
  final int? tabCount;
  final IndexedWidgetBuilder tabBuilder;
  final bool? stateManagement;
  final ScreenTransitionAnimation? screenTransitionAnimation;

  @override
  _TabSwitchingViewState createState() => _TabSwitchingViewState();
}

class _TabSwitchingViewState extends State<_TabSwitchingView>
    with TickerProviderStateMixin {
  final List<bool> shouldBuildTab = <bool>[];
  final List<FocusScopeNode> tabFocusNodes = <FocusScopeNode>[];
  final List<FocusScopeNode> discardedNodes = <FocusScopeNode>[];
  late List<AnimationController?> _animationControllers;
  late List<Animation<double>?> _animations;
  int? _tabCount;
  late int _currentTabIndex;
  late int _previousTabIndex;
  bool? _showAnimation;
  double? _animationValue;
  Curve? _animationCurve;
  Key? key;

  @override
  void initState() {
    super.initState();
    shouldBuildTab.addAll(List<bool>.filled(widget.tabCount!, false));
    _currentTabIndex = widget.currentTabIndex;
    _previousTabIndex = widget.currentTabIndex;
    _tabCount = widget.tabCount;
    _showAnimation = widget.screenTransitionAnimation!.animateTabTransition;

    if (!widget.stateManagement!) {
      key = UniqueKey();
    }

    _initAnimationControllers();
  }

  void _initAnimationControllers() {
    if (widget.screenTransitionAnimation!.animateTabTransition) {
      _animationControllers =
          List<AnimationController?>.filled(widget.tabCount!, null);
      _animations = List<Animation<double>?>.filled(widget.tabCount!, null);
      _animationCurve = widget.screenTransitionAnimation!.curve;
      for (int i = 0; i < widget.tabCount!; ++i) {
        _animationControllers[i] = AnimationController(
          vsync: this,
          duration: widget.screenTransitionAnimation!.duration,
        );
        _animations[i] = Tween<double>(begin: 0, end: 0)
            .chain(CurveTween(curve: widget.screenTransitionAnimation!.curve))
            .animate(_animationControllers[i]!);
      }

      for (int i = 0; i < widget.tabCount!; ++i) {
        _animationControllers[i]!.addListener(() {
          if (_animationControllers[i]!.isCompleted) {
            _previousTabIndex = _currentTabIndex;
            setState(() {
              if (!widget.stateManagement!) {
                key = UniqueKey();
              }
            });
          }
        });
      }
    }
  }

  void _focusActiveTab() {
    if (widget.screenTransitionAnimation!.animateTabTransition) {
      _startAnimation();
    }
    if (tabFocusNodes.length != widget.tabCount) {
      if (tabFocusNodes.length > widget.tabCount!) {
        discardedNodes.addAll(tabFocusNodes.sublist(widget.tabCount!));
        tabFocusNodes.removeRange(widget.tabCount!, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            widget.tabCount! - tabFocusNodes.length,
            (index) => FocusScopeNode(
              debugLabel:
                  "$CupertinoTabScaffold Tab ${index + tabFocusNodes.length}",
            ),
          ),
        );
      }
    }
    FocusScope.of(context).setFirstFocus(tabFocusNodes[_currentTabIndex]);
  }

  /// Starts the animation from one tab to another by shifting the previous
  /// tab to the left/right and making the new tab appear from left/right.
  /// This method must only be called once when [_previousTabIndex]
  /// and [_currentTabIndex] change.
  void _startAnimation() {
    if (_previousTabIndex == _currentTabIndex) {
      return;
    }
    _animationControllers[_previousTabIndex]!.reset();
    _animations[_previousTabIndex] = Tween<double>(
      begin: 0,
      end: (_previousTabIndex > _currentTabIndex)
          ? _animationValue
          : -_animationValue!,
    )
        .chain(CurveTween(curve: widget.screenTransitionAnimation!.curve))
        .animate(_animationControllers[_previousTabIndex]!);

    _animationControllers[_currentTabIndex]!.reset();
    _animations[_currentTabIndex] = Tween<double>(
      begin: (_previousTabIndex > _currentTabIndex)
          ? -_animationValue!
          : _animationValue!,
      end: 0,
    )
        .chain(CurveTween(curve: widget.screenTransitionAnimation!.curve))
        .animate(_animationControllers[_currentTabIndex]!);

    _animationControllers[_previousTabIndex]!.forward();
    _animationControllers[_currentTabIndex]!.forward();
    return;
  }

  Widget _buildScreens() => Stack(
        fit: StackFit.expand,
        children: List<Widget>.generate(widget.tabCount!, (index) {
          final bool active = index == _currentTabIndex ||
              (widget.screenTransitionAnimation!.animateTabTransition &&
                  index == _previousTabIndex);
          shouldBuildTab[index] = active || shouldBuildTab[index];

          return Offstage(
            offstage: !active,
            child: TickerMode(
              enabled: active,
              child: FocusScope(
                node: tabFocusNodes[index],
                child: Builder(
                  builder: (context) => shouldBuildTab[index]
                      ? (widget.screenTransitionAnimation!.animateTabTransition
                          ? AnimatedBuilder(
                              animation: _animations[index]!,
                              builder: (context, child) => Transform.translate(
                                offset: Offset(_animations[index]!.value, 0),
                                child: widget.tabBuilder(context, index),
                              ),
                            )
                          : widget.tabBuilder(context, index))
                      : Container(),
                ),
              ),
            ),
          );
        }),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _focusActiveTab();
  }

  @override
  void didUpdateWidget(_TabSwitchingView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final int lengthDiff = widget.tabCount! - shouldBuildTab.length;
    if (lengthDiff > 0) {
      shouldBuildTab.addAll(List<bool>.filled(lengthDiff, false));
    } else if (lengthDiff < 0) {
      shouldBuildTab.removeRange(widget.tabCount!, shouldBuildTab.length);
    }
    if (widget.currentTabIndex != oldWidget.currentTabIndex) {
      _currentTabIndex = widget.currentTabIndex;
      _previousTabIndex = oldWidget.currentTabIndex;
      _focusActiveTab();
    }
  }

  @override
  void dispose() {
    for (FocusScopeNode focusScopeNode in tabFocusNodes) {
      focusScopeNode.dispose();
    }
    for (FocusScopeNode focusScopeNode in discardedNodes) {
      focusScopeNode.dispose();
    }
    if (widget.screenTransitionAnimation!.animateTabTransition) {
      for (AnimationController? controller in _animationControllers) {
        controller!.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationValue = MediaQuery.of(context).size.width;
    if (_tabCount != widget.tabCount) {
      _tabCount = widget.tabCount;
      _initAnimationControllers();
    }
    if (widget.screenTransitionAnimation!.animateTabTransition &&
            _animationControllers.first!.duration !=
                widget.screenTransitionAnimation!.duration ||
        _animationCurve != widget.screenTransitionAnimation!.curve) {
      _initAnimationControllers();
    }
    if (_showAnimation !=
        widget.screenTransitionAnimation!.animateTabTransition) {
      _showAnimation = widget.screenTransitionAnimation!.animateTabTransition;
      key = UniqueKey();
    }
    return widget.stateManagement!
        ? _buildScreens()
        : KeyedSubtree(
            key: key,
            child: _buildScreens(),
          );
  }
}
