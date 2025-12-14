import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

/// インタースティシャル広告を管理するシングルトンクラス
class InterstitialAdManager {
  static final InterstitialAdManager _instance = InterstitialAdManager._internal();
  factory InterstitialAdManager() => _instance;
  InterstitialAdManager._internal();

  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  bool get isAdReady => _isAdReady;

  /// 広告をロード
  void loadAd() {
    if (_isAdReady) return;

    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdReady = true;

          // フルスクリーンコールバックを設定
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              _isAdReady = false;
              loadAd(); // 次の広告をプリロード
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Interstitial ad failed to show: ${error.message}');
              ad.dispose();
              _interstitialAd = null;
              _isAdReady = false;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed to load: ${error.message}');
          _isAdReady = false;
        },
      ),
    );
  }

  /// 広告を表示
  Future<void> showAd() async {
    if (_isAdReady && _interstitialAd != null) {
      await _interstitialAd!.show();
    } else {
      debugPrint('Interstitial ad not ready');
      // 広告が準備できていない場合は次回のためにロード
      loadAd();
    }
  }

  /// リソースを解放
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isAdReady = false;
  }
}
