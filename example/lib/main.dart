import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:persistent_bottom_nav_bar_v2_example_project/interactive_example.dart";
import "package:persistent_bottom_nav_bar_v2_example_project/screens.dart";

void main() => runApp(const PersistenBottomNavBarDemo());

class PersistenBottomNavBarDemo extends StatelessWidget {
  const PersistenBottomNavBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Persistent Bottom Navigation Bar Demo",
        home: Builder(
          builder: (context) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed("/minimal"),
                  child: const Text("Show Minimal Example"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed("/interactive"),
                  child: const Text("Show Interactive Example"),
                ),
              ],
            ),
          ),
        ),
        routes: {
          "/minimal": (context) => const MinimalExample(),
          "/interactive": (context) => const InteractiveExample(),
        },
      );
}

class MinimalExample extends StatelessWidget {
  const MinimalExample({Key? key}) : super(key: key);

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
          ),
        ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.message),
            title: "Messages",
          ),
        ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: "Settings",
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => PersistentTabView(
        tabs: _tabs(),
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
        ),
      );
}
