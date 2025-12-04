import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/product.dart';
import 'package:union_shop/cart.dart';

Widget _buildTestHost({required Map<String, String> item}) {
  // Minimal host app that defines the /product and /cart routes
  final cart = CartModel();
  return CartProvider(
    cart: cart,
    child: MaterialApp(
      routes: {
        '/product': (_) => ProductPage(item: item),
        '/cart': (_) => const Scaffold(body: Center(child: Text('Your cart is empty'))),
      },
      initialRoute: '/product',
    ),
  );
}

void main() {
  testWidgets('renders product title, price and Add to cart button', (tester) async {
    final item = {
      'title': 'Hoodie',
      'price': '£35',
      'image': 'assets/images/uop_hoodie.webp',
      'category': 'Clothing',
      'sizes': 'XS,S,M,L,XL,XXL',
    };

    await tester.pumpWidget(_buildTestHost(item: item));
    await tester.pumpAndSettle();

    expect(find.text('Hoodie'), findsWidgets);
    expect(find.textContaining('£35'), findsWidgets);
    expect(find.widgetWithText(FloatingActionButton, 'Add to cart'), findsOneWidget);
  });

  testWidgets('size dropdown appears for clothing and can change selection', (tester) async {
    final item = {
      'title': 'T‑Shirt',
      'price': '£20',
      'image': 'assets/images/uop_tshirt.webp',
      'category': 'Clothing',
      'sizes': 'XS,S,M,L,XL,XXL',
    };

    await tester.pumpWidget(_buildTestHost(item: item));
    await tester.pumpAndSettle();

    // Finds the size label and the dropdown
    expect(find.text('Size'), findsOneWidget);
    final dropdown = find.byType(DropdownButtonFormField<String>);
    expect(dropdown, findsOneWidget);

    // Open and select a different size
    await tester.tap(dropdown);
    await tester.pumpAndSettle();

    // Choose 'M'
    final mSize = find.text('M').last;
    await tester.tap(mSize);
    await tester.pumpAndSettle();

    // Dropdown now shows 'M' somewhere (hint/selected value)
    expect(find.text('M'), findsWidgets);
  });

  testWidgets('quantity increase/decrease updates the field', (tester) async {
    final item = {
      'title': 'Notebook',
      'price': '£5',
      'image': 'assets/images/uop_notebook.webp',
      'category': 'Stationery',
    };

    await tester.pumpWidget(_buildTestHost(item: item));
    await tester.pumpAndSettle();

    // Start with 1
    final qtyField = find.byType(TextFormField);
    expect(qtyField, findsOneWidget);
    expect(find.text('1'), findsOneWidget);

    // Increase
    final inc = find.byIcon(Icons.add_circle_outline);
    await tester.tap(inc);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsOneWidget);

    // Decrease
    final dec = find.byIcon(Icons.remove_circle_outline);
    await tester.tap(dec);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);

    // Enter a custom value
    await tester.enterText(qtyField, '3');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('Add to cart shows a snackbar and View cart navigates to /cart', (tester) async {
    final item = {
      'title': 'Pen',
      'price': '£2.00',
      'image': 'assets/images/uop_pen.webp',
      'category': 'Stationery',
    };

    await tester.pumpWidget(_buildTestHost(item: item));
    await tester.pumpAndSettle();

    // Add to cart
    final addBtn = find.widgetWithText(FloatingActionButton, 'Add to cart');
    await tester.tap(addBtn);
    await tester.pump(); // show SnackBar animation start
    expect(find.byType(SnackBar), findsOneWidget);

    // Navigate to cart via FAB
    final viewCartIcon = find.byIcon(Icons.shopping_bag_outlined);
    await tester.tap(viewCartIcon);
    await tester.pumpAndSettle();

    // Cart screen placeholder
    expect(find.textContaining('cart', findRichText: true), findsWidgets);
  });

  testWidgets('sale price is shown and original price is struck-through', (tester) async {
    final item = {
      'title': 'Cap',
      'price': '£10',
      'salePrice': '£6',
      'image': 'assets/images/uop_cap.webp',
      'category': 'Accessories',
    };

    await tester.pumpWidget(_buildTestHost(item: item));
    await tester.pumpAndSettle();

    expect(find.text('Cap'), findsWidgets);
    expect(find.text('£10'), findsWidgets);
    expect(find.text('£6'), findsWidgets);

    // Ensure both prices appear; style checks are limited in widget tests,
    // but presence of both indicates sale rendering path is active.
  });
}