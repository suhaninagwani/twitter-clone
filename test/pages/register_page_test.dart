import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_clone/pages/login_page.dart';
import 'package:twitter_clone/pages/register_page.dart';
import '../test_helpers/firebase_mock_setup.dart';

// NOTE: RegisterPage's State constructs AuthService() immediately, which
// reads FirebaseAuth.instance -- so even just building RegisterPage()
// requires a Firebase app to exist. setupFirebaseAppForTests() fakes just
// enough of firebase_core for that to succeed. We still never tap
// "Register" with valid matching credentials here (that would attempt a
// real Firebase Auth network call and fail/hang). The password-mismatch
// case is genuinely safe: registerMethod() checks
// pwController.text == cpwController.text BEFORE touching Firebase at all.
void main() {
  setUpAll(() async {
    await setupFirebaseAppForTests();
  });

  group('RegisterPage', () {
    testWidgets('renders all four input fields', (tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage(onTap: () {})));

      expect(find.text('Enter your name'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });

    testWidgets('mismatched passwords show an error dialog', (tester) async {
      await tester.pumpWidget(MaterialApp(home: RegisterPage(onTap: () {})));

      await tester.enterText(find.widgetWithText(TextField, 'Enter your password'), 'password123');
      await tester.enterText(find.widgetWithText(TextField, 'Confirm Password'), 'differentPassword');

      await tester.ensureVisible(find.text('Register'));
      await tester.tap(find.text('Register'));
      await tester.pump(); // let the dialog build; no Firebase call happens on this path

      expect(find.text("Passwords don't match"), findsOneWidget);
    });

    testWidgets('tapping Login Now navigates to LoginPage', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: RegisterPage(
        onTap: () {
          Navigator.push(
            tester.element(find.text('Login Now')),
            MaterialPageRoute(
              builder: (context) => LoginPage(onTap: () {}),
            ),
          );
        },
      ),
    ),
  );

  await tester.ensureVisible(find.text('Login Now'));
  await tester.tap(find.text('Login Now'));
  await tester.pumpAndSettle();

  expect(find.byType(LoginPage), findsOneWidget);
});
  });
}
