part of persistent_bottom_nav_bar_v2;

class NeumorphicBottomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NeumorphicProperties neumorphicProperties;
  final NavBarDecoration navBarDecoration;

  NeumorphicBottomNavBar({
    Key? key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
    this.neumorphicProperties = const NeumorphicProperties(),
  }) : super(key: key);

  Widget _getNavItem(
    ItemConfig item,
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
    ItemConfig item,
    bool isSelected,
  ) =>
      item.opacity == 1.0
          ? NeumorphicContainer(
              decoration: this.neumorphicProperties.decoration?.copyWith(
                    color: this.neumorphicProperties.decoration?.color ??
                        this.navBarDecoration.color,
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
                    this.navBarConfig.items,
                    this.navBarDecoration.color,
                    this.navBarConfig.selectedIndex),
              ),
              padding: EdgeInsets.all(6.0),
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: _getNavItem(item, isSelected),
            );

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      decoration: this.navBarDecoration,
      filter: this.navBarConfig.selectedItem.filter,
      opacity: this.navBarConfig.selectedItem.opacity,
      height: this.navBarConfig.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.navBarConfig.items.map((item) {
          int index = this.navBarConfig.items.indexOf(item);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                this.navBarConfig.onItemSelected(index);
              },
              child: _buildItem(
                context,
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
