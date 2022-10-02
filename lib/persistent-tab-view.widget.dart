// Original Author: Bilal Shahid (bilalscheema@gmail.com)
// Version 2 maintained by: Jannis Berndt (berndtjannis@gmail.com)

part of persistent_bottom_nav_bar_v2;

/// A highly customizable persistent bottom navigation bar for flutter.
///
/// To learn more, check out the [Readme](https://github.com/jb3rndt/PersistentBottomNavBarV2).
class PersistentTabView extends StatefulWidget {
  /// List of persistent bottom navigation bar items to be displayed in the navigation bar.
  final List<PersistentBottomNavBarItem> items;

  /// Screens that will be displayed on tapping of persistent bottom navigation bar items.
  final List<Widget> screens;

  /// Controller for persistent bottom navigation bar. Will be declared if left empty.
  final PersistentTabController? controller;

  /// Background color of bottom navigation bar. `white` by default.
  final Color backgroundColor;

  /// Callback when page or tab change is detected.
  final ValueChanged<int>? onItemSelected;

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

  /// TODO update doc:
  /// Builder for the Navigation Bar Widget. This also exposes
  /// [NavBarEssentials] for further control. You can either pass a custom
  /// Widget or choose one of the predefined Navigation Bars.
  final Widget Function(NavBarEssentials) navBarBuilder;

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

  /// If set all pop until to first screen else set once pop once
  final PopActionScreensType? popActionScreens;

  final bool resizeToAvoidBottomInset;

  /// Preserves the state of each tab's screen. `true` by default.
  final bool stateManagement;

  /// If you want to perform a custom action on Android when exiting the app,
  /// you can write your logic here. Returns context of the selected screen.
  final Future<bool> Function(BuildContext?)? onWillPop;

  /// Returns the context of the selected tab.
  final Function(BuildContext?)? selectedTabScreenContext;

  /// Screen transition animation properties when switching tabs.
  final ScreenTransitionAnimation screenTransitionAnimation;

  final bool hideNavigationBarWhenKeyboardShows;

  /// Hides the navigation bar with a transition animation. Defaults to `false`.
  final bool hideNavigationBar;

  final BuildContext context;

  /// Creates a fullscreen container with a navigation bar at the bottom. The
  /// navigation bar style can be chosen from [NavBarStyle]. If you want to
  /// make a custom style use [PersistentTabView.custom].
  ///
  /// The different screens get displayed in the container when an item is
  /// selected in the navigation bar.
  PersistentTabView(
    this.context, {
    Key? key,
    required this.items,
    required this.screens,
    required this.navBarBuilder,
    this.controller,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.navBarOverlap = const NavBarOverlap.full(),
    this.margin = EdgeInsets.zero,
    this.backgroundColor = Colors.white,
    this.onItemSelected,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.resizeToAvoidBottomInset = true,
    this.selectedTabScreenContext,
    this.hideNavigationBarWhenKeyboardShows = true,
    this.popAllScreensOnTapOfSelectedTab = true,
    this.popActionScreens = PopActionScreensType.all,
    this.avoidBottomPadding = true,
    this.onWillPop,
    this.stateManagement = true,
    this.handleAndroidBackButtonPress = true,
    this.hideNavigationBar = false,
    this.screenTransitionAnimation = const ScreenTransitionAnimation(),
  })  : assert(
            assertMidButtonStyles(NavBarStyle.style1,
                items.length), //TODO do something senseful with this
            "NavBar styles 15-18 only accept 3 or 5 PersistentBottomNavBarItem items."),
        assert(items.length == screens.length,
            "screens and items length should be same. If you are using the onPressed callback function of 'PersistentBottomNavBarItem', enter a dummy screen like Container() in its place in the screens"),
        super(key: key);

  @override
  _PersistentTabViewState createState() => _PersistentTabViewState();
}

class _PersistentTabViewState extends State<PersistentTabView> {
  late List<BuildContext?> _contextList;
  late PersistentTabController _controller;
  late int _previousIndex;
  late int _currentIndex;
  bool _sendScreenContext = false;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller ?? PersistentTabController(initialIndex: 0);

    _contextList = List<BuildContext?>.filled(widget.items.length, null);

    _previousIndex = _controller.index;
    _currentIndex = _controller.index;

