import 'package:flutter/material.dart';

class AppTheme {
  static const Color _nightBlue = Color(0xFF0D1B2A);
  static const Color _violet = Color(0xFF7A5AF8);
  static const Color _cyan = Color(0xFF2DD4BF);

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _violet,
      brightness: Brightness.dark,
      primary: _violet,
      secondary: _cyan,
      surface: const Color(0xFF132035),
      tertiary: const Color(0xFF43E8D8),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _nightBlue,
      cardTheme: CardThemeData(
        color: const Color(0xFF17263D),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.07)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _nightBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.primary.withValues(alpha: 0.18),
        selectedColor: colorScheme.secondary.withValues(alpha: 0.25),
        labelStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.06),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
