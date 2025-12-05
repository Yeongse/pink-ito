import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/player.dart';
import '../providers/game_provider.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';
import '../widgets/player_card.dart';

class ReorderScreen extends StatefulWidget {
  final void Function(BuildContext context)? onSubmitReorder;

  const ReorderScreen({
    super.key,
    this.onSubmitReorder,
  });

  @override
  State<ReorderScreen> createState() => _ReorderScreenState();
}

class _ReorderScreenState extends State<ReorderScreen> {
  late List<Player> _orderedPlayers;

  @override
  void initState() {
    super.initState();
    final provider = context.read<GameProvider>();
    _orderedPlayers = List.from(provider.reorderedPlayers);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final player = _orderedPlayers.removeAt(oldIndex);
      _orderedPlayers.insert(newIndex, player);
    });
  }

  void _submitReorder(GameProvider provider) {
    provider.submitReorder(_orderedPlayers);
    if (widget.onSubmitReorder != null) {
      widget.onSubmitReorder!(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, provider, _) {
            return Column(
              children: [
                const SizedBox(height: 24),
                // Title
                const NeonText(
                  text: '小さい順に並べてね',
                  fontSize: 28,
                  animate: false,
                ),
                const SizedBox(height: 8),
                Text(
                  'ドラッグして順番を変更',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedGray,
                  ),
                ),
                const SizedBox(height: 24),
                // Reorderable player list
                Expanded(
                  child: ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _orderedPlayers.length,
                    onReorder: _onReorder,
                    proxyDecorator: _proxyDecorator,
                    itemBuilder: (context, index) {
                      final player = _orderedPlayers[index];
                      return Padding(
                        key: ValueKey(player.id),
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PlayerCard(
                          player: player,
                          rank: index + 1,
                        ),
                      );
                    },
                  ),
                ),
                // Submit button
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: NeonButton(
                    label: '答え合わせ',
                    onPressed: () => _submitReorder(provider),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final animValue = Curves.easeInOut.transform(animation.value);
        final scale = 1.0 + (animValue * 0.05);
        final elevation = animValue * 8;

        return Transform.scale(
          scale: scale,
          child: Material(
            color: Colors.transparent,
            elevation: elevation,
            shadowColor: AppColors.neonPink.withValues(alpha: 0.5),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
