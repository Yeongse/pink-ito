import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/neon_text.dart';
import '../widgets/neon_button.dart';

class TitleScreen extends StatelessWidget {
  final void Function(BuildContext context)? onStartPressed;
  final bool disableAnimations;

  const TitleScreen({
    super.key,
    this.onStartPressed,
    this.disableAnimations = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Logo with neon glow animation
              NeonText(
                text: 'ピンク Ito',
                fontSize: 56,
                animate: !disableAnimations,
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                '大人の数字当てゲーム',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.mutedGray,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(flex: 3),
              // Start button with pulse animation
              NeonButton(
                label: 'スタート',
                pulse: !disableAnimations,
                onPressed: () {
                  if (onStartPressed != null) {
                    onStartPressed!(context);
                  }
                },
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
