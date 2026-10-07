import 'package:flutter/material.dart';

abstract final class AppColors {
  // Yalla Go brand identity — Navy + Turquoise + White.
  static const Color navy = Color(0xFF062B46);
  static const Color navyDeep = Color(0xFF031E33);
  static const Color turquoise = Color(0xFF08B8C5);
  static const Color turquoiseDark = Color(0xFF0796A4);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F8FA);
  static const Color surfaceSoft = Color(0xFFEDF3F6);
  static const Color textDark = Color(0xFF0B2538);
  static const Color textMutedDark = Color(0xFF71808B);

  // Compatibility aliases while the remaining screens are migrated.
  static const Color charcoal = navy;
  static const Color surface = navyDeep;
  static const Color ivory = white;
  static const Color ivorySoft = background;
  static const Color bronze = turquoise;
  static const Color bronzeLight = turquoiseDark;
  static const Color textPrimary = white;
  static const Color textMuted = Color(0xFFB8C7D1);
}
