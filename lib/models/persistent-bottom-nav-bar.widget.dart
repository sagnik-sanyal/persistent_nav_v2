part of persistent_bottom_nav_bar_v2;

class PersistentBottomNavBar extends StatelessWidget {
  final EdgeInsets margin;
  final bool confineToSafeArea;
  final NavBarEssentials? navBarEssentials;
  final Widget child;

  const PersistentBottomNavBar({
    Key? key,
    required this.child,
    EdgeInsets? margin,
    bool? confineToSafeArea,
    this.navBarEssentials,
  })  : confineToSafeArea = confineToSafeArea ?? true,
        margin = margin ?? EdgeInsets.zero,
        super(key: key);

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

  bool opaque(int? index) {
    return this.navBarEssentials!.items == null
        ? true
        : !(this.navBarEssentials!.items![index!].opacity < 1.0);
  }
}

// TODO: Has to be integrated in every NavBarStyle
class DecoratedNavBar extends StatelessWidget {
  final NavBarDecoration decoration;
  final ImageFilter filter;
  final Widget child;
  final Color? color;
  final double opacity;

  DecoratedNavBar({
    Key? key,
    this.decoration = const NavBarDecoration(),
    required this.child,
    this.color,
    ImageFilter? filter,
    this.opacity = 1.0,
  })  : filter = filter ?? ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: this.decoration.borderRadius,
      child: BackdropFilter(
        filter: this.filter,
        child: Container(
          decoration: getNavBarDecoration(
            decoration: decoration,
            color: this.color,
            opacity: this.opacity,
          ),
          child: SafeArea(
            top: false,
            right: false,
            left: false,
            bottom: true,
            child: this.child,
          ),
        ),
      ),
    );
  }
}
