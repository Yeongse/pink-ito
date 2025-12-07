import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/neon_button.dart';

class TitleScreen extends StatefulWidget {
  final void Function(BuildContext context)? onStartPressed;
  final bool disableAnimations;

  const TitleScreen({
    super.key,
    this.onStartPressed,
    this.disableAnimations = false,
  });

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen>
    with TickerProviderStateMixin {
  AnimationController? _bgController;
  AnimationController? _glowController;
  AnimationController? _textController;
  List<_FloatingOrb>? _orbs;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _orbs = List.generate(6, (i) => _FloatingOrb.random(i));

    if (!widget.disableAnimations) {
      _bgController?.repeat();
      _glowController?.repeat(reverse: true);
      _textController?.forward();
    } else {
      _textController?.value = 1.0;
    }
  }

  @override
  void dispose() {
    _bgController?.dispose();
    _glowController?.dispose();
    _textController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF050507),
      body: Stack(
        children: [
          // Animated gradient orbs background
          if (!widget.disableAnimations &&
              _bgController != null &&
              _orbs != null)
            AnimatedBuilder(
              animation: _bgController!,
              builder: (context, child) {
                return CustomPaint(
                  size: Size.infinite,
                  painter: _OrbsPainter(
                    orbs: _orbs!,
                    progress: _bgController!.value,
                  ),
                );
              },
            ),
          // Noise texture overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.3),
                radius: 1.5,
                colors: [
                  AppColors.neonPink.withValues(alpha: 0.03),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // Glass blur effect at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.15,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.neonPink.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const Spacer(flex: 2),
                          // Icon with luxurious frame
                          _buildLuxuryIcon(),
                          const SizedBox(height: 48),
                          // Animated title reveal
                          _buildAnimatedTitle(),
                          const SizedBox(height: 20),
                          // Elegant tagline
                          _buildTagline(),
                          const Spacer(flex: 3),
                          // Premium play button
                          _buildPlayButton(),
                          const SizedBox(height: 40),
                          // Subtle footer
                          _buildFooter(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLuxuryIcon() {
    if (_glowController == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _glowController!,
      builder: (context, child) {
        final glow = widget.disableAnimations
            ? 0.6
            : 0.4 + 0.4 * _glowController!.value;
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.neonPink.withValues(alpha: 0.8),
                AppColors.electricPurple.withValues(alpha: 0.6),
                AppColors.neonPink.withValues(alpha: 0.4),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.neonPink.withValues(alpha: glow * 0.5),
                blurRadius: 50,
                spreadRadius: 5,
              ),
              BoxShadow(
                color: AppColors.electricPurple.withValues(alpha: glow * 0.3),
                blurRadius: 80,
                spreadRadius: 20,
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0C),
              borderRadius: BorderRadius.circular(29),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/images/icon.png',
                width: 160,
                height: 160,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTitle() {
    if (_textController == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _textController!,
      builder: (context, child) {
        final progress = Curves.easeOutCubic.transform(_textController!.value);
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: Column(
        children: [
          // Main title with shimmer effect
          ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                colors: [
                  AppColors.warmWhite,
                  AppColors.neonPink,
                  AppColors.warmWhite,
                  AppColors.electricPurple,
                  AppColors.warmWhite,
                ],
                stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              ).createShader(bounds);
            },
            child: Text(
              'Pink Ito',
              style: TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.w200,
                color: Colors.white,
                letterSpacing: 8,
                height: 1,
                shadows: [
                  Shadow(
                    color: AppColors.neonPink.withValues(alpha: 0.8),
                    blurRadius: 30,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildTagline() {
    if (_textController == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _textController!,
      builder: (context, child) {
        final delay = 0.3;
        final progress = Curves.easeOutCubic.transform(
          ((_textController!.value - delay) / (1 - delay)).clamp(0.0, 1.0),
        );
        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            // Decorative line
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.neonPink.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.neonPink,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonPink.withValues(alpha: 0.8),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.neonPink.withValues(alpha: 0.5),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Tagline text
            Text(
              '秘密の数字を、言葉で繋げ。',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w300,
                color: AppColors.warmWhite.withValues(alpha: 0.7),
                letterSpacing: 4,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 24),
            // Bottom decorative line
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppColors.electricPurple.withValues(alpha: 0.4),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.electricPurple,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.electricPurple.withValues(
                            alpha: 0.6,
                          ),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.electricPurple.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    if (_textController == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _textController!,
      builder: (context, child) {
        final delay = 0.5;
        final rawProgress = ((_textController!.value - delay) / (1 - delay)).clamp(0.0, 1.0);
        // Use easeOutCubic for opacity (stays in 0-1 range)
        final opacityProgress = Curves.easeOutCubic.transform(rawProgress);
        // Use easeOutBack for scale (can exceed 1.0 for bounce effect)
        final scaleProgress = Curves.easeOutBack.transform(rawProgress);
        return Opacity(
          opacity: opacityProgress.clamp(0.0, 1.0),
          child: Transform.scale(scale: 0.8 + 0.2 * scaleProgress, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: NeonButton(
          label: 'PLAY',
          pulse: !widget.disableAnimations,
          onPressed: () {
            if (widget.onStartPressed != null) {
              widget.onStartPressed!(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFooter() {
    if (_textController == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _textController!,
      builder: (context, child) {
        final delay = 0.7;
        final rawProgress = ((_textController!.value - delay) / (1 - delay)).clamp(0.0, 1.0);
        final progress = Curves.easeOutCubic.transform(rawProgress);
        final opacity = (progress * 0.5).clamp(0.0, 1.0);
        return Opacity(opacity: opacity, child: child);
      },
      child: Column(
        children: [
          Text(
            '— Adults Only —',
            style: TextStyle(
              fontSize: 10,
              color: AppColors.mutedGray,
              letterSpacing: 4,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingOrb {
  final double x;
  final double y;
  final double radius;
  final double speed;
  final Color color;
  final double phaseOffset;

  _FloatingOrb({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.color,
    required this.phaseOffset,
  });

  factory _FloatingOrb.random(int index) {
    final random = Random(index * 42);
    final colors = [
      AppColors.neonPink,
      AppColors.electricPurple,
      AppColors.deepMagenta,
    ];
    return _FloatingOrb(
      x: random.nextDouble(),
      y: random.nextDouble(),
      radius: random.nextDouble() * 150 + 100,
      speed: random.nextDouble() * 0.3 + 0.1,
      color: colors[random.nextInt(colors.length)],
      phaseOffset: random.nextDouble() * 2 * pi,
    );
  }
}

class _OrbsPainter extends CustomPainter {
  final List<_FloatingOrb> orbs;
  final double progress;

  _OrbsPainter({required this.orbs, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final orb in orbs) {
      // Smooth floating motion
      final xOffset = sin(progress * 2 * pi * orb.speed + orb.phaseOffset) * 50;
      final yOffset =
          cos(progress * 2 * pi * orb.speed * 0.7 + orb.phaseOffset) * 30;

      final x = orb.x * size.width + xOffset;
      final y = orb.y * size.height + yOffset;

      // Pulsing opacity
      final pulseOpacity =
          0.08 + 0.04 * sin(progress * 2 * pi * 2 + orb.phaseOffset);

      final paint = Paint()
        ..shader =
            RadialGradient(
              colors: [
                orb.color.withValues(alpha: pulseOpacity),
                orb.color.withValues(alpha: 0),
              ],
            ).createShader(
              Rect.fromCircle(center: Offset(x, y), radius: orb.radius),
            );

      canvas.drawCircle(Offset(x, y), orb.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
