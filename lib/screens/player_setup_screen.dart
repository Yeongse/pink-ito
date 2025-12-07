import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../widgets/animated_background.dart';
import '../widgets/confirm_dialog.dart';
import '../widgets/neon_button.dart';
import '../widgets/neon_text.dart';

class PlayerSetupScreen extends StatefulWidget {
  final void Function(BuildContext context)? onGameStart;

  const PlayerSetupScreen({
    super.key,
    this.onGameStart,
  });

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final provider = context.read<GameProvider>();
    _updateControllers(provider.playerCount);
  }

  void _updateControllers(int count) {
    // Dispose extra controllers
    while (_controllers.length > count) {
      _controllers.removeLast().dispose();
      _focusNodes.removeLast().dispose();
    }

    // Add new controllers
    while (_controllers.length < count) {
      final controller = TextEditingController();
      final focusNode = FocusNode();
      _controllers.add(controller);
      _focusNodes.add(focusNode);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, provider, _) {
            // Ensure controllers match player count
            if (_controllers.length != provider.playerCount) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _updateControllers(provider.playerCount);
                });
              });
            }

            final l10n = AppLocalizations.of(context)!;
            return AnimatedBackground(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Title
                  NeonText(
                    text: l10n.playerSetup,
                    fontSize: 32,
                    animate: false,
                  ),
                  const SizedBox(height: 32),
                  // Player count slider
                  _buildPlayerCountSlider(provider, l10n),
                  const SizedBox(height: 24),
                  // Player name fields
                  Expanded(
                    child: _buildPlayerNameList(provider, l10n),
                  ),
                  // Start game button
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: NeonButton(
                      label: l10n.startGame,
                      enabled: provider.allPlayersReady,
                      onPressed: () async {
                        final confirmed = await ConfirmDialog.show(
                          context: context,
                          title: l10n.startGameConfirmTitle,
                          message: l10n.startGameConfirmMessage,
                          confirmLabel: l10n.start,
                        );

                        if (confirmed == true && mounted) {
                          provider.startGame();
                          if (widget.onGameStart != null) {
                            widget.onGameStart!(context);
                          }
                        }
                      },
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

  Widget _buildPlayerCountSlider(GameProvider provider, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            l10n.playerCountFormat(provider.playerCount),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.warmWhite,
            ),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.neonPink,
              inactiveTrackColor: AppColors.darkSurface,
              thumbColor: AppColors.neonPink,
              overlayColor: AppColors.neonPinkGlow,
              trackHeight: 4,
            ),
            child: Slider(
              min: 2,
              max: 10,
              divisions: 8,
              value: provider.playerCount.toDouble(),
              onChanged: (value) {
                provider.setPlayerCount(value.toInt());
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.playerCountFormat(2), style: const TextStyle(color: AppColors.mutedGray)),
              Text(l10n.playerCountFormat(10), style: const TextStyle(color: AppColors.mutedGray)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerNameList(GameProvider provider, AppLocalizations l10n) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: provider.playerCount,
      itemBuilder: (context, index) {
        // Make sure controller exists
        if (index >= _controllers.length) {
          return const SizedBox.shrink();
        }

        final player = provider.players[index];
        final hasName = player.name.trim().isNotEmpty;

        // Sync controller text with provider if they differ
        if (_controllers[index].text != player.name) {
          _controllers[index].text = player.name;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  l10n.playerLabel(index + 1),
                  style: const TextStyle(
                    color: AppColors.warmWhite,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  style: const TextStyle(color: AppColors.warmWhite),
                  decoration: InputDecoration(
                    hintText: l10n.playerNameHint,
                    hintStyle: TextStyle(color: AppColors.mutedGray),
                    filled: true,
                    fillColor: AppColors.darkSurface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: AppColors.neonPink,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  onChanged: (value) {
                    provider.setPlayerName(index, value);
                  },
                ),
              ),
              const SizedBox(width: 12),
              AnimatedOpacity(
                opacity: hasName ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.check_circle,
                  color: AppColors.successGreen,
                  size: 24,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
