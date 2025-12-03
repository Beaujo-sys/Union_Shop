import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/about_page.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets('AboutPage shows title and welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));

    // AppBar title + body heading both use 'About Us' (may be 1+ widgets)
    expect(find.text('About Us'), findsWidgets);

    // Body contains the welcome paragraph
    expect(find.textContaining('Welcome to the Union Shop', findRichText: false), findsOneWidget);
  });

  testWidgets('Footer "About Us" link navigates to AboutPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/about': (context) => const AboutPage(),
        },
        home: const Scaffold(body: Footer()),
      ),
    );

    // Ensure Footer has a TextButton labeled 'About Us'
    final aboutButton = find.widgetWithText(TextButton, 'About Us');
    expect(aboutButton, findsOneWidget);

    // Tap and navigate
    await tester.tap(aboutButton);
    await tester.pumpAndSettle();

    // Verify we're on AboutPage by checking for the welcome text
    expect(find.textContaining('Welcome to the Union Shop', findRichText: false), findsOneWidget);
  });
}
