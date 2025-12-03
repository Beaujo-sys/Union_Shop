import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/about_page.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets('AboutPage shows title and welcome text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));

    expect(find.text('About Us'), findsWidgets);

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

    final aboutButton = find.widgetWithText(TextButton, 'About Us');
    expect(aboutButton, findsOneWidget);

    await tester.tap(aboutButton);
    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome to the Union Shop', findRichText: false), findsOneWidget);
  });
}
