import 'package:flutter/material.dart';

/// Практична 08: оформлення централізоване у ThemeData.
ThemeData buildAppTheme() {
  const blue = Color(0xff335e88);
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: blue),
    scaffoldBackgroundColor: const Color(0xfff8f9fa),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xfff8f9fa),
      foregroundColor: Color(0xff20334a),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: blue, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: blue,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: blue,
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: blue,
        minimumSize: const Size(48, 48),
      ),
    ),
  );
}
