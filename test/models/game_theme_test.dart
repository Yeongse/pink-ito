import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/models/game_theme.dart';

void main() {
  group('GameTheme', () {
    test('should create theme with id and title', () {
      final theme = GameTheme(id: '1', title: '気持ちいいもの');

      expect(theme.id, '1');
      expect(theme.title, '気持ちいいもの');
    });

    test('two themes with same values should be equal', () {
      final theme1 = GameTheme(id: '1', title: '気持ちいいもの');
      final theme2 = GameTheme(id: '1', title: '気持ちいいもの');

      expect(theme1, equals(theme2));
    });

    test('two themes with different values should not be equal', () {
      final theme1 = GameTheme(id: '1', title: '気持ちいいもの');
      final theme2 = GameTheme(id: '2', title: '恥ずかしいシチュエーション');

      expect(theme1, isNot(equals(theme2)));
    });
  });
}
