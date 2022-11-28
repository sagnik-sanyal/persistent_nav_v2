part of persistent_bottom_nav_bar_v2;

class Style2BottomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;
  final EdgeInsets itemPadding;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimation itemAnimationProperties;

  Style2BottomNavBar({
    Key? key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimation(),
    this.itemPadding = const EdgeInsets.all(5.0),
  });

  Widget _buildItem(ItemConfig item, bool isSelected, double deviceWidth) {
    return AnimatedContainer(
      width: isSelected ? deviceWidth * 0.29 : deviceWidth * 0.12,
      duration: this.itemAnimationProperties.duration,
      curve: this.itemAnimationProperties.curve,
      padding: itemPadding,
      decoration: BoxDecoration(
        color: isSelected
            ? item.activeColorSecondary
            : item.inactiveColorSecondary,
        borderRadius: BorderRadius.all(Radius.circular(50)),
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
                    : item.inactiveColorPrimary),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
          if (item.title != null && isSelected)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  item.title!,
                  softWrap: false,
                  style: item.textStyle.apply(
                      color: isSelected
                          ? item.activeColorPrimary
                          : item.inactiveColorPrimary),
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
      decoration: this.navBarDecoration,
      filter: this.navBarConfig.selectedItem.filter,
      opacity: this.navBarConfig.selectedItem.opacity,
      height: this.navBarConfig.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.navBarConfig.items.map((item) {
          int index = this.navBarConfig.items.indexOf(item);
          return InkWell(
            onTap: () {
              this.navBarConfig.onItemSelected(index);
            },
            child: _buildItem(
              item,
              this.navBarConfig.selectedIndex == index,
              MediaQuery.of(context).size.width,
            ),
          );
        }).toList(),
      ),
    );
  }
}
