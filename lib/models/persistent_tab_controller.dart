part of persistent_bottom_nav_bar_v2;

/// Navigation bar controller for `PersistentTabView`.
class PersistentTabController extends ChangeNotifier {
  PersistentTabController({int initialIndex = 0})
      : _index = initialIndex,
        assert(initialIndex >= 0, "Nav Bar item index cannot be less than 0");

  int get index => _index;
  int _index;

  ValueChanged<int>? onIndexChanged;

  set index(int value) {
    assert(value >= 0, "Nav Bar item index cannot be less than 0");
    if (_index == value) {
      return;
    }
    _index = value;
    onIndexChanged?.call(value);
    notifyListeners();
  }

  void jumpToTab(int value) {
    assert(value >= 0, "Nav Bar item index cannot be less than 0");
    if (_index == value) {
      return;
    }
    _index = value;
    onIndexChanged?.call(value);
    notifyListeners();
  }
}
