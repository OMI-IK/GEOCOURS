import 'package:flutter_test/flutter_test.dart';
import 'package:geocours/main.dart';

void main() {
  testWidgets('GEOCOURS app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const GeoCoursApp());
    expect(find.text('GEOCOURS'), findsOneWidget);
  });
}