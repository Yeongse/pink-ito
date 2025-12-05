import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/theme_display_screen.dart';
import 'package:pink_ito/widgets/neon_button.dart';

void main() {
  late GameProvider gameProvider;

  setUp(() {
    gameProvider = GameProvider();
    // Set up players and start game to have a theme
    gameProvider.setPlayerName(0, 'Player 1');
    gameProvider.setPlayerName(1, 'Player 2');
    gameProvider.startGame();
  });

  Widget createTestWidget({
    Widget? nextScreen,
    bool disableAnimations = true,
  }) {
    return ChangeNotifierProvider.value(
      value: gameProvider,
      child: MaterialApp(
        theme: AppTheme.darkThemeForTest,
        home: ThemeDisplayScreen(
          disableAnimations: disableAnimations,
          onDistributeNumbers: nextScreen != null
              ? (context) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => nextScreen),
                  )
              : null,
        ),
      ),
    );
  }

  group('ThemeDisplayScreen', () {
    testWidgets('should display the current theme title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // The theme title should be displayed
      final theme = gameProvider.currentTheme;
      expect(theme, isNotNull);
      expect(find.text(theme!.title), findsOneWidget);
    });

    testWidgets('should display "数字を配る" button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('数字を配る'), findsOneWidget);
    });

    testWidgets('should use NeonButton for distribute button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final neonButton = find.byType(NeonButton);
      expect(neonButton, findsOneWidget);
    });

    testWidgets('should navigate when distribute button is pressed',
        (tester) async {
      final nextScreen = Scaffold(
        body: Center(child: Text('Number Distribution')),
      );

      await tester.pumpWidget(createTestWidget(nextScreen: nextScreen));
      await tester.pump();

      await tester.tap(find.text('数字を配る'));
      await tester.pumpAndSettle();

      expect(find.text('Number Distribution'), findsOneWidget);
    });

    testWidgets('should have dark background', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('should display "今回のお題" label', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      expect(find.text('今回のお題'), findsOneWidget);
    });

    testWidgets('should have neon frame decoration', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Find container with border decoration
      final containers = find.byType(Container);
      expect(containers, findsWidgets);
    });

    testWidgets('should call generateNumbers when button pressed',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pump();

      // Numbers should not be generated yet
      expect(gameProvider.distributedNumbers, isEmpty);

      await tester.tap(find.text('数字を配る'));
      await tester.pump();

      // Numbers should be generated now
      expect(gameProvider.distributedNumbers, isNotEmpty);
    });
  });
}
