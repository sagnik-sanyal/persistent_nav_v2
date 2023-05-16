part of persistent_bottom_nav_bar_v2;

class ScreenTransitionAnimation {
  const ScreenTransitionAnimation({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  });

  const ScreenTransitionAnimation.none()
      : duration = Duration.zero,
        curve = Curves.linear;

  final Duration duration;
  final Curve curve;

  @override
  bool operator ==(Object other) =>
      other is ScreenTransitionAnimation &&
      other.duration == duration &&
      other.curve == curve;

  @override
  int get hashCode => hashValues(duration, curve);
}

class ItemAnimation {
  const ItemAnimation({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  });

  final Duration duration;
  final Curve curve;
}
