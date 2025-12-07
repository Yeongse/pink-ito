import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/player.dart';
import '../providers/game_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';

class ReorderScreen extends StatefulWidget {
  final void Function(BuildContext context)? onSubmitReorder;
  final bool disableAnimations;

  const ReorderScreen({
    super.key,
    this.onSubmitReorder,
    this.disableAnimations = false,
  });

  @override
  State<ReorderScreen> createState() => _ReorderScreenState();
}

class _ReorderScreenState extends State<ReorderScreen> {
  // スロット配列: nullは空きスロット、Playerは配置済み
  List<Player?> _slots = [];
  // 手元に残っているプレイヤー
  List<Player> _handPlayers = [];
  // 現在選択中のプレイヤー（手元から選んだもの）
  Player? _selectedPlayer;
  bool _initialized = false;
  int _totalPlayers = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final provider = context.read<GameProvider>();
      _totalPlayers = provider.reorderedPlayers.length;
      _slots = List.filled(_totalPlayers, null);
      _handPlayers = List.from(provider.reorderedPlayers);
      _initialized = true;
    }
  }

  void _selectPlayer(Player player) {
    setState(() {
      if (_selectedPlayer == player) {
        _selectedPlayer = null;
      } else {
        _selectedPlayer = player;
      }
    });
  }

  void _placeInSlot(int slotIndex) {
    if (_selectedPlayer == null) return;

    setState(() {
      _handPlayers.remove(_selectedPlayer);
      // 既存のカードがあれば手元に戻す
      if (_slots[slotIndex] != null) {
        _handPlayers.add(_slots[slotIndex]!);
      }
      _slots[slotIndex] = _selectedPlayer;
      _selectedPlayer = null;
    });
  }

  void _removeFromSlot(int slotIndex) {
    final player = _slots[slotIndex];
    if (player == null) return;

    setState(() {
      _slots[slotIndex] = null;
      _handPlayers.add(player);
    });
  }

  void _swapSlots(int fromIndex, int toIndex) {
    if (fromIndex == toIndex) return;

    setState(() {
      final temp = _slots[fromIndex];
      _slots[fromIndex] = _slots[toIndex];
      _slots[toIndex] = temp;
    });
  }

  List<Player> _getOrderedPlayers() {
    return _slots.whereType<Player>().toList();
  }

  bool _allSlotsFilled() {
    return _slots.every((slot) => slot != null);
  }

  Future<void> _submitReorder(GameProvider provider, AppLocalizations l10n) async {
    if (!_allSlotsFilled()) {
      await ConfirmDialog.show(
        context: context,
        title: l10n.stillEmpty,
        message: l10n.placeAllRanks,
        confirmLabel: 'OK',
        cancelLabel: '',
      );
      return;
    }

    final confirmed = await ConfirmDialog.show(
      context: context,
      title: l10n.checkAnswer,
      message: l10n.checkAnswerConfirm,
      confirmLabel: l10n.checkAnswer,
    );

    if (confirmed == true && mounted) {
      provider.submitReorder(_getOrderedPlayers());
      if (widget.onSubmitReorder != null) {
        widget.onSubmitReorder!(context);
      }
    }
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
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Theme reminder at top
                  _buildThemeHeader(provider, l10n),
                  const SizedBox(height: 12),
                  // Title
                  NeonText(
                    text: l10n.smallestFirst,
                    fontSize: 24,
                    animate: false,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedPlayer != null
                        ? l10n.tapToPlace
                        : l10n.selectCardToPlace,
                    style: TextStyle(
                      fontSize: 13,
                      color: _selectedPlayer != null
                          ? AppColors.softGold
                          : AppColors.mutedGray,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 並び順スロットセクション
                  _buildSlotSection(l10n),
                  const SizedBox(height: 8),
                  // 手元のカードセクション
                  _buildHandSection(l10n),
                  // Submit button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: NeonButton(
                      label: l10n.checkAnswer,
                      enabled: _allSlotsFilled(),
                      onPressed: () => _submitReorder(provider, l10n),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildThemeHeader(GameProvider provider, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
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
    );
  }

  Widget _buildSlotSection(AppLocalizations l10n) {
    final filledCount = _slots.where((s) => s != null).length;

    return Expanded(
      flex: 3,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.darkSurface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.neonPink.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Section header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.neonPink.withValues(alpha: 0.15),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.format_list_numbered,
                    size: 18,
                    color: AppColors.neonPink,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.arrangementOrder,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neonPink,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.arrangementHint,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.mutedGray,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$filledCount / $_totalPlayers',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.mutedGray,
                    ),
                  ),
                ],
              ),
            ),
            // Slots list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: _totalPlayers,
                itemBuilder: (context, index) {
                  final player = _slots[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: player != null
                        ? _buildFilledSlot(player, index, l10n)
                        : _buildEmptySlot(index, l10n),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveToEmptySlot(int fromIndex, int toIndex) {
    setState(() {
      _slots[toIndex] = _slots[fromIndex];
      _slots[fromIndex] = null;
    });
  }

  Widget _buildEmptySlot(int index, AppLocalizations l10n) {
    final isSelectable = _selectedPlayer != null;

    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        _moveToEmptySlot(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        final isDropTarget = candidateData.isNotEmpty;

        return GestureDetector(
          onTap: isSelectable ? () => _placeInSlot(index) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDropTarget
                  ? AppColors.electricPurple.withValues(alpha: 0.2)
                  : isSelectable
                      ? AppColors.softGold.withValues(alpha: 0.1)
                      : AppColors.darkBg.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDropTarget
                    ? AppColors.electricPurple
                    : isSelectable
                        ? AppColors.softGold.withValues(alpha: 0.8)
                        : AppColors.mutedGray.withValues(alpha: 0.3),
                width: isDropTarget || isSelectable ? 2 : 1,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: Row(
              children: [
                // Rank badge
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: isDropTarget
                        ? AppColors.electricPurple.withValues(alpha: 0.3)
                        : AppColors.mutedGray.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isDropTarget
                          ? AppColors.electricPurple
                          : AppColors.mutedGray.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isDropTarget
                            ? AppColors.electricPurple
                            : AppColors.mutedGray,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Empty slot indicator
                Expanded(
                  child: Text(
                    isDropTarget
                        ? l10n.tapToPlaceHere
                        : isSelectable
                            ? l10n.tapToPlaceHere
                            : '—',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDropTarget
                          ? AppColors.electricPurple
                          : isSelectable
                              ? AppColors.softGold
                              : AppColors.mutedGray.withValues(alpha: 0.5),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                if (isDropTarget)
                  Icon(
                    Icons.arrow_downward,
                    size: 20,
                    color: AppColors.electricPurple,
                  )
                else if (isSelectable)
                  Icon(
                    Icons.add_circle,
                    size: 20,
                    color: AppColors.softGold,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilledSlot(Player player, int index, AppLocalizations l10n) {
    return DragTarget<int>(
      onAcceptWithDetails: (details) {
        _swapSlots(details.data, index);
      },
      builder: (context, candidateData, rejectedData) {
        final isDropTarget = candidateData.isNotEmpty;
        return Draggable<int>(
          data: index,
          onDragStarted: () {
            setState(() {
              _selectedPlayer = null;
            });
          },
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 48,
              child: _buildSlotContent(player, index, isDragging: true),
            ),
          ),
          childWhenDragging: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.darkBg.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.neonPink.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.mutedGray.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.mutedGray.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.moving,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedGray.withValues(alpha: 0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          child: _buildSlotContent(
            player,
            index,
            isDropTarget: isDropTarget,
          ),
        );
      },
    );
  }

  Widget _buildSlotContent(
    Player player,
    int index, {
    bool isDragging = false,
    bool isDropTarget = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDropTarget
            ? AppColors.electricPurple.withValues(alpha: 0.2)
            : AppColors.darkElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDropTarget
              ? AppColors.electricPurple
              : isDragging
                  ? AppColors.neonPink
                  : AppColors.neonPink.withValues(alpha: 0.5),
          width: isDragging || isDropTarget ? 2 : 1,
        ),
        boxShadow: isDragging
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
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.neonPink.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: AppColors.neonPink,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 14,
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
              player.name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.warmWhite,
              ),
            ),
          ),
          // Remove button
          GestureDetector(
            onTap: () => _removeFromSlot(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                Icons.close,
                size: 18,
                color: AppColors.mutedGray,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Drag handle indicator
          Icon(
            Icons.drag_handle,
            size: 20,
            color: AppColors.mutedGray,
          ),
        ],
      ),
    );
  }

  Widget _buildHandSection(AppLocalizations l10n) {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.electricPurple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.electricPurple.withValues(alpha: 0.15),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.back_hand_outlined,
                  size: 18,
                  color: AppColors.electricPurple,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.yourHand,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.electricPurple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.handHint,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.mutedGray,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.handCardsCount(_handPlayers.length),
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.mutedGray,
                  ),
                ),
              ],
            ),
          ),
          // Hand cards
          Expanded(
            child: _handPlayers.isEmpty
                ? Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: AppColors.successGreen,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.allPlaced,
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.successGreen,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    itemCount: _handPlayers.length,
                    itemBuilder: (context, index) {
                      final player = _handPlayers[index];
                      return _buildHandCard(player);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildHandCard(Player player) {
    final isSelected = _selectedPlayer == player;

    return GestureDetector(
      onTap: () => _selectPlayer(player),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? [
                    AppColors.softGold.withValues(alpha: 0.3),
                    AppColors.neonPink.withValues(alpha: 0.2),
                  ]
                : [
                    AppColors.electricPurple.withValues(alpha: 0.2),
                    AppColors.neonPink.withValues(alpha: 0.1),
                  ],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.softGold
                : AppColors.electricPurple.withValues(alpha: 0.6),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.softGold.withValues(alpha: 0.4)
                  : AppColors.electricPurple.withValues(alpha: 0.2),
              blurRadius: isSelected ? 12 : 8,
              spreadRadius: isSelected ? 2 : 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.touch_app,
              size: 24,
              color: isSelected ? AppColors.softGold : AppColors.electricPurple,
            ),
            const SizedBox(height: 8),
            Text(
              player.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.softGold : AppColors.warmWhite,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
