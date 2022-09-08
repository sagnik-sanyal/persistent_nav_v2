part of persistent_bottom_nav_bar_v2;

class PersistentBottomNavBar extends StatelessWidget {
  final EdgeInsets margin;
  final bool confineToSafeArea;
  final Widget child;

  const PersistentBottomNavBar({
    Key? key,
    required this.child,
    this.margin = const EdgeInsets.only(),
    this.confineToSafeArea = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.margin,
      child: MediaQuery.removePadding(
        context: context,
        // safespace should be ignored, so the bottom inset is removed before it could be applied by any safearea child (e.g. in DecoratedNavBar).
        removeBottom: !this.confineToSafeArea,
        child: SafeArea(
          top: false,
          right: false,
          left: false,
          bottom: this.confineToSafeArea && this.margin.bottom != 0,
          child: this.child,
        ),
      ),
    );
  }
}

class DecoratedNavBar extends StatelessWidget {
  final NavBarAppearance appearance;
  final ImageFilter filter;
  final Widget child;
  final double opacity;
  final double height;

  DecoratedNavBar({
    Key? key,
    this.appearance = const NavBarAppearance(),
    required this.child,
    ImageFilter? filter,
    this.opacity = 1.0,
    this.height = kBottomNavigationBarHeight,
  })  : filter = filter ?? ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: this.appearance.decoration?.borderRadius as BorderRadius?,
      child: BackdropFilter(
        filter: this.filter,
        child: Container(
          decoration: this.appearance.decoration?.copyWith(
                color: this
                    .appearance
                    .decoration
                    ?.color
                    ?.withOpacity(this.opacity),
              ),
          child: SafeArea(
            top: false,
            right: false,
            left: false,
            bottom: true,
            child: Container(
              padding: this.appearance.padding,
              height: this.height - this.appearance.borderHeight(),
              child: this.child,
            ),
          ),
        ),
      ),
    );
  }
}
