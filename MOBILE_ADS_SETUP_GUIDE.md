# Flutter モバイル広告（Google AdMob）設定ガイド

このドキュメントは、FlutterアプリにGoogle AdMob広告を実装するための完全な設計・設定ガイドです。

---

## 📋 目次

1. [概要](#概要)
2. [事前準備](#事前準備)
3. [パッケージのインストール](#パッケージのインストール)
4. [AdMobアカウント設定](#admobアカウント設定)
5. [iOS設定](#ios設定)
6. [Android設定](#android設定)
7. [Flutter実装](#flutter実装)
8. [画面への配置](#画面への配置)
9. [テストと本番の切り替え](#テストと本番の切り替え)
10. [トラブルシューティング](#トラブルシューティング)

---

## 概要

### 使用パッケージ

| パッケージ | 用途 | バージョン |
|-----------|------|-----------|
| `google_mobile_ads` | AdMob広告SDK | ^6.0.0 |
| `app_tracking_transparency` | iOS ATT対応 | ^2.0.6+1 |

### 対応広告タイプ

- ✅ **バナー広告** - 画面下部に常時表示
- ✅ **インタースティシャル広告** - 画面遷移時に全画面表示（オプション）
- ⬜ リワード広告（未実装）

---

## 事前準備

### 1. Google AdMobアカウント作成

1. [AdMob](https://admob.google.com/) にアクセス
2. Googleアカウントでログイン
3. AdMobアカウントを作成

### 2. アプリの登録

1. AdMobダッシュボード → **アプリ** → **アプリを追加**
2. プラットフォーム選択（iOS / Android）
3. アプリ名を入力
4. **アプリID** を取得（後で使用）

### 3. 広告ユニットの作成

1. 登録したアプリを選択
2. **広告ユニット** → **広告ユニットを追加**
3. **バナー** を選択
4. 広告ユニット名を入力
5. **広告ユニットID** を取得（後で使用）

---

## パッケージのインストール

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Google Mobile Ads SDK
  google_mobile_ads: ^6.0.0
  
  # iOS App Tracking Transparency（ATT）対応
  app_tracking_transparency: ^2.0.6+1
```

インストール：

```bash
flutter pub get
```

---

## AdMobアカウント設定

### 取得すべきID一覧

| ID種類 | 用途 | 形式例 |
|--------|------|--------|
| **アプリID（iOS）** | Info.plist設定 | `ca-app-pub-XXXXXXXX~YYYYYYYY` |
| **アプリID（Android）** | AndroidManifest設定 | `ca-app-pub-XXXXXXXX~YYYYYYYY` |
| **広告ユニットID** | 広告表示用 | `ca-app-pub-XXXXXXXX/ZZZZZZZZ` |

### テスト用ID（開発時に使用）

Google公式のテスト用IDを使用することで、開発中に無効なトラフィックを発生させずにテストできます。

| 種類 | iOS | Android |
|------|-----|---------|
| **アプリID** | `ca-app-pub-3940256099942544~1458002511` | `ca-app-pub-3940256099942544~3347511713` |
| **固定バナー広告** | `ca-app-pub-3940256099942544/2934735716` | `ca-app-pub-3940256099942544/6300978111` |
| **アダプティブバナー広告** ⭐ | `ca-app-pub-3940256099942544/2435281174` | `ca-app-pub-3940256099942544/9214589741` |
| **インタースティシャル広告** | `ca-app-pub-3940256099942544/4411468910` | `ca-app-pub-3940256099942544/1033173712` |

> ⚠️ **注意**: iPad対応には**アダプティブバナー広告**のテストIDを使用してください。固定バナー用のIDではiPadで広告が表示されない場合があります。

---

## iOS設定

### ios/Runner/Info.plist

以下のキーを `<dict>` 内に追加：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- 既存の設定... -->
    
    <!-- ========== AdMob設定 ========== -->
    
    <!-- AdMob アプリID -->
    <key>GADApplicationIdentifier</key>
    <string>ca-app-pub-XXXXXXXX~YYYYYYYY</string>
    
    <!-- ATT（App Tracking Transparency）説明文 -->
    <key>NSUserTrackingUsageDescription</key>
    <string>より関連性の高い広告を表示するために、デバイス識別子を使用します。</string>
    
    <!-- SKAdNetwork設定（iOS 14以降の広告計測用） -->
    <key>SKAdNetworkItems</key>
    <array>
        <dict>
            <key>SKAdNetworkIdentifier</key>
            <string>cstr6suwn9.skadnetwork</string>
        </dict>
        <!-- 必要に応じて追加のSKAdNetworkIdentifierを追加 -->
    </array>
    
    <!-- 既存の設定... -->
</dict>
</plist>
```

### ATT説明文のローカライズ（多言語対応）

`ios/Runner/` に言語別の `.lproj` フォルダを作成：

**ios/Runner/ja.lproj/InfoPlist.strings:**
```
NSUserTrackingUsageDescription = "より関連性の高い広告を表示するために、デバイス識別子を使用します。";
```

**ios/Runner/en.lproj/InfoPlist.strings:**
```
NSUserTrackingUsageDescription = "We use device identifiers to show you more relevant ads.";
```

**ios/Runner/zh-Hans.lproj/InfoPlist.strings:**
```
NSUserTrackingUsageDescription = "我们使用设备标识符来向您展示更相关的广告。";
```

---

## Android設定

### android/app/src/main/AndroidManifest.xml

`<application>` タグ内に以下を追加：

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="your_app_name"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <!-- ========== AdMob設定 ========== -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-XXXXXXXX~YYYYYYYY" />
        
        <!-- 既存のactivity設定... -->
        
    </application>
</manifest>
```

### android/app/build.gradle.kts（必要に応じて）

minSdkVersionが21以上であることを確認：

```kotlin
android {
    defaultConfig {
        minSdk = 21  // 21以上必須
    }
}
```

---

## Flutter実装

### 1. main.dart - 初期化

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

void main() async {
  // Flutterバインディングの初期化
  WidgetsFlutterBinding.ensureInitialized();

  // AdMob SDKの初期化
  await MobileAds.instance.initialize();

  // iOS ATTダイアログの表示
  await _requestTrackingAuthorization();

  runApp(const MyApp());
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
```

### 2. lib/widgets/ad_banner.dart - バナー広告ウィジェット

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// バナー広告を表示する再利用可能なウィジェット
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  /// 広告ユニットIDを取得
  /// 
  /// 本番環境では実際のIDに置き換えること
  static String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      // Android用広告ユニットID
      // テスト用: 'ca-app-pub-3940256099942544/6300978111'
      return 'ca-app-pub-XXXXXXXX/ZZZZZZZZ';  // ← 本番ID
    } else if (Platform.isIOS) {
      // iOS用広告ユニットID
      // テスト用: 'ca-app-pub-3940256099942544/2934735716'
      return 'ca-app-pub-XXXXXXXX/ZZZZZZZZ';  // ← 本番ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  /// バナー広告をロード
  void _loadBanner() {
    final BannerAd banner = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,  // 320x50 の標準バナー
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
      color: Colors.white,
      child: SafeArea(
        top: false,  // 上部のセーフエリアは無視
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
      color: Colors.grey.shade100,
      child: const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
        ),
      ),
    );
  }
}
```

### 3. インタースティシャル広告（オプション）

画面遷移時に全画面広告を表示する場合：

```dart
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// インタースティシャル広告を管理するクラス
class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;

  static String get _adUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-XXXXXXXX/ZZZZZZZZ';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-XXXXXXXX/ZZZZZZZZ';
    }
    throw UnsupportedError('Unsupported platform');
  }

  /// 広告をロード
  void loadAd() {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdReady = true;
          
          // フルスクリーンコールバックを設定
          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isAdReady = false;
              loadAd();  // 次の広告をプリロード
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isAdReady = false;
              loadAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isAdReady = false;
        },
      ),
    );
  }

  /// 広告を表示
  void showAd() {
    if (_isAdReady && _interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  /// リソースを解放
  void dispose() {
    _interstitialAd?.dispose();
  }
}
```

---

## 画面への配置

### パターン1: bottomNavigationBar に配置（推奨）

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: Center(child: Text('Content')),
      
      // 画面下部に常時表示
      bottomNavigationBar: const AdBanner(),
    );
  }
}
```

### パターン2: Column の最下部に配置

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(child: Text('Content')),
          ),
          
          // 最下部に配置
          const AdBanner(),
        ],
      ),
    );
  }
}
```

### パターン3: Stack で重ねて配置

```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // メインコンテンツ
          Center(child: Text('Content')),
          
          // 下部に固定
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: const AdBanner(),
          ),
        ],
      ),
    );
  }
}
```

---

## テストと本番の切り替え

### 環境別ID管理の推奨パターン

```dart
import 'package:flutter/foundation.dart';
import 'dart:io';

