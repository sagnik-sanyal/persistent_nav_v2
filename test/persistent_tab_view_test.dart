// ignore_for_file: avoid_redundant_argument_values

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

PersistentTabConfig tabConfig(
  int id,
  Widget screen, [
  ScrollController? scrollController,
]) =>
    PersistentTabConfig(
      screen: screen,
      scrollController: scrollController,
      item: ItemConfig(title: "Item$id", icon: const Icon(Icons.add)),
    );

Widget defaultScreen(
  int tab, {
  int level = 0,
  void Function(BuildContext)? onTap,
}) =>
    Column(
      children: [
        Text("Tab $tab"),
        Text("Level $level"),
        Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              if (onTap != null) {
                onTap(context);
                return;
              }
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => defaultScreen(tab, level: level + 1),
                ),
              );
            },
            child: const Text("Push Screen"),
          ),
        ),
      ],
    );

Widget scrollableScreen(
  int tab, {
  int level = 0,
  ScrollController? controller,
}) =>
    ListView(
      controller: controller,
      children: [
        Text("Tab $tab"),
        Text("Level $level"),
        ...List.generate(
          40,
          (id) => Container(
            padding: const EdgeInsets.all(16),
            child: Text("Item $id"),
          ),
        ),
      ],
    );

List<PersistentTabConfig> tabs([int count = 3]) => List.generate(
      count,
      (index) => tabConfig(index, defaultScreen(index)),
    );

Future<void> tapAndroidBackButton(WidgetTester tester) async {
  final dynamic widgetsAppState = tester.state(find.byType(WidgetsApp));
  // ignore: avoid_dynamic_calls
  await widgetsAppState.didPopRoute();
  await tester.pumpAndSettle();
}

Future<void> tapElevatedButton(WidgetTester tester) async {
  await tester.tap(find.byType(ElevatedButton));
  await tester.pumpAndSettle();
}

Future<void> tapItem(WidgetTester tester, int id) async {
  await tester.tap(find.text("Item$id"));
  await tester.pumpAndSettle();
}

Future<void> scroll(
  WidgetTester tester,
  Offset start,
  Offset moveBy,
) async {
  final gesture = await tester.startGesture(start);

  await gesture.moveBy(moveBy);
  await tester.pumpAndSettle();

  await gesture.removePointer();
  await gesture.cancel();
}

void expectTabAndLevel({required int tab, required int level}) {
  expect(find.text("Tab $tab").hitTestable(), findsOneWidget);
  expect(find.text("Level $level").hitTestable(), findsOneWidget);
}

void expectNotTabAndLevel({required int tab, required int level}) {
  expect(find.text("Tab $tab").hitTestable(), findsNothing);
  expect(find.text("Level $level").hitTestable(), findsNothing);
}

void expectMainScreen() {
  expect(find.text("Main Screen"), findsOneWidget);
}

Widget wrapTabView(WidgetBuilder builder) => MaterialApp(
      home: Builder(
        builder: (context) => builder(context),
      ),
    );

Widget wrapTabViewWithMainScreen(WidgetBuilder builder) => wrapTabView(
      (context) => ElevatedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => builder(context),
          ),
        ),
        child: const Text("Main Screen"),
      ),
    );

