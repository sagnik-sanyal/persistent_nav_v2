part of persistent_bottom_nav_bar_v2;

enum PopActionScreensType { once, all }

class NavBarDecoration {
  final BoxDecoration decoration;

  /// `padding` for the persistent navigation bar content.
  final EdgeInsets padding;

  const NavBarDecoration({
    this.decoration = const BoxDecoration(color: Colors.white),
    this.padding = const EdgeInsets.all(5),
  });

  double borderHeight() {
    return this.decoration.border?.dimensions.vertical ?? 0.0;
  }

  double exposedHeight() {
    if (this.decoration.borderRadius != BorderRadius.zero &&
        this.decoration.borderRadius != null &&
        this.decoration.borderRadius is BorderRadius) {
      BorderRadius radius = (this.decoration.borderRadius! as BorderRadius);
      return max(radius.topRight.y, radius.topLeft.y) + this.borderHeight();
    } else {
      return 0;
    }
  }
}
