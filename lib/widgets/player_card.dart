import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_theme.dart';
import '../models/player.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final int? rank;
  final int? revealedNumber;
  final bool? isCorrect;
  final bool isDragging;
  final bool showDragHandle;

  const PlayerCard({
    super.key,
    required this.player,
    this.rank,
    this.revealedNumber,
    this.isCorrect,
    this.isDragging = false,
    this.showDragHandle = false,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      constraints: const BoxConstraints(
        minHeight: AppTheme.minTouchTarget,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(),
          width: 2,
        ),
        boxShadow: isDragging ? _buildDraggingShadows() : _buildNormalShadows(),
      ),
      child: Row(
        children: [
          if (rank != null) ...[
            _buildRankBadge(),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              player.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.warmWhite,
              ),
            ),
          ),
          if (revealedNumber != null) ...[
            const SizedBox(width: 12),
            _buildRevealedNumber(),
          ],
          if (isCorrect != null) ...[
            const SizedBox(width: 8),
            _buildResultIcon(),
          ],
          if (showDragHandle) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.drag_handle,
              color: AppColors.mutedGray,
              size: 24,
            ),
          ],
        ],
      ),
    );

    return Transform.scale(
      scale: isDragging ? 1.05 : 1.0,
      child: cardContent,
    );
  }

  Widget _buildRankBadge() {
    return Container(
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
    );
  }

  Widget _buildRevealedNumber() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _getNumberBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$revealedNumber',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: _getNumberTextColor(),
        ),
      ),
    );
  }

  Widget _buildResultIcon() {
    if (isCorrect == true) {
      return const Icon(
        Icons.check_circle,
        color: AppColors.successGreen,
        size: 28,
      );
    } else {
      return const Icon(
        Icons.cancel,
        color: AppColors.errorRed,
        size: 28,
      );
    }
  }

  Color _getBackgroundColor() {
    if (isCorrect == true) {
      return AppColors.successGreen.withValues(alpha: 0.1);
    } else if (isCorrect == false) {
      return AppColors.errorRed.withValues(alpha: 0.1);
    }
    return AppColors.darkElevated;
  }

  Color _getBorderColor() {
    if (isCorrect == true) {
      return AppColors.successGreen;
    } else if (isCorrect == false) {
      return AppColors.errorRed;
    }
    return AppColors.neonPink.withValues(alpha: 0.5);
  }

  Color _getNumberBackgroundColor() {
    if (isCorrect == true) {
      return AppColors.successGreen.withValues(alpha: 0.2);
    } else if (isCorrect == false) {
      return AppColors.errorRed.withValues(alpha: 0.2);
    }
    return AppColors.neonPink.withValues(alpha: 0.2);
  }

  Color _getNumberTextColor() {
    if (isCorrect == true) {
      return AppColors.successGreen;
    } else if (isCorrect == false) {
      return AppColors.errorRed;
    }
    return AppColors.neonPink;
  }

  List<BoxShadow> _buildNormalShadows() {
    return [
      BoxShadow(
        color: AppColors.neonPink.withValues(alpha: 0.2),
        blurRadius: 8,
        spreadRadius: 0,
      ),
    ];
  }

  List<BoxShadow> _buildDraggingShadows() {
    return [
      BoxShadow(
        color: AppColors.neonPink.withValues(alpha: 0.4),
        blurRadius: 16,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ];
  }
}
