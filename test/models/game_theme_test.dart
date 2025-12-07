import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/models/game_theme.dart';

void main() {
  group('GameTheme', () {
    test('should create theme with id and titleKey', () {
      final theme = GameTheme(id: '1', titleKey: 'theme1');

      expect(theme.id, '1');
      expect(theme.titleKey, 'theme1');
    });

    test('two themes with same values should be equal', () {
      final theme1 = GameTheme(id: '1', titleKey: 'theme1');
      final theme2 = GameTheme(id: '1', titleKey: 'theme1');

      expect(theme1, equals(theme2));
    });

    test('two themes with different values should not be equal', () {
      final theme1 = GameTheme(id: '1', titleKey: 'theme1');
      final theme2 = GameTheme(id: '2', titleKey: 'theme2');

      expect(theme1, isNot(equals(theme2)));
    });
  });
}
