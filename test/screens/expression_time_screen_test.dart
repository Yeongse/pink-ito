import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/expression_time_screen.dart';
import 'package:pink_ito/widgets/neon_button.dart';
import '../helpers/test_helpers.dart';

void main() {
  late GameProvider gameProvider;

  setUp(() {
    gameProvider = GameProvider();
    gameProvider.setPlayerName(0, 'Player 1');
    gameProvider.setPlayerName(1, 'Player 2');
    gameProvider.startGame();
    gameProvider.generateNumbers();
  });

  Widget createTestWidget({
    Widget? nextScreen,
    bool disableAnimations = true,
  }) {
    return createLocalizedTestWidget(
      provider: gameProvider,
      child: ExpressionTimeScreen(
        disableAnimations: disableAnimations,
        onGoToReorder: nextScreen != null
            ? (context) => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => nextScreen),
                )
            : null,
      ),
    );
  }

  group('ExpressionTimeScreen', () {
    testWidgets('should display main message "楽しく話し合ってね"',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('楽しく話し合ってね'), findsOneWidget);
    });

    testWidgets('should display theme reminder at top', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // The current theme should exist
      final theme = gameProvider.currentTheme;
      expect(theme, isNotNull);
      expect(theme!.titleKey, isNotEmpty);
    });

    testWidgets('should display "並び替えへ" button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('並び替えへ'), findsOneWidget);
    });

    testWidgets('should use NeonButton for navigation button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(NeonButton), findsOneWidget);
    });

    testWidgets('should navigate when button is pressed', (tester) async {
      final nextScreen = Scaffold(
        body: Center(child: Text('Reorder Screen')),
      );

      await tester.pumpWidget(createTestWidget(nextScreen: nextScreen));

      await tester.tap(find.text('並び替えへ'));
      await tester.pumpAndSettle();

      expect(find.text('Reorder Screen'), findsOneWidget);
    });

    testWidgets('should have dark background', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('should call goToReorder when button pressed', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('並び替えへ'));
      await tester.pump();

      // goToReorder should set up reorderedPlayers
      expect(gameProvider.reorderedPlayers, isNotEmpty);
    });
  });
}
