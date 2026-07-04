import 'package:flutter/material.dart';

class AppTheme {
  static const seed = Color(0xFF1565C0);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF7F8FC),
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    ),
  );
}