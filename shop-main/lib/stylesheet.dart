import 'package:flutter/material.dart';

/// Centralized styles, fonts and theme for the app.
class Styles {
  // Colors
  static const Color primary = Color(0xFF4d2963);
  static const Color secondary = Color(0xFF7b4fa1);
  static const Color background = Color(0xFFF7F7F7);
  static const Color surface = Colors.white;
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Colors.black54;
  static const Color sale = Colors.redAccent;

  // Common text styles
  static const TextStyle title =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary); // page titles
  static const TextStyle sectionTitle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary); // "PRODUCTS SECTION"
  static const TextStyle productName =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary); // product titles
  static const TextStyle body =
      TextStyle(fontSize: 12, color: textSecondary); // generic body text, was 14

  // Smaller UI labels (filters, chips, etc.)
  static const TextStyle uiLabel =
      TextStyle(fontSize: 11, color: textSecondary);

  static const TextStyle footerSmall =
      TextStyle(fontSize: 13, color: Colors.grey); // footer copyright

  static const TextStyle price =
      TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.w600); // normal price
  static const TextStyle priceSmall =
      TextStyle(fontSize: 13, color: Color.fromARGB(255, 0, 0, 0)); // small price (cards)
  static const TextStyle salePrice =
      TextStyle(fontSize: 18, color: sale, fontWeight: FontWeight.bold); // sale price
  static const TextStyle strikePrice = TextStyle(
    fontSize: 16,
    color: Colors.grey,
    decoration: TextDecoration.lineThrough,
  ); // old price crossed out

  // NEW: About/Shipping styles (centralized)
  static const TextStyle pageHeading =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black);
  static const TextStyle bodyBlack =
      TextStyle(fontSize: 14, color: Colors.black);

  /// Main app theme.
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
      bodyMedium: body, // now 12pt across the app
    ),
  );

  /// Optional alternate theme for "/print-shack".
  static final ThemeData printShackTheme = ThemeData(
    primaryColor: const Color(0xFF0E8C7F),
    scaffoldBackgroundColor: const Color(0xFFFFFBF6),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0E8C7F),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    iconTheme: const IconThemeData(color: Color(0xFF0E8C7F)),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: Colors.black87,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
    ),
  );
}