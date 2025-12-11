import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investment_tracker/core/widgets/elegant_loading.dart';

void main() {
  group('ElegantLoadingIndicator Widget Tests', () {
    testWidgets('should render loading indicator', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ElegantLoadingIndicator(),
          ),
        ),
      );

      // Assert
      expect(find.byType(ElegantLoadingIndicator), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should use custom strokeWidth when provided',
        (WidgetTester tester) async {
      // Arrange
      const testStrokeWidth = 5.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ElegantLoadingIndicator(
              strokeWidth: testStrokeWidth,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(ElegantLoadingIndicator), findsOneWidget);
    });

    testWidgets('should use custom color when provided',
        (WidgetTester tester) async {
      // Arrange
      const testColor = Colors.red;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ElegantLoadingIndicator(
              color: testColor,
            ),
          ),
        ),
      );

      // Assert
      final progressIndicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );
      expect(progressIndicator.valueColor?.value, testColor);
    });

    testWidgets('should use custom size when provided',
        (WidgetTester tester) async {
      // Arrange
      const testSize = 50.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ElegantLoadingIndicator(
              size: testSize,
            ),
          ),
        ),
      );

      // Assert
      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(ElegantLoadingIndicator),
          matching: find.byType(SizedBox),
        ).first,
      );
      expect(sizedBox.width, testSize);
      expect(sizedBox.height, testSize);
    });
  });
}
