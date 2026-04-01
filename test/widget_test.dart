import 'package:click_dashboard/book_demo_app.dart';
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
}
