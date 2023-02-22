part of persistent_bottom_nav_bar_v2;

enum PopActionScreensType { once, all }

class NavBarDecoration extends BoxDecoration {
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

  /// `padding` for the persistent navigation bar content.
  @override
  final EdgeInsets padding;

  double borderHeight() => border?.dimensions.vertical ?? 0.0;

  double exposedHeight() {
    if (borderRadius != BorderRadius.zero &&
        borderRadius != null &&
        borderRadius is BorderRadius) {
      final BorderRadius radius = borderRadius! as BorderRadius;
      return max(radius.topRight.y, radius.topLeft.y) + borderHeight();
    } else {
      return 0;
    }
  }
}
