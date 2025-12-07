import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../services/interstitial_ad_manager.dart';
import '../widgets/animated_background.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';
import '../widgets/player_card.dart';

class ResultScreen extends StatefulWidget {
  final void Function(BuildContext context)? onPlayAgain;
  final void Function(BuildContext context)? onChangeSettings;
  final void Function(BuildContext context)? onReset;
  final bool disableAnimations;

  const ResultScreen({
    super.key,
    this.onPlayAgain,
    this.onChangeSettings,
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
  int _currentRevealIndex = 0;
  bool _allRevealed = false;
  bool _showResult = false;
  Timer? _interstitialAdTimer;
  bool _adShown = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<GameProvider>();
    _playerResults = provider.getPlayerResults();
    _isSuccess = provider.checkResult();

    if (widget.disableAnimations) {
      _revealedCards =
          List.generate(provider.reorderedPlayers.length, (_) => true);
      _currentRevealIndex = provider.reorderedPlayers.length;
      _allRevealed = true;
      _showResult = true;
    } else {
      _revealedCards =
          List.generate(provider.reorderedPlayers.length, (_) => false);
    }

    _initConfetti();
  }

  void _initConfetti() {
    _confettiParticles = List.generate(50, (_) => _ConfettiParticle.random());
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  void _revealNextCard() {
    if (_currentRevealIndex >= _revealedCards.length) return;

    setState(() {
      _revealedCards[_currentRevealIndex] = true;
      _currentRevealIndex++;

      // Check if all cards are revealed
      if (_currentRevealIndex >= _revealedCards.length) {
        _allRevealed = true;
        // Show result after a short delay
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _showResult = true;
            });
            // Start confetti if success
            if (_isSuccess && !widget.disableAnimations) {
              _confettiController.repeat();
            }
            // Start 10 second timer for interstitial ad
            _startInterstitialAdTimer();
          }
        });
      }
    });
  }

  /// インタースティシャル広告の10秒タイマーを開始
  void _startInterstitialAdTimer() {
    if (_adShown) return;
    _interstitialAdTimer?.cancel();
    _interstitialAdTimer = Timer(const Duration(seconds: 10), () {
      _showInterstitialAd();
    });
  }

  /// インタースティシャル広告を表示
  Future<void> _showInterstitialAd() async {
    if (_adShown) return;
    _adShown = true;
    _interstitialAdTimer?.cancel();
    await InterstitialAdManager().showAd();
  }

  @override
  void dispose() {
    _interstitialAdTimer?.cancel();
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
            final l10n = AppLocalizations.of(context)!;
            return AnimatedBackground(
              disableAnimations: widget.disableAnimations,
              child: Stack(
                children: [
                  // Confetti animation
                  if (_isSuccess && _showResult && !widget.disableAnimations)
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
                    const SizedBox(height: 16),
                    // Theme reminder at top
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.neonPink,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.neonPinkGlow,
                            blurRadius: 12,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            l10n.theme,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mutedGray,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 20,
                            color: AppColors.neonPink.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Text(
                              provider.currentTheme?.getLocalizedTitle(l10n) ?? '',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.neonPink,
                                shadows: [
                                  Shadow(
                                    color: AppColors.neonPinkGlow,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Result title (shows after all cards revealed)
                    _buildResultTitle(l10n),
                    const SizedBox(height: 24),
                    // Player cards
                    Expanded(
                      child: _buildPlayerList(provider, l10n),
                    ),
                    // Reveal button or action buttons
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: _allRevealed
                          ? _buildActionButtons(provider, l10n)
                          : _buildRevealButton(l10n),
                    ),
                  ],
                ),
              ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildResultTitle(AppLocalizations l10n) {
    // Show "答え合わせ" until all cards are revealed
    if (!_showResult) {
      return Column(
        children: [
          NeonText(
            text: l10n.result,
            fontSize: 36,
            animate: false,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToFlip,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.mutedGray,
            ),
          ),
        ],
      );
    }

    // Show result after all cards revealed
    if (_isSuccess) {
      return Column(
        children: [
          NeonText(
            text: l10n.success,
            fontSize: 48,
            glowColor: AppColors.softGold,
            animate: !widget.disableAnimations,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.allCorrect,
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
          NeonText(
            text: l10n.failed,
            fontSize: 48,
            animate: false,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.checkCorrectOrder,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.mutedGray,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildRevealButton(AppLocalizations l10n) {
    final remaining = _revealedCards.length - _currentRevealIndex;
    return NeonButton(
      label: l10n.flipNext(remaining),
      onPressed: _revealNextCard,
      pulse: true,
    );
  }

  Widget _buildActionButtons(GameProvider provider, AppLocalizations l10n) {
    return Column(
      children: [
        NeonButton(
          label: l10n.playAgain,
          onPressed: () async {
            // Show interstitial ad before navigating
            await _showInterstitialAd();
            if (!mounted) return;
            provider.playAgain();
            if (widget.onPlayAgain != null) {
              widget.onPlayAgain!(context);
            }
          },
        ),
        const SizedBox(height: 10),
        NeonButton(
          label: l10n.changeSettings,
          onPressed: () async {
            // Show interstitial ad before navigating
            await _showInterstitialAd();
            if (!mounted) return;
            provider.goToPlayerSetup();
            if (widget.onChangeSettings != null) {
              widget.onChangeSettings!(context);
            }
          },
        ),
        const SizedBox(height: 10),
        _buildTextButton(
          label: l10n.backToTop,
          onPressed: () async {
            // Show interstitial ad before navigating
            await _showInterstitialAd();
            if (!mounted) return;
            provider.resetGame();
            if (widget.onReset != null) {
              widget.onReset!(context);
            }
          },
        ),
      ],
    );
  }

  Widget _buildTextButton({
    required String label,
    required Future<void> Function() onPressed,
  }) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.mutedGray,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.mutedGray.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerList(GameProvider provider, AppLocalizations l10n) {
    final players = provider.reorderedPlayers;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        final isRevealed = _revealedCards[index];
        final isCorrect = _playerResults[index];
        final isNextToReveal = index == _currentRevealIndex;

        return GestureDetector(
          onTap: isNextToReveal ? _revealNextCard : null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: isRevealed
                ? AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: AnimatedSlide(
                      offset: Offset.zero,
                      duration: const Duration(milliseconds: 300),
                      child: PlayerCard(
                        player: player,
                        rank: index + 1,
                        revealedNumber: player.assignedNumber,
                        isCorrect: _showResult ? isCorrect : null,
                      ),
                    ),
                  )
                : _buildHiddenCard(player.name, index + 1, isNextToReveal, l10n),
          ),
        );
      },
    );
  }

  Widget _buildHiddenCard(String playerName, int rank, bool isNextToReveal, AppLocalizations l10n) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNextToReveal
              ? AppColors.neonPink
              : AppColors.neonPink.withValues(alpha: 0.3),
          width: isNextToReveal ? 2 : 1,
        ),
        boxShadow: isNextToReveal
            ? [
                BoxShadow(
                  color: AppColors.neonPink.withValues(alpha: 0.4),
                  blurRadius: 12,
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      child: Row(
        children: [
          // Rank badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.neonPink.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.neonPink,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPink,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Player name
          Expanded(
            child: Text(
              playerName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.warmWhite,
              ),
            ),
          ),
          // Hidden number indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isNextToReveal ? l10n.tap : l10n.hidden,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isNextToReveal ? AppColors.neonPink : AppColors.mutedGray,
              ),
            ),
          ),
        ],
      ),
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
