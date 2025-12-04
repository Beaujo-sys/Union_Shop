import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

import 'package:union_shop/product.dart';
import 'package:union_shop/cart.dart';
import 'firebasemock_test.dart';

Widget _host({required Map<String, String> item}) {
  final cart = CartModel(
    repo: TestCartRepository(),
    authState: const Stream<User?>.empty(),
  );
  return CartProvider(
    cart: cart,
    child: MaterialApp(
      home: ProductPage(item: item),
    ),
  );
}

void main() {
  testWidgets('ProductPage renders title and price', (tester) async {
    final item = {
      'title': 'Hoodie',
      'price': '£35',
      'image': 'assets/images/uop_hoodie.webp',
      'category': 'Clothing',
      'sizes': 'XS,S,M,L,XL,XXL',
    };

    await tester.pumpWidget(_host(item: item));
    await tester.pumpAndSettle();

    expect(find.textContaining('Hoodie'), findsWidgets);
    expect(find.textContaining('£35'), findsWidgets);
  });

  testWidgets('quantity can increase and decrease', (tester) async {
    final item = {
      'title': 'Notebook',
      'price': '£5',
      'image': 'assets/images/uop_notebook.webp',
      'category': 'Stationery',
    };

    await tester.pumpWidget(_host(item: item));
    await tester.pumpAndSettle();

    Finder qtyField = find.byType(TextFormField);
    if (qtyField.evaluate().isEmpty) {
      qtyField = find.byType(TextField);
    }
    expect(qtyField, findsOneWidget);

    expect(find.text('1'), findsWidgets);

    final plusIcon = find.byIcon(Icons.add_circle_outline);
    expect(plusIcon, findsWidgets);
    await tester.tap(plusIcon.first);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsWidgets);

    final minusIcon = find.byIcon(Icons.remove_circle_outline);
    expect(minusIcon, findsWidgets);
    await tester.tap(minusIcon.first);
    await tester.pumpAndSettle();
    expect(find.text('1'), findsWidgets);

    await tester.enterText(qtyField, '3');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.text('3'), findsWidgets);
  });

  testWidgets('size selector appears for Clothing items', (tester) async {
    final item = {
      'title': 'T‑Shirt',
      'price': '£20',
      'image': 'assets/images/uop_tshirt.webp',
      'category': 'Clothing',
      'sizes': 'XS,S,M,L,XL,XXL',
    };

    await tester.pumpWidget(_host(item: item));
    await tester.pumpAndSettle();

    expect(find.textContaining('Size'), findsWidgets);

    Finder sizeDropdown = find.byType(DropdownButtonFormField<String>);
    if (sizeDropdown.evaluate().isEmpty) {
      sizeDropdown = find.byType(DropdownButton<String>);
    }
    if (sizeDropdown.evaluate().isEmpty) {
      final sizeLabel = find.textContaining('Size');
      if (sizeLabel.evaluate().isNotEmpty) {
        await tester.tap(sizeLabel.first);
        await tester.pumpAndSettle();
      }
      final mText = find.text('M');
      if (mText.evaluate().isNotEmpty) {
        await tester.tap(mText.last);
        await tester.pumpAndSettle();
      }
      expect(find.textContaining('Size'), findsWidgets);
      return;
    }
    await tester.tap(sizeDropdown.first);
    await tester.pumpAndSettle();
    final mText = find.text('M');
    if (mText.evaluate().isNotEmpty) {
      await tester.tap(mText.last);
      await tester.pumpAndSettle();
      expect(find.text('M'), findsWidgets);
    }
  });

  testWidgets('sale item shows both price and sale price', (tester) async {
    final item = {
      'title': 'Cap',
      'price': '£10',
      'salePrice': '£6',
      'image': 'assets/images/uop_cap.webp',
      'category': 'Accessories',
    };

    await tester.pumpWidget(_host(item: item));
    await tester.pumpAndSettle();

    expect(find.textContaining('Cap'), findsWidgets);
    expect(find.textContaining('£10'), findsWidgets);
    expect(find.textContaining('£6'), findsWidgets);
  });
}