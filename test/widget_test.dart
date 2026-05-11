import 'package:click_dashboard/book_demo_app.dart';
import 'package:click_dashboard/demo/pages/notification_bell_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('loads cinematic book cover', (tester) async {
    await tester.pumpWidget(const ClickBookDemoApp());

    expect(find.text('Cinematic Click Book'), findsOneWidget);
    expect(find.text('NEON ATLAS'), findsOneWidget);
  });

  testWidgets('opens cover and navigates to the next page', (tester) async {
    await tester.pumpWidget(const ClickBookDemoApp());

    expect(find.text('Intro Control Deck'), findsOneWidget);
    expect(find.text('Rotary Volume Knob'), findsNothing);
    expect(find.text('Prime CTA'), findsNothing);

    await tester.tap(find.text('NEON ATLAS'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 950));

    expect(find.text('Intro Control Deck'), findsOneWidget);
    expect(find.text('Page 1 / 10'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Rotary Volume Knob'), findsOneWidget);
    expect(find.text('Page 2 / 10'), findsOneWidget);
    expect(find.text('Prime CTA'), findsNothing);
  });

  testWidgets('previous navigation stays on the first page', (tester) async {
    await tester.pumpWidget(const ClickBookDemoApp());

    await _openCover(tester);
    expect(find.text('Page 1 / 10'), findsOneWidget);

    await tester.tap(find.text('Prev'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Intro Control Deck'), findsOneWidget);
    expect(find.text('Page 1 / 10'), findsOneWidget);
  });

  testWidgets('notification badge caps at 99', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SizedBox(width: 800, height: 800, child: NotificationBellPage()),
      ),
    );

    for (var tap = 0; tap < 120; tap += 1) {
      await tester.tap(find.byIcon(Icons.notifications));
      await tester.pump();
    }

    expect(find.text('99'), findsOneWidget);
    expect(find.text('100'), findsNothing);
  });
}

Future<void> _openCover(WidgetTester tester) async {
  await tester.tap(find.text('NEON ATLAS'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 950));
}
