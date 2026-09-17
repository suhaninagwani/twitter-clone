import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/services/auth/login_or_register.dart';
import 'package:twitter_clone/pages/login_page.dart';
import 'package:twitter_clone/pages/register_page.dart';
import 'package:twitter_clone/themes/theme_provider.dart';
import 'test_helpers/firebase_mock_setup.dart';

// NOTE: We test LoginOrRegister here instead of MyApp/AuthGate directly.
// AuthGate calls FirebaseAuth.instance.authStateChanges(), a real stream
// subscription that's a bigger ask to fake reliably than the one-shot
// app-existence check LoginOrRegister's children need. LoginOrRegister ->
// LoginPage/RegisterPage still needs a Firebase app to exist (see
// firebase_mock_setup.dart).
//
// This is also the right place to test the actual Login<->Register toggle:
// LoginPage/RegisterPage don't navigate on their own -- they just call
// whatever onTap their parent gives them -- and LoginOrRegister is the
// parent that actually wires that callback up to real page-swapping.
void main() {
  setUpAll(() async {
    await setupFirebaseAppForTests();
  });

  Widget buildTestApp() {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MaterialApp(home: LoginOrRegister()),
    );
  }

  testWidgets('unauthenticated flow starts on the LoginPage', (tester) async {
    await tester.pumpWidget(buildTestApp());

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('tapping Register Now toggles to RegisterPage', (tester) async {
    await tester.pumpWidget(buildTestApp());

    await tester.ensureVisible(find.text('Register Now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register Now'));
    await tester.pump();

    expect(find.byType(RegisterPage), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);
  });

  testWidgets('tapping Login Now toggles back to LoginPage', (tester) async {
    await tester.pumpWidget(buildTestApp());

    // Go to RegisterPage first.
    await tester.ensureVisible(find.text('Register Now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Register Now'));
    await tester.pump();

    // Then back to LoginPage.
    await tester.ensureVisible(find.text('Login Now'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Login Now'));
    await tester.pump();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(RegisterPage), findsNothing);
  });
}
