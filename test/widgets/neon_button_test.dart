import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/widgets/neon_button.dart';
import 'package:pink_ito/constants/app_colors.dart';

void main() {
  group('NeonButton', () {
    testWidgets('should display the provided label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeonButton(
              label: 'Start',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Start'), findsOneWidget);
    });

    testWidgets('should call onPressed when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeonButton(
              label: 'Tap Me',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('should be disabled when enabled is false', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeonButton(
              label: 'Disabled',
              onPressed: () {
                tapped = true;
              },
              enabled: false,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('should have neon glow effect', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeonButton(
              label: 'Glow',
              onPressed: () {},
            ),
          ),
        ),
      );

      // Find the Container with decoration
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(NeonButton),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.boxShadow, isNotNull);
    });

    testWidgets('should have minimum touch target size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NeonButton(
              label: 'Size',
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.getSize(find.byType(NeonButton));
      expect(button.height, greaterThanOrEqualTo(44.0));
    });
  });
}