class AdConfig {
  // 本番用アプリID
  static const String _prodAppIdIOS = 'ca-app-pub-XXXXXXXX~YYYYYYYY';
  static const String _prodAppIdAndroid = 'ca-app-pub-XXXXXXXX~YYYYYYYY';
  
  // 本番用広告ユニットID
  static const String _prodBannerIdIOS = 'ca-app-pub-XXXXXXXX/ZZZZZZZZ';
  static const String _prodBannerIdAndroid = 'ca-app-pub-XXXXXXXX/ZZZZZZZZ';
  
  // テスト用ID（Google公式）
  static const String _testAppIdIOS = 'ca-app-pub-3940256099942544~1458002511';
  static const String _testAppIdAndroid = 'ca-app-pub-3940256099942544~3347511713';
  static const String _testBannerIdIOS = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testBannerIdAndroid = 'ca-app-pub-3940256099942544/6300978111';

  /// バナー広告ユニットIDを取得
  static String get bannerAdUnitId {
    // デバッグモードではテスト用IDを使用
    if (kDebugMode) {
      return Platform.isIOS ? _testBannerIdIOS : _testBannerIdAndroid;
    }
    // リリースモードでは本番IDを使用
    return Platform.isIOS ? _prodBannerIdIOS : _prodBannerIdAndroid;
  }
}
```

---

## トラブルシューティング

### ⚠️ iPad対応の重要な注意事項

iPadで広告が表示されない問題は、App Storeレビューでリジェクトされる原因になります。以下の点に注意してください。

#### 問題: iPadで「No ad to show」エラーが発生する

**原因**: 固定サイズのバナー（`AdSize.banner` = 320x50）はiPadの画面幅に最適化されておらず、広告在庫がない場合がある

**解決策**: **アダプティブバナー**を使用する

```dart
// ❌ 固定サイズ（iPadで問題が発生する可能性）
final BannerAd banner = BannerAd(
  adUnitId: adUnitId,
  size: AdSize.banner,  // 320x50 固定
  // ...
);

