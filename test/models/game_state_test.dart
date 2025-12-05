import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/models/game_state.dart';
import 'package:pink_ito/models/game_phase.dart';
import 'package:pink_ito/models/player.dart';
import 'package:pink_ito/models/game_theme.dart';

void main() {
  group('GamePhase', () {
    test('should have all required phases', () {
      expect(GamePhase.values, contains(GamePhase.title));
      expect(GamePhase.values, contains(GamePhase.playerSetup));
      expect(GamePhase.values, contains(GamePhase.themeDisplay));
      expect(GamePhase.values, contains(GamePhase.numberDistribution));
      expect(GamePhase.values, contains(GamePhase.expressionTime));
      expect(GamePhase.values, contains(GamePhase.reorder));
      expect(GamePhase.values, contains(GamePhase.result));
    });
  });

  group('GameState', () {
    test('initial state should have empty players and title phase', () {
      final state = GameState.initial();

      expect(state.players, isEmpty);
      expect(state.currentTheme, isNull);
      expect(state.distributedNumbers, isEmpty);
      expect(state.currentPlayerIndex, 0);
      expect(state.reorderedPlayers, isEmpty);
      expect(state.phase, GamePhase.title);
    });

    test('copyWith should update specified fields', () {
      final initialState = GameState.initial();
      final players = [
        Player(id: '1', name: 'Alice'),
        Player(id: '2', name: 'Bob'),
      ];

      final updatedState = initialState.copyWith(
        players: players,
        phase: GamePhase.playerSetup,
      );

      expect(updatedState.players, players);
      expect(updatedState.phase, GamePhase.playerSetup);
      expect(updatedState.currentTheme, isNull);
    });

    test('copyWith should preserve unspecified fields', () {
      final theme = GameTheme(id: '1', title: 'テスト');
      final state = GameState(
        players: [Player(id: '1', name: 'Alice')],
        currentTheme: theme,
        distributedNumbers: [42],
        currentPlayerIndex: 0,
        reorderedPlayers: [],
        phase: GamePhase.themeDisplay,
      );

      final updatedState = state.copyWith(phase: GamePhase.numberDistribution);

      expect(updatedState.currentTheme, theme);
      expect(updatedState.players.length, 1);
      expect(updatedState.phase, GamePhase.numberDistribution);
    });
  });
}
