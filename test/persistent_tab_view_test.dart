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

Widget defaultScreen(int id) => Text("Screen$id");
Widget scrollableScreen(int id, [ScrollController? controller]) => ListView(
      controller: controller,
      children: [
        Text("Screen$id"),
        ...List.generate(
          40,
          (id) => Container(
            padding: const EdgeInsets.all(16),
            child: Text("Item $id"),
          ),
        ),
      ],
    );

Widget screenWithSubPages(int id) => id > 99
    ? defaultScreen(id)
    : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          defaultScreen(id),
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => screenWithSubPages(id * 10 + (id % 10)),
                ),
              ),
              child: const Text("Push SubPage"),
            ),
          ),
        ],
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

void expectScreen(int id, {int screenCount = 3}) {
  find.byType(Text).hitTestable().evaluate().forEach((element) {
    final Text text = element.widget as Text;
    if (text.data?.startsWith("Screen") ?? false) {
      expect(
        text.data,
        equals("Screen$id"),
      );
    }
  });
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
        child: const Text("Screen0"),
      ),
    );

void main() {
  group("PersistentTabView", () {
    testWidgets("builds a DecoratedNavBar", (tester) async {
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

    testWidgets("can switch through tabs", (tester) async {
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

      expectScreen(1);
      await tapItem(tester, 2);
      expectScreen(2);
      await tapItem(tester, 3);
      expectScreen(3);
      await tapItem(tester, 1);
      expectScreen(1);
    });

    testWidgets("hides the navbar when hideNavBar is true", (tester) async {
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

    testWidgets("sizes the navbar according to the height", (tester) async {
      const double height = 42;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            onTabChanged: (index) => count++,
          ),
        ),
      );

      await tapItem(tester, 2);
      expect(count, 1);
      await tapItem(tester, 3);
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
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, defaultScreen(id)))
                  .toList(),
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
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, screenWithSubPages(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        expectScreen(1);
        await tapItem(tester, 2);
        expectScreen(2);

        await tapAndroidBackButton(tester);

        expectScreen(1);
      });

      testWidgets("pops one screen on back button press", (tester) async {
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, screenWithSubPages(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expect(find.text("Screen1"), findsNothing);
        expect(find.text("Screen11"), findsOneWidget);

        await tapAndroidBackButton(tester);

        expect(find.text("Screen1"), findsOneWidget);
        expect(find.text("Screen11"), findsNothing);
      });

      testWidgets("pops main screen when historyLength is 0", (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 0),
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, defaultScreen(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectScreen(1);

        await tapItem(tester, 2);
        expectScreen(2);

        await tapAndroidBackButton(tester);
        expectScreen(0);
      });

      testWidgets("pops main screen when historyLength is 1", (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 1),
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, defaultScreen(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectScreen(1);

        await tapItem(tester, 2);
        expectScreen(2);

        await tapAndroidBackButton(tester);
        expectScreen(1);

        await tapAndroidBackButton(tester);
        expectScreen(0);
      });

      testWidgets(
          "pops main screen when historyLength is 1 and switched to initial tab",
          (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 1),
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, defaultScreen(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectScreen(1);

        await tapItem(tester, 2);
        expectScreen(2);

        await tapItem(tester, 1);
        expectScreen(1);

        await tapAndroidBackButton(tester);
        expectScreen(0);
      });

      testWidgets(
          "pops main screen when historyLength is 1 and initial tab has subpage",
          (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 1),
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, screenWithSubPages(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectScreen(1);

        await tapElevatedButton(tester);
        expectScreen(11);

        await tapItem(tester, 2);
        expectScreen(2);

        await tapAndroidBackButton(tester);
        expectScreen(11);

        await tapAndroidBackButton(tester);
        expectScreen(1);

        await tapAndroidBackButton(tester);
        expectScreen(0);
      });

      testWidgets("pops main screen when historyLength is 2", (tester) async {
        await tester.pumpWidget(
          wrapTabViewWithMainScreen(
            (context) => PersistentTabView(
              controller: PersistentTabController(historyLength: 2),
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, defaultScreen(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectScreen(1);

        await tapItem(tester, 2);
        expectScreen(2);

        await tapItem(tester, 3);
        expectScreen(3);

        await tapAndroidBackButton(tester);
        expectScreen(2);

        await tapAndroidBackButton(tester);
        expectScreen(1);

        await tapAndroidBackButton(tester);
        expectScreen(0);
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
              tabs: [1, 2, 3]
                  .map((id) => tabConfig(id, defaultScreen(id)))
                  .toList(),
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        await tapElevatedButton(tester);
        expectScreen(1);

        await tapItem(tester, 2);
        expectScreen(2);

        await tapItem(tester, 1);
        expectScreen(1);

        await tapAndroidBackButton(tester);
        expectScreen(0);
      });
    });

    group("should not handle Android back button press and thus", () {
      testWidgets("does not switch the tab on back button press",
          (tester) async {
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

        expectScreen(1);
        await tapItem(tester, 2);
        expectScreen(2);

        await tapAndroidBackButton(tester);

        expectScreen(2);
      });

      testWidgets("pops no screen on back button press", (tester) async {
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

        await tapElevatedButton(tester);
        expectScreen(11);

        await tapAndroidBackButton(tester);

        expectScreen(11);
      });
    });

    group("handles altering tabs at runtime when", () {
      testWidgets("removing tabs", (tester) async {
        final List<PersistentTabConfig> tabs = [
          1,
          2,
          3,
        ].map((id) => tabConfig(id, defaultScreen(id))).toList();

        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: tabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        expectScreen(1);
        expect(find.byType(Icon), findsNWidgets(3));

        tabs.removeAt(0);
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: tabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );
        await tester.pump();

        expectScreen(2);
        expect(find.byType(Icon), findsNWidgets(2));
      });

      testWidgets("removing and re-adding tabs", (tester) async {
        final List<PersistentTabConfig> tabs = [
          1,
          2,
          3,
        ].map((id) => tabConfig(id, defaultScreen(id))).toList();

        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: tabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );

        expectScreen(1);
        expect(find.byType(Icon), findsNWidgets(3));

        tabs.removeAt(0);
        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: tabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );
        await tester.pump();

        expectScreen(2);
        expect(find.byType(Icon), findsNWidgets(2));

        tabs.insert(0, tabConfig(1, defaultScreen(1)));

        await tester.pumpWidget(
          wrapTabView(
            (context) => PersistentTabView(
              tabs: tabs,
              navBarBuilder: (config) =>
                  Style1BottomNavBar(navBarConfig: config),
            ),
          ),
        );
        await tester.pump();

        expectScreen(1);
        expect(find.byType(Icon), findsNWidgets(3));
      });
    });

    testWidgets(
        "hides nav bar after the specified amount of pixels have been scrolled",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, scrollableScreen(id)))
                .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
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
                tabs: [1, 2, 3]
                    .map((id) => tabConfig(id, defaultScreen(id)))
                    .toList(),
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
                tabs: [1, 2, 3]
                    .map((id) => tabConfig(id, defaultScreen(id)))
                    .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, defaultScreen(id)))
                .toList(),
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              popAction: PopActionType.none,
            ),
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectScreen(11);
      await tapItem(tester, 1);
      expectScreen(11);
    });

    testWidgets(
        "pops all screens when tapping same tab when `selectedTabPressConfig.popAction == PopActionType.all`",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              popAction: PopActionType.all,
            ),
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectScreen(11);
      await tapElevatedButton(tester);
      expectScreen(111);
      await tapItem(tester, 1);
      expectScreen(1);
    });

    testWidgets(
        "pops a single screen when tapping same tab when `selectedTabPressConfig.popAction == PopActionType.single`",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              popAction: PopActionType.single,
            ),
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectScreen(11);
      await tapElevatedButton(tester);
      expectScreen(111);
      await tapItem(tester, 1);
      expectScreen(11);
    });

    testWidgets(
        "runs callback when selected tab is tapped again and there are no screens pushed",
        (tester) async {
      bool callbackGotExecuted = false;
      bool areScreensPushed = false;

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
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

      expectScreen(1);
      await tapItem(tester, 1);
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
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
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
      expectScreen(11);
      await tapItem(tester, 1);
      expect(areScreensPushed, equals(true));
      expect(callbackGotExecuted, equals(true));
    });

    testWidgets(
        "scrolls the tab content to top when the selected tab is tapped again and it is enabled",
        (tester) async {
      final tabs = [
        {"id": 1, "controller": ScrollController()},
        {"id": 2, "controller": ScrollController()},
        {"id": 3, "controller": ScrollController()},
      ];

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs
                .map(
                  (dict) => tabConfig(
                    dict["id"]! as int,
                    scrollableScreen(
                      dict["id"]! as int,
                      dict["controller"]! as ScrollController,
                    ),
                    dict["controller"]! as ScrollController,
                  ),
                )
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              scrollToTop: true,
            ),
          ),
        ),
      );

      await scroll(tester, const Offset(0, 200), const Offset(0, -400));

      expect(find.text("Screen1"), findsNothing);

      await tapItem(tester, 1);

      expect(find.text("Screen1"), findsOneWidget);
      expect(
        (tabs[0]["controller"]! as ScrollController).offset,
        equals(0),
      );
    });

    testWidgets(
        "does not scroll the tab content to top when the selected tab is tapped again when it is disabled",
        (tester) async {
      final tabs = [
        {"id": 1, "controller": ScrollController()},
        {"id": 2, "controller": ScrollController()},
        {"id": 3, "controller": ScrollController()},
      ];

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs
                .map(
                  (dict) => tabConfig(
                    dict["id"]! as int,
                    scrollableScreen(
                      dict["id"]! as int,
                      dict["controller"]! as ScrollController,
                    ),
                    dict["controller"]! as ScrollController,
                  ),
                )
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              scrollToTop: false,
            ),
          ),
        ),
      );

      await scroll(tester, const Offset(0, 200), const Offset(0, -400));

      expect(find.text("Screen1"), findsNothing);

      await tapItem(tester, 1);

      expect(find.text("Screen1"), findsNothing);
      expect(
        (tabs[0]["controller"]! as ScrollController).offset,
        isNot(0),
      );
    });

    testWidgets(
        "scrollToTop is enabled but switching to a new tab does not scroll immediately",
        (tester) async {
      final tabs = [
        {"id": 1, "controller": ScrollController()},
        {"id": 2, "controller": ScrollController()},
        {"id": 3, "controller": ScrollController()},
      ];

      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: tabs
                .map(
                  (dict) => tabConfig(
                    dict["id"]! as int,
                    scrollableScreen(
                      dict["id"]! as int,
                      dict["controller"]! as ScrollController,
                    ),
                    dict["controller"]! as ScrollController,
                  ),
                )
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            selectedTabPressConfig: const SelectedTabPressConfig(
              scrollToTop: true,
            ),
          ),
        ),
      );

      await scroll(tester, const Offset(0, 200), const Offset(0, -400));

      expect(find.text("Screen1"), findsNothing);

      await tapItem(tester, 2);
      await tapItem(tester, 1);

      expect(find.text("Screen1"), findsNothing);
      expect(
        (tabs[0]["controller"]! as ScrollController).offset,
        isNot(0),
      );
    });

    testWidgets(
        "does keep navigator history when `keepNaviagotHistory == true`",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            keepNavigatorHistory: true,
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectScreen(11);
      await tapItem(tester, 2);
      await tapItem(tester, 1);
      expectScreen(11);
    });

    testWidgets(
        "doesnt keep any navigator history when `keepNaviagotHistory == false`",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            keepNavigatorHistory: false,
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectScreen(11);
      await tapItem(tester, 2);
      await tapItem(tester, 1);
      expectScreen(1);
    });

    testWidgets("persists screens while switching if stateManagement turned on",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectScreen(11);
      await tapItem(tester, 2);
      expectScreen(2);
      await tapItem(tester, 1);
      expectScreen(11);
    });

    testWidgets("trashes screens while switching if stateManagement turned off",
        (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
            navBarBuilder: (config) => Style1BottomNavBar(navBarConfig: config),
            stateManagement: false,
          ),
        ),
      );

      await tapElevatedButton(tester);
      expectScreen(11);
      await tapItem(tester, 2);
      expectScreen(2);
      await tapItem(tester, 1);
      expectScreen(1);
    });

    testWidgets("shows FloatingActionButton if specified", (tester) async {
      await tester.pumpWidget(
        wrapTabView(
          (context) => PersistentTabView(
            tabs: [1, 2, 3]
                .map((id) => tabConfig(id, screenWithSubPages(id)))
                .toList(),
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
      expectScreen(2);

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
      expectScreen(2);
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
