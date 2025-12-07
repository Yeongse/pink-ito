import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/constants/themes.dart';
import 'package:pink_ito/models/game_theme.dart';

void main() {
  group('themes', () {
    test('should have exactly 30 themes', () {
      expect(themes.length, 30);
    });

    test('all themes should have unique ids', () {
      final ids = themes.map((t) => t.id).toSet();
      expect(ids.length, themes.length);
    });

    test('all themes should have non-empty titleKeys', () {
      for (final theme in themes) {
        expect(theme.titleKey, isNotEmpty);
      }
    });

    test('all themes should be GameTheme instances', () {
      for (final theme in themes) {
        expect(theme, isA<GameTheme>());
      }
    });

    test('first theme should have id "1"', () {
      expect(themes.first.id, '1');
    });

    test('last theme should have id "30"', () {
      expect(themes.last.id, '30');
    });
  });
}
