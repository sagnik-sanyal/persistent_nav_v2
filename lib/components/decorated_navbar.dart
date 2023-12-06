part of "../persistent_bottom_nav_bar_v2.dart";

class DecoratedNavBar extends StatelessWidget {
  DecoratedNavBar({
    required this.child,
    super.key,
    this.decoration = const NavBarDecoration(),
    ImageFilter? filter,
    this.opacity = 1.0,
    this.height = kBottomNavigationBarHeight,
  }) : filter = filter ?? ImageFilter.blur(sigmaX: 3, sigmaY: 3);

  final NavBarDecoration decoration;
  final ImageFilter filter;
  final Widget child;
  final double opacity;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius:
            decoration.borderRadius as BorderRadius? ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: filter,
          child: DecoratedBox(
            decoration: decoration.copyWith(
              color: decoration.color?.withOpacity(opacity),
            ),
            child: SafeArea(
              top: false,
              right: false,
              left: false,
              child: Container(
                padding: decoration.padding,
                height: height - decoration.borderHeight(),
                child: child,
              ),
            ),
          ),
        ),
      );
}
