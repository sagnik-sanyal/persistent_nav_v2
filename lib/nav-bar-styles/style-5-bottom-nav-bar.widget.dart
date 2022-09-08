part of persistent_bottom_nav_bar_v2;

class BottomNavStyle5 extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarAppearance navBarDecoration;

  BottomNavStyle5({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarAppearance(),
  });

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Column(
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
        Container(
          height: 5.0,
          width: 5.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: isSelected ? item.activeColorSecondary : Colors.transparent,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      appearance: this.navBarDecoration,
      filter: this.navBarEssentials.currentItem.filter,
      opacity: this.navBarEssentials.currentItem.opacity,
      height: this.navBarEssentials.navBarHeight ?? kBottomNavigationBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.navBarEssentials.items!.map((item) {
          int index = this.navBarEssentials.items!.indexOf(item);
          return Expanded(
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                if (this.navBarEssentials.items![index].onPressed != null) {
                  this.navBarEssentials.items![index].onPressed!(
                      this.navBarEssentials.selectedScreenBuildContext);
                } else {
                  this.navBarEssentials.onItemSelected!(index);
                }
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
