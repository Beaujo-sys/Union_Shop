import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/cart.dart';
import 'package:union_shop/checkout.dart';
import 'package:union_shop/stylesheet.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  testWidgets('Checkout clears cart and pops', (WidgetTester tester) async {
    final cart = CartModel(authState: const Stream<User?>.empty());
    cart.addItem(CartItem(title: 'Test Item', image: '', unitPrice: 10.0, quantity: 2));

    final app = CartProvider(
      cart: cart,
      child: MaterialApp(
        theme: Styles.appTheme,
        routes: {
          '/cart': (_) => const CartPage(),
          '/checkout': (_) => const CheckoutPage(),
        },
        home: const CartPage(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(find.text('Total'), findsOneWidget);
    expect(cart.items.length, 1);

    final checkoutButton = find.widgetWithText(ElevatedButton, 'Checkout');
    expect(checkoutButton, findsOneWidget);
    await tester.tap(checkoutButton);
    await tester.pumpAndSettle();

    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Place Order'), findsOneWidget);

    final placeOrder = find.widgetWithText(ElevatedButton, 'Place Order');
    await tester.tap(placeOrder);
    await tester.pump(); 
    await tester.pumpAndSettle();

    expect(find.text('Your Cart'), findsOneWidget);
    expect(cart.items.length, 0);
  });

  testWidgets('No checkout button when cart is empty', (WidgetTester tester) async {
    final cart = CartModel(authState: const Stream<User?>.empty());

    final app = CartProvider(
      cart: cart,
      child: MaterialApp(
        theme: Styles.appTheme,
        routes: {
          '/cart': (_) => const CartPage(),
          '/checkout': (_) => const CheckoutPage(),
        },
        home: const CartPage(),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle();

    expect(cart.items.isEmpty, isTrue);

    final checkoutButton = find.widgetWithText(ElevatedButton, 'Checkout');
    expect(checkoutButton, findsNothing);
  });
}
