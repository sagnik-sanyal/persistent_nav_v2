part of persistent_bottom_nav_bar_v2;

class BottomNavStyle3 extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarAppearance navBarDecoration;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimationProperties itemAnimationProperties;

  BottomNavStyle3({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarAppearance(),
    this.itemAnimationProperties = const ItemAnimationProperties(),
  });

  Widget _buildItem(ItemConfig item, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: IconTheme(
            data: IconThemeData(
              size: item.iconSize,
              color: isSelected
                  ? item.activeColorPrimary
                  : item.inactiveColorPrimary,
            ),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
        ),
        if (item.title != null)
          FittedBox(
            child: Text(
              item.title!,
              style: item.textStyle.apply(
                color: isSelected
                    ? item.activeColorPrimary
                    : item.inactiveColorPrimary,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Color selectedItemActiveColor =
        this.navBarEssentials.currentItem.activeColorPrimary;
    double itemWidth = ((MediaQuery.of(context).size.width -
            this.navBarDecoration.padding.horizontal) /
        this.navBarEssentials.items.length);
    return DecoratedNavBar(
      appearance: this.navBarDecoration,
      filter: this.navBarEssentials.currentItem.filter,
      opacity: this.navBarEssentials.currentItem.opacity,
      height: this.navBarEssentials.navBarHeight,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              AnimatedContainer(
                duration: this.itemAnimationProperties.duration,
                curve: this.itemAnimationProperties.curve,
                width: this.navBarEssentials.selectedIndex == 0
                    ? 0.0
                    : itemWidth * this.navBarEssentials.selectedIndex!,
                height: 4.0,
              ),
              Flexible(
                child: AnimatedContainer(
                  duration: this.itemAnimationProperties.duration,
                  curve: this.itemAnimationProperties.curve,
                  width: itemWidth,
                  height: 4.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedItemActiveColor,
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 5.0),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: this.navBarEssentials.items.map((item) {
                int index = this.navBarEssentials.items.indexOf(item);
                return Flexible(
                  child: InkWell(
                    onTap: () {
                      this.navBarEssentials.onItemSelected!(index);
                    },
                    child: _buildItem(
                      item,
                      this.navBarEssentials.selectedIndex == index,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