    _controller.addListener(() {
      if (_controller.index != _currentIndex) {
        if (widget.selectedTabScreenContext != null) {
          _sendScreenContext = true;
        }
        if (mounted)
          setState(
            () => _currentIndex = _controller.index,
          );
      }
    });
    if (widget.selectedTabScreenContext != null) {
      _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
        widget.selectedTabScreenContext!(_contextList[_controller.index]);
      });
    }
  }

  Widget _buildScreen(int index) {
    return CustomTabView(
      routeAndNavigatorSettings: widget.items[index].routeAndNavigatorSettings,
      builder: (BuildContext screenContext) {
        _contextList[index] = screenContext;
        if (_sendScreenContext) {
          _sendScreenContext = false;
          widget.selectedTabScreenContext!(_contextList[_controller.index]);
        }
        return Material(
          elevation: 0,
          child: widget.screens[index],
          type: MaterialType.transparency,
        );
      },
    );
  }

  Widget navigationBarWidget() => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 100), // TODO: Simulate gesture bar
        ),
        child: PersistentTabScaffold(
          controller: _controller,
          hideNavigationBar: widget.hideNavigationBar,
          itemCount: widget.items.length,
          stateManagement: widget.stateManagement,
          backgroundColor: widget.backgroundColor,
          navBarOverlap: widget.navBarOverlap,
          opacities: widget.items.map((e) => e.opacity).toList(),
          screenTransitionAnimation: widget.screenTransitionAnimation,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          avoidBottomPadding: widget.avoidBottomPadding,
          margin: widget.margin,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          tabBar: widget.navBarBuilder(
            NavBarEssentials(
              selectedIndex: _controller.index,
              previousIndex: _previousIndex,
              selectedScreenBuildContext: _contextList[_controller.index],
              items: widget.items,
              navBarHeight: widget.navBarHeight,
              popScreensOnTapOfSelectedTab:
                  widget.popAllScreensOnTapOfSelectedTab,
              onItemSelected: (int index) {
                if (_controller.index != _previousIndex) {
                  _previousIndex = _controller.index;
                }
                if ((widget.popAllScreensOnTapOfSelectedTab) &&
                    _previousIndex == index) {
                  popAllScreens();
                }
                _controller.index = index;
                widget.onItemSelected?.call(index);
              },
            ),
          ),
          tabBuilder: (BuildContext context, int index) {
            return _buildScreen(index);
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (_contextList.length != widget.items.length) {
      _contextList = List<BuildContext?>.filled(widget.items.length, null);
    }
    if (widget.handleAndroidBackButtonPress || widget.onWillPop != null) {
      return WillPopScope(
        onWillPop:
            !widget.handleAndroidBackButtonPress && widget.onWillPop != null
                ? () => widget.onWillPop!(_contextList[_controller.index])
                : () async {
                    if (_controller.index == 0 &&
                        !Navigator.canPop(_contextList.first!)) {
                      if (widget.handleAndroidBackButtonPress &&
                          widget.onWillPop != null) {
                        return widget.onWillPop!(_contextList.first);
                      }
                      return true;
                    } else {
                      if (Navigator.canPop(_contextList[_controller.index]!)) {
                        Navigator.pop(_contextList[_controller.index]!);
                      } else {
                        if (widget.onItemSelected != null) {
                          widget.onItemSelected!(0);
                        }
                        _controller.index = 0;
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
    if (widget.popAllScreensOnTapOfSelectedTab) {
      if (widget.items[_controller.index]
                  .onSelectedTabPressWhenNoScreensPushed !=
              null &&
          !Navigator.of(_contextList[_controller.index]!).canPop()) {
        widget
            .items[_controller.index].onSelectedTabPressWhenNoScreensPushed!();
      }

      if (widget.popActionScreens == PopActionScreensType.once) {
        if (Navigator.of(_contextList[_controller.index]!).canPop()) {
          Navigator.of(_contextList[_controller.index]!).pop(context);
          return;
        }
      } else {
        Navigator.popUntil(
            _contextList[_controller.index]!,
            ModalRoute.withName(widget.items[_controller.index]
                    .routeAndNavigatorSettings.initialRoute ??
                '/9f580fc5-c252-45d0-af25-9429992db112'));
      }
    }
  }
}

//asserts

bool assertMidButtonStyles(NavBarStyle navBarStyle, int itemCount) {
  if (navBarStyle == NavBarStyle.style15 ||
      navBarStyle == NavBarStyle.style16 ||
      navBarStyle == NavBarStyle.style17 ||
      navBarStyle == NavBarStyle.style18) {
    if (itemCount % 2 != 0) {
      return true;
    } else {
      return false;
    }
  }
  return true;
}
