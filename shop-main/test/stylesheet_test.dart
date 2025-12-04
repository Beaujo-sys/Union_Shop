import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/stylesheet.dart';

void main() {
  group('Styles', () {
    test('appTheme is a Material Theme with expected palette', () {
      final theme = Styles.appTheme;
      expect(theme, isA<ThemeData>());

      // Primary color should be set
      expect(theme.primaryColor, isNotNull);

      // Text theme exists
      expect(theme.textTheme, isNotNull);
      expect(theme.textTheme.bodyMedium, isNotNull);
      expect(theme.textTheme.titleMedium, isNotNull);
    });

    testWidgets('Theme applies to MaterialApp', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: Styles.appTheme,
        home: const Scaffold(body: Text('Hello')),
      ));
      await tester.pumpAndSettle();

      // Verify Theme is attached and has our primaryColor
      final ctx = tester.element(find.text('Hello'));
      final theme = Theme.of(ctx);
      expect(theme, isNotNull);
      expect(theme.primaryColor, Styles.primary);
    });

    test('public text styles are non-null', () {
      expect(Styles.body, isA<TextStyle>());
      expect(Styles.sectionTitle, isA<TextStyle>());
      expect(Styles.productName, isA<TextStyle>());
      expect(Styles.price, isA<TextStyle>());
      expect(Styles.priceSmall, isA<TextStyle>());
      expect(Styles.footerSmall, isA<TextStyle>());
      expect(Styles.uiLabel, isA<TextStyle>());
    });

    test('color roles are present', () {
      expect(Styles.primary, isA<Color>());
      expect(Styles.surface, isA<Color>());
      expect(Styles.textPrimary, isA<Color>());
    });
  });
}
