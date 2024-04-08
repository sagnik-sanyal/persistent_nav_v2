part of "../persistent_bottom_nav_bar_v2.dart";

/// Navigation bar controller for `PersistentTabView`.
class PersistentTabController extends ChangeNotifier {
  PersistentTabController({
    int initialIndex = 0,
    int historyLength = 5,
  })  : _initialIndex = initialIndex,
        _historyLength = historyLength,
        _index = initialIndex,
        assert(initialIndex >= 0, "Nav Bar item index cannot be less than 0"),
        assert(historyLength >= 0, "Nav Bar history length cannot be less than 0");

  final int _initialIndex;
  final int _historyLength;
  int get index => _index;
  int _index;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<int> _tabHistory = [];
  ValueChanged<int>? onIndexChanged;

  void _updateIndex(int value, [bool isUndo = false]) {
    assert(value >= 0, "Nav Bar item index cannot be less than 0");
    if (_index == value) {
      return;
    }
    if (!isUndo) {
      if (_historyLength > 0) {
        _tabHistory.add(_index);
      }

      if (_tabHistory.length > _historyLength) {
        _tabHistory.removeRange(1, _tabHistory.length - _historyLength + 1);
        if (_tabHistory.length > 1 && _tabHistory[0] == _tabHistory[1]) {
          _tabHistory.removeAt(1);
        }
      }
    }
    _index = value;
    onIndexChanged?.call(value);
    notifyListeners();
  }

  void jumpToTab(int value) {
    _updateIndex(value);
  }

  void jumpToPreviousTab() {
    if (!isOnInitialTab()) {
      _updateIndex(_tabHistory.removeLast(), true);
    }
  }

  bool isOnInitialTab() => _tabHistory.isEmpty;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
