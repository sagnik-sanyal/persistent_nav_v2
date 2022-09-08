part of persistent_bottom_nav_bar_v2;

class BottomNavStyle2 extends StatelessWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarDecoration navBarDecoration;

  BottomNavStyle2({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarDecoration(),
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
        if (item.title != null)
          FittedBox(
            child: Text(
              isSelected ? item.title! : " ",
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
            left: this.navBarEssentials.padding?.left ??
                MediaQuery.of(context).size.width * 0.05,
            right: this.navBarEssentials.padding?.right ??
                MediaQuery.of(context).size.width * 0.05,
            top: this.navBarEssentials.padding?.top ??
                this.navBarEssentials.navBarHeight! * 0.15,
            bottom: this.navBarEssentials.padding?.bottom ??
                this.navBarEssentials.navBarHeight! * 0.12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: this.navBarEssentials.items!.map((item) {
            int index = this.navBarEssentials.items!.indexOf(item);
            return Expanded(
              child: InkWell(
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
      ),
    );
  }
}
