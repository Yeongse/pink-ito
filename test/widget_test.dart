import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pink_ito/constants/app_theme.dart';
import 'package:pink_ito/providers/game_provider.dart';
import 'package:pink_ito/screens/title_screen.dart';

void main() {
  testWidgets('PinkItoApp should render title screen', (WidgetTester tester) async {
    // Use a test-friendly version without animations
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => GameProvider(),
        child: MaterialApp(
          theme: AppTheme.darkThemeForTest,
          home: const TitleScreen(
            disableAnimations: true,
          ),
        ),
      ),
    );

    // Title screen should be displayed with the logo
    expect(find.text('ピンク Ito'), findsOneWidget);
    expect(find.text('スタート'), findsOneWidget);
  });
}
