import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:union_shop/main.dart';

void main() {
  Future<void> _pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const UnionShopApp());
    await tester.pumpAndSettle();
  }

  testWidgets('renders header actions and home scaffold', (tester) async {
    await _pumpApp(tester);

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);

    expect(find.byType(Scaffold), findsWidgets);
    expect(
      find.byWidgetPredicate(
        (w) => w is Text && (w.data ?? '').toLowerCase().contains('union shop'),
      ),
      findsWidgets,
    );
  });

  testWidgets('opens search and shows results, then can close', (tester) async {
    await _pumpApp(tester);

    // Open search
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Type query
    final queryField = find.byType(TextField);
    expect(queryField, findsOneWidget);

    await tester.enterText(queryField, 'about');
    await tester.pumpAndSettle();

    // Expect some result
    expect(find.textContaining('About'), findsWidgets);

    // Try to close via back icon first
    final backIcon = find.byIcon(Icons.arrow_back);
    if (backIcon.evaluate().isNotEmpty) {
      await tester.tap(backIcon);
      await tester.pumpAndSettle();
    }

    // If still open, try ESC
    if (queryField.evaluate().isNotEmpty) {
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
    }

    // If still open, try system back (Android)
    if (queryField.evaluate().isNotEmpty) {
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
    }

    // Last resort: Navigator.pop on root context (protected by try/catch)
    if (queryField.evaluate().isNotEmpty) {
      try {
        final ctx = tester.element(find.byType(UnionShopApp));
        Navigator.of(ctx).maybePop();
        await tester.pumpAndSettle();
      } catch (_) {
        // swallow
      }
    }

    // Search overlay gone
    expect(find.byType(TextField), findsNothing);
  });
}