import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/number_distribution_screen.dart';
import 'package:pink_ito/widgets/neon_button.dart';
import 'package:pink_ito/widgets/neon_text.dart';

void main() {
  late GameProvider gameProvider;

  setUp(() {
    gameProvider = GameProvider();
    // Set up players and start game
    gameProvider.setPlayerName(0, 'Alice');
    gameProvider.setPlayerName(1, 'Bob');
    gameProvider.startGame();
    gameProvider.generateNumbers();
    gameProvider.goToNumberDistribution();
  });

  Widget createTestWidget({Widget? nextScreen}) {
    return ChangeNotifierProvider.value(
      value: gameProvider,
      child: MaterialApp(
        theme: AppTheme.darkThemeForTest,
        home: NumberDistributionScreen(
          onAllPlayersComplete: nextScreen != null
              ? (context) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => nextScreen),
                  )
              : null,
        ),
      ),
    );
  }

  group('NumberDistributionScreen - Handoff State', () {
    testWidgets('should display handoff message for first player',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Aliceさんに渡してください'), findsOneWidget);
    });

    testWidgets('should have tap to reveal instruction', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('タップして数字を見る'), findsOneWidget);
    });

    testWidgets('should show number when tapped', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap to reveal
      await tester.tap(find.text('タップして数字を見る'));
      await tester.pump();

      // Should now show the number
      final player = gameProvider.players[0];
      expect(find.text('${player.assignedNumber}'), findsOneWidget);
    });
  });

  group('NumberDistributionScreen - Number Reveal State', () {
    testWidgets('should display player name when showing number',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap to reveal
      await tester.tap(find.text('タップして数字を見る'));
      await tester.pump();

      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('should display large number with neon effect', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap to reveal
      await tester.tap(find.text('タップして数字を見る'));
      await tester.pump();

      // Find NeonText with the number
      final neonTexts = find.byType(NeonText);
      expect(neonTexts, findsWidgets);
    });

    testWidgets('should show "覚えたら次へ" button after reveal',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap to reveal
      await tester.tap(find.text('タップして数字を見る'));
      await tester.pump();

      expect(find.text('覚えたら次へ'), findsOneWidget);
    });

    testWidgets('should use NeonButton for next button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap to reveal
      await tester.tap(find.text('タップして数字を見る'));
      await tester.pump();

      expect(find.byType(NeonButton), findsOneWidget);
    });

    testWidgets('should go to next player when next button pressed',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // First player reveals number
      await tester.tap(find.text('タップして数字を見る'));
      await tester.pump();

      // Press next button
      await tester.tap(find.text('覚えたら次へ'));
      await tester.pump();

      // Should now show handoff for second player
      expect(find.text('Bobさんに渡してください'), findsOneWidget);
    });
  });

  group('NumberDistributionScreen - Completion', () {
    testWidgets('should navigate to next screen after all players complete',
        (tester) async {
      final nextScreen = Scaffold(
        body: Center(child: Text('Expression Time')),
      );

      await tester.pumpWidget(createTestWidget(nextScreen: nextScreen));

      // First player
      await tester.tap(find.text('タップして数字を見る'));
      await tester.pump();
      await tester.tap(find.text('覚えたら次へ'));
      await tester.pump();

      // Second player
      await tester.tap(find.text('タップして数字を見る'));
      await tester.pump();
      await tester.tap(find.text('覚えたら次へ'));
      await tester.pumpAndSettle();

      expect(find.text('Expression Time'), findsOneWidget);
    });
  });

  group('NumberDistributionScreen - Visual', () {
    testWidgets('should have dark background', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });
  });
}
