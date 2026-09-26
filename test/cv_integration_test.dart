import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myportfolio/data/content.dart';
import 'package:myportfolio/main.dart';

void main() {
  test('Content has valid CV URL', () {
    expect(Content.cvUrl, isNotEmpty);
    expect(Content.cvUrl, startsWith('https://drive.google.com/'));
  });

  test('Content contains expected experience entries', () {
    final companies =
        Content.experience.map((e) => e['company']).toList(growable: false);
    expect(companies, contains('DomApp'));
    expect(companies, contains('Elryad Company'));
    expect(companies, contains('Top Business'));
    expect(companies, contains('Ana Engineer Source'));
    expect(companies, contains('Alwsata Real State'));
    expect(Content.experience.length, 5);
  });

  testWidgets('Download CV button is rendered on home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 300));

    // Finds Download CV button in Hero and Contact sections
    expect(find.text('Download CV'), findsWidgets);
  });

  testWidgets('command palette contains Download CV action',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 1400));

    await tester.tap(find.byIcon(Icons.keyboard_command_key_rounded));
    await tester.pump(const Duration(milliseconds: 350));

    final dialogFinder = find.byType(Dialog);
    expect(
      find.descendant(of: dialogFinder, matching: find.text('Download CV')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey('command-search')),
      'download',
    );
    await tester.pump();
    expect(
      find.descendant(of: dialogFinder, matching: find.text('Download CV')),
      findsOneWidget,
    );
  });

  test('Content has valid WhatsApp details', () {
    expect(Content.whatsappNumber, '01062933188');
    expect(Content.whatsappUrl, 'https://wa.me/201062933188');
  });

  testWidgets('WhatsApp button is rendered on home screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 300));

    // Finds WhatsApp button in Hero and Contact sections
    expect(find.text('WhatsApp'), findsWidgets);
  });

  testWidgets('command palette contains Open WhatsApp action',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 1400));

    await tester.tap(find.byIcon(Icons.keyboard_command_key_rounded));
    await tester.pump(const Duration(milliseconds: 350));

    final dialogFinder = find.byType(Dialog);
    expect(
      find.descendant(of: dialogFinder, matching: find.text('Open WhatsApp')),
      findsOneWidget,
    );

    await tester.enterText(
      find.byKey(const ValueKey('command-search')),
      'whatsapp',
    );
    await tester.pump();
    expect(
      find.descendant(of: dialogFinder, matching: find.text('Open WhatsApp')),
      findsOneWidget,
    );
  });
}
