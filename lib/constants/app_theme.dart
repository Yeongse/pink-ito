import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double minTouchTarget = 44.0;

  static ThemeData get darkTheme => _buildDarkTheme(useGoogleFonts: true);

  static ThemeData get darkThemeForTest => _buildDarkTheme(useGoogleFonts: false);

  static ThemeData _buildDarkTheme({required bool useGoogleFonts}) {
    final baseTextTheme = ThemeData.dark().textTheme;
    final textTheme = useGoogleFonts
        ? GoogleFonts.notoSansTextTheme(baseTextTheme)
        : baseTextTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.neonPink,
        secondary: AppColors.electricPurple,
        surface: AppColors.darkSurface,
        error: AppColors.errorRed,
        onPrimary: AppColors.warmWhite,
        onSecondary: AppColors.warmWhite,
        onSurface: AppColors.warmWhite,
        onError: AppColors.warmWhite,
      ),
      textTheme: textTheme.apply(
        bodyColor: AppColors.warmWhite,
        displayColor: AppColors.warmWhite,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          backgroundColor: AppColors.neonPink,
          foregroundColor: AppColors.warmWhite,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(minTouchTarget, minTouchTarget),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(minTouchTarget, minTouchTarget),
        ),
      ),
    );
  }
}
