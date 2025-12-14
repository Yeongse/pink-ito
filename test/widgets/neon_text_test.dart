import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/widgets/neon_text.dart';
import 'package:pink_ito/constants/app_colors.dart';

void main() {
  group('NeonText', () {
    testWidgets('should display the provided text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NeonText(text: 'Hello'),
          ),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('should use default neon pink glow color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NeonText(text: 'Test'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      final style = textWidget.style;

      // Should have shadows for glow effect
      expect(style?.shadows, isNotNull);
      expect(style?.shadows, isNotEmpty);
    });

    testWidgets('should apply custom glow color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NeonText(
              text: 'Custom',
              glowColor: Colors.blue,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Custom'));
      final style = textWidget.style;

      expect(style?.shadows?.first.color, Colors.blue);
    });

    testWidgets('should apply custom font size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NeonText(
              text: 'Large',
              fontSize: 48.0,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Large'));
      expect(textWidget.style?.fontSize, 48.0);
    });

    testWidgets('should use warmWhite as default text color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NeonText(text: 'White'),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('White'));
      expect(textWidget.style?.color, AppColors.warmWhite);
    });
  });
}
