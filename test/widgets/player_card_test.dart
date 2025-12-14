import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/widgets/player_card.dart';
import 'package:pink_ito/models/player.dart';
import 'package:pink_ito/constants/app_colors.dart';

void main() {
  group('PlayerCard', () {
    final testPlayer = Player(id: '1', name: 'Alice', assignedNumber: 42);

    testWidgets('should display player name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerCard(player: testPlayer),
          ),
        ),
      );

      expect(find.text('Alice'), findsOneWidget);
    });

    testWidgets('should display rank when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerCard(
              player: testPlayer,
              rank: 1,
            ),
          ),
        ),
      );

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should display revealed number when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerCard(
              player: testPlayer,
              revealedNumber: 42,
            ),
          ),
        ),
      );

      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('should show check icon when isCorrect is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerCard(
              player: testPlayer,
              revealedNumber: 42,
              isCorrect: true,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('should show x icon when isCorrect is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerCard(
              player: testPlayer,
              revealedNumber: 42,
              isCorrect: false,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('should apply dragging style when isDragging is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerCard(
              player: testPlayer,
              isDragging: true,
            ),
          ),
        ),
      );

      // Find the Transform widget that applies scale
      final transform = tester.widget<Transform>(
        find.descendant(
          of: find.byType(PlayerCard),
          matching: find.byType(Transform),
        ),
      );

      expect(transform.transform.getMaxScaleOnAxis(), closeTo(1.05, 0.01));
    });

    testWidgets('should have minimum touch target size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PlayerCard(player: testPlayer),
          ),
        ),
      );

      final cardSize = tester.getSize(find.byType(PlayerCard));
      expect(cardSize.height, greaterThanOrEqualTo(44.0));
    });
  });
}
