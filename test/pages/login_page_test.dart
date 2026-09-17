import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:twitter_clone/pages/login_page.dart';
import '../test_helpers/firebase_mock_setup.dart';

// NOTE: LoginPage's State constructs AuthService() immediately, which reads
// FirebaseAuth.instance -- so even just building LoginPage() requires a
// Firebase app to exist. setupFirebaseAppForTests() fakes just enough of
// firebase_core for that to succeed. We deliberately do NOT tap "Login"
// with credentials and assert a Firebase outcome here -- that would
// attempt a real network call. LoginPage doesn't navigate anywhere on its
// own -- it just calls whatever onTap its parent (LoginOrRegister) gives
// it -- so we test that the callback fires, not standalone navigation.
void main() {
  setUpAll(() async {
    await setupFirebaseAppForTests();
  });

  group('LoginPage', () {
    testWidgets('renders email and password fields', (tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage(onTap: () {})));

      expect(find.text('Enter email'), findsOneWidget);
      expect(find.text('Enter password'), findsOneWidget);
      expect(find.text("Welcome back, You've been missed!"), findsOneWidget);
    });

    testWidgets('tapping Register Now calls onTap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(MaterialApp(home: LoginPage(onTap: () => tapped = true)));

      await tester.ensureVisible(find.text('Register Now'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Register Now'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
