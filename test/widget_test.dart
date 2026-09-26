// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:myportfolio/core/widgets/journey_motion.dart';
import 'package:myportfolio/main.dart';

void main() {
  testWidgets('portfolio home renders key sections',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text("Let's build something solid"), findsOneWidget);
    expect(find.text('EXECUTION_LOGS'), findsOneWidget);
  });

  testWidgets('command palette opens and filters commands',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 1400));

    await tester.tap(find.byIcon(Icons.keyboard_command_key_rounded));
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Open GitHub'), findsOneWidget);
    expect(find.text('Go to Projects'), findsOneWidget);

    await tester.enterText(
      find.byKey(const ValueKey('command-search')),
      'github',
    );
    await tester.pump();
    expect(find.text('Open GitHub'), findsOneWidget);
    expect(find.text('Go to Projects'), findsNothing);
  });

  testWidgets('theme control switches the visible theme action',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 1400));

    expect(find.byIcon(Icons.light_mode_rounded), findsOneWidget);
    await tester.tap(find.byIcon(Icons.light_mode_rounded));
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.byIcon(Icons.dark_mode_rounded), findsOneWidget);
  });

  testWidgets('journey content stays visible when reduced motion is enabled',
      (WidgetTester tester) async {
    final controller = ScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: SingleChildScrollView(
            controller: controller,
            child: JourneyReveal(
              controller: controller,
              child: const Text('Reduced motion content'),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final opacity =
        tester.widget<AnimatedOpacity>(find.byType(AnimatedOpacity));
    expect(opacity.opacity, 1);
    expect(find.text('Reduced motion content'), findsOneWidget);
  });

  testWidgets('hero adapts without overflow on mobile and tablet',
      (WidgetTester tester) async {
    for (final size in const [Size(390, 844), Size(768, 1024)]) {
      await tester.binding.setSurfaceSize(size);
      await tester.pumpWidget(const MyApp());
      await tester.pump(const Duration(milliseconds: 1400));

      expect(find.text('100k+ users served'), findsOneWidget);
      expect(find.text('Team leadership'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.binding.setSurfaceSize(null);
  });
}
