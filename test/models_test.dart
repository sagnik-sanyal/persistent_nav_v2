import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

void main() {
  group("ScreenTransitionAnimation", () {
    testWidgets("== and hashCode", (tester) async {
      const animation = ScreenTransitionAnimation();
      expect(animation, equals(animation));
      expect(animation, equals(const ScreenTransitionAnimation()));
      expect(
        animation.hashCode,
        equals(const ScreenTransitionAnimation().hashCode),
      );
    });
  });

  group("NavBarConfig", () {
    testWidgets("copyWith", (tester) async {
      bool didRun = false;

      final config = NavBarConfig(
        selectedIndex: 0,
        items: List.empty(),
        onItemSelected: (index) {},
      );
      final newConfig = config.copyWith(
        selectedIndex: 1,
        items: [ItemConfig(icon: const Icon(Icons.home), title: "Home")],
        onItemSelected: (index) {
          didRun = true;
        },
      );
      expect(newConfig.selectedIndex, equals(1));
      expect(newConfig.items.first.title, equals("Home"));
      newConfig.onItemSelected(0);
      expect(didRun, isTrue);
    });
  });

  group("NavigatorConfig", () {
    testWidgets("copyWith", (tester) async {
      final config = NavigatorConfig(
        defaultTitle: "Default Title",
        routes: {"route": (context) => const SizedBox()},
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        initialRoute: "/",
        navigatorObservers: [NavigatorObserver()],
        navigatorKey: GlobalKey<NavigatorState>(),
      );
      final newConfig = config.copyWith(
        defaultTitle: "New Title",
        routes: {"newRoute": (context) => const SizedBox()},
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const SizedBox(),
        ),
        initialRoute: "/new",
        navigatorObservers: [NavigatorObserver()],
        navigatorKey: GlobalKey<NavigatorState>(),
      );
      expect(newConfig.defaultTitle, equals("New Title"));
      expect(newConfig.routes.keys.first, equals("newRoute"));
      expect(newConfig.initialRoute, equals("/new"));
    });
  });

  group("NavBarDecoration", () {
    testWidgets("exposedHeight is calculated correctly", (tester) async {
      final decoration = NavBarDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2),
      );
      expect(decoration.exposedHeight(), equals(14));
    });
  });
}
