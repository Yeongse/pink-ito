import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_animations.dart';
import '../constants/app_colors.dart';

class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color glowColor;
  final Color textColor;
  final bool animate;
  final Duration glowDuration;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const NeonText({
    super.key,
    required this.text,
    this.fontSize = 24.0,
    this.glowColor = AppColors.neonPink,
    this.textColor = AppColors.warmWhite,
    this.animate = false,
    this.glowDuration = AppAnimations.neonPulse,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: textColor,
        shadows: _buildGlowShadows(),
      ),
    );

    if (animate) {
      return textWidget
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .fadeIn(duration: glowDuration ~/ 2)
          .then()
          .custom(
            duration: glowDuration,
            builder: (context, value, child) {
              return Opacity(
                opacity: 0.7 + (0.3 * value),
                child: child,
              );
            },
          );
    }

    return textWidget;
  }

  List<Shadow> _buildGlowShadows() {
    return [
      Shadow(
        color: glowColor,
        blurRadius: 10,
      ),
      Shadow(
        color: glowColor,
        blurRadius: 20,
      ),
      Shadow(
        color: glowColor,
        blurRadius: 40,
      ),
      Shadow(
        color: glowColor.withValues(alpha: 0.5),
        blurRadius: 80,
      ),
    ];
  }
}
