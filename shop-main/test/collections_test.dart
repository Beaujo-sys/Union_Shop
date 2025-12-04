import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/collections.dart';

void main() {
  Widget _host(Widget child) => MaterialApp(home: child);

  testWidgets('Collections opens SALE initially and shows items', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(_host(const CollectionsPage(initialOpenTitle: 'SALE')));
    await tester.pumpAndSettle();
    
    expect(find.textContaining('SALE'), findsWidgets);
    
    expect(find.textContaining('£'), findsWidgets);
  }, skip: true);

  testWidgets('Collections merge sale prices into main collections', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(_host(const CollectionsPage()));
    await tester.pumpAndSettle();
    
    final clothing = find.text('Clothing');
    if (clothing.evaluate().isNotEmpty) {
      await tester.tap(clothing.first);
      await tester.pumpAndSettle();
    }
    
    final hoodie = find.textContaining('Hoodie');
    final tshirt = find.textContaining('T');
    expect(hoodie.evaluate().isNotEmpty || tshirt.evaluate().isNotEmpty, true);
    expect(find.textContaining('£'), findsWidgets);
  }, skip: true);
}
