import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/constants/app_colors.dart';

void main() {
  group('AppTheme', () {
    test('darkTheme should use dark background color', () {
      final theme = AppTheme.darkThemeForTest;
      expect(theme.scaffoldBackgroundColor, AppColors.darkBg);
    });

    test('darkTheme should have Material Design 3 enabled', () {
      final theme = AppTheme.darkThemeForTest;
      expect(theme.useMaterial3, true);
    });

    test('darkTheme colorScheme should be dark', () {
      final theme = AppTheme.darkThemeForTest;
      expect(theme.colorScheme.brightness, Brightness.dark);
    });

    test('darkTheme primary color should be neonPink', () {
      final theme = AppTheme.darkThemeForTest;
      expect(theme.colorScheme.primary, AppColors.neonPink);
    });

    test('minTouchTarget should be at least 44x44', () {
      expect(AppTheme.minTouchTarget, greaterThanOrEqualTo(44.0));
    });
  });
}
