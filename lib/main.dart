import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'constants/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/game_provider.dart';
import 'screens/title_screen.dart';
import 'screens/player_setup_screen.dart';
import 'screens/theme_display_screen.dart';
import 'screens/number_distribution_screen.dart';
import 'screens/expression_time_screen.dart';
import 'screens/reorder_screen.dart';
import 'screens/result_screen.dart';
import 'screens/how_to_play_screen.dart';
import 'services/interstitial_ad_manager.dart';
import 'widgets/fade_slide_route.dart';

void main() async {
  // Flutterバインディングの初期化
  WidgetsFlutterBinding.ensureInitialized();

  // AdMob SDKの初期化
  await MobileAds.instance.initialize();

  // テストデバイスの設定（シミュレータ・実機テスト用）
  // これにより、テスト広告が確実に表示される
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      // iOSシミュレータは自動的にテストデバイスとして認識される
      // 実機テスト時はコンソールに出力されるデバイスIDを追加
      testDeviceIds: <String>[],
    ),
  );

  // iOS ATTダイアログの表示
  await _requestTrackingAuthorization();

  // インタースティシャル広告をプリロード
  InterstitialAdManager().loadAd();

  runApp(const PinkItoApp());
}

/// iOS ATT（App Tracking Transparency）の許可リクエスト
Future<void> _requestTrackingAuthorization() async {
  try {
    // 現在のトラッキング許可状態を取得
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;

    // まだ決定されていない場合のみダイアログを表示
    if (status == TrackingStatus.notDetermined) {
      // UIが完全に読み込まれるまで少し待つ
      await Future.delayed(const Duration(milliseconds: 200));

      // ATTダイアログを表示
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  } catch (e) {
    // エラーが発生しても広告は表示可能（パーソナライズされない可能性あり）
    debugPrint('ATT request failed: $e');
  }
}

class PinkItoApp extends StatelessWidget {
  const PinkItoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider(),
      child: MaterialApp(
        title: 'Pink Ito',
        theme: AppTheme.darkTheme,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja'), Locale('en'), Locale('ko')],
        initialRoute: '/',
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return FadeSlideRoute(
          page: TitleScreen(
            onStartPressed: (context) {
              Navigator.of(context).pushNamed('/player-setup');
            },
            onHowToPlayPressed: (context) {
              Navigator.of(context).pushNamed('/how-to-play');
            },
          ),
        );

      case '/how-to-play':
        return FadeSlideRoute(page: const HowToPlayScreen());

      case '/player-setup':
        return FadeSlideRoute(
          page: PlayerSetupScreen(
            onGameStart: (context) {
              Navigator.of(context).pushNamed('/theme-display');
            },
          ),
        );

      case '/theme-display':
        return FadeSlideRoute(
          page: ThemeDisplayScreen(
            onDistributeNumbers: (context) {
              Navigator.of(context).pushNamed('/number-distribution');
            },
          ),
        );

      case '/number-distribution':
        return FadeSlideRoute(
          page: NumberDistributionScreen(
            onAllPlayersComplete: (context) {
              // Set phase before navigation to prevent flash of first player's screen
              context.read<GameProvider>().goToExpressionTime();
              Navigator.of(context).pushNamed('/expression-time');
            },
          ),
        );

      case '/expression-time':
        return FadeSlideRoute(
          page: ExpressionTimeScreen(
            onGoToReorder: (context) {
              Navigator.of(context).pushNamed('/reorder');
            },
          ),
        );

      case '/reorder':
        return FadeSlideRoute(
          page: ReorderScreen(
            onSubmitReorder: (context) {
              Navigator.of(context).pushNamed('/result');
            },
          ),
        );

      case '/result':
        return FadeSlideRoute(
          page: ResultScreen(
            onPlayAgain: (context) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/theme-display',
                (route) => route.settings.name == '/',
              );
            },
            onChangeSettings: (context) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/player-setup',
                (route) => route.settings.name == '/',
              );
            },
            onReset: (context) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        );

      default:
        return FadeSlideRoute(
          page: TitleScreen(
            onStartPressed: (context) {
              Navigator.of(context).pushNamed('/player-setup');
            },
          ),
        );
    }
  }
}
