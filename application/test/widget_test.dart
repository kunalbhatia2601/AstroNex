import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:astrology_app/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: AstrologyApp(),
      ),
    );

    // Wait for async operations
    await tester.pumpAndSettle();

    // Verify that the app loads with the home screen
    expect(find.text('Welcome to'), findsOneWidget);
  });
}
