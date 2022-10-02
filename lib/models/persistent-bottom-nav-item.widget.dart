part of persistent_bottom_nav_bar_v2;

/// Configuration for an individual Item in the navbar.
/// Styling depends on the styling of the navigation bar.
/// Needs to be passed to the [PersistentTabView] widget via [PersistentTabConfig].
class ItemConfig {
  /// Icon for the bar item.
  final Widget icon;

  /// Inactive icon for the bar item. Defaults to `icon`
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

  /// Filter used when `opacity < 1.0`. Can be used to create 'frosted glass' effect.
  ///
  /// By default -> `ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0)`.
  final ImageFilter? filter;

  /// `TextStyle` of the title's text. Defaults to `TextStyle(color: CupertinoColors.systemGrey, fontWeight: FontWeight.w400, fontSize: 12.0)`
  final TextStyle textStyle;

  final double iconSize;

  ItemConfig({
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
    this.textStyle = const TextStyle(
      color: CupertinoColors.systemGrey,
      fontWeight: FontWeight.w400,
      fontSize: 12.0,
    ),
    this.iconSize = 26.0,
  })  : inactiveIcon = inactiveIcon ?? icon,
        activeColorSecondary =
            activeColorSecondary ?? activeColorPrimary.withOpacity(0.2),
        assert(opacity >= 0 && opacity <= 1.0);
}

class PersistentTabConfig {
  final Widget screen;

  final ItemConfig item;

  final NavigatorConfig navigatorConfig;

  /// If you want custom behavior on a press of a NavBar item like display a modal screen, you can declare your logic here.
  ///
  /// NOTE: This will override the default tab switiching behavior for this particular item.
  final void Function(BuildContext)? onPressed;

  /// Use it when you want to run some code when user presses the NavBar when on the initial screen of that respective tab. The inspiration was taken from the native iOS navigation bar behavior where when performing similar operation, you taken to the top of the list.
  ///
  /// NOTE: This feature is experimental at the moment and might not work as intended for some.
  final Function? onSelectedTabPressWhenNoScreensPushed;

  PersistentTabConfig({
    required this.screen,
    required this.item,
    this.navigatorConfig = const NavigatorConfig(),
    this.onSelectedTabPressWhenNoScreensPushed,
  }) : onPressed = null;

  PersistentTabConfig.noScreen({
    required this.item,
    required this.onPressed,
    this.navigatorConfig = const NavigatorConfig(),
    this.onSelectedTabPressWhenNoScreensPushed,
  }) : screen = Container();
}
