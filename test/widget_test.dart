import 'package:click_dashboard/book_demo_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('loads cinematic book cover', (tester) async {
    await tester.pumpWidget(const ClickBookDemoApp());

    expect(find.text('Cinematic Click Book'), findsOneWidget);
    expect(find.text('NEON ATLAS'), findsOneWidget);
  });
}
