part of persistent_bottom_nav_bar_v2;

/// An item widget for the `PersistentTabView`.
class PersistentBottomNavBarItem {
  /// Icon for the bar item.
  final Widget icon;

  /// In-Active icon for the bar item. Defaults to `icon`
  final Widget inactiveIcon;

  /// Title for the bar item. Might not appear is some `styles`.
  final String? title;

  /// Color for `icon` and `title` if item is selected. Defaults to `CupertinoColors.activeBlue`
  final Color activeColorPrimary;

  /// Color for `icon` and `title` if item is unselected. Defaults to `CupertinoColors.systemGrey`
  final Color inactiveColorPrimary;

  /// Color for the item background if selected. Defaults to `activeColorPrimary.withOpacity(0.2)`
  final Color activeColorSecondary;

  /// Color for the item background if unselected. Defaults to `Colors.transparent`
  final Color inactiveColorSecondary;

  /// Padding of the navigation bar item. Applies on all sides. `5.0` by default.
  ///
  /// `USE WITH CAUTION, MAY BREAK THE NAV BAR`.
  final double contentPadding;

  /// Enables and controls the transparency effect of the entire NavBar when this tab is selected.
  ///
  /// `Warning: Screen will cover the entire extent of the display`
  final double opacity;

  /// If you want custom behavior on a press of a NavBar item like display a modal screen, you can declare your logic here.
  ///
  /// NOTE: This will override the default tab switiching behavior for this particular item.
  final Function(BuildContext?)? onPressed;

  /// Use it when you want to run some code when user presses the NavBar when on the initial screen of that respective tab. The inspiration was taken from the native iOS navigation bar behavior where when performing similar operation, you taken to the top of the list.
  ///
  /// NOTE: This feature is experimental at the moment and might not work as intended for some.
  final Function? onSelectedTabPressWhenNoScreensPushed;

  /// Filter used when `opacity < 1.0`. Can be used to create 'frosted glass' effect.
  ///
  /// By default -> `ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0)`.
  final ImageFilter? filter;

  /// `TextStyle` of the title's text.
  final TextStyle? textStyle;

  final double iconSize;

  final RouteAndNavigatorSettings routeAndNavigatorSettings;

  PersistentBottomNavBarItem({
    required this.icon,
    Icon? inactiveIcon,
    this.title,
    this.contentPadding = 5.0,
    this.activeColorPrimary = CupertinoColors.activeBlue,
    this.inactiveColorPrimary = CupertinoColors.systemGrey,
    Color? activeColorSecondary,
    this.inactiveColorSecondary = Colors.transparent,
    this.opacity = 1.0,
    this.filter,
    this.textStyle,
    this.iconSize = 26.0,
    this.onSelectedTabPressWhenNoScreensPushed,
    this.routeAndNavigatorSettings = const RouteAndNavigatorSettings(),
    this.onPressed,
  })  : inactiveIcon = inactiveIcon ?? icon,
        activeColorSecondary =
            activeColorSecondary ?? activeColorPrimary.withOpacity(0.2),
        assert(opacity >= 0 && opacity <= 1.0);
}
