import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/reorder_screen.dart';
import 'package:pink_ito/widgets/neon_button.dart';
import 'package:pink_ito/widgets/player_card.dart';

void main() {
  late GameProvider gameProvider;

  setUp(() {
    gameProvider = GameProvider();
    gameProvider.setPlayerName(0, 'Alice');
    gameProvider.setPlayerName(1, 'Bob');
    gameProvider.startGame();
    gameProvider.generateNumbers();
    gameProvider.goToReorder();
  });

  Widget createTestWidget({Widget? nextScreen}) {
    return ChangeNotifierProvider.value(
      value: gameProvider,
      child: MaterialApp(
        theme: AppTheme.darkThemeForTest,
        home: ReorderScreen(
          onSubmitReorder: nextScreen != null
              ? (context) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => nextScreen),
                  )
              : null,
        ),
      ),
    );
  }

  group('ReorderScreen', () {
    testWidgets('should display instruction text "小さい順に並べてね"',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('小さい順に並べてね'), findsOneWidget);
    });

    testWidgets('should display all player cards', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(PlayerCard), findsNWidgets(2));
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('should display "答え合わせ" button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('答え合わせ'), findsOneWidget);
    });

    testWidgets('should use NeonButton for submit button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(NeonButton), findsOneWidget);
    });

    testWidgets('should display rank numbers on cards', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Ranks 1 and 2 should be displayed
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should navigate when submit button is pressed',
        (tester) async {
      final nextScreen = Scaffold(
        body: Center(child: Text('Result Screen')),
      );

      await tester.pumpWidget(createTestWidget(nextScreen: nextScreen));

      await tester.tap(find.text('答え合わせ'));
      await tester.pumpAndSettle();

      expect(find.text('Result Screen'), findsOneWidget);
    });

    testWidgets('should have dark background', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('should use ReorderableListView', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ReorderableListView), findsOneWidget);
    });

    testWidgets('should call submitReorder when button pressed',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.text('答え合わせ'));
      await tester.pump();

      // Phase should change to result
      expect(gameProvider.phase.toString(), contains('result'));
    });
  });
}
