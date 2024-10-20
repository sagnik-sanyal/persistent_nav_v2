part of "../persistent_bottom_nav_bar_v2.dart";

/// Navigation bar controller for `PersistentTabView`.
class PersistentTabController extends ChangeNotifier {
  PersistentTabController({int initialIndex = 0})
      : _index = initialIndex,
        assert(initialIndex >= 0, "Nav Bar item index cannot be less than 0");

  int get index => _index;
  int _index;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final List<int> _tabHistory = [];

  void _updateIndex(int value, [bool isUndo = false]) {
    assert(value >= 0, "Nav Bar item index cannot be less than 0");
    if (_index == value) {
      return;
    }
    if (!isUndo) {
      _tabHistory.add(_index);
    }
    _index = value;
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
