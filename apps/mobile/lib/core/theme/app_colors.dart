import 'package:flutter/material.dart';

/// ParentHug brand palette. Clean, iOS-native neutral canvas with warm brand
/// accents used sparingly.
class AppColors {
  AppColors._();

  // Brand accents
  static const primary = Color(0xFF3B82F6); // refined blue (links, selection)
  static const coral = Color(0xFFFB5D6B); // primary action / brand
  static const yellow = Color(0xFFF5B93B);
  static const mint = Color(0xFF34C98B);
  static const cream = Color(0xFFF4F5F7); // app canvas (neutral, cool)
  static const ink = Color(0xFF171A21); // primary text (near-black)

  // Neutrals / support
  static const surface = Colors.white;
  static const inkMuted = Color(0xFF6A7180);
  static const inkFaint = Color(0xFFA0A6B2);
  static const hairline = Color(0xFFE6E8EC); // cool light hairline
  static const primarySoft = Color(0xFFEAF2FE);
  static const coralSoft = Color(0xFFFFEBED);
  static const mintSoft = Color(0xFFE4F7EF);
  static const yellowSoft = Color(0xFFFDF3DC);

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
