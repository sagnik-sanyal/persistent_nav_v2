part of persistent_bottom_nav_bar_v2;

class BottomNavStyle1 extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarDecoration navBarDecoration;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimationProperties itemAnimationProperties;

  BottomNavStyle1({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimationProperties(),
  });

  Widget _buildItem(
      PersistentBottomNavBarItem item, bool isSelected) {
    return AnimatedContainer(
      width: isSelected ? 120 : 50,
      duration: this.itemAnimationProperties.duration,
      curve: this.itemAnimationProperties.curve,
      // TODO: is this contentPadding needed / respected in every style?
      padding: EdgeInsets.all(item.contentPadding),
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
      filter: this
          .navBarEssentials
          .items![this.navBarEssentials.selectedIndex!]
          .filter,
      color: this.navBarEssentials.backgroundColor,
      opacity: this
          .navBarEssentials
          .items![this.navBarEssentials.selectedIndex!]
          .opacity,
      child: Container(
        height: this.navBarEssentials.navBarHeight,
        padding: this.navBarEssentials.padding == null
            ? EdgeInsets.symmetric(
                horizontal: this.navBarEssentials.navBarHeight! * 0.15,
                vertical: this.navBarEssentials.navBarHeight! * 0.15,
              )
            : EdgeInsets.only(
                top: this.navBarEssentials.padding?.top ??
                    this.navBarEssentials.navBarHeight! * 0.15,
                left: this.navBarEssentials.padding?.left ??
                    this.navBarEssentials.navBarHeight! * 0.15,
                right: this.navBarEssentials.padding?.right ??
                    this.navBarEssentials.navBarHeight! * 0.15,
                bottom: this.navBarEssentials.padding?.bottom ??
                    this.navBarEssentials.navBarHeight! * 0.15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: this.navBarEssentials.items!.map((item) {
            int index = this.navBarEssentials.items!.indexOf(item);
            return GestureDetector(
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
            );
          }).toList(),
        ),
      ),
    );
  }
}
