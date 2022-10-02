part of persistent_bottom_nav_bar_v2;

class NavigatorConfig {
  final String? defaultTitle;

  final Map<String, WidgetBuilder> routes;

  final RouteFactory? onGenerateRoute;

  final RouteFactory? onUnknownRoute;

  final String? initialRoute;

  final List<NavigatorObserver> navigatorObservers;

  final GlobalKey<NavigatorState>? navigatorKey;

  const NavigatorConfig({
    this.defaultTitle,
    this.routes = const {},
    this.onGenerateRoute,
    this.onUnknownRoute,
    this.initialRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.navigatorKey,
  });

  NavigatorConfig copyWith({
    String? defaultTitle,
    Map<String, WidgetBuilder>? routes,
    RouteFactory? onGenerateRoute,
    RouteFactory? onUnknownRoute,
    String? initialRoute,
    List<NavigatorObserver>? navigatorObservers,
    GlobalKey<NavigatorState>? navigatorKeys,
  }) {
    return NavigatorConfig(
      defaultTitle: defaultTitle ?? this.defaultTitle,
      routes: routes ?? this.routes,
      onGenerateRoute: onGenerateRoute ?? this.onGenerateRoute,
      onUnknownRoute: onUnknownRoute ?? this.onUnknownRoute,
      initialRoute: initialRoute ?? this.initialRoute,
      navigatorObservers: navigatorObservers ?? this.navigatorObservers,
      navigatorKey: navigatorKey ?? this.navigatorKey,
    );
  }
}
