part of persistent_bottom_nav_bar_v2;

class Style1BottomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  Style1BottomNavBar({
    Key? key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
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
                    : item.inactiveColorPrimary),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
        ),
        if (item.title != null)
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                child: Text(
                  item.title!,
                  style: item.textStyle.apply(
                    color: isSelected
                        ? item.activeColorPrimary
                        : item.inactiveColorPrimary,
                  ),
                ),
              ),
            ),
          ),
      ],
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
          return Expanded(
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
    );
  }
}
