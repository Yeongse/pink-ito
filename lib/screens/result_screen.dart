import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../constants/app_animations.dart';
import '../providers/game_provider.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';
import '../widgets/player_card.dart';

class ResultScreen extends StatefulWidget {
  final void Function(BuildContext context)? onPlayAgain;
  final void Function(BuildContext context)? onReset;
  final bool disableAnimations;

  const ResultScreen({
    super.key,
    this.onPlayAgain,
    this.onReset,
    this.disableAnimations = false,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late List<bool> _revealedCards;
  late List<bool> _playerResults;
  late bool _isSuccess;
  late AnimationController _confettiController;
  late List<_ConfettiParticle> _confettiParticles;
  int _revealedCount = 0;

  @override
  void initState() {
    super.initState();
    final provider = context.read<GameProvider>();
    _playerResults = provider.getPlayerResults();
    _isSuccess = provider.checkResult();

    if (widget.disableAnimations) {
      _revealedCards =
          List.generate(provider.reorderedPlayers.length, (_) => true);
      _revealedCount = provider.reorderedPlayers.length;
    } else {
      _revealedCards =
          List.generate(provider.reorderedPlayers.length, (_) => false);
      _startRevealAnimation(provider.reorderedPlayers.length);
    }

    _initConfetti();
  }

  void _initConfetti() {
    _confettiParticles = List.generate(50, (_) => _ConfettiParticle.random());
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    if (_isSuccess && !widget.disableAnimations) {
      // Start confetti after all cards are revealed
      final delay = Duration(
        milliseconds:
            AppAnimations.cardReveal.inMilliseconds * _revealedCards.length +
                500,
      );
      Future.delayed(delay, () {
        if (mounted) {
          _confettiController.repeat();
        }
      });
    }
  }

  void _startRevealAnimation(int playerCount) {
    for (int i = 0; i < playerCount; i++) {
      Future.delayed(
        Duration(milliseconds: AppAnimations.cardReveal.inMilliseconds * i),
        () {
          if (mounted) {
            setState(() {
              _revealedCards[i] = true;
              _revealedCount = i + 1;
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                // Confetti animation
                if (_isSuccess && !widget.disableAnimations)
                  AnimatedBuilder(
                    animation: _confettiController,
                    builder: (context, child) {
                      return CustomPaint(
                        size: Size.infinite,
                        painter: _ConfettiPainter(
                          particles: _confettiParticles,
                          progress: _confettiController.value,
                        ),
                      );
                    },
                  ),
                // Main content
                Column(
                  children: [
                    const SizedBox(height: 32),
                    // Result title
                    _buildResultTitle(),
                    const SizedBox(height: 24),
                    // Player cards
                    Expanded(
                      child: _buildPlayerList(provider),
                    ),
                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          NeonButton(
                            label: 'もう一度遊ぶ',
                            onPressed: () {
                              provider.playAgain();
                              if (widget.onPlayAgain != null) {
                                widget.onPlayAgain!(context);
                              }
                            },
                          ),
                          const SizedBox(height: 12),
                          NeonButton(
                            label: '最初から',
                            onPressed: () {
                              provider.resetGame();
                              if (widget.onReset != null) {
                                widget.onReset!(context);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultTitle() {
    if (_isSuccess) {
      return Column(
        children: [
          NeonText(
            text: 'SUCCESS!',
            fontSize: 48,
            glowColor: AppColors.softGold,
            animate: !widget.disableAnimations,
          ),
          const SizedBox(height: 8),
          Text(
            '全員正解!',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.successGreen,
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          const NeonText(
            text: '残念...',
            fontSize: 48,
            animate: false,
          ),
          const SizedBox(height: 8),
          Text(
            '正しい順番を確認しよう',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.mutedGray,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildPlayerList(GameProvider provider) {
    final players = provider.reorderedPlayers;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        final isRevealed = _revealedCards[index];
        final isCorrect = _playerResults[index];

        return AnimatedOpacity(
          opacity: isRevealed ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: AnimatedSlide(
            offset: isRevealed ? Offset.zero : const Offset(0.1, 0),
            duration: const Duration(milliseconds: 300),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PlayerCard(
                player: player,
                rank: index + 1,
                revealedNumber: isRevealed ? player.assignedNumber : null,
                isCorrect: isRevealed ? isCorrect : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ConfettiParticle {
  final double x;
  final double speed;
  final double size;
  final Color color;
  final double rotation;

  _ConfettiParticle({
    required this.x,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotation,
  });

  factory _ConfettiParticle.random() {
    final random = Random();
    final colors = [
      AppColors.neonPink,
      AppColors.softGold,
      AppColors.electricPurple,
      AppColors.successGreen,
    ];
    return _ConfettiParticle(
      x: random.nextDouble(),
      speed: random.nextDouble() * 0.5 + 0.3,
      size: random.nextDouble() * 8 + 4,
      color: colors[random.nextInt(colors.length)],
      rotation: random.nextDouble() * pi * 2,
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({
    required this.particles,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final y = (progress * particle.speed * size.height * 2) % size.height;
      final paint = Paint()..color = particle.color.withValues(alpha: 0.8);

      canvas.save();
      canvas.translate(particle.x * size.width, y);
      canvas.rotate(particle.rotation + progress * pi * 2);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size * 0.6,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
