part of persistent_bottom_nav_bar_v2;

// TODO: Rename e.g. NavbarConfig or combine with tabcontroller?
class NavBarEssentials {
  final int? selectedIndex;
  final int? previousIndex;
  final List<ItemConfig> items;
  final bool Function(int)? onItemSelected;
  final double navBarHeight;
  final bool? popScreensOnTapOfSelectedTab;
  final BuildContext? selectedScreenBuildContext;

  const NavBarEssentials({
    this.selectedIndex,
    this.previousIndex,
    required this.items,
    this.onItemSelected,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.popScreensOnTapOfSelectedTab,
    this.selectedScreenBuildContext,
  });

  ItemConfig get currentItem => this.items[this.selectedIndex!];

  NavBarEssentials copyWith({
    int? selectedIndex,
    int? previousIndex,
    List<ItemConfig>? items,
    bool Function(int)? onItemSelected,
    double? navBarHeight,
    bool? popScreensOnTapOfSelectedTab,
  }) {
    return NavBarEssentials(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      previousIndex: previousIndex ?? this.previousIndex,
      items: items ?? this.items,
      onItemSelected: onItemSelected ?? this.onItemSelected,
      navBarHeight: navBarHeight ?? this.navBarHeight,
      popScreensOnTapOfSelectedTab:
          popScreensOnTapOfSelectedTab ?? this.popScreensOnTapOfSelectedTab,
    );
  }
}
