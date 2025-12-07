import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../widgets/ad_banner.dart';
import '../widgets/animated_background.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';

class NumberDistributionScreen extends StatefulWidget {
  final void Function(BuildContext context)? onAllPlayersComplete;

  const NumberDistributionScreen({
    super.key,
    this.onAllPlayersComplete,
  });

  @override
  State<NumberDistributionScreen> createState() =>
      _NumberDistributionScreenState();
}

class _NumberDistributionScreenState extends State<NumberDistributionScreen>
    with TickerProviderStateMixin {
  bool _isNumberRevealed = false;
  AnimationController? _handoffController;
  AnimationController? _revealController;
  int _currentPlayerKey = 0;

  @override
  void initState() {
    super.initState();
    _handoffController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _handoffController?.forward();
  }

  @override
  void dispose() {
    _handoffController?.dispose();
    _revealController?.dispose();
    super.dispose();
  }

  void _revealNumber() {
    _handoffController?.reverse().then((_) {
      setState(() {
        _isNumberRevealed = true;
      });
      _revealController?.forward(from: 0);
    });
  }

  Future<void> _goToNextPlayer(GameProvider provider, AppLocalizations l10n) async {
    // Check if this is the last player before advancing
    final isLastPlayer =
        provider.currentPlayerIndex == provider.players.length - 1;

    final confirmed = await ConfirmDialog.show(
      context: context,
      title: isLastPlayer ? l10n.toDiscussion : l10n.nextPerson,
      message: isLastPlayer
          ? l10n.allNumbersDistributed
          : l10n.passToNext,
      confirmLabel: isLastPlayer ? l10n.goToDiscussion : l10n.pass,
    );

    if (confirmed != true || !mounted) return;

    if (isLastPlayer) {
      // Navigate to next screen immediately without calling nextPlayer()
      // to prevent the flash of the first player's handoff screen
      if (widget.onAllPlayersComplete != null) {
        widget.onAllPlayersComplete!(context);
      }
    } else {
      // Animate out, then advance to next player
      _revealController?.reverse().then((_) {
        setState(() {
          _isNumberRevealed = false;
          _currentPlayerKey++;
        });
        provider.nextPlayer();
        _handoffController?.forward(from: 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      bottomNavigationBar: const AdBanner(),
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, provider, _) {
            final l10n = AppLocalizations.of(context)!;
            final currentPlayer = provider.players[provider.currentPlayerIndex];

            return AnimatedBackground(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _isNumberRevealed
                      ? _buildNumberReveal(provider, currentPlayer.name,
                          currentPlayer.assignedNumber ?? 0, l10n)
                      : _buildHandoff(currentPlayer.name, l10n),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHandoff(String playerName, AppLocalizations l10n) {
    if (_handoffController == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _handoffController!,
      builder: (context, child) {
        final progress = Curves.easeOutCubic.transform(_handoffController!.value);
        return Opacity(
          opacity: progress.clamp(0.0, 1.0),
          child: Transform.translate(
            // Horizontal slide from right (consistent with FadeSlideRoute)
            offset: Offset(30 * (1 - progress), 0),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        key: ValueKey('handoff_$_currentPlayerKey'),
        onTap: _revealNumber,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Instruction text
              Text(
                l10n.passPhone,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.mutedGray,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 24),
              // Player name - large and prominent
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.neonPink.withValues(alpha: 0.2),
                      AppColors.electricPurple.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.neonPink,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonPink.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    NeonText(
                      text: playerName,
                      fontSize: 36,
                      animate: false,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.playerTurn,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.warmWhite.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              // Tap instruction
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.darkSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.neonPink.withValues(alpha: 0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 24,
                      color: AppColors.neonPink,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.tapToSeeNumber,
                      style: TextStyle(
                        fontSize: 18,
                        color: AppColors.warmWhite,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumberReveal(
      GameProvider provider, String playerName, int number, AppLocalizations l10n) {
    if (_revealController == null) {
      return const SizedBox.shrink();
    }
    return AnimatedBuilder(
      animation: _revealController!,
      builder: (context, child) {
        final progress = _revealController!.value;
        // Staggered animations for each element
        // Use easeOutCubic for opacity (stays in 0-1 range)
        final badgeProgress = Curves.easeOutCubic.transform(
          (progress * 1.5).clamp(0.0, 1.0),
        );
        // For number: use easeOutCubic for opacity, easeOutBack for scale
        final numberRawProgress = ((progress - 0.1) * 1.3).clamp(0.0, 1.0);
        final numberOpacity = Curves.easeOutCubic.transform(numberRawProgress);
        final numberScale = Curves.easeOutBack.transform(numberRawProgress);
        final messageProgress = Curves.easeOutCubic.transform(
          ((progress - 0.2) * 1.3).clamp(0.0, 1.0),
        );
        final buttonProgress = Curves.easeOutCubic.transform(
          ((progress - 0.3) * 1.5).clamp(0.0, 1.0),
        );

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            // Player name badge
            Opacity(
              opacity: badgeProgress.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(20 * (1 - badgeProgress), 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.neonPink.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: AppColors.neonPink.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    l10n.playerNumber(playerName),
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.warmWhite,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Large number with neon glow and scale animation
            Opacity(
              opacity: numberOpacity.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.5 + 0.5 * numberScale,
                child: NeonText(
                  text: '$number',
                  fontSize: 120,
                  animate: false,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Confirmation message
            Opacity(
              opacity: messageProgress.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(15 * (1 - messageProgress), 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.electricPurple.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.rememberNumber,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.warmWhite,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.dontShowOthers,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.mutedGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(flex: 2),
            // Next button
            Opacity(
              opacity: buttonProgress.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(20 * (1 - buttonProgress), 0),
                child: NeonButton(
                  label: l10n.rememberedNext,
                  onPressed: () => _goToNextPlayer(provider, l10n),
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        );
      },
    );
  }
}
