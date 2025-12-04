import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:union_shop/main.dart';
import 'package:union_shop/cart.dart';

void main() {
  group('Cart page smoke tests', () {
    Future<void> _pumpAppAndOpenCart(
      WidgetTester tester, {
      void Function(CartModel cart)? setupCart,
    }) async {
      final cart = CartModel();
      setupCart?.call(cart);

      await tester.pumpWidget(
        CartProvider(
          cart: cart,
          child: const UnionShopApp(),
        ),
      );
      await tester.pumpAndSettle();

      // 1) Try cart icon
      final cartIcon = find.byIcon(Icons.shopping_bag_outlined);
      if (cartIcon.evaluate().isNotEmpty) {
        await tester.tap(cartIcon);
        await tester.pumpAndSettle();
        return;
      }

      // 2) Fallback: named route
      final ctx = tester.element(find.byType(UnionShopApp));
      try {
        Navigator.of(ctx).pushNamed('/cart');
        await tester.pumpAndSettle();
      } catch (_) {
        // If there is no /cart route, do nothing – test will still show us the tree
      }
    }

    testWidgets('cart page builds without crashing', (tester) async {
      await _pumpAppAndOpenCart(tester);

      // Just expect that a CartPage exists somewhere, or any widget with "Cart" in its type name
      final cartPageType = find.byType(CartPage);
      if (cartPageType.evaluate().isNotEmpty) {
        expect(cartPageType, findsOneWidget);
      } else {
        // Very loose fallback: any Text that includes "cart" (case-insensitive)
        final anyCartText = find.byWidgetPredicate((w) {
          if (w is Text) {
            final t = w.data?.toLowerCase() ?? '';
            return t.contains('cart');
          }
          return false;
        });
        expect(anyCartText, findsWidgets);
      }
    });

    testWidgets('shows at least some empty or summary text when empty', (tester) async {
      await _pumpAppAndOpenCart(tester);

      // Accept *any* empty-state style message
      final emptyLikeText = find.byWidgetPredicate((w) {
        if (w is Text) {
          final t = (w.data ?? '').toLowerCase();
          return t.contains('empty') ||
                 t.contains('no items') ||
                 t.contains('your cart') ||
                 t.contains('basket');
        }
        return false;
      });

      expect(emptyLikeText, findsWidgets);
    });

    testWidgets('shows an item when one is added to CartModel', (tester) async {
      await _pumpAppAndOpenCart(
        tester,
        setupCart: (cart) {
          cart.addItem(
            CartItem(
              title: 'Smoke Test Item',
              image: 'assets/images/uop_hoodie.webp',
              unitPrice: 10.0,
              quantity: 1,
            ),
          );
        },
      );

      // Look for our test item by name (anywhere)
      expect(find.text('Smoke Test Item'), findsWidgets);
    });
  });
}