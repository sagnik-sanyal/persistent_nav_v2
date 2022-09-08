part of persistent_bottom_nav_bar_v2;

class BottomNavStyle18 extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarAppearance navBarDecoration;

  BottomNavStyle18({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarAppearance(),
  });

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
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
          )
      ],
    );
  }

  Widget _buildMiddleItem(
      BuildContext context, PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(
        left: 5.0,
        right: 5.0,
      ),
      decoration: BoxDecoration(
        color: item.activeColorPrimary,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.transparent, width: 5.0),
      ),
      child: Column(
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final midIndex = (this.navBarEssentials.items!.length / 2).floor();
    return DecoratedNavBar(
      appearance: this.navBarDecoration,
      filter: this.navBarEssentials.currentItem.filter,
      opacity: this.navBarEssentials.currentItem.opacity,
      height: this.navBarEssentials.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.navBarEssentials.items!.map((item) {
          int index = this.navBarEssentials.items!.indexOf(item);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (this.navBarEssentials.items![index].onPressed != null) {
                  this.navBarEssentials.items![index].onPressed!(
                      this.navBarEssentials.selectedScreenBuildContext);
                } else {
                  this.navBarEssentials.onItemSelected!(index);
                }
              },
              child: index == midIndex
                  ? _buildMiddleItem(
                      context,
                      item,
                      this.navBarEssentials.selectedIndex == index,
                    )
                  : _buildItem(
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
