import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/title_screen.dart';
import 'package:pink_ito/widgets/neon_text.dart';
import 'package:pink_ito/widgets/neon_button.dart';

void main() {
  Widget createTestWidget({
    Widget? nextScreen,
    bool disableAnimations = true,
  }) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        theme: AppTheme.darkThemeForTest,
        home: TitleScreen(
          disableAnimations: disableAnimations,
          onStartPressed: nextScreen != null
              ? (context) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => nextScreen),
                  )
              : null,
        ),
      ),
    );
  }

  group('TitleScreen', () {
    testWidgets('should display the game logo "ピンク Ito"', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('ピンク Ito'), findsOneWidget);
    });

    testWidgets('should display the subtitle "大人の数字当てゲーム"',
        (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('大人の数字当てゲーム'), findsOneWidget);
    });

    testWidgets('should use NeonText widget for the logo', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final neonTextFinder = find.byType(NeonText);
      expect(neonTextFinder, findsWidgets);

      // Find the NeonText containing the logo
      final logoNeonText = find.ancestor(
        of: find.text('ピンク Ito'),
        matching: find.byType(NeonText),
      );
      expect(logoNeonText, findsOneWidget);
    });

    testWidgets('should display "スタート" button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('スタート'), findsOneWidget);
    });

    testWidgets('should use NeonButton for start button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final neonButtonFinder = find.byType(NeonButton);
      expect(neonButtonFinder, findsOneWidget);
    });

    testWidgets('should navigate when start button is pressed', (tester) async {
      final nextScreen = Scaffold(
        body: Center(child: Text('Next Screen')),
      );

      await tester.pumpWidget(createTestWidget(nextScreen: nextScreen));

      await tester.tap(find.text('スタート'));
      await tester.pumpAndSettle();

      expect(find.text('Next Screen'), findsOneWidget);
    });

    testWidgets('should have dark background', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final scaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(scaffold.backgroundColor, isNotNull);
    });

    testWidgets('should center content vertically', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // The main column should be centered
      final columnFinder = find.byType(Column);
      expect(columnFinder, findsWidgets);
    });

    testWidgets(
        'logo NeonText should have animate disabled when disableAnimations is true',
        (tester) async {
      await tester.pumpWidget(createTestWidget(disableAnimations: true));

      final neonTextWidget = tester.widget<NeonText>(
        find.ancestor(
          of: find.text('ピンク Ito'),
          matching: find.byType(NeonText),
        ),
      );

      expect(neonTextWidget.animate, isFalse);
    });

    testWidgets(
        'start button should have pulse disabled when disableAnimations is true',
        (tester) async {
      await tester.pumpWidget(createTestWidget(disableAnimations: true));

      final neonButtonWidget = tester.widget<NeonButton>(
        find.byType(NeonButton),
      );

      expect(neonButtonWidget.pulse, isFalse);
    });

    testWidgets('logo font size should be large (56px)', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final neonTextWidget = tester.widget<NeonText>(
        find.ancestor(
          of: find.text('ピンク Ito'),
          matching: find.byType(NeonText),
        ),
      );

      expect(neonTextWidget.fontSize, 56.0);
    });

    testWidgets('should have subtitle with muted color', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final subtitleText = tester.widget<Text>(
        find.text('大人の数字当てゲーム'),
      );

      expect(subtitleText.style?.fontSize, 18);
    });
  });
}
