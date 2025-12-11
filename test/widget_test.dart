// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:investment_tracker/main.dart';
import 'package:investment_tracker/core/services/notification_service.dart';

void main() {
  testWidgets('App starts without crashing', (WidgetTester tester) async {
    // Initialize notification service for testing
    final notificationService = NotificationService();

    // Build our app and trigger a frame
    await tester.pumpWidget(MyApp(notificationService: notificationService));

    // Verify the app loaded successfully
    // (The actual content depends on your app's initial screen)
    expect(find.byType(MyApp), findsOneWidget);
  });
}
