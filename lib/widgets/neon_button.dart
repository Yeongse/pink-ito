import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../constants/app_animations.dart';
import '../constants/app_colors.dart';
import '../constants/app_theme.dart';

class NeonButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool enabled;
  final bool pulse;
  final Color glowColor;
  final double fontSize;

  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.enabled = true,
    this.pulse = false,
    this.glowColor = AppColors.neonPink,
    this.fontSize = 18.0,
  });

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveGlowColor = widget.enabled
        ? widget.glowColor
        : widget.glowColor.withValues(alpha: 0.3);

    Widget button = GestureDetector(
      onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
      onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
      onTapCancel: widget.enabled ? () => _setPressed(false) : null,
      onTap: widget.enabled ? widget.onPressed : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: AppAnimations.buttonTap,
        child: Container(
          constraints: const BoxConstraints(
            minHeight: AppTheme.minTouchTarget,
            minWidth: 120,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          decoration: BoxDecoration(
            color: widget.enabled
                ? AppColors.darkElevated
                : AppColors.darkSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: effectiveGlowColor,
              width: 2,
            ),
            boxShadow: widget.enabled ? _buildGlowShadows() : null,
          ),
          child: Text(
            widget.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              color: widget.enabled
                  ? AppColors.warmWhite
                  : AppColors.mutedGray,
            ),
          ),
        ),
      ),
    );

    if (widget.pulse && widget.enabled) {
      button = button
          .animate(
            onPlay: (controller) => controller.repeat(reverse: true),
          )
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.03, 1.03),
            duration: AppAnimations.buttonPulse,
            curve: Curves.easeInOut,
          );
    }

    return button;
  }

  void _setPressed(bool pressed) {
    setState(() {
      _isPressed = pressed;
    });
  }

  List<BoxShadow> _buildGlowShadows() {
    return [
      BoxShadow(
        color: widget.glowColor.withValues(alpha: 0.6),
        blurRadius: 8,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: widget.glowColor.withValues(alpha: 0.4),
        blurRadius: 16,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: widget.glowColor.withValues(alpha: 0.2),
        blurRadius: 32,
        spreadRadius: 4,
      ),
    ];
  }
}
