import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../providers/game_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';

class ExpressionTimeScreen extends StatefulWidget {
  final void Function(BuildContext context)? onGoToReorder;
  final bool disableAnimations;

  const ExpressionTimeScreen({
    super.key,
    this.onGoToReorder,
    this.disableAnimations = false,
  });

  @override
  State<ExpressionTimeScreen> createState() => _ExpressionTimeScreenState();
}

class _ExpressionTimeScreenState extends State<ExpressionTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, provider, _) {
            return AnimatedBackground(
              disableAnimations: widget.disableAnimations,
              child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        // Theme reminder at top
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.darkSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.neonPink.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'お題: ${provider.currentTheme?.title ?? ''}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mutedGray,
                            ),
                          ),
                        ),
                        const Spacer(flex: 2),
                        // Main message
                        const NeonText(
                          text: '楽しく話し合ってね',
                          fontSize: 32,
                          animate: false,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '自分の数字を言わずに\nお題について話し合おう',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.mutedGray,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(flex: 2),
                        // Go to reorder button
                        NeonButton(
                          label: '並び替えへ',
                          pulse: !widget.disableAnimations,
                          onPressed: () {
                            provider.goToReorder();
                            if (widget.onGoToReorder != null) {
                              widget.onGoToReorder!(context);
                            }
                          },
                        ),
                        const Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
            );
          },
        ),
      ),
    );
  }
}
