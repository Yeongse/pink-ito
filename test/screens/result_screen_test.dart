import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/models/player.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/result_screen.dart';
import 'package:pink_ito/widgets/neon_button.dart';
import 'package:pink_ito/widgets/player_card.dart';

void main() {
  late GameProvider gameProvider;

  Widget createTestWidget({
    Widget? playAgainScreen,
    Widget? resetScreen,
    bool disableAnimations = true,
  }) {
    return ChangeNotifierProvider.value(
      value: gameProvider,
      child: MaterialApp(
        theme: AppTheme.darkThemeForTest,
        home: ResultScreen(
          disableAnimations: disableAnimations,
          onPlayAgain: playAgainScreen != null
              ? (context) => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => playAgainScreen),
                  )
              : null,
          onReset: resetScreen != null
              ? (context) => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => resetScreen),
                  )
              : null,
        ),
      ),
    );
  }

  group('ResultScreen - Success Case', () {
    setUp(() {
      gameProvider = GameProvider();
      gameProvider.setPlayerName(0, 'Alice');
      gameProvider.setPlayerName(1, 'Bob');
      gameProvider.startGame();

      // Manually set numbers so Alice < Bob (correct order)
      // We need to submit in correct order
      gameProvider.generateNumbers();
      gameProvider.goToReorder();

      // Sort players by their assigned numbers
      final sortedPlayers = List<Player>.from(gameProvider.players)
        ..sort((a, b) =>
            (a.assignedNumber ?? 0).compareTo(b.assignedNumber ?? 0));
      gameProvider.submitReorder(sortedPlayers);
    });

    testWidgets('should display "SUCCESS!" when order is correct',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('SUCCESS!'), findsOneWidget);
    });

    testWidgets('should display all player cards with numbers',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(PlayerCard), findsNWidgets(2));
    });

    testWidgets('should display "もう一度遊ぶ" button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('もう一度遊ぶ'), findsOneWidget);
    });

    testWidgets('should display "最初から" button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('最初から'), findsOneWidget);
    });

    testWidgets('should have two NeonButton widgets', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(NeonButton), findsNWidgets(2));
    });

    testWidgets('should navigate when "もう一度遊ぶ" is pressed',
        (tester) async {
      final playAgainScreen = Scaffold(
        body: Center(child: Text('Theme Display')),
      );

      await tester.pumpWidget(createTestWidget(playAgainScreen: playAgainScreen));

      await tester.tap(find.text('もう一度遊ぶ'));
      await tester.pumpAndSettle();

      expect(find.text('Theme Display'), findsOneWidget);
    });

    testWidgets('should navigate when "最初から" is pressed', (tester) async {
      final resetScreen = Scaffold(
        body: Center(child: Text('Title Screen')),
      );

      await tester.pumpWidget(createTestWidget(resetScreen: resetScreen));

      await tester.tap(find.text('最初から'));
      await tester.pumpAndSettle();

      expect(find.text('Title Screen'), findsOneWidget);
    });
  });

  group('ResultScreen - Failure Case', () {
    setUp(() {
      gameProvider = GameProvider();
      gameProvider.setPlayerName(0, 'Alice');
      gameProvider.setPlayerName(1, 'Bob');
      gameProvider.startGame();
      gameProvider.generateNumbers();
      gameProvider.goToReorder();

      // Sort players by their assigned numbers in REVERSE order (wrong)
      final wrongOrder = List<Player>.from(gameProvider.players)
        ..sort((a, b) =>
            (b.assignedNumber ?? 0).compareTo(a.assignedNumber ?? 0));
      gameProvider.submitReorder(wrongOrder);
    });

    testWidgets('should display "残念..." when order is incorrect',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('残念...'), findsOneWidget);
    });

    testWidgets('should still have replay buttons', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('もう一度遊ぶ'), findsOneWidget);
      expect(find.text('最初から'), findsOneWidget);
    });
  });

  group('ResultScreen - Visual', () {
    setUp(() {
      gameProvider = GameProvider();
      gameProvider.setPlayerName(0, 'Alice');
      gameProvider.setPlayerName(1, 'Bob');
      gameProvider.startGame();
      gameProvider.generateNumbers();
      gameProvider.goToReorder();
      gameProvider.submitReorder(gameProvider.players);
    });

    testWidgets('should have dark background', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });
  });
}
