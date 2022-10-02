part of persistent_bottom_nav_bar_v2;

class BottomNavStyle15 extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarAppearance navBarDecoration;

  BottomNavStyle15({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarAppearance(),
  })  : assert(navBarEssentials.items.length % 2 == 1,
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

  Widget _buildMiddleItem(ItemConfig item, bool isSelected, double? height) {
    return Container(
      width: 150.0,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: item.activeColorPrimary,
        boxShadow: this.navBarDecoration.decoration?.boxShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                size: item.iconSize,
                color: item.activeColorPrimary,
              ),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
          ),
          // TODO: Title should be below raised button
          if (item.title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final midIndex = (this.navBarEssentials.items.length / 2).floor();
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
              appearance: this.navBarDecoration,
              filter: this.navBarEssentials.currentItem.filter,
              opacity: this.navBarEssentials.currentItem.opacity,
              height: this.navBarEssentials.navBarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: this.navBarEssentials.items.map((item) {
                  int index = this.navBarEssentials.items.indexOf(item);
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        this.navBarEssentials.onItemSelected!(index);
                      },
                      child: index == midIndex
                          ? Container(width: 150, color: Colors.transparent)
                          : _buildItem(
                              context,
                              item,
                              this.navBarEssentials.selectedIndex == index,
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
                  this.navBarEssentials.onItemSelected!(midIndex);
                },
                child: _buildMiddleItem(
                    this.navBarEssentials.items[midIndex],
                    this.navBarEssentials.selectedIndex == midIndex,
                    this.navBarEssentials.navBarHeight)),
          ),
        ),
      ],
    );
  }
}
