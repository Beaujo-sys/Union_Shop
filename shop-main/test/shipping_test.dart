import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/shipping.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets('ShippingPage displays headings and sample text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ShippingPage()));

    expect(find.text('Shipping Information'), findsOneWidget);

    expect(find.text('Shipping'), findsOneWidget);
    expect(find.text('Delivery Times'), findsOneWidget);
    expect(find.text('Returns & Exchanges'), findsOneWidget);

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

    final shippingButton = find.widgetWithText(TextButton, 'Shipping');
    expect(shippingButton, findsOneWidget);

    await tester.tap(shippingButton);
    await tester.pumpAndSettle();

    expect(find.text('Delivery Times'), findsOneWidget);
  });
}