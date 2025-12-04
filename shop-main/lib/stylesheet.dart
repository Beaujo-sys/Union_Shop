import 'package:flutter/material.dart';
class Styles {
  static const Color primary = Color(0xFF4d2963);
  static const Color secondary = Color(0xFF7b4fa1);
  static const Color background = Color(0xFFF7F7F7);
  static const Color surface = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color sale = Colors.redAccent;

  static const TextStyle title =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary);
  static const TextStyle sectionTitle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary);
  static const TextStyle productName =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary);
  static const TextStyle body =
      TextStyle(fontSize: 12, color: textSecondary);

  static const TextStyle uiLabel =
      TextStyle(fontSize: 11, color: textSecondary);

  static const TextStyle footerSmall =
      TextStyle(fontSize: 13, color: Colors.grey);

  static const TextStyle price =
      TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w600);
  static const TextStyle priceSmall =
      TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0));
  static const TextStyle salePrice =
      TextStyle(fontSize: 18, color: sale, fontWeight: FontWeight.bold);
  static const TextStyle strikePrice = TextStyle(
    fontSize: 16,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle pageHeading =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
  static const TextStyle bodyBlack =
      TextStyle(fontSize: 14, color: Colors.black);

  static final ThemeData appTheme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(color: textPrimary),
    textTheme: TextTheme(
      titleLarge: title,
      titleMedium: sectionTitle,
      bodyMedium: body,
    ),
  );
}