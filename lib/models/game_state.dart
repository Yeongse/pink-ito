import 'game_phase.dart';
import 'game_theme.dart';
import 'player.dart';

class GameState {
  final List<Player> players;
  final GameTheme? currentTheme;
  final List<int> distributedNumbers;
  final int currentPlayerIndex;
  final List<Player> reorderedPlayers;
  final GamePhase phase;

  const GameState({
    required this.players,
    required this.currentTheme,
    required this.distributedNumbers,
    required this.currentPlayerIndex,
    required this.reorderedPlayers,
    required this.phase,
  });

  factory GameState.initial() {
    return const GameState(
      players: [],
      currentTheme: null,
      distributedNumbers: [],
      currentPlayerIndex: 0,
      reorderedPlayers: [],
      phase: GamePhase.title,
    );
  }

  GameState copyWith({
    List<Player>? players,
    GameTheme? currentTheme,
    List<int>? distributedNumbers,
    int? currentPlayerIndex,
    List<Player>? reorderedPlayers,
    GamePhase? phase,
  }) {
    return GameState(
      players: players ?? this.players,
      currentTheme: currentTheme ?? this.currentTheme,
      distributedNumbers: distributedNumbers ?? this.distributedNumbers,
      currentPlayerIndex: currentPlayerIndex ?? this.currentPlayerIndex,
      reorderedPlayers: reorderedPlayers ?? this.reorderedPlayers,
      phase: phase ?? this.phase,
    );
  }

  @override
  String toString() =>
      'GameState(players: $players, currentTheme: $currentTheme, phase: $phase)';
}
