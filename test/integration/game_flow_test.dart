import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/models/player.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/title_screen.dart';
import 'package:pink_ito/screens/player_setup_screen.dart';
import 'package:pink_ito/screens/theme_display_screen.dart';
import 'package:pink_ito/screens/number_distribution_screen.dart';
import 'package:pink_ito/screens/expression_time_screen.dart';
import 'package:pink_ito/screens/reorder_screen.dart';
import 'package:pink_ito/screens/result_screen.dart';

void main() {
  late GameProvider gameProvider;

  setUp(() {
    gameProvider = GameProvider();
  });

  group('Complete Game Flow Integration Test', () {
    testWidgets('should complete full game from title to result',
        (tester) async {
      // Step 1: Title Screen
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: gameProvider,
          child: MaterialApp(
            theme: AppTheme.darkThemeForTest,
            home: TitleScreen(
              disableAnimations: true,
              onStartPressed: (context) {},
            ),
          ),
        ),
      );

      expect(find.text('ピンク Ito'), findsOneWidget);
      expect(find.text('スタート'), findsOneWidget);

      // Step 2: Player Setup Screen
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: gameProvider,
          child: MaterialApp(
            theme: AppTheme.darkThemeForTest,
            home: PlayerSetupScreen(
              onGameStart: (context) {},
            ),
          ),
        ),
      );

      // Enter player names
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Alice');
      await tester.pump();
      await tester.enterText(textFields.last, 'Bob');
      await tester.pump();

      expect(gameProvider.allPlayersReady, isTrue);

      // Simulate game start
      gameProvider.startGame();

      // Step 3: Theme Display Screen
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: gameProvider,
          child: MaterialApp(
            theme: AppTheme.darkThemeForTest,
            home: ThemeDisplayScreen(
              disableAnimations: true,
              onDistributeNumbers: (context) {},
            ),
          ),
        ),
      );

      expect(gameProvider.currentTheme, isNotNull);
      expect(find.text(gameProvider.currentTheme!.title), findsOneWidget);

      // Simulate number distribution
      gameProvider.generateNumbers();
      gameProvider.goToNumberDistribution();

      // Step 4: Number Distribution Screen
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: gameProvider,
          child: MaterialApp(
            theme: AppTheme.darkThemeForTest,
            home: NumberDistributionScreen(
              onAllPlayersComplete: (context) {},
            ),
          ),
        ),
      );

      // Distribute numbers to all players
      for (int i = 0; i < gameProvider.playerCount; i++) {
        await tester.tap(find.text('タップして数字を見る'));
        await tester.pump();
        await tester.tap(find.text('覚えたら次へ'));
        await tester.pump();
      }

      // Step 5: Expression Time Screen
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: gameProvider,
          child: MaterialApp(
            theme: AppTheme.darkThemeForTest,
            home: ExpressionTimeScreen(
              disableAnimations: true,
              onGoToReorder: (context) {},
            ),
          ),
        ),
      );

      expect(find.text('楽しく話し合ってね'), findsOneWidget);

      // Simulate going to reorder
      gameProvider.goToReorder();

      // Step 6: Reorder Screen
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: gameProvider,
          child: MaterialApp(
            theme: AppTheme.darkThemeForTest,
            home: ReorderScreen(
              onSubmitReorder: (context) {},
            ),
          ),
        ),
      );

      expect(find.text('小さい順に並べてね'), findsOneWidget);

      // Submit in correct order
      final sortedPlayers = List<Player>.from(gameProvider.players)
        ..sort(
            (a, b) => (a.assignedNumber ?? 0).compareTo(b.assignedNumber ?? 0));
      gameProvider.submitReorder(sortedPlayers);

      // Step 7: Result Screen
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: gameProvider,
          child: MaterialApp(
            theme: AppTheme.darkThemeForTest,
            home: ResultScreen(
              disableAnimations: true,
              onPlayAgain: (context) {},
              onReset: (context) {},
            ),
          ),
        ),
      );

      // Should show success
      expect(gameProvider.checkResult(), isTrue);
      expect(find.text('SUCCESS!'), findsOneWidget);
    });

    testWidgets('should allow play again and get new theme', (tester) async {
      // Setup game to result
      gameProvider.setPlayerName(0, 'Alice');
      gameProvider.setPlayerName(1, 'Bob');
      gameProvider.startGame();
      gameProvider.generateNumbers();
      gameProvider.goToReorder();
      gameProvider.submitReorder(gameProvider.players);

      // Play again
      gameProvider.playAgain();

      // Verify new game started
      expect(gameProvider.currentTheme, isNotNull);
      // Theme might be different (not guaranteed due to randomness)
      expect(gameProvider.distributedNumbers, isEmpty);
      expect(gameProvider.players.length, 2);
      expect(gameProvider.players[0].name, 'Alice');
      expect(gameProvider.players[1].name, 'Bob');
    });

    testWidgets('theme repository should not repeat themes consecutively',
        (tester) async {
      // Play multiple games and ensure themes don't repeat consecutively
      gameProvider.setPlayerName(0, 'Alice');
      gameProvider.setPlayerName(1, 'Bob');

      String? lastThemeId;
      for (int i = 0; i < 5; i++) {
        gameProvider.startGame();
        final currentThemeId = gameProvider.currentTheme?.id;

        // Themes should not repeat consecutively
        if (lastThemeId != null) {
          expect(currentThemeId, isNot(equals(lastThemeId)));
        }

        lastThemeId = currentThemeId;

        gameProvider.generateNumbers();
        gameProvider.goToReorder();
        gameProvider.submitReorder(gameProvider.players);
        gameProvider.playAgain();
      }
    });
  });
}
