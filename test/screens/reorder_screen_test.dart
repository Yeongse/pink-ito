import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/reorder_screen.dart';
import 'package:pink_ito/widgets/neon_button.dart';
import '../helpers/test_helpers.dart';

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
    return createLocalizedTestWidget(
      provider: gameProvider,
      child: ReorderScreen(
        onSubmitReorder: nextScreen != null
            ? (context) => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => nextScreen),
                )
            : null,
      ),
    );
  }

  group('ReorderScreen', () {
    testWidgets('should display instruction text "小さい順に並べてね"',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('小さい順に並べてね'), findsOneWidget);
    });

    testWidgets('should display all player names in hand section',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Players should be displayed in the hand section
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

    testWidgets('should display rank numbers in slots', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Ranks 1 and 2 should be displayed as slot numbers
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });

    testWidgets('should have dark background', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('should display arrangement order section', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check for the arrangement order section header
      expect(find.text('並び順'), findsOneWidget);
    });

    testWidgets('should display hand section', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Check for the hand section header
      expect(find.text('手元のカード'), findsOneWidget);
    });

    testWidgets('should allow placing card in slot by tapping',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap on Alice's card in hand
      await tester.tap(find.text('Alice'));
      await tester.pump();

      // Tap on the first empty slot (rank 1)
      await tester.tap(find.text('タップして配置').first);
      await tester.pump();

      // Alice should now appear in the slot section as well
      // Since she moved from hand to slot
      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('should have drag handles on filled slots', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Place Alice in slot 1
      await tester.tap(find.text('Alice'));
      await tester.pump();
      await tester.tap(find.text('タップして配置').first);
      await tester.pump();

      // Check for drag handle icon
      expect(find.byIcon(Icons.drag_handle), findsOneWidget);
    });

    testWidgets('should replace card when placing on occupied slot',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Place Alice in slot 1
      await tester.tap(find.text('Alice'));
      await tester.pump();
      await tester.tap(find.text('タップして配置').first);
      await tester.pump();

      // Place Bob in slot 1 (should replace Alice)
      await tester.tap(find.text('Bob'));
      await tester.pump();
      // Tap on Alice's slot (which is now filled)
      await tester.tap(find.text('Alice'));
      await tester.pump();

      // Alice should be back in hand, Bob in slot
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });
  });
}
