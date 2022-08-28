part of persistent_bottom_nav_bar_v2;

/// Navigation bar controller for `PersistentTabView`.
class PersistentTabController extends ChangeNotifier {
  PersistentTabController({int initialIndex = 0})
      : _index = initialIndex,
        assert(initialIndex >= 0);

  int get index => _index;
  int _index;

  set index(int value) {
    assert(value >= 0);
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }

  jumpToTab(int value) {
    assert(value >= 0);
    if (_index == value) {
      return;
    }
    _index = value;
    notifyListeners();
  }
}

class PersistentTabScaffold extends StatelessWidget {
  PersistentTabScaffold({
    Key? key,
    required this.tabBar,
    required this.tabBuilder,
    this.controller,
    this.opacities = const [],
    this.backgroundColor,
    this.confineInSafeArea = true,
    this.margin = EdgeInsets.zero,
    this.resizeToAvoidBottomInset = true,
    this.stateManagement,
    this.isOpaque = false,
    this.screenTransitionAnimation,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.itemCount,
    this.hideNavigationBar = false,
    this.colorBehindNavBar = Colors.transparent,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.animatePadding = false,
  }) : super(key: key);

  final Widget tabBar;

  final PersistentTabController? controller;

  final IndexedWidgetBuilder tabBuilder;

  final Color? backgroundColor;

  final bool resizeToAvoidBottomInset;

  final int? itemCount;

  final double navBarHeight;

  final bool isOpaque;

  final bool confineInSafeArea;

  final EdgeInsets margin;

  final List<double> opacities;

  final bool hideNavigationBar;

  final Color colorBehindNavBar;

  final bool? stateManagement;

  final NavBarOverlap navBarOverlap;

  final ScreenTransitionAnimation? screenTransitionAnimation;

  final bool animatePadding;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData existingMediaQuery = MediaQuery.of(context);
    MediaQueryData newMediaQuery = MediaQuery.of(context);

    Widget content = _TabSwitchingView(
        key: Key("TabSwitchingView"),
        currentTabIndex: controller!.index,
        tabCount: itemCount,
        tabBuilder: tabBuilder,
        stateManagement: stateManagement,
        screenTransitionAnimation: screenTransitionAnimation,
        backgroundColor:
            Colors.transparent //tabBar.navBarEssentials!.backgroundColor,
        );
    double contentPadding = 0.0;

    if (resizeToAvoidBottomInset) {
      newMediaQuery = newMediaQuery.removeViewInsets(removeBottom: true);
    }

    double overlap = 0.0;
    bool isNotOpaque = controller!.index > opacities.length
        ? false
        : opacities[controller!.index] != 1.0;
    if (isNotOpaque && navBarOverlap.fullOverlapWhenNotOpaque) {
      overlap = double.infinity;
    } else {
      overlap = navBarOverlap.overlap;
    }

    if (hideNavigationBar) {
      contentPadding = 0.0;
    } else {
      contentPadding = max(0, navBarHeight - overlap);
    }

    content = MediaQuery(
      data: newMediaQuery,
      child: AnimatedContainer(
        duration: Duration(
            milliseconds: animatePadding || hideNavigationBar
                ? hideNavigationBar
                    ? 200
                    : 400
                : 0),
        curve: hideNavigationBar ? Curves.linear : Curves.easeIn,
        color: colorBehindNavBar,
        padding: EdgeInsets.only(bottom: contentPadding),
        child: content,
      ),
    );

    return Stack(
      children: <Widget>[
        // TODO: The previous content will change because the safearea gets removed for all tabs
        SafeArea(
          top: false,
          right: false,
          left: false,
          bottom: isNotOpaque || hideNavigationBar
              ? false
              : confineInSafeArea && margin.bottom == 0,
          child: content,
        ),
        MediaQuery(
          data: existingMediaQuery.copyWith(textScaleFactor: 1),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: tabBar,
          ),
        ),
      ],
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
    required this.backgroundColor,
  })  : assert(tabCount != null && tabCount > 0),
        super(key: key);

  final int currentTabIndex;
  final int? tabCount;
  final IndexedWidgetBuilder tabBuilder;
  final bool? stateManagement;
  final ScreenTransitionAnimation? screenTransitionAnimation;
  final Color? backgroundColor;

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

  _initAnimationControllers() {
    if (widget.screenTransitionAnimation!.animateTabTransition) {
      _animationControllers =
          List<AnimationController?>.filled(widget.tabCount!, null);
      _animations = List<Animation<double>?>.filled(widget.tabCount!, null);
      _animationCurve = widget.screenTransitionAnimation!.curve;
      for (int i = 0; i < widget.tabCount!; ++i) {
        _animationControllers[i] = AnimationController(
            vsync: this, duration: widget.screenTransitionAnimation!.duration);
        _animations[i] = Tween(begin: 0.0, end: 0.0)
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
    if (widget.screenTransitionAnimation!.animateTabTransition)
      _startAnimation();
    if (tabFocusNodes.length != widget.tabCount) {
      if (tabFocusNodes.length > widget.tabCount!) {
        discardedNodes.addAll(tabFocusNodes.sublist(widget.tabCount!));
        tabFocusNodes.removeRange(widget.tabCount!, tabFocusNodes.length);
      } else {
        tabFocusNodes.addAll(
          List<FocusScopeNode>.generate(
            widget.tabCount! - tabFocusNodes.length,
            (int index) => FocusScopeNode(
                debugLabel:
                    '$CupertinoTabScaffold Tab ${index + tabFocusNodes.length}'),
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
    if (_previousTabIndex == _currentTabIndex) return;
    _animationControllers[_previousTabIndex]!.reset();
    _animations[_previousTabIndex] = Tween(
            begin: 0.0,
            end: (_previousTabIndex > _currentTabIndex)
                ? _animationValue
                : -_animationValue!)
        .chain(CurveTween(curve: widget.screenTransitionAnimation!.curve))
        .animate(_animationControllers[_previousTabIndex]!);

    _animationControllers[_currentTabIndex]!.reset();
    _animations[_currentTabIndex] = Tween(
      begin: (_previousTabIndex > _currentTabIndex)
          ? -_animationValue!
          : _animationValue!,
      end: 0.0,
    )
        .chain(CurveTween(curve: widget.screenTransitionAnimation!.curve))
        .animate(_animationControllers[_currentTabIndex]!);

    _animationControllers[_previousTabIndex]!.forward();
    _animationControllers[_currentTabIndex]!.forward();
    return;
  }

  Widget _buildScreens() {
    return Container(
      color: widget.backgroundColor,
      child: Stack(
        fit: StackFit.expand,
        children: List<Widget>.generate(widget.tabCount!, (int index) {
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
                  builder: (BuildContext context) {
                    return shouldBuildTab[index]
                        ? (widget
                                .screenTransitionAnimation!.animateTabTransition
                            ? AnimatedBuilder(
                                animation: _animations[index]!,
                                builder: (context, child) =>
                                    Transform.translate(
                                  offset: Offset(_animations[index]!.value, 0),
                                  child: widget.tabBuilder(context, index),
                                ),
                              )
                            : widget.tabBuilder(context, index))
                        : Container();
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

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
    return Container(
      color: widget.backgroundColor,
      child: widget.stateManagement!
          ? _buildScreens()
          : KeyedSubtree(
              key: key,
              child: _buildScreens(),
            ),
    );
  }
}
