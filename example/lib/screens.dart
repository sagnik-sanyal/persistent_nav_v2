import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:persistent_bottom_nav_bar_v2_example_project/modal_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tab Main Screen')),
      backgroundColor: Colors.indigo,
      body: ListView(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            child: TextField(
              decoration: InputDecoration(hintText: "Test Text Field"),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: '/home'),
                  screen: MainScreen2(),
                  pageTransitionAnimation: PageTransitionAnimation.scaleRotate,
                );
              },
              child: Text(
                "Go to Second Screen ->",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  useRootNavigator: true,
                  builder: (context) => Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                "Push bottom sheet on TOP of Nav Bar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.white,
                  useRootNavigator: false,
                  builder: (context) => Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Exit",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
              child: Text(
                "Push bottom sheet BEHIND the Nav Bar",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                pushDynamicScreen(context,
                    screen: SampleModalScreen(), withNavBar: true);
              },
              child: Text(
                "Push Dynamic/Modal Screen",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 60.0,
          ),
        ],
      ),
    );
  }
}

class MainScreen2 extends StatelessWidget {
  const MainScreen2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secondary Screen')),
      backgroundColor: Colors.teal,
      body: ListView(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              pushNewScreen(context, screen: MainScreen3());
            },
            child: Text(
              "Go to Third Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Go Back to First Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class MainScreen3 extends StatelessWidget {
  const MainScreen3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tertiary Screen')),
      backgroundColor: Colors.deepOrangeAccent,
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Go Back to Second Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
