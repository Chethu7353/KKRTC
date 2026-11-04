import 'package:flutter/material.dart';

/// KKRTC's ocean and cyan identity. Every UI token resolves to the approved
/// brand palette so older screens can migrate without changing their logic.
class AppColors {
  static const Color deepNavy = Color(0xFF06182B);
  static const Color midnightNavy = Color(0xFF06182B);
  static const Color darkBlue = Color(0xFF0B2C4A);
  static const Color oceanBlue = Color(0xFF164B70);
  static const Color brightCyan = Color(0xFF56C8F2);
  static const Color iceBlue = Color(0xFFB8F1FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color mutedBlueGrey = Color(0xFF91AFC2);

  // Compatibility tokens used throughout the existing screens.
  static const Color warmLightYellow = iceBlue;
  static const Color softYellow = iceBlue;
  static const Color goldenYellow = brightCyan;
  static const Color transportOrange = brightCyan;
  static const Color creamBackground = deepNavy;
  static const Color cardSurface = darkBlue;
  static const Color subtleGrey = oceanBlue;
  static const Color borderSubtle = oceanBlue;
  static const Color borderFocus = brightCyan;
  static const Color primaryText = white;
  static const Color secondaryText = mutedBlueGrey;
  static const Color mutedText = mutedBlueGrey;
  static const Color textOnNavy = white;
  static const Color successGreen = brightCyan;
  static const Color errorRed = iceBlue;
  static const Color warningAmber = brightCyan;
  static const Color staleGrey = mutedBlueGrey;
  static const Color officialDriverGps = brightCyan;
  static const Color passengerAssistedGps = iceBlue;
  static const Color gpsUnavailable = mutedBlueGrey;
}
