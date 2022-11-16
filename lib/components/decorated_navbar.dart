part of persistent_bottom_nav_bar_v2;

class DecoratedNavBar extends StatelessWidget {
  final NavBarDecoration decoration;
  final ImageFilter filter;
  final Widget child;
  final double opacity;
  final double height;

  DecoratedNavBar({
    Key? key,
    this.decoration = const NavBarDecoration(),
    required this.child,
    ImageFilter? filter,
    this.opacity = 1.0,
    this.height = kBottomNavigationBarHeight,
  })  : filter = filter ?? ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          this.decoration.borderRadius as BorderRadius? ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: this.filter,
        child: Container(
          decoration: this.decoration.copyWith(
                color: this.decoration.color?.withOpacity(this.opacity),
              ),
          child: SafeArea(
            top: false,
            right: false,
            left: false,
            bottom: true,
            child: Container(
              padding: this.decoration.padding,
              height: this.height - this.decoration.borderHeight(),
              child: this.child,
            ),
          ),
        ),
      ),
    );
  }
}
