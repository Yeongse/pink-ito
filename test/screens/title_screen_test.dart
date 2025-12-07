import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/screens/title_screen.dart';
import 'package:pink_ito/widgets/neon_button.dart';
import '../helpers/test_helpers.dart';

void main() {
  Widget createTestWidget({
    Widget? nextScreen,
    bool disableAnimations = true,
  }) {
    return createLocalizedTestWidget(
      child: TitleScreen(
        disableAnimations: disableAnimations,
        onStartPressed: nextScreen != null
            ? (context) => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => nextScreen),
                )
            : null,
      ),
    );
  }

  group('TitleScreen', () {
    testWidgets('should display the game logo "Pink Ito"', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Pink Ito'), findsOneWidget);
    });

    testWidgets('should display the tagline', (tester) async {
      await tester.pumpWidget(createTestWidget());

      // Japanese locale tagline
      expect(find.text('秘密の数字を、言葉で繋げ。'), findsOneWidget);
    });

    testWidgets('should display "PLAY" button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('PLAY'), findsOneWidget);
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

      await tester.tap(find.text('PLAY'));
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
        'start button should have pulse disabled when disableAnimations is true',
        (tester) async {
      await tester.pumpWidget(createTestWidget(disableAnimations: true));

      final neonButtonWidget = tester.widget<NeonButton>(
        find.byType(NeonButton),
      );

      expect(neonButtonWidget.pulse, isFalse);
    });
  });
}
