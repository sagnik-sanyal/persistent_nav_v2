part of persistent_bottom_nav_bar_v2;

class BottomNavStyle3 extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarDecoration navBarDecoration;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimationProperties itemAnimationProperties;

  BottomNavStyle3({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarDecoration(),
    this.itemAnimationProperties = const ItemAnimationProperties(),
  });

  Widget _buildItem(
      PersistentBottomNavBarItem item, bool isSelected, double? height) {
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
    Color selectedItemActiveColor = this
        .navBarEssentials
        .items![this.navBarEssentials.selectedIndex!]
        .activeColorPrimary;
    double itemWidth = ((MediaQuery.of(context).size.width -
            ((this.navBarEssentials.padding?.left ??
                    MediaQuery.of(context).size.width * 0.05) +
                (this.navBarEssentials.padding?.right ??
                    MediaQuery.of(context).size.width * 0.05))) /
        this.navBarEssentials.items!.length);
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
        padding: EdgeInsets.only(
            top: this.navBarEssentials.padding?.top ?? 0.0,
            left: this.navBarEssentials.padding?.left ??
                MediaQuery.of(context).size.width * 0.05,
            right: this.navBarEssentials.padding?.right ??
                MediaQuery.of(context).size.width * 0.05,
            bottom: this.navBarEssentials.padding?.bottom ??
                this.navBarEssentials.navBarHeight! * 0.1),
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
                children: this.navBarEssentials.items!.map((item) {
                  int index = this.navBarEssentials.items!.indexOf(item);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (this.navBarEssentials.items![index].onPressed !=
                            null) {
                          this.navBarEssentials.items![index].onPressed!(
                              this.navBarEssentials.selectedScreenBuildContext);
                        } else {
                          this.navBarEssentials.onItemSelected!(index);
                        }
                      },
                      child: Container(
                        child: _buildItem(
                            item,
                            this.navBarEssentials.selectedIndex == index,
                            this.navBarEssentials.navBarHeight),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
