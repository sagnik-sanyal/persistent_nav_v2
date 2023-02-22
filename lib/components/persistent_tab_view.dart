part of persistent_bottom_nav_bar_v2;

/// A highly customizable persistent bottom navigation bar for flutter.
///
/// To learn more, check out the [Readme](https://github.com/jb3rndt/PersistentBottomNavBarV2).
class PersistentTabView extends StatefulWidget {
  /// Creates a fullscreen container with a navigation bar at the bottom. The
  /// navigation bar style can be chosen from [NavBarStyle]. If you want to
  /// make a custom style use [PersistentTabView.custom].
  ///
  /// The different screens get displayed in the container when an item is
  /// selected in the navigation bar.
  const PersistentTabView({
    required this.tabs,
    required this.navBarBuilder,
    Key? key,
    this.controller,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.margin = EdgeInsets.zero,
    this.backgroundColor = Colors.white,
    this.onTabChanged,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.selectedTabContext,
    this.popAllScreensOnTapOfSelectedTab = true,
    this.popAllScreensOnTapAnyTabs = false,
    this.popActionScreens = PopActionScreensType.all,
    this.avoidBottomPadding = true,
    this.onWillPop,
    this.stateManagement = true,
    this.handleAndroidBackButtonPress = true,
    this.hideNavigationBar = false,
    this.screenTransitionAnimation = const ScreenTransitionAnimation(),
    this.drawer,
    this.drawerEdgeDragWidth,
    this.gestureNavigationEnabled = false,
  }) : super(key: key);

  /// List of persistent bottom navigation bar items to be displayed in the navigation bar.
  final List<PersistentTabConfig> tabs;

  /// Controller for persistent bottom navigation bar. Will be declared if left empty.
  final PersistentTabController? controller;

  /// Background color of bottom navigation bar. `Colors.white` by default.
  final Color backgroundColor;

  /// Callback when the tab changed. The index of the new tab is passed as a parameter.
  final ValueChanged<int>? onTabChanged;

  /// A button displayed floating above the screens content.
  /// The position can be changed using [floatingActionButtonLocation].
  /// The button will be displayed on all screens equally.
  ///
  /// Typically a [FloatingActionButton].
  final Widget? floatingActionButton;

  /// Responsible for determining where the [floatingActionButton] should go.
  ///
  /// Defaults to [FloatingActionButtonLocation.endFloat].
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Specifies the navBarHeight
  ///
  /// Defaults to `kBottomNavigationBarHeight` which is `56.0`.
  final double navBarHeight;

  /// Specifies how much the navBar should float above
  /// the tab content. Defaults to [NavBarOverlap.full].
  final NavBarOverlap navBarOverlap;

  /// The margin around the navigation bar.
  final EdgeInsets margin;

  /// Builder for the Navigation Bar Widget. This also exposes
  /// [NavBarConfig] for further control. You can either pass a custom
  /// Widget or choose one of the predefined Navigation Bars.
  final Widget Function(NavBarConfig) navBarBuilder;

  /// If `true`, the navBar will be positioned so the content does not overlap with the bottom padding caused by system elements. If ``false``, the navBar will be positioned at the bottom of the screen. Defaults to `true`.
  final bool avoidBottomPadding;

  /// Handles android back button actions. Defaults to `true`.
  ///
  /// Action based on scenarios:
  /// 1. If the you are on the first tab with all screens popped of the given tab, the app will close.
  /// 2. If you are on another tab with all screens popped of that given tab, you will be switched to first tab.
  /// 3. If there are screens pushed on the selected tab, a screen will pop on a respective back button press.
  final bool handleAndroidBackButtonPress;

  /// If an already selected tab is pressed/tapped again, all the screens pushed
  /// on that particular tab will pop until the first screen in the stack.
  /// Defaults to `true`.
  final bool popAllScreensOnTapOfSelectedTab;

  /// All the screens pushed on that particular tab will pop until the first screen in the stack, whether the tab is already selected or not. Defaults to `false`.
  final bool popAllScreensOnTapAnyTabs;

  /// If set all pop until to first screen else set once pop once
  final PopActionScreensType? popActionScreens;

  final bool resizeToAvoidBottomInset;

  /// Preserves the state of each tab's screen. `true` by default.
  final bool stateManagement;

  /// If you want to perform a custom action on Android when exiting the app,
  /// you can write your logic here. Returns context of the selected screen.
  final Future<bool> Function(BuildContext)? onWillPop;

  /// Returns the context of the selected tab.
  final Function(BuildContext)? selectedTabContext;

  /// Screen transition animation properties when switching tabs.
  final ScreenTransitionAnimation screenTransitionAnimation;

  /// Hides the navigation bar with a transition animation. Defaults to `false`.
  final bool hideNavigationBar;

  /// If set to `true`, you can additionally swipe left/right to change the tab. Defaults to `false`.
  final bool gestureNavigationEnabled;