// ✅ アダプティブバナー（iPhone/iPad両対応）
final double screenWidth = MediaQuery.of(context).size.width;
final int adWidth = screenWidth.truncate();
final AdSize? adaptiveSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(adWidth);

final BannerAd banner = BannerAd(
  adUnitId: adUnitId,
  size: adaptiveSize!,  // デバイスに最適化されたサイズ
  // ...
);
```

#### アダプティブバナー用テストID

**重要**: アダプティブバナーには**専用のテストID**が必要です。固定バナー用のテストIDでは動作しません。

| 種類 | iOS | Android |
|------|-----|---------|
| **固定バナー** | `ca-app-pub-3940256099942544/2934735716` | `ca-app-pub-3940256099942544/6300978111` |
| **アダプティブバナー** | `ca-app-pub-3940256099942544/2435281174` | `ca-app-pub-3940256099942544/9214589741` |

#### 広告ロード失敗時のエラーハンドリング

広告がロードできない場合に、ローディングスピナーが永遠に表示されるとユーザー体験が悪化し、App Storeレビューでリジェクトされます。

```dart
class _AdBannerState extends State<AdBanner> {
  bool _isLoaded = false;
  bool _hasError = false;  // ← エラー状態を追跡
  Timer? _timeoutTimer;

  void _loadBanner() {
    // タイムアウトを設定（15秒）
    _timeoutTimer = Timer(const Duration(seconds: 15), () {
      if (!_isLoaded && mounted) {
        setState(() => _hasError = true);
      }
    });

    // ... 広告ロード処理
  }

