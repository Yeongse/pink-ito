import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/animated_background.dart';
import '../widgets/neon_text.dart';

class HowToPlayScreen extends StatelessWidget {
  final bool disableAnimations;

  const HowToPlayScreen({
    super.key,
    this.disableAnimations = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: AnimatedBackground(
          disableAnimations: disableAnimations,
          child: Column(
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.darkSurface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.neonPink.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: AppColors.neonPink,
                          size: 24,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const NeonText(
                      text: 'How To Play',
                      fontSize: 24,
                      animate: false,
                    ),
                    const Spacer(),
                    const SizedBox(width: 40), // Balance the back button
                  ],
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    const SizedBox(height: 8),
                    _buildIntroSection(),
                    const SizedBox(height: 24),
                    _buildStepSection(
                      stepNumber: 1,
                      title: 'お題を確認',
                      description: 'ランダムに選ばれたお題が表示されます。\n例：「怖いもの」「嬉しいこと」など',
                      icon: Icons.topic,
                    ),
                    const SizedBox(height: 16),
                    _buildStepSection(
                      stepNumber: 2,
                      title: '数字を受け取る',
                      description: '各プレイヤーに1〜100の数字がランダムに配られます。\n自分の数字は他の人には見せないでね！',
                      icon: Icons.pin,
                    ),
                    const SizedBox(height: 16),
                    _buildStepSection(
                      stepNumber: 3,
                      title: '表現タイム',
                      description: 'お題に沿って、自分の数字を言葉や身振りで表現しよう！\n数字そのものは言っちゃダメ！\n\n例：お題「怖いもの」で数字が80なら\n「死」「戦争」など大きめのものを表現',
                      icon: Icons.chat_bubble_outline,
                    ),
                    const SizedBox(height: 16),
                    _buildStepSection(
                      stepNumber: 4,
                      title: '並び替え',
                      description: '全員の表現を聞いたら、数字が小さい順に並べよう！\n相談してもOK！',
                      icon: Icons.sort,
                    ),
                    const SizedBox(height: 16),
                    _buildStepSection(
                      stepNumber: 5,
                      title: '答え合わせ',
                      description: '並べた順番が正しいかチェック！\n全員正解でクリア！',
                      icon: Icons.check_circle_outline,
                    ),
                    const SizedBox(height: 24),
                    _buildTipsSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.neonPink.withValues(alpha: 0.15),
            AppColors.electricPurple.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.neonPink.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Itoとは？',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.neonPink,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '価値観のズレを楽しむ協力パーティーゲーム！\n\nお題に対して自分の数字を「言葉」で表現し、\nみんなで小さい順に並べることを目指します。',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.warmWhite,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepSection({
    required int stepNumber,
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.electricPurple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Step number badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.neonPink.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.neonPink,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.neonPink,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      size: 18,
                      color: AppColors.electricPurple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warmWhite,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedGray,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.softGold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.softGold.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lightbulb_outline,
                size: 22,
                color: AppColors.softGold,
              ),
              const SizedBox(width: 8),
              Text(
                'コツ',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.softGold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTipItem('数字の大小は相対的！みんなの価値観を想像しよう'),
          const SizedBox(height: 10),
          _buildTipItem('具体的な例を出すと伝わりやすい'),
          const SizedBox(height: 10),
          _buildTipItem('曖昧な表現も面白い！解釈の違いを楽しもう'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.softGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.warmWhite,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
