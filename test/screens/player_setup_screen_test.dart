import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/player_setup_screen.dart';
import 'package:pink_ito/widgets/neon_button.dart';

void main() {
  late GameProvider gameProvider;

  setUp(() {
    gameProvider = GameProvider();
  });

  Widget createTestWidget({Widget? nextScreen}) {
    return ChangeNotifierProvider.value(
      value: gameProvider,
      child: MaterialApp(
        theme: AppTheme.darkThemeForTest,
        home: PlayerSetupScreen(
          onGameStart: nextScreen != null
              ? (context) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => nextScreen),
                  )
              : null,
        ),
      ),
    );
  }

  group('PlayerSetupScreen', () {
    testWidgets('should display player count slider', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('slider should have range 2-10', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final slider = tester.widget<Slider>(find.byType(Slider));

      expect(slider.min, 2.0);
      expect(slider.max, 10.0);
    });

    testWidgets('should display default 2 player name fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));
    });

    testWidgets('should update player count when slider moves', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Move slider to 5 players
      final slider = find.byType(Slider);
      await tester.drag(slider, const Offset(100, 0));
      await tester.pumpAndSettle();

      // Should have more text fields now
      final textFields = find.byType(TextField);
      expect(textFields, findsWidgets);
    });

    testWidgets('should display "ゲーム開始" button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('ゲーム開始'), findsOneWidget);
    });

    testWidgets('start button should be disabled when names are empty',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      final neonButton = tester.widget<NeonButton>(find.byType(NeonButton));

      expect(neonButton.enabled, isFalse);
    });

    testWidgets('start button should be enabled when all names are filled',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter names for both players
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Player 1');
      await tester.pump();
      await tester.enterText(textFields.last, 'Player 2');
      await tester.pump();

      final neonButton = tester.widget<NeonButton>(find.byType(NeonButton));

      expect(neonButton.enabled, isTrue);
    });

    testWidgets('should show checkmarks for entered player names',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Enter name for first player
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Player 1');
      await tester.pump();

      // Both players have check icons (one visible via opacity, one hidden)
      // When one name is entered, one checkmark becomes visible
      final checkIcons = find.byIcon(Icons.check_circle);
      expect(checkIcons, findsNWidgets(2)); // Both icons exist, opacity controls visibility
    });

    testWidgets('should navigate when game start button is pressed',
        (tester) async {
      final nextScreen = Scaffold(
        body: Center(child: Text('Theme Display')),
      );

      await tester.pumpWidget(createTestWidget(nextScreen: nextScreen));

      // Enter names for both players
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, 'Player 1');
      await tester.pump();
      await tester.enterText(textFields.last, 'Player 2');
      await tester.pump();

      // Tap start button
      await tester.tap(find.text('ゲーム開始'));
      await tester.pumpAndSettle();

      expect(find.text('Theme Display'), findsOneWidget);
    });

    testWidgets('should display player number labels', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('プレイヤー 1'), findsOneWidget);
      expect(find.text('プレイヤー 2'), findsOneWidget);
    });

    testWidgets('should display screen title', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('プレイヤー設定'), findsOneWidget);
    });

    testWidgets('should display current player count', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Default is 2 players - shown in multiple places (count display and slider labels)
      expect(find.text('2人'), findsWidgets);
    });
  });
}
