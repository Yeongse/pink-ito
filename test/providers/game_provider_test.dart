import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/models/game_phase.dart';

void main() {
  group('GameProvider - Basic Player Management', () {
    late GameProvider provider;

    setUp(() {
      provider = GameProvider();
    });

    test('initial state should have 2 players and title phase', () {
      expect(provider.playerCount, 2);
      expect(provider.phase, GamePhase.title);
      expect(provider.players.length, 2);
    });

    test('setPlayerCount should update player count between 2 and 10', () {
      provider.setPlayerCount(5);
      expect(provider.playerCount, 5);
      expect(provider.players.length, 5);
    });

    test('setPlayerCount should clamp to minimum 2', () {
      provider.setPlayerCount(1);
      expect(provider.playerCount, 2);
    });

    test('setPlayerCount should clamp to maximum 10', () {
      provider.setPlayerCount(15);
      expect(provider.playerCount, 10);
    });

    test('setPlayerName should update specific player name', () {
      provider.setPlayerName(0, 'Alice');
      expect(provider.players[0].name, 'Alice');
    });

    test('setPlayerName should not change other players', () {
      provider.setPlayerName(0, 'Alice');
      provider.setPlayerName(1, 'Bob');
      expect(provider.players[0].name, 'Alice');
      expect(provider.players[1].name, 'Bob');
    });

    test('allPlayersReady should be false when names are empty', () {
      expect(provider.allPlayersReady, isFalse);
    });

    test('allPlayersReady should be true when all names are filled', () {
      provider.setPlayerName(0, 'Alice');
      provider.setPlayerName(1, 'Bob');
      expect(provider.allPlayersReady, isTrue);
    });

    test('allPlayersReady should be false when some names are empty', () {
      provider.setPlayerName(0, 'Alice');
      expect(provider.allPlayersReady, isFalse);
    });

    test('allPlayersReady should trim whitespace', () {
      provider.setPlayerName(0, '  ');
      provider.setPlayerName(1, 'Bob');
      expect(provider.allPlayersReady, isFalse);
    });
  });

  group('GameProvider - Game Flow', () {
    late GameProvider provider;

    setUp(() {
      provider = GameProvider();
      provider.setPlayerName(0, 'Alice');
      provider.setPlayerName(1, 'Bob');
    });

    test('startGame should change phase to themeDisplay', () {
      provider.startGame();
      expect(provider.phase, GamePhase.themeDisplay);
    });

    test('startGame should select a theme', () {
      provider.startGame();
      expect(provider.currentTheme, isNotNull);
    });

    test('generateNumbers should create unique numbers for each player', () {
      provider.startGame();
      provider.generateNumbers();

      expect(provider.distributedNumbers.length, provider.players.length);

      // Check all numbers are unique
      final numberSet = provider.distributedNumbers.toSet();
      expect(numberSet.length, provider.distributedNumbers.length);
    });

    test('generateNumbers should create numbers between 1 and 100', () {
      provider.startGame();
      provider.generateNumbers();

      for (final number in provider.distributedNumbers) {
        expect(number, greaterThanOrEqualTo(1));
        expect(number, lessThanOrEqualTo(100));
      }
    });

    test('nextPlayer should increment currentPlayerIndex', () {
      provider.startGame();
      provider.generateNumbers();
      provider.goToNumberDistribution();

      expect(provider.currentPlayerIndex, 0);
      provider.nextPlayer();
      expect(provider.currentPlayerIndex, 1);
    });

    test('nextPlayer should go to expressionTime when all players done', () {
      provider.startGame();
      provider.generateNumbers();
      provider.goToNumberDistribution();

      provider.nextPlayer(); // Player 1 done
      provider.nextPlayer(); // Player 2 done, all done

      expect(provider.phase, GamePhase.expressionTime);
    });
  });

  group('GameProvider - Result and Replay', () {
    late GameProvider provider;

    setUp(() {
      provider = GameProvider();
      provider.setPlayerName(0, 'Alice');
      provider.setPlayerName(1, 'Bob');
      provider.startGame();
      provider.generateNumbers();
    });

    test('submitReorder should save reordered players', () {
      final reordered = provider.players.reversed.toList();
      provider.submitReorder(reordered);

      expect(provider.reorderedPlayers.length, reordered.length);
      expect(provider.reorderedPlayers[0].name, reordered[0].name);
    });

    test('checkResult should return true when order is correct', () {
      // Sort players by their assigned numbers (ascending)
      final correctOrder = List.of(provider.players);
      correctOrder.sort((a, b) =>
          (a.assignedNumber ?? 0).compareTo(b.assignedNumber ?? 0));

      provider.submitReorder(correctOrder);
      expect(provider.checkResult(), isTrue);
    });

    test('checkResult should return false when order is wrong', () {
      // Sort players by their assigned numbers (descending - wrong order)
      final wrongOrder = List.of(provider.players);
      wrongOrder.sort((a, b) =>
          (b.assignedNumber ?? 0).compareTo(a.assignedNumber ?? 0));

      provider.submitReorder(wrongOrder);

      // Only wrong if numbers are different
      if (wrongOrder[0].assignedNumber != wrongOrder[1].assignedNumber) {
        expect(provider.checkResult(), isFalse);
      }
    });

    test('playAgain should keep players but reset game state', () {
      final originalPlayers = List.of(provider.players);
      provider.playAgain();

      expect(provider.phase, GamePhase.themeDisplay);
      expect(provider.players.length, originalPlayers.length);
      expect(provider.currentTheme, isNotNull);
      expect(provider.currentPlayerIndex, 0);
      expect(provider.reorderedPlayers, isEmpty);
    });

    test('resetGame should clear all state', () {
      provider.resetGame();

      expect(provider.phase, GamePhase.title);
      expect(provider.currentTheme, isNull);
      expect(provider.distributedNumbers, isEmpty);
      expect(provider.currentPlayerIndex, 0);
      expect(provider.reorderedPlayers, isEmpty);
    });
  });
}
