import 'package:flutter/material.dart';

/// KKRTC Design System - Professional Color Palette
/// Matches Section 1 Design Identity Specification
class AppColors {
  // Primary Navy Tones
  static const Color deepNavy = Color(0xFF142B4A);
  static const Color midnightNavy = Color(0xFF0B1F38);

  // Warm Yellow & Gold Accents
  static const Color warmLightYellow = Color(0xFFFFF4CC);
  static const Color softYellow = Color(0xFFFFE69A);
  static const Color goldenYellow = Color(0xFFF4BD36);

  // Transport Identity Accent
  static const Color transportOrange = Color(0xFFF28C28);

  // Surfaces & Backgrounds
  static const Color creamBackground = Color(0xFFFFFCF3);
  static const Color white = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color subtleGrey = Color(0xFFF7FAFC);
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF142B4A);

  // Typography
  static const Color primaryText = Color(0xFF172B43);
  static const Color secondaryText = Color(0xFF718096);
  static const Color mutedText = Color(0xFFA0AEC0);
  static const Color textOnNavy = Color(0xFFFFFFFF);

  // Status & Telemetry Indicators
  static const Color successGreen = Color(0xFF25865A);
  static const Color errorRed = Color(0xFFD94B45);
  static const Color warningAmber = Color(0xFFE08E00);
  static const Color staleGrey = Color(0xFF8896A6);

  // Tracking Source Indicator Colors
  static const Color officialDriverGps = Color(0xFF25865A); // High Confidence
  static const Color passengerAssistedGps = Color(0xFFF28C28); // Crowdsourced
  static const Color gpsUnavailable = Color(0xFFD94B45); // Stale / Offline
}
