import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets('Mobile header shows bottom sheet menu and navigates', (WidgetTester tester) async {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.window.devicePixelRatioTestValue = 1.0;
    binding.window.physicalSizeTestValue = const Size(400, 800);
    addTearDown(() {
      binding.window.clearPhysicalSizeTestValue();
      binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(const MaterialApp(home: Shell()));
    await tester.pumpAndSettle();

    final moreButton = find.byIcon(Icons.more_vert);
    expect(moreButton, findsOneWidget);
    await tester.ensureVisible(moreButton);
    await tester.tap(moreButton);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ListTile, 'Home'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'About Us'), findsOneWidget);
    expect(find.widgetWithText(ListTile, 'Shipping'), findsOneWidget);

    await tester.tap(find.widgetWithText(ListTile, 'About Us'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Welcome to the Union Shop', findRichText: false), findsOneWidget);
  });
}
