# Technology Stack

## Architecture

クライアント完結型のモバイルアプリ。バックエンド不要、全てのゲームロジックとデータはアプリ内で管理。

## Core Technologies

- **Language**: Dart 3.10+
- **Framework**: Flutter
- **Platforms**: iOS / Android（マルチプラットフォーム）

## Key Libraries

- **flutter_lints**: 静的解析・コード品質
- **cupertino_icons**: iOSスタイルアイコン
- **flutter_animate** (推奨): アニメーション実装
- **google_fonts** (推奨): カスタムフォント

## Development Standards

### Type Safety
- Dart null safety有効
- 明示的な型アノテーション推奨

### Code Quality
- `flutter_lints`パッケージによるLint
- `flutter analyze`でのエラーチェック

### Testing
- `flutter_test`による単体テスト
- `flutter test`コマンドで実行

## Development Environment

### Required Tools
- Flutter SDK 3.10+
- Dart SDK 3.10+
- Xcode（iOS向け）
- Android Studio（Android向け）

### Common Commands
```bash
# Dev: flutter run
# Build: flutter build apk / flutter build ios
# Test: flutter test
# Analyze: flutter analyze
```

## Key Technical Decisions

- **オフライン設計**: ネットワーク依存なし、ローカルメモリでゲーム状態管理
- **Material Design**: Flutterの標準ウィジェットベース、カスタムテーマでネオンピンク表現
- **StatefulWidget**: ゲーム状態管理はFlutter標準のsetStateパターン
- **定数配列**: お題データはソースコード内の定数として管理

---
_Document standards and patterns, not every dependency_
