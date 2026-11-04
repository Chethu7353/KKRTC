import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final textTheme = ThemeData.dark().textTheme.apply(
      bodyColor: AppColors.white,
      displayColor: AppColors.white,
    );
    final scheme = const ColorScheme.dark(
      primary: AppColors.brightCyan,
      onPrimary: AppColors.deepNavy,
      secondary: AppColors.iceBlue,
      onSecondary: AppColors.deepNavy,
      tertiary: AppColors.oceanBlue,
      surface: AppColors.darkBlue,
      onSurface: AppColors.white,
      error: AppColors.iceBlue,
      onError: AppColors.deepNavy,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.deepNavy,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.deepNavy,
        foregroundColor: AppColors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: AppColors.white,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkBlue,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.oceanBlue),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brightCyan,
          foregroundColor: AppColors.deepNavy,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brightCyan,
          side: const BorderSide(color: AppColors.brightCyan),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkBlue,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.oceanBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.oceanBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.brightCyan, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.mutedBlueGrey),
        labelStyle: GoogleFonts.inter(color: AppColors.mutedBlueGrey),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.darkBlue,
        indicatorColor: AppColors.oceanBlue,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.inter(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? AppColors.brightCyan
                : AppColors.mutedBlueGrey,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? AppColors.brightCyan
                : AppColors.mutedBlueGrey,
          ),
        ),
      ),
      dialogTheme: const DialogThemeData(backgroundColor: AppColors.darkBlue),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.darkBlue,
        modalBackgroundColor: AppColors.darkBlue,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.brightCyan,
      ),
      dividerTheme: const DividerThemeData(color: AppColors.oceanBlue),
    );
  }
}
