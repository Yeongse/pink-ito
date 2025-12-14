import 'dart:io';

import 'package:flutter/foundation.dart';

class AdConfig {
  // 本番用広告ユニットID
  static const String _prodBannerIdIOS =
      'ca-app-pub-6257323478670896/1963481606';
  static const String _prodBannerIdAndroid =
      'ca-app-pub-6257323478670896/1963481606';
  static const String _prodInterstitialIdIOS =
      'ca-app-pub-6257323478670896/8448998909';
  static const String _prodInterstitialIdAndroid =
      'ca-app-pub-6257323478670896/8448998909';

  // テスト用ID（Google公式）
  // アダプティブバナー用のテストID（iPhone/iPad両対応）
  static const String _testBannerIdIOS =
      'ca-app-pub-3940256099942544/2435281174';
  static const String _testBannerIdAndroid =
      'ca-app-pub-3940256099942544/9214589741';
  static const String _testInterstitialIdIOS =
      'ca-app-pub-3940256099942544/4411468910';
  static const String _testInterstitialIdAndroid =
      'ca-app-pub-3940256099942544/1033173712';

  /// バナー広告ユニットIDを取得
  static String get bannerAdUnitId {
    // デバッグモードではテスト用IDを使用
    if (kDebugMode) {
      return Platform.isIOS ? _testBannerIdIOS : _testBannerIdAndroid;
    }
    // リリースモードでは本番IDを使用
    return Platform.isIOS ? _prodBannerIdIOS : _prodBannerIdAndroid;
  }

  /// インタースティシャル広告ユニットIDを取得
  static String get interstitialAdUnitId {
    // デバッグモードではテスト用IDを使用
    if (kDebugMode) {
      return Platform.isIOS
          ? _testInterstitialIdIOS
          : _testInterstitialIdAndroid;
    }
    // リリースモードでは本番IDを使用
    return Platform.isIOS ? _prodInterstitialIdIOS : _prodInterstitialIdAndroid;
  }
}
