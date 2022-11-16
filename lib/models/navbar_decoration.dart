part of persistent_bottom_nav_bar_v2;

enum PopActionScreensType { once, all }

class NavBarDecoration extends BoxDecoration {
  /// `padding` for the persistent navigation bar content.
  final EdgeInsets padding;

  const NavBarDecoration({
    Color color = Colors.white,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape shape = BoxShape.rectangle,
    this.padding = const EdgeInsets.all(5),
  }) : super(
          color: color,
          image: image,
          border: border,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
          gradient: gradient,
          backgroundBlendMode: backgroundBlendMode,
          shape: shape,
        );

  double borderHeight() {
    return this.border?.dimensions.vertical ?? 0.0;
  }

  double exposedHeight() {
    if (this.borderRadius != BorderRadius.zero &&
        this.borderRadius != null &&
        this.borderRadius is BorderRadius) {
      BorderRadius radius = (this.borderRadius! as BorderRadius);
      return max(radius.topRight.y, radius.topLeft.y) + this.borderHeight();
    } else {
      return 0;
    }
  }
}
