part of "../persistent_bottom_nav_bar_v2.dart";

enum PopActionScreensType { once, all }

class NavBarDecoration extends BoxDecoration {
  const NavBarDecoration({
    Color super.color = Colors.white,
    super.image,
    super.border,
    super.borderRadius,
    super.boxShadow,
    super.gradient,
    super.backgroundBlendMode,
    super.shape,
    this.padding = const EdgeInsets.all(5),
  });

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
