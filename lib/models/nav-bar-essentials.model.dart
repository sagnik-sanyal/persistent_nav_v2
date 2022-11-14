part of persistent_bottom_nav_bar_v2;

class NavBarConfig {
  final int selectedIndex;
  final List<ItemConfig> items;
  final void Function(int) onItemSelected;
  final double navBarHeight;

  const NavBarConfig({
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
    this.navBarHeight = kBottomNavigationBarHeight,
  });

  ItemConfig get selectedItem => this.items[this.selectedIndex];

  NavBarConfig copyWith({
    int? selectedIndex,
    List<ItemConfig>? items,
    bool Function(int)? onItemSelected,
    double? navBarHeight,
  }) {
    return NavBarConfig(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      items: items ?? this.items,
      onItemSelected: onItemSelected ?? this.onItemSelected,
      navBarHeight: navBarHeight ?? this.navBarHeight,
    );
  }
}
