part of persistent_bottom_nav_bar_v2;

// TODO: Rename e.g. NavbarConfig or combine with tabcontroller?
class NavBarEssentials {
  final int selectedIndex;
  final List<ItemConfig> items;
  final bool Function(int)? onItemSelected;
  final double navBarHeight;
  final BuildContext? selectedScreenBuildContext;

  const NavBarEssentials({
    required this.selectedIndex,
    required this.items,
    this.onItemSelected,
    this.navBarHeight = kBottomNavigationBarHeight,
    this.selectedScreenBuildContext,
  });

  ItemConfig get selectedItem => this.items[this.selectedIndex];

  NavBarEssentials copyWith({
    int? selectedIndex,
    List<ItemConfig>? items,
    bool Function(int)? onItemSelected,
    double? navBarHeight,
  }) {
    return NavBarEssentials(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      items: items ?? this.items,
      onItemSelected: onItemSelected ?? this.onItemSelected,
      navBarHeight: navBarHeight ?? this.navBarHeight,
    );
  }
}
