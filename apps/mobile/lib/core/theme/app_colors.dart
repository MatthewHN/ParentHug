import 'package:flutter/material.dart';

/// ParentHug brand palette. Warm, calm, colorful, premium.
class AppColors {
  AppColors._();

  // Brand
  static const primary = Color(0xFF2F9CF4); // sky blue
  static const coral = Color(0xFFFF6B7A);
  static const yellow = Color(0xFFFFC83D);
  static const mint = Color(0xFF52E3A2);
  static const cream = Color(0xFFFFF6EA); // app background
  static const ink = Color(0xFF1F2A44); // primary text

  // Neutrals / support
  static const surface = Colors.white;
  static const inkMuted = Color(0xFF6B7385);
  static const inkFaint = Color(0xFF9AA1B1);
  static const hairline = Color(0xFFEFE7D8);
  static const primarySoft = Color(0xFFE7F3FE);
  static const coralSoft = Color(0xFFFFEAED);
  static const mintSoft = Color(0xFFE3F9EF);
  static const yellowSoft = Color(0xFFFFF4D8);

  // Gradients
  static const skyGradient = LinearGradient(
    colors: [Color(0xFF2F9CF4), Color(0xFF52E3A2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const warmGradient = LinearGradient(
    colors: [Color(0xFFFF6B7A), Color(0xFFFFC83D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const hugGradient = LinearGradient(
    colors: [Color(0xFF2F9CF4), Color(0xFFFF6B7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent color per Family Board category.
  static Color category(String category) {
    switch (category) {
      case 'heads_up':
        return coral;
      case 'rules':
        return primary;
      case 'wins':
        return mint;
      case 'wants':
        return yellow;
      case 'triggers':
        return const Color(0xFFB07CF6); // soft violet
      case 'saved_scripts':
        return const Color(0xFF2FB8C6); // teal
      default:
        return primary;
    }
  }

  static Color categorySoft(String key) =>
      Color.alphaBlend(category(key).withValues(alpha: 0.12), cream);
}
