import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:firebase_auth/firebase_auth.dart'; // If Firebase authentication is used.
import 'package:paye_alle/home_page.dart';
import 'package:paye_alle/login.dart'; // Import the path to your LoginPage class.


void main() {
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  group('Login Page Tests', () {
    testWidgets('Login with valid credentials should navigate to HomePage',
            (WidgetTester tester) async {
          final auth = MockFirebaseAuth(signedIn: true);
          await tester.pumpWidget(MaterialApp(home: LoginPage(auth: auth)));

          // Enter valid credentials.
          await tester.enterText(find.byKey(Key('email')), 'montyoliver12@hotmail.com');
          await tester.enterText(find.byKey(Key('password')), 'oliver1299');

          // Tap the login button.
          await tester.tap(find.byKey(Key('login')));
          await tester.pumpAndSettle();

          // Ensure the navigation to HomePage occurred.
          expect(find.byType(HomePage), findsOneWidget);
        });

    /*testWidgets('Login with invalid credentials should show error message',
            (WidgetTester tester) async {
          final auth = MockFirebaseAuth(signedIn: false);
          await tester.pumpWidget(MaterialApp(home: LoginPage(auth: auth)));

          // Enter invalid credentials.
          await tester.enterText(find.byKey(Key('email')), 'invalid_username');
          await tester.enterText(find.byKey(Key('password')), 'invalid_password');

          // Tap the login button.
          await tester.tap(find.byKey(Key('login')));
          await tester.pumpAndSettle();

          // Ensure the error message dialog is shown.
          expect(find.byType(AlertDialog), findsOneWidget);
          expect(find.text('Incorrect Email'), findsOneWidget);
        });*/
  });
}

