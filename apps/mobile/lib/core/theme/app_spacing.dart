import 'package:flutter/widgets.dart';

/// Spacing, radii, and shadows - the calm, roomy rhythm of the app.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  static const double radiusSm = 14;
  static const double radius = 22;
  static const double radiusLg = 30;
  static const double radiusPill = 999;

  static const EdgeInsets page = EdgeInsets.fromLTRB(20, 12, 20, 28);
  static const EdgeInsets card = EdgeInsets.all(18);

  static const gap4 = SizedBox(height: 4, width: 4);
  static const gap8 = SizedBox(height: 8, width: 8);
  static const gap12 = SizedBox(height: 12, width: 12);
  static const gap16 = SizedBox(height: 16, width: 16);
  static const gap24 = SizedBox(height: 24, width: 24);
  static const gap32 = SizedBox(height: 32, width: 32);
}

/// Soft, premium shadows.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> soft = [
    BoxShadow(
      color: const Color(0x141F2A44),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> subtle = [
    BoxShadow(
      color: const Color(0x0D1F2A44),
      blurRadius: 14,
      offset: const Offset(0, 6),
    ),
  ];
}
