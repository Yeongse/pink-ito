import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/constants/app_colors.dart';

void main() {
  group('AppColors', () {
    test('neonPink should be #FF2D7B', () {
      expect(AppColors.neonPink, const Color(0xFFFF2D7B));
    });

    test('darkBg should be #0D0D0F', () {
      expect(AppColors.darkBg, const Color(0xFF0D0D0F));
    });

    test('darkSurface should be #1A1A1F', () {
      expect(AppColors.darkSurface, const Color(0xFF1A1A1F));
    });

    test('darkElevated should be #252529', () {
      expect(AppColors.darkElevated, const Color(0xFF252529));
    });

    test('neonPinkGlow should have 50% opacity', () {
      expect(AppColors.neonPinkGlow, const Color(0x80FF2D7B));
    });

    test('warmWhite should be #FFF5F5', () {
      expect(AppColors.warmWhite, const Color(0xFFFFF5F5));
    });

    test('mutedGray should be #6B6B75', () {
      expect(AppColors.mutedGray, const Color(0xFF6B6B75));
    });

    test('deepMagenta should be #C41E5C', () {
      expect(AppColors.deepMagenta, const Color(0xFFC41E5C));
    });

    test('softGold should be #D4AF37', () {
      expect(AppColors.softGold, const Color(0xFFD4AF37));
    });

    test('electricPurple should be #9D4EDD', () {
      expect(AppColors.electricPurple, const Color(0xFF9D4EDD));
    });

    test('successGreen should be defined', () {
      expect(AppColors.successGreen, isA<Color>());
    });

    test('errorRed should be defined', () {
      expect(AppColors.errorRed, isA<Color>());
    });
  });
}
