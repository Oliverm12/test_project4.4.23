import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paye_alle/cart.dart';
import 'package:paye_alle/home.dart';
import 'package:paye_alle/home_page.dart';
import 'package:paye_alle/qrscanner.dart';
import 'package:firebase_core/firebase_core.dart'; // Import the firebase_core package

void main() {
  // Initialize Firebase before running the tests
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Initial page is HomePage1', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => HomePage(),
        ),
      ),
    );

    // Verify that the initial page displayed is HomePage1
    expect(find.byType(HomePage1), findsOneWidget);
  });

  testWidgets('Navigate to QrCodeScanner page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => HomePage(),
        ),
      ),
    );

    // Tap the Scan icon to navigate to QrCodeScanner page
    final scanIcon = find.byIcon(Icons.qr_code_scanner_sharp);
    await tester.tap(scanIcon);
    await tester.pumpAndSettle();

    // Verify that the QrCodeScanner page is displayed
    expect(find.byType(QrCodeScanner), findsOneWidget);
  });

  testWidgets('Navigate to Cart page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => HomePage(),
        ),
      ),
    );

    // Tap the Cart icon to navigate to Cart page
    final cartIcon = find.byIcon(Icons.shopping_cart_outlined);
    await tester.tap(cartIcon);
    await tester.pumpAndSettle();

    // Verify that the Cart page is displayed
    expect(find.byType(Cart), findsOneWidget);
  });

  testWidgets('Navigate back to HomePage1 from Cart page', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => HomePage(),
        ),
      ),
    );

    // Tap the Cart icon to navigate to Cart page
    final cartIcon = find.byIcon(Icons.shopping_cart_outlined);
    await tester.tap(cartIcon);
    await tester.pumpAndSettle();

    // Verify that the Cart page is displayed
    expect(find.byType(Cart), findsOneWidget);

    // Tap the Home icon to navigate back to HomePage1
    final homeIcon = find.byIcon(Icons.home);
    await tester.tap(homeIcon);
    await tester.pumpAndSettle();

    // Verify that the initial page displayed is HomePage1
    expect(find.byType(HomePage1), findsOneWidget);
  });
}

