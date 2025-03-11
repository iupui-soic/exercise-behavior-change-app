import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exercise_behavior_change_app/app.dart';
import 'package:exercise_behavior_change_app/widgets/app_button.dart';

void main() {
  testWidgets('MyApp starts with welcome screen', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the welcome screen is shown
    expect(find.text('Start working out to reach your creative peak.'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });

  group('AppButton Widget Tests', () {
    testWidgets('AppButton renders with text', (WidgetTester tester) async {
      const buttonText = 'Test Button';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: buttonText,
            onPressed: () {},
          ),
        ),
      ));

      // Verify button renders with text
      expect(find.text(buttonText), findsOneWidget);
    });

    testWidgets('AppButton shows loading indicator when isLoading is true', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Loading Button',
            onPressed: () {},
            isLoading: true,
          ),
        ),
      ));

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Button'), findsNothing);
    });

    testWidgets('AppButton calls onPressed when tapped', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Tap Me',
            onPressed: () {
              buttonPressed = true;
            },
          ),
        ),
      ));

      // Tap the button
      await tester.tap(find.text('Tap Me'));

      // Verify callback was called
      expect(buttonPressed, true);
    });

    testWidgets('AppButton does not call onPressed when isLoading is true', (WidgetTester tester) async {
      bool buttonPressed = false;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AppButton(
            text: 'Loading Button',
            onPressed: () {
              buttonPressed = true;
            },
            isLoading: true,
          ),
        ),
      ));

      // Try to tap where the button text would be
      await tester.tap(find.byType(ElevatedButton));

      // Verify callback was not called
      expect(buttonPressed, false);
    });
  });
}