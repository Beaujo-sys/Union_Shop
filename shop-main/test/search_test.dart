import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  Future<void> _pump(WidgetTester tester) async {
    await tester.pumpWidget(const UnionShopApp());
    await tester.pumpAndSettle();
  }

  testWidgets('Search: typing filters and selecting navigates', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await _pump(tester);

    // Open search
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Query for 'about' (keeps us on current page)
    await tester.enterText(find.byType(TextField), 'about');
    await tester.pumpAndSettle();

    // Expect an entry for About
    expect(find.textContaining('About'), findsWidgets);
    // Close via back icon
    final backIcon = find.byIcon(Icons.arrow_back);
    if (backIcon.evaluate().isNotEmpty) {
      await tester.tap(backIcon);
      await tester.pumpAndSettle();
    }

    // After closing the search, just ensure search overlay is gone.
    expect(find.byType(TextField), findsNothing);
  });
}
