import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/game_phase.dart';
import '../models/game_state.dart';
import '../models/game_theme.dart';
import '../models/player.dart';
import '../repositories/theme_repository.dart';

class GameProvider extends ChangeNotifier {
  GameState _state;
  final ThemeRepository _themeRepository;
  final Random _random = Random();

  GameProvider({ThemeRepository? themeRepository})
      : _themeRepository = themeRepository ?? ThemeRepository(),
        _state = GameState.initial() {
    _initializePlayers(2);
  }

  // Getters
  GamePhase get phase => _state.phase;
  List<Player> get players => _state.players;
  int get playerCount => _state.players.length;
  GameTheme? get currentTheme => _state.currentTheme;
  List<int> get distributedNumbers => _state.distributedNumbers;
  int get currentPlayerIndex => _state.currentPlayerIndex;
  List<Player> get reorderedPlayers => _state.reorderedPlayers;

  bool get allPlayersReady {
    return _state.players.every((player) => player.name.trim().isNotEmpty);
  }

  // Player Management
  void setPlayerCount(int count) {
    final clampedCount = count.clamp(2, 10);
    _initializePlayers(clampedCount);
    notifyListeners();
  }

  void _initializePlayers(int count) {
    final currentPlayers = _state.players;
    final newPlayers = <Player>[];

    for (int i = 0; i < count; i++) {
      if (i < currentPlayers.length) {
        newPlayers.add(currentPlayers[i]);
      } else {
        newPlayers.add(Player(id: 'player_$i', name: ''));
      }
    }

    _state = _state.copyWith(players: newPlayers);
  }

  void setPlayerName(int index, String name) {
    if (index < 0 || index >= _state.players.length) return;

    final updatedPlayers = List<Player>.from(_state.players);
    updatedPlayers[index] = updatedPlayers[index].copyWith(name: name);
    _state = _state.copyWith(players: updatedPlayers);
    notifyListeners();
  }

  // Game Flow
  void startGame() {
    final theme = _themeRepository.getRandomTheme();
    _themeRepository.markAsUsed(theme.id);

    _state = _state.copyWith(
      currentTheme: theme,
      phase: GamePhase.themeDisplay,
    );
    notifyListeners();
  }

  void generateNumbers() {
    final numbers = _generateUniqueNumbers(_state.players.length);

    final updatedPlayers = <Player>[];
    for (int i = 0; i < _state.players.length; i++) {
      updatedPlayers.add(
        _state.players[i].copyWith(assignedNumber: numbers[i]),
      );
    }

    _state = _state.copyWith(
      players: updatedPlayers,
      distributedNumbers: numbers,
    );
    notifyListeners();
  }

  List<int> _generateUniqueNumbers(int count) {
    final allNumbers = List<int>.generate(100, (i) => i + 1);
    allNumbers.shuffle(_random);
    return allNumbers.take(count).toList();
  }

  void goToNumberDistribution() {
    _state = _state.copyWith(
      phase: GamePhase.numberDistribution,
      currentPlayerIndex: 0,
    );
    notifyListeners();
  }

  void nextPlayer() {
    final nextIndex = _state.currentPlayerIndex + 1;

    if (nextIndex >= _state.players.length) {
      _state = _state.copyWith(
        phase: GamePhase.expressionTime,
        currentPlayerIndex: 0,
      );
    } else {
      _state = _state.copyWith(currentPlayerIndex: nextIndex);
    }
    notifyListeners();
  }

  void goToExpressionTime() {
    _state = _state.copyWith(
      phase: GamePhase.expressionTime,
    );
    notifyListeners();
  }

  void goToReorder() {
    _state = _state.copyWith(
      phase: GamePhase.reorder,
      reorderedPlayers: List.from(_state.players),
    );
    notifyListeners();
  }

  // Result and Replay
  void submitReorder(List<Player> reorderedPlayers) {
    _state = _state.copyWith(
      reorderedPlayers: reorderedPlayers,
      phase: GamePhase.result,
    );
    notifyListeners();
  }

  bool checkResult() {
    final reordered = _state.reorderedPlayers;
    for (int i = 0; i < reordered.length - 1; i++) {
      final current = reordered[i].assignedNumber ?? 0;
      final next = reordered[i + 1].assignedNumber ?? 0;
      if (current > next) {
        return false;
      }
    }
    return true;
  }

  List<bool> getPlayerResults() {
    final reordered = _state.reorderedPlayers;
    final sortedByNumber = List<Player>.from(_state.players)
      ..sort((a, b) =>
          (a.assignedNumber ?? 0).compareTo(b.assignedNumber ?? 0));

    return List.generate(reordered.length, (i) {
      return reordered[i].id == sortedByNumber[i].id;
    });
  }

  void playAgain() {
    final theme = _themeRepository.getRandomTheme();
    _themeRepository.markAsUsed(theme.id);

    // Reset players' assigned numbers
    final resetPlayers = _state.players
        .map((p) => Player(id: p.id, name: p.name))
        .toList();

    _state = _state.copyWith(
      players: resetPlayers,
      currentTheme: theme,
      distributedNumbers: [],
      currentPlayerIndex: 0,
      reorderedPlayers: [],
      phase: GamePhase.themeDisplay,
    );
    notifyListeners();
  }

  void resetGame() {
    _themeRepository.resetUsedThemes();
    _state = GameState.initial();
    _initializePlayers(2);
    notifyListeners();
  }

  /// プレイヤー設定画面に戻る（既存の設定を保持）
  void goToPlayerSetup() {
    // Reset players' assigned numbers but keep names
    final resetPlayers = _state.players
        .map((p) => Player(id: p.id, name: p.name))
        .toList();

    _state = _state.copyWith(
      players: resetPlayers,
      currentTheme: null,
      distributedNumbers: [],
      currentPlayerIndex: 0,
      reorderedPlayers: [],
      phase: GamePhase.playerSetup,
    );
    notifyListeners();
  }
}
