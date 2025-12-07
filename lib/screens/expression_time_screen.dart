import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../l10n/app_localizations.dart';
import '../providers/game_provider.dart';
import '../services/interstitial_ad_manager.dart';
import '../widgets/animated_background.dart';
import '../widgets/neon_text.dart';

class ExpressionTimeScreen extends StatefulWidget {
  final void Function(BuildContext context)? onGoToReorder;
  final bool disableAnimations;

  const ExpressionTimeScreen({
    super.key,
    this.onGoToReorder,
    this.disableAnimations = false,
  });

  @override
  State<ExpressionTimeScreen> createState() => _ExpressionTimeScreenState();
}

class _ExpressionTimeScreenState extends State<ExpressionTimeScreen>
    with TickerProviderStateMixin {
  Timer? _adTimer;
  bool _adShown = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    // ローディングアニメーション用コントローラー
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (!widget.disableAnimations) {
      _pulseController.repeat(reverse: true);
    }

    // 5秒後にインタースティシャル広告を表示
    _adTimer = Timer(const Duration(seconds: 5), () {
      _showInterstitialAndNavigate();
    });
  }

  Future<void> _showInterstitialAndNavigate() async {
    if (_adShown || !mounted) return;
    _adShown = true;

    final provider = context.read<GameProvider>();

    // インタースティシャル広告を表示
    await InterstitialAdManager().showAd();

    if (!mounted) return;

    // 広告が終わったら並び替え画面に遷移
    provider.goToReorder();
    if (widget.onGoToReorder != null) {
      widget.onGoToReorder!(context);
    }
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      // バナー広告なし
      body: SafeArea(
        child: Consumer<GameProvider>(
          builder: (context, provider, _) {
            final l10n = AppLocalizations.of(context)!;
            return AnimatedBackground(
              disableAnimations: widget.disableAnimations,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Spacer(flex: 1),
                      // お題を大きく表示
                      _buildThemeDisplay(provider, l10n),
                      const Spacer(flex: 1),
                      // ローディングインジケーター
                      _buildLoadingIndicator(),
                      const SizedBox(height: 32),
                      // 広告準備中のメッセージ
                      _buildAdPreparingMessage(l10n),
                      const Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// お題を大きく目立つように表示
  Widget _buildThemeDisplay(GameProvider provider, AppLocalizations l10n) {
    final themeTitle = provider.currentTheme?.getLocalizedTitle(l10n) ?? '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.neonPink.withValues(alpha: 0.2),
            AppColors.electricPurple.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.neonPink,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonPink.withValues(alpha: 0.4),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // ラベル
          Text(
            l10n.theme,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.mutedGray,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 16),
          // お題タイトル（大きく）
          NeonText(
            text: themeTitle,
            fontSize: 42,
            animate: !widget.disableAnimations,
          ),
          const SizedBox(height: 20),
          // 説明文
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.expressionDescription,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.warmWhite.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ローディングインジケーター
  Widget _buildLoadingIndicator() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final scale = 1.0 + 0.1 * _pulseController.value;
        final opacity = 0.6 + 0.4 * _pulseController.value;

        return Transform.scale(
          scale: scale,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.neonPink.withValues(alpha: opacity),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neonPink.withValues(alpha: opacity * 0.5),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.neonPink.withValues(alpha: opacity),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 広告準備中のメッセージ
  Widget _buildAdPreparingMessage(AppLocalizations l10n) {
    return Column(
      children: [
        // タイトル
        Text(
          l10n.adPreparingTitle,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.warmWhite,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        // メッセージ
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.electricPurple.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.electricPurple.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                l10n.adPreparingMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.warmWhite.withValues(alpha: 0.9),
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 12),
              // 話し合おうというメッセージ
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.softGold.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.softGold.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble_outline,
                      size: 18,
                      color: AppColors.softGold,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.discussNow,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.softGold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
