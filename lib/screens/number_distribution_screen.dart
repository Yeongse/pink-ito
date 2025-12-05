import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/game_phase.dart';
import '../providers/game_provider.dart';
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

class _NumberDistributionScreenState extends State<NumberDistributionScreen> {
  bool _isNumberRevealed = false;

  void _revealNumber() {
    setState(() {
      _isNumberRevealed = true;
    });
  }

  void _goToNextPlayer(GameProvider provider) {
    provider.nextPlayer();

    // Check if all players have seen their numbers
    if (provider.phase == GamePhase.expressionTime) {
      if (widget.onAllPlayersComplete != null) {
        widget.onAllPlayersComplete!(context);
      }
    } else {
      // Reset for next player
      setState(() {
        _isNumberRevealed = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, provider, _) {
            final currentPlayer = provider.players[provider.currentPlayerIndex];

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _isNumberRevealed
                    ? _buildNumberReveal(provider, currentPlayer.name,
                        currentPlayer.assignedNumber ?? 0)
                    : _buildHandoff(currentPlayer.name),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHandoff(String playerName) {
    return GestureDetector(
      onTap: _revealNumber,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            NeonText(
              text: '$playerNameさんに渡してください',
              fontSize: 28,
              animate: false,
            ),
            const Spacer(flex: 2),
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
              child: Text(
                'タップして数字を見る',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.warmWhite,
                ),
              ),
            ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberReveal(
      GameProvider provider, String playerName, int number) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(flex: 2),
        // Player name
        Text(
          playerName,
          style: TextStyle(
            fontSize: 24,
            color: AppColors.mutedGray,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 32),
        // Large number with neon glow
        NeonText(
          text: '$number',
          fontSize: 120,
          animate: false,
        ),
        const Spacer(flex: 2),
        // Next button
        NeonButton(
          label: '覚えたら次へ',
          onPressed: () => _goToNextPlayer(provider),
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}
