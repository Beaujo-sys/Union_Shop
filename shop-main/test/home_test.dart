import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  group('Home page', () {
    Future<void> _pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(const UnionShopApp());
      await tester.pumpAndSettle();
    }

    testWidgets('shows header banner and logo', (tester) async {
      await _pumpApp(tester);

      // Top banner text
      expect(
        find.text('CHRISTMAS IS COMING - FREE DELIVERY ON ORDERS OVER £30'),
        findsOneWidget,
      );

      // Header logo image
      expect(
        find.byWidgetPredicate(
          (w) => w is Image && (w.image is AssetImage),
        ),
        findsWidgets,
      );
    });

    testWidgets('shows header actions (search, cart, profile/menu)', (tester) async {
      await _pumpApp(tester);

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
      // Depending on your final UI this might be Icons.menu or Icons.person_outline
      // Keep whichever you actually use:
      // expect(find.byIcon(Icons.menu), findsOneWidget);
    });

    testWidgets('shows footer copyright text', (tester) async {
      await _pumpApp(tester);

      expect(
        find.textContaining('Union Shop — All rights reserved'),
        findsOneWidget,
      );
    });

    testWidgets('navigates to About page via search', (tester) async {
      await _pumpApp(tester);

      // Open the search
      await tester.tap(find.byIcon(Icons.search));
      await tester.pumpAndSettle();

      // Type "about" and select result
      await tester.enterText(find.byType(TextField), 'about');
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('About Us').first);
      await tester.pumpAndSettle();

      // Expect AboutPage content (adjust to whatever text is on that page)
      expect(find.textContaining('About'), findsWidgets);
    });
  });
}
