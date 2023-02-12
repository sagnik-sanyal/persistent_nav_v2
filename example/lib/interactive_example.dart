import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:persistent_bottom_nav_bar_v2_example_project/modal_screen.dart";
import "package:persistent_bottom_nav_bar_v2_example_project/screens.dart";
import "package:persistent_bottom_nav_bar_v2_example_project/settings.dart";

class InteractiveExample extends StatefulWidget {
  const InteractiveExample({Key key}) : super(key: key);

  @override
  State<InteractiveExample> createState() => _InteractiveExampleState();
}

class _InteractiveExampleState extends State<InteractiveExample> {
  final PersistentTabController _controller = PersistentTabController();
  Settings settings = Settings();

  List<PersistentTabConfig> _tabs() => [
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.home),
            title: "Home",
            activeColorPrimary: Colors.blue,
            inactiveColorPrimary: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.search),
            title: "Search",
            activeColorPrimary: Colors.teal,
            inactiveColorPrimary: Colors.grey,
          ),
        ),
        PersistentTabConfig.noScreen(
          item: ItemConfig(
            icon: const Icon(Icons.add),
            title: "Add",
            activeColorPrimary: Colors.blueAccent,
            inactiveColorPrimary: Colors.grey,
          ),
          onPressed: (context) {
            pushWithNavBar(context, SampleModalScreen());
          },
        ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.message),
            title: "Messages",
            activeColorPrimary: Colors.deepOrange,
            inactiveColorPrimary: Colors.grey,
          ),
        ),
        PersistentTabConfig(
          screen: const MainScreen(),
          item: ItemConfig(
            icon: const Icon(Icons.settings),
            title: "Settings",
            activeColorPrimary: Colors.indigo,
            inactiveColorPrimary: Colors.grey,
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) => PersistentTabView(
        controller: _controller,
        tabs: _tabs(),
        navBarBuilder: (essentials) => settings.navBarBuilder(
          essentials,
          NavBarDecoration(
            color: settings.navBarColor,
            borderRadius: BorderRadius.circular(10),
          ),
          const ItemAnimation(),
          const NeumorphicProperties(),
        ),
        floatingActionButton: IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => Dialog(
              child: SettingsView(
                settings: settings,
                onChanged: (newSettings) => setState(() {
                  settings = newSettings;
                }),
              ),
            ),
          ),
          icon: const Icon(Icons.settings),
        ),
        backgroundColor: Colors.green,
        margin: settings.margin,
        avoidBottomPadding: settings.avoidBottomPadding,
        handleAndroidBackButtonPress: settings.handleAndroidBackButtonPress,
        resizeToAvoidBottomInset: settings.resizeToAvoidBottomInset,
        stateManagement: settings.stateManagement,
        onWillPop: (context) async {
          await showDialog(
            context: context,
            useSafeArea: true,
            builder: (context) => Container(
              height: 50,
              width: 50,
              color: Colors.white,
              child: ElevatedButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          );
          return false;
        },
        hideNavigationBar: settings.hideNavBar,
        popAllScreensOnTapOfSelectedTab:
            settings.popAllScreensOnTapOfSelectedTab,
      );
}
