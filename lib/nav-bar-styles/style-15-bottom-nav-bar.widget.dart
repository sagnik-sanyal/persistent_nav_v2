part of persistent_bottom_nav_bar_v2;

class BottomNavStyle15 extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  BottomNavStyle15({
    Key? key,
    required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
  })  : assert(navBarConfig.items.length % 2 == 1,
            "The number of items must be odd for this style"),
        super(key: key);

  Widget _buildItem(BuildContext context, ItemConfig item, bool isSelected) {
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
                      : item.inactiveColorPrimary),
            ),
          ),
      ],
    );
  }

  Widget _buildMiddleItem(ItemConfig item, bool isSelected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 150.0,
          height: this.navBarConfig.navBarHeight,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.activeColorPrimary,
            boxShadow: this.navBarDecoration.decoration?.boxShadow,
          ),
          child: Center(
            child: IconTheme(
              data: IconThemeData(
                size: item.iconSize,
                color: item.activeColorPrimary,
              ),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
          ),
        ),
        if (item.title != null)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FittedBox(
                child: Text(
                  item.title!,
                  style: item.textStyle.apply(
                      color: isSelected
                          ? item.activeColorPrimary
                          : item.inactiveColorPrimary),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final midIndex = (this.navBarConfig.items.length / 2).floor();
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 23,
            ),
            DecoratedNavBar(
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
                    child: GestureDetector(
                      onTap: () {
                        this.navBarConfig.onItemSelected(index);
                      },
                      child: index == midIndex
                          ? Container(width: 150, color: Colors.transparent)
                          : _buildItem(
                              context,
                              item,
                              this.navBarConfig.selectedIndex == index,
                            ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          child: Center(
            child: GestureDetector(
              onTap: () {
                this.navBarConfig.onItemSelected(midIndex);
              },
              child: _buildMiddleItem(
                this.navBarConfig.items[midIndex],
                this.navBarConfig.selectedIndex == midIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
