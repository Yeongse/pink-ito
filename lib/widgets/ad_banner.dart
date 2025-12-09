import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants/app_colors.dart';
import '../services/ad_config.dart';

/// バナー広告を表示する再利用可能なウィジェット
/// アダプティブバナーを使用してiPhone/iPad両方に対応
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _hasError = false;
  Timer? _timeoutTimer;
  bool _isLoadingStarted = false;

  /// 広告ロードのタイムアウト時間（秒）
  static const int _loadTimeoutSeconds = 15;

  /// アダプティブバナーの高さ（デフォルト値）
  static const double _defaultBannerHeight = 60.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // contextが必要なので、didChangeDependenciesでロード
    if (!_isLoadingStarted) {
      _isLoadingStarted = true;
      _loadAdaptiveBanner();
    }
  }

  /// アダプティブバナー広告をロード
  /// デバイスの画面幅に最適化されたサイズの広告を取得
  Future<void> _loadAdaptiveBanner() async {
    // 画面幅を取得してアダプティブバナーサイズを計算
    final double screenWidth = MediaQuery.of(context).size.width;
    final int adWidth = screenWidth.truncate();

    // アダプティブバナーサイズを取得（iPhone/iPadに最適化）
    final AdSize? adaptiveSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(adWidth);

    if (adaptiveSize == null) {
      debugPrint('Unable to get adaptive banner size');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
      return;
    }

    debugPrint(
      'Adaptive banner size: ${adaptiveSize.width}x${adaptiveSize.height}',
    );

    // タイムアウトタイマーを開始
    _timeoutTimer = Timer(const Duration(seconds: _loadTimeoutSeconds), () {
      if (!mounted) return;
      if (!_isLoaded) {
        debugPrint('Banner ad load timeout after $_loadTimeoutSeconds seconds');
        setState(() {
          _hasError = true;
        });
      }
    });

    final BannerAd banner = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: adaptiveSize, // アダプティブバナーサイズを使用
      request: const AdRequest(),
      listener: BannerAdListener(
        // 広告ロード成功時
        onAdLoaded: (ad) {
          _timeoutTimer?.cancel();
          debugPrint('Banner ad loaded successfully: ${ad.responseInfo}');
          if (!mounted) return;
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
            _hasError = false;
          });
        },
        // 広告ロード失敗時
        onAdFailedToLoad: (ad, error) {
          _timeoutTimer?.cancel();
          debugPrint(
            'Banner ad failed to load: ${error.message} (code: ${error.code})',
          );
          ad.dispose();
          if (!mounted) return;
          setState(() {
            _hasError = true;
          });
        },
        // 広告クリック時
        onAdClicked: (ad) {
          debugPrint('Banner ad clicked');
        },
        // 広告インプレッション時
        onAdImpression: (ad) {
          debugPrint('Banner ad impression');
        },
      ),
    );

    banner.load();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // エラー発生時またはタイムアウト時は何も表示しない
    if (_hasError) {
      return const SizedBox.shrink();
    }

    // 広告がロードされた場合はそのサイズを使用
    final double bannerHeight = _isLoaded && _bannerAd != null
        ? _bannerAd!.size.height.toDouble()
        : _defaultBannerHeight;

    return Container(
      width: double.infinity,
      color: AppColors.darkBg,
      child: SafeArea(
        top: false, // 上部のセーフエリアは無視
        child: SizedBox(
          width: double.infinity,
          height: bannerHeight,
          child: _isLoaded && _bannerAd != null
              ? AdWidget(ad: _bannerAd!)
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  /// 広告ロード中のプレースホルダー
  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.darkSurface,
      child: Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.mutedGray),
          ),
        ),
      ),
    );
  }
}
