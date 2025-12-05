import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/main.dart';

void main() {
  testWidgets('Header navigates to Print Shack page', (WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1200, 800);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(const MaterialApp(home: Shell()));
    await tester.pumpAndSettle();

    final link = find.widgetWithText(TextButton, 'Print Shack');
    expect(link, findsOneWidget);

    await tester.tap(link);
    await tester.pumpAndSettle();

    expect(find.text('Print Shack'), findsWidgets);
  });
}
