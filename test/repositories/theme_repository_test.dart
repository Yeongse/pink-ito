import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/repositories/theme_repository.dart';
import 'package:pink_ito/constants/themes.dart';

void main() {
  group('ThemeRepository', () {
    late ThemeRepository repository;

    setUp(() {
      repository = ThemeRepository();
    });

    test('getAvailableThemes should return all themes initially', () {
      final available = repository.getAvailableThemes();
      expect(available.length, themes.length);
    });

    test('getRandomTheme should return a theme', () {
      final theme = repository.getRandomTheme();
      expect(theme, isNotNull);
      expect(themes.contains(theme), isTrue);
    });

    test('markAsUsed should exclude theme from available themes', () {
      final theme = repository.getRandomTheme();
      repository.markAsUsed(theme.id);

      final available = repository.getAvailableThemes();
      expect(available.contains(theme), isFalse);
      expect(available.length, themes.length - 1);
    });

    test('remainingCount should decrease after marking theme as used', () {
      expect(repository.remainingCount, themes.length);

      final theme = repository.getRandomTheme();
      repository.markAsUsed(theme.id);

      expect(repository.remainingCount, themes.length - 1);
    });

    test('resetUsedThemes should restore all themes', () {
      // Mark several themes as used
      for (int i = 0; i < 5; i++) {
        final theme = repository.getRandomTheme();
        repository.markAsUsed(theme.id);
      }

      expect(repository.remainingCount, themes.length - 5);

      repository.resetUsedThemes();

      expect(repository.remainingCount, themes.length);
      expect(repository.getAvailableThemes().length, themes.length);
    });

    test('getRandomTheme should auto-reset when all themes are used', () {
      // Use all themes
      for (int i = 0; i < themes.length; i++) {
        final theme = repository.getRandomTheme();
        repository.markAsUsed(theme.id);
      }

      expect(repository.remainingCount, 0);

      // Should auto-reset and return a theme
      final theme = repository.getRandomTheme();
      expect(theme, isNotNull);
      expect(repository.remainingCount, themes.length);
    });

    test('getRandomTheme should not return the same theme twice consecutively', () {
      // Use all but one theme
      final Set<String> usedIds = {};
      for (int i = 0; i < themes.length - 1; i++) {
        final theme = repository.getRandomTheme();
        repository.markAsUsed(theme.id);
        usedIds.add(theme.id);
      }

      // The last available theme should be returned
      final lastTheme = repository.getRandomTheme();
      expect(usedIds.contains(lastTheme.id), isFalse);
    });
  });
}
