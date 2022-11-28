import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:persistent_bottom_nav_bar_v2_example_project/interactive_example.dart';
import 'package:persistent_bottom_nav_bar_v2_example_project/screens.dart';

void main() => runApp(PersistenBottomNavBarDemo());

class PersistenBottomNavBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistent Bottom Navigation Bar Demo',
      home: Builder(
        builder: (context) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed("/minimal"),
                  child: Text("Show Minimal Example"),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed("/interactive"),
                  child: Text("Show Interactive Example"),
                ),
              ],
            ),
          );
        }
      ),
      routes: {
        '/minimal': (context) => MinimalExample(),
        '/interactive': (context) => InteractiveExample(),
      },
    );
  }
}

class MinimalExample extends StatelessWidget {
  MinimalExample({Key key}) : super(key: key);

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: MainScreen(),
        item: ItemConfig(
          icon: Icon(Icons.home),
          title: "Home",
        ),
      ),
      PersistentTabConfig(
        screen: MainScreen(),
        item: ItemConfig(
          icon: Icon(Icons.message),
          title: "Messages",
        ),
      ),
      PersistentTabConfig(
        screen: MainScreen(),
        item: ItemConfig(
          icon: Icon(Icons.settings),
          title: "Settings",
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: _tabs(),
      navBarBuilder: (navBarConfig) => Style1BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Colors.white,
        ),
      ),
    );
  }
}
