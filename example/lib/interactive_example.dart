import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:persistent_bottom_nav_bar_v2_example_project/settings.dart';

import 'modal_screen.dart';
import 'screens.dart';

class InteractiveExample extends StatefulWidget {
  @override
  State<InteractiveExample> createState() => _InteractiveExampleState();
}

class _InteractiveExampleState extends State<InteractiveExample> {
  PersistentTabController _controller = PersistentTabController();
  Settings settings = Settings();

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: MainScreen(),
        item: ItemConfig(
          icon: Icon(Icons.home),
          title: "Home",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: MainScreen(),
        item: ItemConfig(
          icon: Icon(Icons.search),
          title: "Search",
          activeColorPrimary: Colors.teal,
          inactiveColorPrimary: Colors.grey,
        ),
      ),
      PersistentTabConfig.noScreen(
        item: ItemConfig(
          icon: Icon(Icons.add),
          title: "Add",
          activeColorPrimary: Colors.blueAccent,
          inactiveColorPrimary: Colors.grey,
        ),
        onPressed: (context) {
          pushWithNavBar(context, SampleModalScreen());
        },
      ),
      PersistentTabConfig(
        screen: MainScreen(),
        item: ItemConfig(
          icon: Icon(Icons.message),
          title: "Messages",
          activeColorPrimary: Colors.deepOrange,
          inactiveColorPrimary: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: MainScreen(),
        item: ItemConfig(
          icon: Icon(Icons.settings),
          title: "Settings",
          activeColorPrimary: Colors.indigo,
          inactiveColorPrimary: Colors.grey,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      controller: _controller,
      tabs: _tabs(),
      navBarBuilder: (essentials) => settings.navBarBuilder(
        essentials,
        NavBarDecoration(
          color: settings.navBarColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        ItemAnimation(
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        NeumorphicProperties(),
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
        icon: Icon(Icons.settings),
      ),
      backgroundColor: Colors.green,
      margin: settings.margin,
      navBarOverlap: NavBarOverlap.full(),
      avoidBottomPadding: settings.avoidBottomPadding,
      handleAndroidBackButtonPress: settings.handleAndroidBackButtonPress,
      resizeToAvoidBottomInset: settings.resizeToAvoidBottomInset,
      stateManagement: settings.stateManagement,
      navBarHeight: kBottomNavigationBarHeight,
      popActionScreens: PopActionScreensType.all,
      onWillPop: (context) async {
        await showDialog(
          context: context,
          useSafeArea: true,
          builder: (context) => Container(
            height: 50.0,
            width: 50.0,
            color: Colors.white,
            child: ElevatedButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        );
        return false;
      },
      hideNavigationBar: settings.hideNavBar,
      popAllScreensOnTapOfSelectedTab: settings.popAllScreensOnTapOfSelectedTab,
      screenTransitionAnimation: ScreenTransitionAnimation(
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
    );
  }
}