  /// A Drawer that should be accessible in every tab. To open the drawer, call `controller.openDrawer()` on your [PersistentTabController]. The hamburger menu button will not be automatically added to the appbar, but you can add it easily by using the following code in the initial screen of each tab:
  /// ```dart
  /// appBar: AppBar(
  ///   ...
  ///   leading: IconButton(
  ///     icon: const Icon(Icons.menu),
  ///     iconSize: 24,
  ///     onPressed: () {
  ///       controller.openDrawer();
  ///     },
  ///     tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
  ///   ),
  /// )
  /// ```
  final Widget? drawer;

  final double? drawerEdgeDragWidth;

  @override
  State<PersistentTabView> createState() => _PersistentTabViewState();
}

class _PersistentTabViewState extends State<PersistentTabView> {
  late List<BuildContext?> _contextList;
  late PersistentTabController _controller;
  bool _sendScreenContext = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? PersistentTabController();
    _controller.onIndexChanged = widget.onTabChanged;

    _contextList = List<BuildContext?>.filled(widget.tabs.length, null);

    _controller.addListener(() {
      if (widget.selectedTabContext != null) {
        _sendScreenContext = true;
      }
      if (mounted) {
        setState(() {});
      }
    });

    if (widget.selectedTabContext != null) {
      _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
        widget.selectedTabContext!(_contextList[_controller.index]!);
      });
    }
  }

  Widget _buildScreen(int index) => CustomTabView(
        navigatorConfig: widget.tabs[index].navigatorConfig,
        home: (screenContext) {
          _contextList[index] = screenContext;
          if (_sendScreenContext && index == _controller.index) {
            _sendScreenContext = false;
            widget.selectedTabContext!(_contextList[_controller.index]!);
          }
          return widget.tabs[index].screen;
        },
      );

  Widget navigationBarWidget() => PersistentTabViewScaffold(
        controller: _controller,
        hideNavigationBar: widget.hideNavigationBar,
        tabCount: widget.tabs.length,
        stateManagement: widget.stateManagement,
        backgroundColor: widget.backgroundColor,
        navBarOverlap: widget.navBarOverlap,
        opacities: widget.tabs.map((e) => e.item.opacity).toList(),
        screenTransitionAnimation: widget.screenTransitionAnimation,
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        avoidBottomPadding: widget.avoidBottomPadding,
        margin: widget.margin,
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        drawer: widget.drawer,
        drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
        gestureNavigationEnabled: widget.gestureNavigationEnabled,
        tabBar: widget.navBarBuilder(
          NavBarConfig(
            selectedIndex: _controller.index,
            items: widget.tabs.map((e) => e.item).toList(),
            navBarHeight: widget.navBarHeight,
            onItemSelected: (index) {
              if (widget.tabs[index].onPressed != null) {
                widget.tabs[index].onPressed!(context);
              } else {
                if (widget.popAllScreensOnTapOfSelectedTab &&
                    _controller.index == index) {
                  popAllScreens();
                }
                _controller.jumpToTab(index);
              }
            },
          ),
        ),
        tabBuilder: (context, index) => _buildScreen(index),
      );

  @override
  Widget build(BuildContext context) {
    if (_contextList.length != widget.tabs.length) {
      _contextList = List<BuildContext?>.filled(widget.tabs.length, null);
    }
    if (widget.handleAndroidBackButtonPress || widget.onWillPop != null) {
      return WillPopScope(
        onWillPop:
            !widget.handleAndroidBackButtonPress && widget.onWillPop != null
                ? () => widget.onWillPop!(_contextList[_controller.index]!)
                : () async {
                    if (_controller.isOnInitialTab() &&
                        !Navigator.canPop(_contextList.first!)) {
                      if (widget.handleAndroidBackButtonPress &&
                          widget.onWillPop != null) {
                        return widget.onWillPop!(_contextList.first!);
                      }
                      return true;
                    } else {
                      if (Navigator.canPop(_contextList[_controller.index]!)) {
                        Navigator.pop(_contextList[_controller.index]!);
                      } else {
                        _controller.jumpToPreviousTab();
                      }
                      return false;
                    }
                  },
        child: navigationBarWidget(),
      );
    } else {
      return navigationBarWidget();
    }
  }

  void popAllScreens() {
    if (widget.popAllScreensOnTapOfSelectedTab ||
        widget.popAllScreensOnTapAnyTabs) {
      if (widget.tabs[_controller.index]
                  .onSelectedTabPressWhenNoScreensPushed !=
              null &&
          !Navigator.of(_contextList[_controller.index]!).canPop()) {
        widget.tabs[_controller.index].onSelectedTabPressWhenNoScreensPushed!();
      }

      if (widget.popActionScreens == PopActionScreensType.once) {
        if (Navigator.of(_contextList[_controller.index]!).canPop()) {
          Navigator.of(_contextList[_controller.index]!).pop(context);
          return;
        }
      } else {
        Navigator.popUntil(
          _contextList[_controller.index]!,
          ModalRoute.withName(
            widget.tabs[_controller.index].navigatorConfig.initialRoute ??
                Navigator.defaultRouteName,
          ),
        );
      }
    }
  }
}
