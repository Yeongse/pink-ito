import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constants/app_colors.dart';
import '../services/ad_config.dart';

/// バナー広告を表示する再利用可能なウィジェット
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  /// バナー広告をロード
  void _loadBanner() {
    final BannerAd banner = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner, // 320x50 の標準バナー
      request: const AdRequest(),
      listener: BannerAdListener(
        // 広告ロード成功時
        onAdLoaded: (ad) {
          if (!mounted) return;
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        // 広告ロード失敗時
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed to load: ${error.message}');
          ad.dispose();
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
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 標準バナーサイズ（320x50）
    const double bannerWidth = 320.0;
    const double bannerHeight = 50.0;

    return Container(
      width: double.infinity,
      color: AppColors.darkBg,
      child: SafeArea(
        top: false, // 上部のセーフエリアは無視
        child: Container(
          width: _isLoaded && _bannerAd != null
              ? _bannerAd!.size.width.toDouble()
              : bannerWidth,
          height: _isLoaded && _bannerAd != null
              ? _bannerAd!.size.height.toDouble()
              : bannerHeight,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: _isLoaded && _bannerAd != null
              ? Center(child: AdWidget(ad: _bannerAd!))
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
