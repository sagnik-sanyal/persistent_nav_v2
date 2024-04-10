part of "../persistent_bottom_nav_bar_v2.dart";

class DecoratedNavBar extends StatelessWidget {
  const DecoratedNavBar({
    required this.child,
    super.key,
    this.decoration = const NavBarDecoration(),
    this.height = kBottomNavigationBarHeight,
  });

  final NavBarDecoration decoration;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius:
            decoration.borderRadius as BorderRadius? ?? BorderRadius.zero,
        child: BackdropFilter(
          filter: decoration.filter ?? ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: DecoratedBox(
            decoration: decoration,
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