void main() {
  group("PersistentTabView", () {
    testWidgets("builds a DecoratedNavBar", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);
    });

    testWidgets("can switch through tabs", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      expectTabAndLevel(tab: 0, level: 0);
      await tapItem(tester, 1);
      expectTabAndLevel(tab: 1, level: 0);
      await tapItem(tester, 2);
      expectTabAndLevel(tab: 2, level: 0);
      await tapItem(tester, 0);
      expectTabAndLevel(tab: 0, level: 0);
    });

    testWidgets("hides the navbar when hideNavBar is true", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            hideNavigationBar: true,
          ),
        ),
      );

      expect(find.byType(DecoratedNavBar).hitTestable(), findsNothing);
    });

    testWidgets("sizes the navbar according to the height", (tester) async {
      const double height = 42;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              height: height,
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(DecoratedNavBar)).height,
        equals(height),
      );
    });

    testWidgets("puts padding around the navbar specified by margin",
        (tester) async {
      EdgeInsets margin = EdgeInsets.zero;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            margin: margin,
          ),
        ),
      );

      expect(
        const Offset(0, 600) -
            tester.getBottomLeft(find.byType(DecoratedNavBar)),
        equals(margin.bottomLeft),
      );
      expect(
        const Offset(800, 600 - 56) -
            tester.getTopRight(find.byType(DecoratedNavBar)),
        equals(margin.topRight),
      );

      margin = const EdgeInsets.fromLTRB(12, 10, 8, 6);

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
        tester.getBottomLeft(
              find
                  .descendant(
                    of: find.byType(DecoratedNavBar),
                    matching: find.byType(Container),
                  )
                  .first,
            ) -
            const Offset(0, 600),
        equals(margin.bottomLeft),
      );
      expect(
        tester.getTopRight(
              find
                  .descendant(
                    of: find.byType(DecoratedNavBar),
                    matching: find.byType(Container),
                  )
                  .first,
            ) -
            Offset(800, 600 - 56 - margin.vertical),
        equals(margin.topRight),
      );
    });

    testWidgets("navbar is colored by decoration color", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration:
                  const NavBarDecoration(color: Color(0xFFFFC107)),
            ),
          ),
        ),
      );

      expect(
        ((tester.firstWidget(
          find.descendant(
            of: find.byType(DecoratedNavBar),
            matching: find.byType(DecoratedBox),
          ),
        ) as DecoratedBox?)
                ?.decoration as BoxDecoration?)
            ?.color,
        const Color(0xFFFFC107),
      );
    });

    testWidgets("executes onItemSelected when tapping items", (tester) async {
      int count = 0;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            onTabChanged: (index) => count++,
          ),
        ),
      );

      await tapItem(tester, 1);
      expect(count, 1);
      await tapItem(tester, 2);
      expect(count, 2);
    });

    testWidgets(
        "executes onPopInvokedWithResult of enclosing PopScope when exiting",
        (tester) async {
      bool? popResult;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              popResult = didPop;
            },
            child: PersistentTabView(
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        ),
      );

      await tapAndroidBackButton(tester);

      expect(popResult, false);
    });

    group("should handle Android back button press and thus", () {
      testWidgets("switches to first tab on back button press", (tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        expectTabAndLevel(tab: 0, level: 0);
        await tapItem(tester, 1);
        expectTabAndLevel(tab: 1, level: 0);
        await tapAndroidBackButton(tester);
        expectTabAndLevel(tab: 0, level: 0);
      });

      testWidgets("pops one screen on back button press", (tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectTabAndLevel(tab: 0, level: 1);

        await tapAndroidBackButton(tester);
        expectTabAndLevel(tab: 0, level: 0);
      });

      testWidgets("pops main screen when historyLength is 0", (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 0),
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectTabAndLevel(tab: 0, level: 0);

        await tapItem(tester, 1);
        expectTabAndLevel(tab: 1, level: 0);

        await tapAndroidBackButton(tester);
        expectMainScreen();
      });

      testWidgets("pops main screen when historyLength is 1", (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 1),
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectTabAndLevel(tab: 0, level: 0);

        await tapItem(tester, 1);
        expectTabAndLevel(tab: 1, level: 0);

        await tapAndroidBackButton(tester);
        expectTabAndLevel(tab: 0, level: 0);

        await tapAndroidBackButton(tester);
        expectMainScreen();
      });

      testWidgets(
          "pops main screen when historyLength is 1 and switched to initial tab",
          (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 1),
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectTabAndLevel(tab: 0, level: 0);

        await tapItem(tester, 1);
        expectTabAndLevel(tab: 1, level: 0);

        await tapItem(tester, 0);
        expectTabAndLevel(tab: 0, level: 0);

        await tapAndroidBackButton(tester);
        expectMainScreen();
      });

      testWidgets(
          "pops main screen when historyLength is 1 and initial tab has subpage",
          (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 1),
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectTabAndLevel(tab: 0, level: 0);

        await tapElevatedButton(tester);
        expectTabAndLevel(tab: 0, level: 1);

        await tapItem(tester, 1);
        expectTabAndLevel(tab: 1, level: 0);

        await tapAndroidBackButton(tester);
        expectTabAndLevel(tab: 0, level: 1);

        await tapAndroidBackButton(tester);
        expectTabAndLevel(tab: 0, level: 0);

        await tapAndroidBackButton(tester);
        expectMainScreen();
      });

      testWidgets("pops main screen when historyLength is 2", (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 2),
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectTabAndLevel(tab: 0, level: 0);

        await tapItem(tester, 1);
        expectTabAndLevel(tab: 1, level: 0);

        await tapItem(tester, 2);
        expectTabAndLevel(tab: 2, level: 0);

        await tapAndroidBackButton(tester);
        expectTabAndLevel(tab: 1, level: 0);

        await tapAndroidBackButton(tester);
        expectTabAndLevel(tab: 0, level: 0);

        await tapAndroidBackButton(tester);
        expectMainScreen();
      });

      testWidgets(
          "pops main screen when historyLength is 2 and clearing history",
          (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(
                historyLength: 2,
                clearHistoryOnInitialIndex: true,
              ),
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectTabAndLevel(tab: 0, level: 0);

        await tapItem(tester, 1);
        expectTabAndLevel(tab: 1, level: 0);

        await tapItem(tester, 0);
        expectTabAndLevel(tab: 0, level: 0);

        await tapAndroidBackButton(tester);
        expectMainScreen();
      });
    });

    group("should not handle Android back button press and thus", () {
      testWidgets("does not switch the tab on back button press",
          (tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
              handleAndroidBackButtonPress: false,
            ),
          ),
        );

        expectTabAndLevel(tab: 0, level: 0);
        await tapItem(tester, 1);
        expectTabAndLevel(tab: 1, level: 0);

        await tapAndroidBackButton(tester);

        expectTabAndLevel(tab: 1, level: 0);
      });

      testWidgets("pops no screen on back button press", (tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: tabs(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
              handleAndroidBackButtonPress: false,
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectTabAndLevel(tab: 0, level: 1);

        await tapAndroidBackButton(tester);

        expectTabAndLevel(tab: 0, level: 1);
      });
    });

    group("handles altering tabs at runtime when", () {
      testWidgets("removing tabs", (tester) async {
        final List<PersistentTabConfig> localTabs = tabs();

        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: localTabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        expectTabAndLevel(tab: 0, level: 0);
        expect(find.byType(Icon), findsNWidgets(3));

        localTabs.removeAt(0);
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: localTabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );
        await tester.pump();

        expectTabAndLevel(tab: 1, level: 0);
        expect(find.byType(Icon), findsNWidgets(2));
      });

      testWidgets("removing and re-adding tabs", (tester) async {
        final List<PersistentTabConfig> localTabs = tabs();

        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: localTabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        expectTabAndLevel(tab: 0, level: 0);
        expect(find.byType(Icon), findsNWidgets(3));

        localTabs.removeAt(0);
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: localTabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );
        await tester.pump();

        expectTabAndLevel(tab: 1, level: 0);
        expect(find.byType(Icon), findsNWidgets(2));

        localTabs.insert(0, tabConfig(0, defaultScreen(0)));

        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: localTabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );
        await tester.pump();

        expectTabAndLevel(tab: 0, level: 0);
        expect(find.byType(Icon), findsNWidgets(3));
      });
    });

    testWidgets(
        "hides nav bar after the specified amount of pixels have been scrolled",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: List.generate(3, (id) => tabConfig(id, scrollableScreen(id))),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
            ),
            hideOnScrollVelocity: 200,
          ),
        ),
      );

      final initialHeight =
          tester.getSize(find.byType(DecoratedNavBar).first).height;

      await scroll(tester, const Offset(0, 200), const Offset(0, -100));

      expect(
        find.byType(DecoratedNavBar).hitTestable(at: Alignment.topCenter),
        findsOneWidget,
      );
      expect(
        (tester.getRect(find.byType(DecoratedNavBar).first).bottom - 600)
            .toStringAsPrecision(2),
        equals(
          (Curves.ease.transform(0.5) * initialHeight).toStringAsPrecision(2),
        ),
      );

      await scroll(tester, const Offset(0, 200), const Offset(0, -100));
      expect(
        tester.getRect(find.byType(DecoratedNavBar).first).bottom - 600,
        equals(kBottomNavigationBarHeight),
      );

      expect(find.byType(DecoratedNavBar).hitTestable(), findsNothing);
      await scroll(tester, const Offset(0, 200), const Offset(0, 200));

      expect(find.byType(DecoratedNavBar).hitTestable(), findsOneWidget);
      expect(
        tester.getSize(find.byType(DecoratedNavBar).first).height,
        equals(initialHeight),
      );
    });

    testWidgets("navBarPadding adds padding inside navBar", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration:
                  const NavBarDecoration(padding: EdgeInsets.zero),
            ),
          ),
        ),
      );
      final double originalIconSize =
          tester.getSize(find.byType(Icon).first).height;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration:
                  const NavBarDecoration(padding: EdgeInsets.all(4)),
            ),
          ),
        ),
      );
      expect(
        tester.getSize(find.byType(Icon).first).height,
        equals(originalIconSize - 4 * 2),
      );
    });

    testWidgets("navBarPadding does not make navbar bigger", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration:
                  const NavBarDecoration(padding: EdgeInsets.all(4)),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(DecoratedNavBar)).height,
        equals(kBottomNavigationBarHeight),
      );
    });

    testWidgets(
        "resizes screens to avoid bottom inset according to resizeToAvoidBottomInset",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: const MediaQueryData(
              viewInsets:
                  EdgeInsets.only(bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(
              builder: (context) => PersistentTabView(
                tabs: tabs(),
                navBarBuilder: (config) =>
                    Style1BottomNavBar(navBarConfig: config),
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(CustomTabView).first).height,
        equals(500),
      );

      await tester.pumpWidget(
        wrapTabView(
          (context) => MediaQuery(
            data: const MediaQueryData(
              viewInsets:
                  EdgeInsets.only(bottom: 100), // Simulate an open keyboard
            ),
            child: Builder(
              builder: (context) => PersistentTabView(
                tabs: tabs(),
                navBarBuilder: (config) =>
                    Style1BottomNavBar(navBarConfig: config),
                resizeToAvoidBottomInset: false,
              ),
            ),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(CustomTabView).first).height,
        equals(600 - kBottomNavigationBarHeight),
      );
    });

    testWidgets("shrinks screens according to NavBarOverlap.custom",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            navBarOverlap: const NavBarOverlap.full(),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(CustomTabView).first).height,
        equals(600),
      );

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(CustomTabView).first).height,
        equals(600 - kBottomNavigationBarHeight),
      );

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            navBarOverlap: const NavBarOverlap.custom(overlap: 30),
          ),
        ),
      );

      expect(
        tester.getSize(find.byType(CustomTabView).first).height,
        equals(600 - (kBottomNavigationBarHeight - 30)),
      );
    });

    testWidgets(
        "doesnt pop any screen when tapping same tab when `selectedTabPressConfig.popAction == PopActionType.none`",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              popAction: PopActionType.none,
            ),
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 1);
      await tapItem(tester, 0);
      expectTabAndLevel(tab: 0, level: 1);
    });

    testWidgets(
        "pops all screens when tapping same tab when `selectedTabPressConfig.popAction == PopActionType.all`",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              popAction: PopActionType.all,
            ),
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 1);
      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 2);
      await tapItem(tester, 0);
      expectTabAndLevel(tab: 0, level: 0);
    });

    testWidgets(
        "pops a single screen when tapping same tab when `selectedTabPressConfig.popAction == PopActionType.single`",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              popAction: PopActionType.single,
            ),
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 1);
      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 2);
      await tapItem(tester, 0);
      expectTabAndLevel(tab: 0, level: 1);
    });

    testWidgets(
        "runs callback when selected tab is tapped again and there are no screens pushed",
        (tester) async {
      bool callbackGotExecuted = false;
      bool areScreensPushed = false;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: SelectedTabPressConfig(
              onPressed: (hasPages) {
                areScreensPushed = hasPages;
                callbackGotExecuted = true;
              },
            ),
          ),
        ),
      );

      expectTabAndLevel(tab: 0, level: 0);
      await tapItem(tester, 0);
      expect(areScreensPushed, equals(false));
      expect(callbackGotExecuted, equals(true));
    });

    testWidgets(
        "runs callback when selected tab is tapped again and there are screens pushed",
        (tester) async {
      bool callbackGotExecuted = false;
      bool areScreensPushed = false;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: SelectedTabPressConfig(
              onPressed: (hasPages) {
                areScreensPushed = hasPages;
                callbackGotExecuted = true;
              },
            ),
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 1);
      await tapItem(tester, 0);
      expect(areScreensPushed, equals(true));
      expect(callbackGotExecuted, equals(true));
    });

    testWidgets(
        "scrolls the tab content to top when the selected tab is tapped again and it is enabled",
        (tester) async {
      final controllers = [
        ScrollController(),
        ScrollController(),
        ScrollController(),
      ];

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: List.generate(
              3,
              (id) => tabConfig(
                id,
                scrollableScreen(
                  id,
                  controller: controllers[id],
                ),
                controllers[id],
              ),
            ),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              scrollToTop: true,
            ),
          ),
        ),
      );

      await scroll(tester, const Offset(0, 200), const Offset(0, -400));

      expectNotTabAndLevel(tab: 0, level: 0);

      await tapItem(tester, 0);

      expectTabAndLevel(tab: 0, level: 0);
      expect(controllers[0].offset, equals(0));
    });

    testWidgets(
        "does not scroll the tab content to top when the selected tab is tapped again when it is disabled",
        (tester) async {
      final controllers = [
        ScrollController(),
        ScrollController(),
        ScrollController(),
      ];

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: List.generate(
              3,
              (id) => tabConfig(
                id,
                scrollableScreen(
                  id,
                  controller: controllers[id],
                ),
                controllers[id],
              ),
            ),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              scrollToTop: false,
            ),
          ),
        ),
      );

      await scroll(tester, const Offset(0, 200), const Offset(0, -400));

      expectNotTabAndLevel(tab: 0, level: 0);

      await tapItem(tester, 0);

      expectNotTabAndLevel(tab: 0, level: 0);
      expect(controllers[0].offset, isNot(0));
    });

    testWidgets(
        "scrollToTop is enabled but switching to a new tab does not scroll immediately",
        (tester) async {
      final controllers = [
        ScrollController(),
        ScrollController(),
        ScrollController(),
      ];

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: List.generate(
              3,
              (id) => tabConfig(
                id,
                scrollableScreen(
                  id,
                  controller: controllers[id],
                ),
                controllers[id],
              ),
            ),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              scrollToTop: true,
            ),
          ),
        ),
      );

      await scroll(tester, const Offset(0, 200), const Offset(0, -400));

      expectNotTabAndLevel(tab: 0, level: 0);

      await tapItem(tester, 1);
      await tapItem(tester, 0);

      expectNotTabAndLevel(tab: 0, level: 0);
      expect(controllers[0].offset, isNot(0));
    });

    testWidgets(
        "does keep navigator history when `keepNaviagotHistory == true`",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            keepNavigatorHistory: true,
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 1);
      await tapItem(tester, 1);
      await tapItem(tester, 0);
      expectTabAndLevel(tab: 0, level: 1);
    });

    testWidgets(
        "doesnt keep any navigator history when `keepNaviagotHistory == false`",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            keepNavigatorHistory: false,
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 1);
      await tapItem(tester, 1);
      await tapItem(tester, 0);
      expectTabAndLevel(tab: 0, level: 0);
    });

    testWidgets("persists screens while switching if stateManagement turned on",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 1);
      await tapItem(tester, 1);
      expectTabAndLevel(tab: 1, level: 0);
      await tapItem(tester, 0);
      expectTabAndLevel(tab: 0, level: 1);
    });

    testWidgets("trashes screens while switching if stateManagement turned off",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            stateManagement: false,
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectTabAndLevel(tab: 0, level: 1);
      await tapItem(tester, 1);
      expectTabAndLevel(tab: 1, level: 0);
      await tapItem(tester, 0);
      expectTabAndLevel(tab: 0, level: 0);
    });

    testWidgets("shows FloatingActionButton if specified", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton).hitTestable(), findsOneWidget);
    });

    testWidgets(
        "Style 13 and Style 14 center button are tappable above the navBar",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) =>
                Style13BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      Offset topCenter = tester.getRect(find.byType(DecoratedNavBar)).topCenter;
      await tester.tapAt(topCenter.translate(0, -10));
      await tester.pumpAndSettle();
      expectTabAndLevel(tab: 1, level: 0);

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) =>
                Style14BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      topCenter = tester.getRect(find.byType(DecoratedNavBar)).topCenter;
      await tester.tapAt(topCenter.translate(0, -10));
      await tester.pumpAndSettle();
      expectTabAndLevel(tab: 1, level: 0);
    });
  });

  group("Regression", () {
    testWidgets("#31 one navbar border side does not throw error",
        (widgetTester) async {
      await widgetTester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs(),
            navBarBuilder: (config) => Style1BottomNavBar(
              navBarConfig: config,
              navBarDecoration: const NavBarDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 2,
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
