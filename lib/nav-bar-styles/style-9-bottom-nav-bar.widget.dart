part of persistent_bottom_nav_bar_v2;

class BottomNavStyle9 extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarAppearance navBarDecoration;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimationProperties itemAnimationProperties;

  BottomNavStyle9({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarAppearance(),
    this.itemAnimationProperties = const ItemAnimationProperties(),
  });

  Widget _buildItem(ItemConfig item, bool isSelected) {
    return AnimatedContainer(
      width: isSelected ? 120 : 50,
      duration: this.itemAnimationProperties.duration,
      curve: this.itemAnimationProperties.curve,
      padding: EdgeInsets.all(item.contentPadding),
      decoration: BoxDecoration(
        color: isSelected
            ? item.activeColorSecondary
            : item.inactiveColorSecondary,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          IconTheme(
            data: IconThemeData(
              size: item.iconSize,
              color: isSelected
                  ? item.activeColorPrimary
                  : item.inactiveColorPrimary,
            ),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
          if (item.title != null && isSelected)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: FittedBox(
                  child: Text(
                    item.title!,
                    style: item.textStyle.apply(
                        color: isSelected
                            ? item.activeColorPrimary
                            : item.inactiveColorPrimary),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      appearance: this.navBarDecoration,
      filter: this.navBarEssentials.selectedItem.filter,
      opacity: this.navBarEssentials.selectedItem.opacity,
      height: this.navBarEssentials.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.navBarEssentials.items.map((item) {
          int index = this.navBarEssentials.items.indexOf(item);
          return GestureDetector(
            onTap: () {
              this.navBarEssentials.onItemSelected!(index);
            },
            child: _buildItem(
              item,
              this.navBarEssentials.selectedIndex == index,
            ),
          );
        }).toList(),
      ),
    );
  }
}
