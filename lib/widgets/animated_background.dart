import 'dart:math';

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final bool disableAnimations;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.disableAnimations = false,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late List<_Particle> _particles;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _initParticles();
  }

  void _initParticles() {
    if (widget.disableAnimations) {
      _particles = [];
      _particleController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      );
      return;
    }

    _particles = List.generate(20, (index) => _Particle.random());
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Particle animation background
        if (!widget.disableAnimations)
          AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _particleController.value,
                ),
              );
            },
          ),
        // Content
        widget.child,
      ],
    );
  }
}

class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });

  factory _Particle.random() {
    final random = Random();
    return _Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 4 + 2,
      speed: random.nextDouble() * 0.5 + 0.2,
      opacity: random.nextDouble() * 0.5 + 0.2,
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ParticlePainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final yOffset = (particle.y + progress * particle.speed) % 1.0;
      final paint = Paint()
        ..color = AppColors.neonPink.withValues(alpha: particle.opacity * 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

      canvas.drawCircle(
        Offset(particle.x * size.width, yOffset * size.height),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
