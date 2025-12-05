import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/constants/app_animations.dart';

void main() {
  group('AppAnimations', () {
    test('screenTransition should be 350ms', () {
      expect(
        AppAnimations.screenTransition,
        const Duration(milliseconds: 350),
      );
    });

    test('buttonTap should be 100ms', () {
      expect(
        AppAnimations.buttonTap,
        const Duration(milliseconds: 100),
      );
    });

    test('neonPulse should be 2 seconds', () {
      expect(
        AppAnimations.neonPulse,
        const Duration(seconds: 2),
      );
    });

    test('typewriter should be 50ms per character', () {
      expect(
        AppAnimations.typewriter,
        const Duration(milliseconds: 50),
      );
    });

    test('cardReveal should be 1500ms', () {
      expect(
        AppAnimations.cardReveal,
        const Duration(milliseconds: 1500),
      );
    });

    test('defaultCurve should be easeInOut', () {
      expect(AppAnimations.defaultCurve, Curves.easeInOut);
    });

    test('buttonPulse should be 3 seconds', () {
      expect(
        AppAnimations.buttonPulse,
        const Duration(seconds: 3),
      );
    });
  });
}
