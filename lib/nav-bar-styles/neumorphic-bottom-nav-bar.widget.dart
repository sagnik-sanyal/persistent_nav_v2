part of persistent_bottom_nav_bar_v2;

class NeumorphicBottomNavBar extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NeumorphicProperties neumorphicProperties;
  final NavBarDecoration navBarDecoration;
  final EdgeInsets defaultPadding;

  NeumorphicBottomNavBar({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarDecoration(),
    this.neumorphicProperties = const NeumorphicProperties(),
  })  : defaultPadding = EdgeInsets.symmetric(
          horizontal: navBarEssentials.navBarHeight! * 0.06,
          vertical: navBarEssentials.navBarHeight! * 0.12,
        ),
        super(key: key);

  Widget _getNavItem(
    PersistentBottomNavBarItem item,
    bool isSelected,
  ) =>
      this.neumorphicProperties.showSubtitleText
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconTheme(
                  data: IconThemeData(
                      size: item.iconSize,
                      color: isSelected
                          ? item.activeColorPrimary
                          : item.inactiveColorPrimary),
                  child: isSelected ? item.icon : item.inactiveIcon,
                ),
                FittedBox(
                  child: Text(
                    item.title!,
                    style: item.textStyle.apply(
                        color: isSelected
                            ? item.activeColorPrimary
                            : item.inactiveColorPrimary),
                  ),
                ),
              ],
            )
          : IconTheme(
              data: IconThemeData(
                  size: item.iconSize,
                  color: isSelected
                      ? item.activeColorPrimary
                      : item.inactiveColorPrimary),
              child: isSelected ? item.icon : item.inactiveIcon,
            );

  Widget _buildItem(
    BuildContext context,
    PersistentBottomNavBarItem item,
    bool isSelected,
  ) =>
      opaque(this.navBarEssentials.items!, this.navBarEssentials.selectedIndex)
          ? NeumorphicContainer(
              decoration: NeumorphicDecoration(
                borderRadius: BorderRadius.circular(
                    this.neumorphicProperties.borderRadius),
                color: this.navBarEssentials.backgroundColor,
                border: this.neumorphicProperties.border,
                shape: this.neumorphicProperties.shape,
              ),
              bevel: this.neumorphicProperties.bevel,
              curveType: isSelected
                  ? CurveType.emboss
                  : this.neumorphicProperties.curveType,
              padding: EdgeInsets.all(6.0),
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: _getNavItem(item, isSelected),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: getBackgroundColor(
                    context,
                    this.navBarEssentials.items,
                    this.navBarEssentials.backgroundColor,
                    this.navBarEssentials.selectedIndex),
              ),
              padding: EdgeInsets.all(6.0),
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: _getNavItem(item, isSelected),
            );

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
        padding: EdgeInsets.only(
          left: this.navBarEssentials.padding?.left ?? defaultPadding.left,
          right: this.navBarEssentials.padding?.right ?? defaultPadding.right,
          top: this.navBarEssentials.padding?.top ?? defaultPadding.top,
          bottom:
              this.navBarEssentials.padding?.bottom ?? defaultPadding.bottom,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: this.navBarEssentials.items!.map((item) {
            int index = this.navBarEssentials.items!.indexOf(item);
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  if (item.onPressed != null) {
                    item.onPressed!(
                        this.navBarEssentials.selectedScreenBuildContext);
                  } else {
                    this.navBarEssentials.onItemSelected!(index);
                  }
                },
                child: _buildItem(
                  context,
                  item,
                  this.navBarEssentials.selectedIndex == index,
                  // TODO: Navbarheight should not be nullable
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
