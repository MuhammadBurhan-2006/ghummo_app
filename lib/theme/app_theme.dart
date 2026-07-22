import 'package:flutter/material.dart';

/// Color scheme is marked "not decided" in the branding doc — this is a
/// placeholder palette (warm orange/coral/violet) chosen to look good with
/// the gradient header and tilt-card sheen. Swap seedColor once branding
/// is finalized; everything else (buttons, app bar, etc.) will follow it.
class AppTheme {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFFF7A45),
      tertiary: const Color(0xFF7B5CFA),
    ),
    scaffoldBackgroundColor: const Color(0xFFF7F7FB),
    // "Big icons" requirement from the UX notes (Stressed User / Visual Learners)
    iconTheme: const IconThemeData(size: 28),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontWeight: FontWeight.bold),
    ),
    navigationBarTheme: NavigationBarThemeData(
      elevation: 8,
      indicatorColor: const Color(0xFFFF7A45).withValues(alpha: 0.15),
    ),
  );
}
