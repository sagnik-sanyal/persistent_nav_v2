part of persistent_bottom_nav_bar_v2;

class ScreenTransitionAnimation {
  const ScreenTransitionAnimation({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  }) : _animateTabTransition = true;

  const ScreenTransitionAnimation.none()
      : _animateTabTransition = false,
        duration = Duration.zero,
        curve = Curves.linear;

  final bool _animateTabTransition;
  final Duration duration;
  final Curve curve;

  bool get animateTabTransition => _animateTabTransition;
}

class ItemAnimation {
  const ItemAnimation({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.ease,
  });

  final Duration duration;
  final Curve curve;
}
