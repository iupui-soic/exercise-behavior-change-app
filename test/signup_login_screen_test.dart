import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exercise_behavior_change_app/screens/auth/login_screen.dart';
import 'package:exercise_behavior_change_app/screens/auth/signup_screen.dart';

void main() {
  group('LoginScreen UI Tests', () {
    testWidgets('Login link should have sufficient bottom padding',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: LoginScreen()));

          // Find the login text
          final loginTextFinder = find.text('Already have an account? Login');
          expect(loginTextFinder, findsOneWidget, reason: 'Login text should be present');

          // Find the padding around the login text
          final paddingFinders = find.ancestor(
            of: loginTextFinder,
            matching: find.byType(Padding),
          );

          // Check if any padding has sufficient bottom margin
          bool hasSufficientPadding = false;

          for (int i = 0; i < tester.widgetList(paddingFinders).length; i++) {
            final padding = tester.widget<Padding>(paddingFinders.at(i));

            if (padding.padding is EdgeInsets) {
              final edgeInsets = padding.padding as EdgeInsets;
              if (edgeInsets.bottom >= 30.0) { // Looking for our increased padding
                hasSufficientPadding = true;
                break;
              }
            }
          }

          expect(hasSufficientPadding, isTrue,
              reason: 'Login link should have significant bottom padding to avoid system UI overlap');
        });

    testWidgets('Login link should be placed at the bottom of the screen',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: LoginScreen()));

          // Find the login text
          final loginTextFinder = find.text('Already have an account? Login');
          expect(loginTextFinder, findsOneWidget);

          // Get the position of the text
          final textPosition = tester.getCenter(loginTextFinder);

          // Get the size of the screen
          final screenSize = tester.getSize(find.byType(Scaffold));

          // Check that the text is in the bottom portion of the screen
          expect(textPosition.dy > (screenSize.height * 0.7), isTrue,
              reason: 'Login link should be placed near the bottom of the screen');
        });
  });

  group('EmailLoginScreen UI Tests', () {
    testWidgets('Signup link should have sufficient bottom padding',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: EmailLoginScreen()));

          // Find the signup text
          final signupTextFinder = find.text('Don\'t have an account? Sign up');
          expect(signupTextFinder, findsOneWidget, reason: 'Signup text should be present');

          // Find the padding around the signup text
          final paddingFinders = find.ancestor(
            of: signupTextFinder,
            matching: find.byType(Padding),
          );

          // Check if any padding has sufficient bottom margin
          bool hasSufficientPadding = false;

          for (int i = 0; i < tester.widgetList(paddingFinders).length; i++) {
            final padding = tester.widget<Padding>(paddingFinders.at(i));

            if (padding.padding is EdgeInsets) {
              final edgeInsets = padding.padding as EdgeInsets;
              if (edgeInsets.bottom >= 30.0) { // Looking for our increased padding
                hasSufficientPadding = true;
                break;
              }
            }
          }

          expect(hasSufficientPadding, isTrue,
              reason: 'Signup link should have significant bottom padding to avoid system UI overlap');
        });

    testWidgets('Signup link should be placed at the bottom of the screen',
            (WidgetTester tester) async {
          await tester.pumpWidget(MaterialApp(home: EmailLoginScreen()));

          // Find the signup text
          final signupTextFinder = find.text('Don\'t have an account? Sign up');
          expect(signupTextFinder, findsOneWidget);

          // Get the position of the text
          final textPosition = tester.getCenter(signupTextFinder);

          // Get the size of the screen
          final screenSize = tester.getSize(find.byType(Scaffold));

          // Check that the text is in the bottom portion of the screen
          expect(textPosition.dy > (screenSize.height * 0.7), isTrue,
              reason: 'Signup link should be placed near the bottom of the screen');
        });
  });
}