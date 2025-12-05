# Project Structure

## Organization Philosophy

Flutter標準のディレクトリ構成に従い、機能別にファイルを整理。シンプルなアプリのため、過度な階層化は避ける。

## Directory Patterns

### ソースコード (`lib/`)
**Location**: `/lib/`
**Purpose**: Dartソースコード全て
**Structure**:
- `main.dart` - アプリエントリーポイント
- `screens/` - 各画面のウィジェット
- `widgets/` - 再利用可能なUIコンポーネント
- `constants/` - お題データ、カラー定義などの定数
- `models/` - データモデル（Player、Gameなど）
- `utils/` - ユーティリティ関数

### プラットフォーム設定
**Locations**: `/android/`, `/ios/`, `/web/`, `/macos/`, `/linux/`, `/windows/`
**Purpose**: 各プラットフォーム固有の設定・ネイティブコード
**Note**: 通常は自動生成、必要時のみ編集

### テスト (`test/`)
**Location**: `/test/`
**Purpose**: 単体テスト・ウィジェットテスト
**Pattern**: `*_test.dart`

### アセット
**Location**: `/assets/` (作成時)
**Purpose**: 画像、フォント、その他リソース
**Note**: `pubspec.yaml`で登録が必要

## Naming Conventions

- **Files**: snake_case（例: `player_card.dart`）
- **Classes**: PascalCase（例: `PlayerCard`）
- **Variables/Functions**: camelCase（例: `playerName`）
- **Constants**: camelCaseまたはSCREAMING_SNAKE_CASE

## Import Organization

```dart
// Dart標準ライブラリ
import 'dart:math';

// Flutterパッケージ
import 'package:flutter/material.dart';

// 外部パッケージ
import 'package:google_fonts/google_fonts.dart';

// プロジェクト内
import 'package:pink_ito/constants/themes.dart';
import 'package:pink_ito/screens/home_screen.dart';
```

**Path Aliases**:
- `package:pink_ito/` - `/lib/`へのマッピング

## Code Organization Principles

- 1画面 = 1ファイル（`screens/`内）
- 再利用コンポーネントは`widgets/`に分離
- ビジネスロジックとUIは適度に分離
- 定数はハードコードせず`constants/`で一元管理

---
_Document patterns, not file trees. New files following patterns shouldn't require updates_
