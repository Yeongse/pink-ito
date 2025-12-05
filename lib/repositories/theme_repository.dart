import 'dart:math';

import '../constants/themes.dart';
import '../models/game_theme.dart';

class ThemeRepository {
  final Set<String> _usedThemeIds = {};
  final Random _random = Random();

  List<GameTheme> getAvailableThemes() {
    return themes.where((theme) => !_usedThemeIds.contains(theme.id)).toList();
  }

  GameTheme getRandomTheme() {
    final available = getAvailableThemes();

    if (available.isEmpty) {
      resetUsedThemes();
      return getRandomTheme();
    }

    final index = _random.nextInt(available.length);
    return available[index];
  }

  void markAsUsed(String themeId) {
    _usedThemeIds.add(themeId);
  }

  void resetUsedThemes() {
    _usedThemeIds.clear();
  }

  int get remainingCount => themes.length - _usedThemeIds.length;
}
