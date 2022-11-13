import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:persistent_bottom_nav_bar_v2_example_project/interactive_example.dart';
import 'package:persistent_bottom_nav_bar_v2_example_project/modal-screen.dart';
import 'package:persistent_bottom_nav_bar_v2_example_project/screens.dart';

void main() => runApp(PersistenBottomNavBarDemo());

class PersistenBottomNavBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistent Bottom Navigation Bar Demo',
      home: MainMenu(),
      routes: {
        // When navigating to the "/first" route, build the FirstScreen widget.
        '/first': (context) => MainScreen2(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => MainScreen3(),
      },
    );
  }
}

class MainMenu extends StatelessWidget {
  MainMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navigation Bar Demo"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: ElevatedButton(
              child: Text("Built-in style example"),
              onPressed: () => pushNewScreen(
                context,
                screen: ProvidedStyleExample(),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Center(
            child: ElevatedButton(
              child: Text("Interactive Example"),
              onPressed: () => pushNewScreen(
                context,
                screen: InteractiveExample(),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Center(
            child: ElevatedButton(
              child: Text("Interactive Example"),
              onPressed: () => pushNewScreen(
                context,
                screen: TestScaffold(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TestScaffold extends StatelessWidget {
  const TestScaffold({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        padding: EdgeInsets.only(
            bottom: 100,
            top: MediaQuery.of(context)
                .padding
                .top), // TODO: Simulate gesture bar
      ),
      child: Scaffold(
        appBar: AppBar(title: Text("Test Scaffold")),
        body: MainScreen(),
        bottomNavigationBar: Container(
          color: Colors.green,
          height: 50,
        ),
        bottomSheet: Container(
          color: Colors.red,
          height: 30,
        ),
      ),
    );
  }
}

// ----------------------- Using a provided Navbar style ---------------------//

class ProvidedStyleExample extends StatefulWidget {
  ProvidedStyleExample({Key key}) : super(key: key);

  @override
  _ProvidedStyleExampleState createState() => _ProvidedStyleExampleState();
}

class _ProvidedStyleExampleState extends State<ProvidedStyleExample> {
  PersistentTabController _controller;
  bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<PersistentTabConfig> _tabs() {
    return [
      PersistentTabConfig(
        screen: MainScreen(
          hideStatus: _hideNavBar,
          onScreenHideButtonPressed: () {
            setState(() {
              _hideNavBar = !_hideNavBar;
            });
          },
        ),
        item: ItemConfig(
          icon: Icon(Icons.home),
          title: "Home",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
          inactiveColorSecondary: Colors.purple,
        ),
      ),
      PersistentTabConfig(
        screen: MainScreen(
          hideStatus: _hideNavBar,
          onScreenHideButtonPressed: () {
            setState(() {
              _hideNavBar = !_hideNavBar;
            });
          },
        ),
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
          activeColorSecondary: Colors.green,
          inactiveColorPrimary: Colors.grey,
        ),
        onPressed: (context) {
          pushDynamicScreen(context,
              screen: SampleModalScreen(), withNavBar: true);
        },
      ),
      PersistentTabConfig(
        screen: MainScreen(
          hideStatus: _hideNavBar,
          onScreenHideButtonPressed: () {
            setState(() {
              _hideNavBar = !_hideNavBar;
            });
          },
        ),
        item: ItemConfig(
          icon: Icon(Icons.message),
          title: "Messages",
          activeColorPrimary: Colors.deepOrange,
          inactiveColorPrimary: Colors.grey,
        ),
      ),
      PersistentTabConfig(
        screen: MainScreen(
          hideStatus: _hideNavBar,
          onScreenHideButtonPressed: () {
            setState(() {
              _hideNavBar = !_hideNavBar;
            });
          },
        ),
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
      navBarOverlap: NavBarOverlap.full(),
      avoidBottomPadding: true,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarHeight: kBottomNavigationBarHeight,
      hideNavigationBarWhenKeyboardShows: true,
      margin: EdgeInsets.all(0.0),
      popActionScreens: PopActionScreensType.all,
      onTabChanged: (i) {
        print("Switched to tab $i");
      },
      floatingActionButton: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.ac_unit,
            size: 40,
          )),
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
      hideNavigationBar: _hideNavBar,
      popAllScreensOnTapOfSelectedTab: true,
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarBuilder: (navBarEssentials) => BottomNavStyle15(
        navBarEssentials: navBarEssentials,
        navBarDecoration:
            NavBarAppearance(decoration: BoxDecoration(color: Colors.white)),
        // itemAnimationProperties: ItemAnimationProperties(
        //   duration: Duration(milliseconds: 400),
        //   curve: Curves.ease,
        // ),
      ), // Choose the nav bar widget with this property
    );
  }
}

class CustomNavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final List<ItemConfig> items;
  final ValueChanged<int> onItemSelected;

  CustomNavBarWidget({
    Key key,
    this.selectedIndex,
    @required this.items,
    this.onItemSelected,
  });

  Widget _buildItem(ItemConfig item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      height: kBottomNavigationBarHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 26.0,
                  color: isSelected
                      ? (item.activeColorSecondary == null
                          ? item.activeColorPrimary
                          : item.activeColorSecondary)
                      : item.inactiveColorPrimary == null
                          ? item.activeColorPrimary
                          : item.inactiveColorPrimary),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Material(
              type: MaterialType.transparency,
              child: FittedBox(
                child: Text(
                  item.title,
                  style: TextStyle(
                      color: isSelected
                          ? (item.activeColorSecondary == null
                              ? item.activeColorPrimary
                              : item.activeColorSecondary)
                          : item.inactiveColorPrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        width: double.infinity,
        height: kBottomNavigationBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.map((item) {
            int index = items.indexOf(item);
            return Expanded(
              child: InkWell(
                onTap: () {
                  this.onItemSelected(index);
                },
                child: _buildItem(item, selectedIndex == index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
