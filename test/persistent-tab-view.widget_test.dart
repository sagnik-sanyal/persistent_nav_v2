import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

PersistentTabConfig tabConfig(int id, Widget screen) => PersistentTabConfig(
      screen: screen,
      item: ItemConfig(title: "Item$id", icon: Icon(Icons.add)),
    );

Widget defaultScreen(int id) => Container(child: Text("Screen$id"));

Widget screenWithSubPages(int id) => id > 99
    ? defaultScreen(id)
    : Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            defaultScreen(id),
            Builder(builder: (context) {
              return ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          screenWithSubPages(id * 10 + (id % 10))),
                ),
                child: Text("SubPage"),
              );
            })
          ],
        ),
      );

Future<void> tapAndroidBackButton(WidgetTester tester) async {
  final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
  await widgetsAppState.didPopRoute();
  await tester.pumpAndSettle();
}

void main() {
  Widget wrapTabView(WidgetBuilder builder) {
    return MaterialApp(
      home: Builder(
        builder: (context) => builder(context),
      ),
    );
  }

  group('PersistentTabView', () {
    testWidgets('builds a DecoratedNavBar', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);
    });

    testWidgets('can switch through tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      expect(find.text('Screen1'), findsOneWidget);
      expect(find.text('Screen2'), findsNothing);
      expect(find.text('Screen3'), findsNothing);
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(find.text('Screen1'), findsNothing);
      expect(find.text('Screen2'), findsOneWidget);
      expect(find.text('Screen3'), findsNothing);
      await tester.tap(find.text("Item3"));
      await tester.pumpAndSettle();
      expect(find.text('Screen1'), findsNothing);
      expect(find.text('Screen2'), findsNothing);
      expect(find.text('Screen3'), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text('Screen1'), findsOneWidget);
      expect(find.text('Screen2'), findsNothing);
      expect(find.text('Screen3'), findsNothing);
    });

    testWidgets('hides the navbar when hideNavBar is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            hideNavigationBar: true,
          ),
        ),
      );

      expect(find.byType(DecoratedNavBar).hitTestable(), findsNothing);
    });

    testWidgets("sizes the navbar according to navBarHeight",
        (WidgetTester tester) async {
      double height = 42;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            navBarHeight: height,
          ),
        ),
      );

      expect(
          tester.getSize(find.byType(DecoratedNavBar)).height, equals(height));
    });

    testWidgets("puts padding around the navbar specified by margin",
        (WidgetTester tester) async {
      EdgeInsets margin = EdgeInsets.zero;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            margin: margin,
          ),
        ),
      );

      expect(
          Offset(0, 600) - tester.getBottomLeft(find.byType(DecoratedNavBar)),
          equals(margin.bottomLeft));
      expect(
          Offset(800, 600 - 56) -
              tester.getTopRight(find.byType(DecoratedNavBar)),
          equals(margin.topRight));

      margin = EdgeInsets.fromLTRB(12, 10, 8, 6);

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            margin: margin,
          ),
        ),
      );

      expect(
          tester.getBottomLeft(find
                  .descendant(
                      of: find.byType(DecoratedNavBar),
                      matching: find.byType(Container))
                  .first) -
              Offset(0, 600),
          equals(margin.bottomLeft));
      expect(
          tester.getTopRight(find
                  .descendant(
                      of: find.byType(DecoratedNavBar),
                      matching: find.byType(Container))
                  .first) -
              Offset(800, 600 - 56 - margin.vertical),
          equals(margin.topRight));
    });

    testWidgets("navbar is colored by decoration color",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration: NavBarDecoration(color: Color(0xFFFFC107)),
            ),
          ),
        ),
      );

      expect(
          ((tester.firstWidget((find.descendant(
                      of: find.byType(DecoratedNavBar),
                      matching: find.byType(Container)))) as Container)
                  .decoration as BoxDecoration)
              .color,
          Color(0xFFFFC107));
    });

    testWidgets("executes onItemSelected when tapping items",
        (WidgetTester tester) async {
      int count = 0;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            onTabChanged: (index) => count++,
          ),
        ),
      );

      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(count, 1);
      await tester.tap(find.text("Item3"));
      await tester.pumpAndSettle();
      expect(count, 2);
    });

    testWidgets("executes onWillPop when exiting", (WidgetTester tester) async {
      int count = 0;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            onWillPop: (context) async {
              count++;
              return true;
            },
          ),
        ),
      );

      await tapAndroidBackButton(tester);

      expect(count, 1);
    });

    group("should handle Android back button press and thus", () {
      testWidgets("switches to first tab on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, screenWithSubPages(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
              handleAndroidBackButtonPress: true,
            ),
          ),
        );

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen2'), findsNothing);
        await tester.tap(find.text("Item2"));
        await tester.pumpAndSettle();
        expect(find.text('Screen1'), findsNothing);
        expect(find.text('Screen2'), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen2'), findsNothing);
      });

      testWidgets("pops one screen on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, screenWithSubPages(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
              handleAndroidBackButtonPress: true,
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen11'), findsNothing);
      });
    });

    group("should not handle Android back button press and thus", () {
      testWidgets("does not switch to first tab on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, defaultScreen(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
              handleAndroidBackButtonPress: false,
            ),
          ),
        );

        expect(find.text('Screen1'), findsOneWidget);
        expect(find.text('Screen2'), findsNothing);
        await tester.tap(find.text("Item2"));
        await tester.pumpAndSettle();
        expect(find.text('Screen1'), findsNothing);
        expect(find.text('Screen2'), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text('Screen1'), findsNothing);
        expect(find.text('Screen2'), findsOneWidget);
      });

      testWidgets("pops no screen on back button press",
          (WidgetTester tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, screenWithSubPages(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
              handleAndroidBackButtonPress: false,
            ),
          ),
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();
        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);
      });
    });

    testWidgets("navBarPadding adds padding inside navBar",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration: NavBarDecoration(padding: EdgeInsets.all(0)),
            ),
          ),
        ),
      );
      double originalIconSize = tester.getSize(find.byType(Icon).first).height;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration: NavBarDecoration(padding: EdgeInsets.all(4)),
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byType(Icon).first).height,
          equals(originalIconSize - 4 * 2));
    });
    testWidgets("navBarPadding does not make navbar bigger",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration: NavBarDecoration(padding: EdgeInsets.all(4)),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(DecoratedNavBar)).height,
          equals(kBottomNavigationBarHeight));
    });

    testWidgets(
        'resizes screens to avoid bottom inset according to resizeToAvoidBottomInset',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(builder: (context) {
              return PersistentTabView(
                tabs: [1, 2, 3]
                    .map((id) => tabConfig(id, defaultScreen(id)))
                    .toList(),
                navBarBuilder: (config) =>
                    Style1BottomNavBar(navBarConfig: config),
                resizeToAvoidBottomInset: true,
              );
            }),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CustomTabView).first).height,
          equals(500));

      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: MediaQueryData(
              viewInsets: const EdgeInsets.only(
                  bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(builder: (context) {
              return PersistentTabView(
                tabs: [1, 2, 3]
                    .map((id) => tabConfig(id, defaultScreen(id)))
                    .toList(),
                navBarBuilder: (config) =>
                    Style1BottomNavBar(navBarConfig: config),
                resizeToAvoidBottomInset: false,
              );
            }),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CustomTabView).first).height,
          equals(600));
    });

    testWidgets('shrinks screens according to NavBarOverlap.custom',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            navBarOverlap:
                NavBarOverlap.full(),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CustomTabView).first).height,
          equals(600));

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            navBarOverlap:
                NavBarOverlap.none(),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CustomTabView).first).height,
          equals(600 - kBottomNavigationBarHeight));

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            navBarOverlap:
                NavBarOverlap.custom(overlap: 30),
          ),
        ),
      );

      expect(tester.getSize(find.byType(CustomTabView).first).height,
          equals(600 - (kBottomNavigationBarHeight - 30)));
    });

    testWidgets(
        'returns current screen context through selectedTabScreenContext',
        (WidgetTester tester) async {
      BuildContext? screenContext;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabContext: (context) => screenContext = context,
          ),
        ),
      );

      expect(screenContext?.findAncestorWidgetOfExactType<Offstage>()?.offstage,
          isFalse);
      BuildContext? oldContext = screenContext;
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(screenContext, isNot(equals(oldContext)));
      expect(screenContext?.findAncestorWidgetOfExactType<Offstage>()?.offstage,
          isFalse);
    });

    testWidgets('pops screens when tapping same tab if specified to do so',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            popAllScreensOnTapOfSelectedTab: true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            popAllScreensOnTapOfSelectedTab: false,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
    });

    testWidgets('pops all screens when tapping same tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            popAllScreensOnTapOfSelectedTab: true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsNothing);
      expect(find.text("Screen111"), findsOneWidget);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);
      expect(find.text("Screen111"), findsNothing);
    });

    testWidgets('persists screens while switching if stateManagement turned on',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            stateManagement: true,
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
    });

    testWidgets('trashes screens while switching if stateManagement turned off',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            stateManagement: false,
            screenTransitionAnimation: ScreenTransitionAnimation(
              animateTabTransition: true,
              curve: Curves.ease,
              duration: Duration(milliseconds: 200),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();
      expect(find.text("Screen1"), findsNothing);
      expect(find.text("Screen11"), findsOneWidget);
      await tester.tap(find.text("Item2"));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);
      expect(find.text("Screen11"), findsNothing);
      await tester.tap(find.text("Item1"));
      await tester.pumpAndSettle();
      expect(find.text("Screen11"), findsNothing);
      expect(find.text("Screen1"), findsOneWidget);
    });

    testWidgets('shows FloatingActionButton if specified',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton).hitTestable(), findsOneWidget);
    });

    testWidgets(
        "Style 13 and Style 14 center button are tappable above the navBar",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) =>
                Style13BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      Offset topCenter = tester.getRect(find.byType(DecoratedNavBar)).topCenter;
      await tester.tapAt(topCenter.translate(0, -10));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) =>
                Style14BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      topCenter = tester.getRect(find.byType(DecoratedNavBar)).topCenter;
      await tester.tapAt(topCenter.translate(0, -10));
      await tester.pumpAndSettle();
      expect(find.text("Screen2"), findsOneWidget);
    });
  });

  group("Regression", () {
    testWidgets("#31 one navbar border side does not throw error",
        (widgetTester) async {
      await widgetTester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration: const NavBarDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  });
}
