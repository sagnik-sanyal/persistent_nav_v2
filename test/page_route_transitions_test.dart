import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart";

Widget mainScreen(void Function() onPressed) => MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: onPressed,
            child: const Text("Push Route"),
          ),
        ),
      ),
    );

void main() {
  group("PageTransitionAnimation", () {
    testWidgets("slideRight", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            SlideRightPageRoute(
              page: const Column(
                children: [
                  Text("SlideRight"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pump(Durations.short1);
      await tester.pump(Durations.short1);
      // 400 is the horizontal center of the screen, so tab 0 should leave towards the right and tab 1 should enter from the left
      expect(tester.getCenter(find.byType(Column)).dx, lessThan(0));

      await tester.pumpAndSettle();

      expect(find.text("SlideRight"), findsOneWidget);
    });

    testWidgets("scale", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            ScalePageRoute(
              page: const Column(
                children: [
                  Text("Scale"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pump(Durations.short1);
      await tester.pump(Durations.short1);

      expect(tester.getRect(find.byType(Column)).width, lessThan(600));
      expect(tester.getRect(find.byType(Column)).height, lessThan(800));

      await tester.pumpAndSettle();

      expect(find.text("Scale"), findsOneWidget);
    });

    testWidgets("rotate", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            RotationPageRoute(
              page: const Column(
                children: [
                  Text("Rotate"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pumpAndSettle();

      expect(find.text("Rotate"), findsOneWidget);
    });

    testWidgets("sizeUp", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            SizePageRoute(
              page: const Column(
                children: [
                  Text("SizeUp"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pump(Durations.short1);
      await tester.pump(Durations.short1);

      expect(tester.getSize(find.byType(Column)).width, lessThan(600));
      expect(tester.getSize(find.byType(Column)).height, lessThan(800));

      await tester.pumpAndSettle();

      expect(find.text("SizeUp"), findsOneWidget);
    });

    testWidgets("fade", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            FadePageRoute(
              page: const Column(
                children: [
                  Text("Fade"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pumpAndSettle();

      expect(find.text("Fade"), findsOneWidget);
    });

    testWidgets("scaleRotate", (tester) async {
      await tester.pumpWidget(
        mainScreen(() {
          Navigator.of(tester.element(find.text("Push Route"))).push(
            ScaleRotatePageRoute(
              page: const Column(
                children: [
                  Text("ScaleRotate"),
                ],
              ),
            ),
          );
        }),
      );

      await tester.tap(find.text("Push Route"));
      await tester.pump(Durations.short1);
      await tester.pump(Durations.short1);

      expect(tester.getRect(find.byType(Column)).width, lessThan(600));
      expect(tester.getRect(find.byType(Column)).height, lessThan(800));

      await tester.pumpAndSettle();

      expect(find.text("ScaleRotate"), findsOneWidget);
    });
  });
}
