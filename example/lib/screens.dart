import "package:flutter/material.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";
import "package:persistent_bottom_nav_bar_v2_example_project/modal_screen.dart";

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Tab Main Screen")),
        backgroundColor: Colors.indigo,
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: TextField(
                decoration: InputDecoration(hintText: "Test Text Field"),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  pushScreen(
                    context,
                    settings: const RouteSettings(name: "/home"),
                    screen: const MainScreen2(),
                    pageTransitionAnimation:
                        PageTransitionAnimation.scaleRotate,
                  );
                },
                child: const Text(
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
                        child: const Text(
                          "Exit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text(
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
                        child: const Text(
                          "Exit",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Push bottom sheet BEHIND the Nav Bar",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  pushWithNavBar(context, SampleModalScreen());
                },
                child: const Text(
                  "Push Dynamic/Modal Screen",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
}

class MainScreen2 extends StatelessWidget {
  const MainScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Secondary Screen")),
        backgroundColor: Colors.teal,
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Center(
              child: ElevatedButton(
                onPressed: () {
                  pushScreen(context, screen: const MainScreen3());
                },
                child: const Text(
                  "Go to Third Screen",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Go Back to First Screen",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
}

class MainScreen3 extends StatelessWidget {
  const MainScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text("Tertiary Screen")),
        backgroundColor: Colors.deepOrangeAccent,
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Go Back to Second Screen",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
}
