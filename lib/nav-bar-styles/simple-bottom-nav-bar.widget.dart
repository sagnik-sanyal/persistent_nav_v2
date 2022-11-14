part of persistent_bottom_nav_bar_v2;

class BottomNavSimple extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarAppearance navBarDecoration;

  BottomNavSimple({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarAppearance(),
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
      appearance: this.navBarDecoration,
      filter: this.navBarEssentials.selectedItem.filter,
      opacity: this.navBarEssentials.selectedItem.opacity,
      height: this.navBarEssentials.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.navBarEssentials.items.map((item) {
          int index = this.navBarEssentials.items.indexOf(item);
          return Flexible(
            child: InkWell(
              onTap: () {
                this.navBarEssentials.onItemSelected(index);
              },
              child: _buildItem(
                item,
                this.navBarEssentials.selectedIndex == index,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
