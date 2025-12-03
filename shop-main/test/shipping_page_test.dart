import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/shipping_page.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets('ShippingPage displays headings and sample text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShippingPage()));

    // AppBar title
    expect(find.text('Shipping Information'), findsOneWidget);

    // Body headings
    expect(find.text('Shipping'), findsOneWidget);
    expect(find.text('Delivery Times'), findsOneWidget);
    expect(find.text('Returns & Exchanges'), findsOneWidget);

    // Sample content snippets
    expect(find.textContaining('Shipping cost varies depending', findRichText: false), findsOneWidget);
    expect(find.textContaining('Delivery usually takes', findRichText: false), findsOneWidget);
    expect(find.textContaining('Products can be returned', findRichText: false), findsOneWidget);
  });

  testWidgets('Footer "Shipping" link navigates to ShippingPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          '/shipping': (context) => const ShippingPage(),
        },
        home: const Scaffold(body: Footer()),
      ),
    );

    // Ensure the Footer has a TextButton with label 'Shipping'
    final shippingButton = find.widgetWithText(TextButton, 'Shipping');
    expect(shippingButton, findsOneWidget);

    // Tap and navigate
    await tester.tap(shippingButton);
    await tester.pumpAndSettle();

    // Verify we are on ShippingPage by checking for a known heading
    expect(find.text('Delivery Times'), findsOneWidget);
  });
}