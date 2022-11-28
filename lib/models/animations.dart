part of persistent_bottom_nav_bar_v2;

class ScreenTransitionAnimation {
  final bool _animateTabTransition;
  final Duration duration;
  final Curve curve;

  const ScreenTransitionAnimation({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  }) : _animateTabTransition = true;

  const ScreenTransitionAnimation.none()
      : _animateTabTransition = false,
        duration = Duration.zero,
        curve = Curves.linear;

  bool get animateTabTransition => _animateTabTransition;
}

class ItemAnimation {
  final Duration duration;
  final Curve curve;

  const ItemAnimation({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  });
}