  @override
  Widget build(BuildContext context) {
    // エラー時は何も表示しない（スピナーを隠す）
    if (_hasError) {
      return const SizedBox.shrink();
    }
    // ...
  }
}
```

#### iPad対応チェックリスト

- [ ] アダプティブバナーを使用している
- [ ] アダプティブバナー用のテストIDを使用している
- [ ] 広告ロード失敗時のエラーハンドリングがある
- [ ] タイムアウト処理がある（15秒推奨）
- [ ] iPadシミュレータで動作確認済み

---

### よくあるエラーと解決方法

#### 1. `MobileAds.instance.initialize()` でクラッシュ

**原因**: Info.plist または AndroidManifest.xml にアプリIDが設定されていない

**解決策**:
- iOS: `GADApplicationIdentifier` キーを確認
- Android: `com.google.android.gms.ads.APPLICATION_ID` メタデータを確認

#### 2. 広告が表示されない（テスト環境）

**原因**: テスト用IDが正しく設定されていない

**解決策**: Google公式のテスト用IDを使用しているか確認

#### 3. ATTダイアログが表示されない（iOS）

**原因**: `NSUserTrackingUsageDescription` が設定されていない

**解決策**: Info.plistに説明文を追加

#### 4. 広告ロード失敗（本番環境）

**確認事項**:
1. AdMobアカウントが有効か
2. アプリがAdMobで承認されているか
3. 広告ユニットが有効か
4. ネットワーク接続があるか

#### 5. ビルドエラー（iOS）

```bash
# CocoaPodsのキャッシュをクリア
cd ios
pod deintegrate
pod cache clean --all
pod install
```

#### 6. ビルドエラー（Android）

```bash
# Gradleキャッシュをクリア
cd android
./gradlew clean
```

---

## チェックリスト

### リリース前確認

- [ ] AdMobでアプリが承認済み
- [ ] 本番用アプリIDに置き換え済み
- [ ] 本番用広告ユニットIDに置き換え済み
- [ ] ATT説明文が適切（iOS）
- [ ] テストデバイスで広告表示確認
- [ ] 実機で広告表示確認

### Info.plist（iOS）

- [ ] `GADApplicationIdentifier` 設定済み
- [ ] `NSUserTrackingUsageDescription` 設定済み
- [ ] `SKAdNetworkItems` 設定済み（推奨）

### AndroidManifest.xml

- [ ] `com.google.android.gms.ads.APPLICATION_ID` 設定済み

---

## 参考リンク

- [Google Mobile Ads Flutter Plugin](https://pub.dev/packages/google_mobile_ads)
- [AdMob公式ドキュメント](https://developers.google.com/admob)
- [App Tracking Transparency](https://pub.dev/packages/app_tracking_transparency)
- [AdMobポリシー](https://support.google.com/admob/answer/6128543)

---

## 更新履歴

| 日付 | バージョン | 内容 |
|------|-----------|------|
| 2025-12-05 | 1.0.0 | 初版作成 |
| 2025-12-09 | 1.1.0 | iPad対応の注意事項を追加（アダプティブバナー、エラーハンドリング） |

