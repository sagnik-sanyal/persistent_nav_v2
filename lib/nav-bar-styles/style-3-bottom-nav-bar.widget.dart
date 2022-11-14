part of persistent_bottom_nav_bar_v2;

class BottomNavStyle3 extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimationProperties itemAnimationProperties;

  BottomNavStyle3({
    Key? key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
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
        this.navBarConfig.selectedItem.activeColorPrimary;
    double itemWidth = ((MediaQuery.of(context).size.width -
            this.navBarDecoration.padding.horizontal) /
        this.navBarConfig.items.length);
    return DecoratedNavBar(
      decoration: this.navBarDecoration,
      filter: this.navBarConfig.selectedItem.filter,
      opacity: this.navBarConfig.selectedItem.opacity,
      height: this.navBarConfig.navBarHeight,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              AnimatedContainer(
                duration: this.itemAnimationProperties.duration,
                curve: this.itemAnimationProperties.curve,
                width: this.navBarConfig.selectedIndex == 0
                    ? 0.0
                    : itemWidth * this.navBarConfig.selectedIndex,
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
              children: this.navBarConfig.items.map((item) {
                int index = this.navBarConfig.items.indexOf(item);
                return Flexible(
                  child: InkWell(
                    onTap: () {
                      this.navBarConfig.onItemSelected(index);
                    },
                    child: _buildItem(
                      item,
                      this.navBarConfig.selectedIndex == index,
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
