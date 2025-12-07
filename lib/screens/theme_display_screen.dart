import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../constants/app_animations.dart';
import '../constants/app_colors.dart';
import '../providers/game_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';

class ThemeDisplayScreen extends StatefulWidget {
  final void Function(BuildContext context)? onDistributeNumbers;
  final bool disableAnimations;

  const ThemeDisplayScreen({
    super.key,
    this.onDistributeNumbers,
    this.disableAnimations = false,
  });

  @override
  State<ThemeDisplayScreen> createState() => _ThemeDisplayScreenState();
}

class _ThemeDisplayScreenState extends State<ThemeDisplayScreen> {
  String _displayedText = '';
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    if (widget.disableAnimations) {
      _animationComplete = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = context.read<GameProvider>();
        setState(() {
          _displayedText = provider.currentTheme?.title ?? '';
        });
      });
    } else {
      _startTypewriterAnimation();
    }
  }

  void _startTypewriterAnimation() {
    final provider = context.read<GameProvider>();
    final title = provider.currentTheme?.title ?? '';

    int charIndex = 0;
    Future.doWhile(() async {
      if (charIndex < title.length) {
        await Future.delayed(AppAnimations.typewriter);
        if (mounted) {
          setState(() {
            _displayedText = title.substring(0, charIndex + 1);
          });
          charIndex++;
        }
        return mounted && charIndex < title.length;
      }
      if (mounted) {
        setState(() {
          _animationComplete = true;
        });
      }
      return false;
    });
  }

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(flex: 2),
                      // Label
                      Text(
                        '今回のお題',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.mutedGray,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Theme title with neon frame
                      _buildThemeFrame(provider),
                      const Spacer(flex: 2),
                      // Distribute numbers button
                      NeonButton(
                        label: '数字を配る',
                        pulse: !widget.disableAnimations && _animationComplete,
                        onPressed: () {
                          provider.generateNumbers();
                          provider.goToNumberDistribution();
                          if (widget.onDistributeNumbers != null) {
                            widget.onDistributeNumbers!(context);
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

  Widget _buildThemeFrame(GameProvider provider) {
    Widget content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neonPink,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPinkGlow,
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: NeonText(
        text: widget.disableAnimations
            ? (provider.currentTheme?.title ?? '')
            : _displayedText,
        fontSize: 36,
        animate: false,
      ),
    );

    if (!widget.disableAnimations) {
      content = content
          .animate()
          .fadeIn(duration: const Duration(milliseconds: 500))
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
            duration: const Duration(milliseconds: 500),
          );
    }

    return content;
  }
}
