import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pink_ito/widgets/fade_slide_route.dart';
import 'package:pink_ito/constants/app_animations.dart';

void main() {
  group('FadeSlideRoute', () {
    testWidgets('should navigate to the new page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    FadeSlideRoute(
                      page: const Scaffold(
                        body: Center(child: Text('New Page')),
                      ),
                    ),
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      await tester.pumpAndSettle();

      expect(find.text('New Page'), findsOneWidget);
    });

    testWidgets('should use correct transition duration', (tester) async {
      final route = FadeSlideRoute(
        page: const Scaffold(body: Text('Test')),
      );

      expect(route.transitionDuration, AppAnimations.screenTransition);
    });

    testWidgets('should apply fade and slide animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    FadeSlideRoute(
                      page: const Scaffold(
                        body: Center(child: Text('Animated Page')),
                      ),
                    ),
                  );
                },
                child: const Text('Navigate'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Navigate'));
      // Pump a few frames during animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Animation should be in progress
      expect(find.text('Animated Page'), findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
