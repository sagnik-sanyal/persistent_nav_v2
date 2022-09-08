part of persistent_bottom_nav_bar_v2;

// TODO: Remove
enum NavBarStyle {
  style1,
  style2,
  style3,
  style4,
  style5,
  style6,
  style7,
  style8,
  style9,
  style10,
  style11,
  style12,
  style13,
  style14,
  style15,
  style16,
  style17,
  style18,
  neumorphic,
  simple,
}

enum PopActionScreensType { once, all }

class NavBarAppearance {
  final BoxDecoration? decoration;

  /// `padding` for the persistent navigation bar content.
  ///
  /// `USE WITH CAUTION, MAY CAUSE LAYOUT ISSUES`.
  final EdgeInsets padding;

  const NavBarAppearance({
    this.decoration,
    this.padding = const EdgeInsets.all(8),
  });

  double borderHeight() {
    return this.decoration!.border?.dimensions.vertical ?? 0.0;
  }

  double exposedHeight() {
    if (this.decoration?.borderRadius != BorderRadius.zero &&
        this.decoration?.borderRadius != null &&
        this.decoration?.borderRadius is BorderRadius) {
      BorderRadius radius = (this.decoration!.borderRadius! as BorderRadius);
      return max(radius.topRight.y, radius.topLeft.y) +
          this.borderHeight();
    } else {
      return 0;
    }
  }
}
