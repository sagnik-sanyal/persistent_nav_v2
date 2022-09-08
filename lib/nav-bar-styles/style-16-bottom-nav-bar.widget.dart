part of persistent_bottom_nav_bar_v2;

// TODO: move to own file
class NavBarOverlap {
  final double overlap;
  final bool fullOverlapWhenNotOpaque;

  const NavBarOverlap.full()
      : overlap = double
            .infinity, // This is the placeholder so [PersistentTabScaffold] uses the navBarHeight instead
        fullOverlapWhenNotOpaque = true;

  const NavBarOverlap.none({
    this.fullOverlapWhenNotOpaque = true,
  }) : overlap = 0.0;

  const NavBarOverlap.custom({
    this.overlap = 0.0,
    this.fullOverlapWhenNotOpaque = true,
  });
}

class BottomNavStyle16 extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarDecoration navBarDecoration;

  BottomNavStyle16({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarDecoration(),
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
                      : item.inactiveColorPrimary),
            ),
          ),
      ],
    );
  }

  Widget _buildMiddleItem(BuildContext context, PersistentBottomNavBarItem item,
      bool isSelected, double? height) {
    return Container(
      // TODO: Causes error when navBarheight is 0.
      width: height! - 5.0,
      height: height - 5.0,
      decoration: BoxDecoration(
        color: item.activeColorPrimary,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: this.navBarDecoration.boxShadow,
      ),
      child: Column(
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
    final midIndex = (this.navBarEssentials.items!.length / 2).floor();
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
                height: this.navBarEssentials.navBarHeight!,
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
                            this.navBarEssentials.items![index].onPressed!(this
                                .navBarEssentials
                                .selectedScreenBuildContext);
                          } else {
                            this.navBarEssentials.onItemSelected!(index);
                          }
                        },
                        child: index == midIndex
                            ? Container(width: 150, color: Colors.transparent)
                            : _buildItem(
                                item,
                                this.navBarEssentials.selectedIndex == index,
                              ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          child: Center(
            child: GestureDetector(
                onTap: () {
                  if (this.navBarEssentials.items![midIndex].onPressed !=
                      null) {
                    this.navBarEssentials.items![midIndex].onPressed!(
                        this.navBarEssentials.selectedScreenBuildContext);
                  } else {
                    this.navBarEssentials.onItemSelected!(midIndex);
                  }
                },
                child: _buildMiddleItem(
                    context,
                    this.navBarEssentials.items![midIndex],
                    this.navBarEssentials.selectedIndex == midIndex,
                    this.navBarEssentials.navBarHeight)),
          ),
        ),
      ],
    );
  }
}
