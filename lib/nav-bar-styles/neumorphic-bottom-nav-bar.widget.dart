part of persistent_bottom_nav_bar_v2;

class NeumorphicBottomNavBar extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NeumorphicProperties neumorphicProperties;
  final NavBarAppearance navBarDecoration;

  NeumorphicBottomNavBar({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarAppearance(),
    this.neumorphicProperties = const NeumorphicProperties(),
  }) : super(key: key);

  Widget _getNavItem(
    PersistentBottomNavBarItem item,
    bool isSelected,
  ) =>
      Column(
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
          if (this.neumorphicProperties.showSubtitleText)
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
      );

  Widget _buildItem(
    BuildContext context,
    PersistentBottomNavBarItem item,
    bool isSelected,
  ) =>
      opaque(this.navBarEssentials.items!, this.navBarEssentials.selectedIndex)
          ? NeumorphicContainer(
              decoration: this.neumorphicProperties.decoration?.copyWith(
                    color: this.neumorphicProperties.decoration?.color ??
                        this.navBarDecoration.decoration?.color,
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
                borderRadius:
                    this.neumorphicProperties.decoration?.borderRadius,
                color: getBackgroundColor(
                    context,
                    this.navBarEssentials.items,
                    this.navBarDecoration.decoration?.color,
                    this.navBarEssentials.selectedIndex),
              ),
              padding: EdgeInsets.all(6.0),
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: _getNavItem(item, isSelected),
            );

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      appearance: this.navBarDecoration,
      filter: this.navBarEssentials.currentItem.filter,
      opacity: this.navBarEssentials.currentItem.opacity,
      height: this.navBarEssentials.navBarHeight,
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
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
