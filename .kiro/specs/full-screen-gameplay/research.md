# Research & Design Decisions

---
**Purpose**: full-screen-gameplay フィーチャーのディスカバリー結果と設計決定の根拠を記録
---

## Summary
- **Feature**: `full-screen-gameplay`
- **Discovery Scope**: New Feature（Flutterアプリの全7画面を新規実装）
- **Key Findings**:
  - Flutterの状態管理は小〜中規模アプリにはProviderで十分、シンプルなゲームにはStatefulWidgetも有効
  - ReorderableListViewはFlutter標準で提供されており、ドラッグ&ドロップ実装に最適
  - flutter_animateパッケージで宣言的かつ統一されたアニメーションAPIを使用可能

## Research Log

### 状態管理アプローチの選定
- **Context**: オフライン完結型ゲームにおける適切な状態管理手法の調査
- **Sources Consulted**:
  - [Flutter State Management: Provider vs. Riverpod vs. BLoC](https://www.gigson.co/blog/flutter-state-management-provider-vs-riverpod-vs-bloc-explained)
  - [Master Flutter State Management 2025](https://www.boltuix.com/2025/09/master-flutter-state-management-2025.html)
- **Findings**:
  - Provider: 小〜中規模アプリに最適、学習コストが低い、Flutter公式推奨
  - Riverpod: 大規模アプリ向け、compile-time safety、ウィジェットツリー非依存
  - StatefulWidget: 最もシンプル、単一画面内の状態管理に適切
- **Implications**:
  - ステアリングでStatefulWidget+setStateパターンが推奨されている
  - ゲーム状態は画面遷移を跨ぐためProviderで管理が適切
  - GameProviderで全ゲーム状態を一元管理する設計を採用

### ドラッグ&ドロップ実装
- **Context**: 並び替え画面でのプレイヤーカード並び替え機能の実装方法
- **Sources Consulted**:
  - [ReorderableListView - Flutter API](https://api.flutter.dev/flutter/material/ReorderableListView-class.html)
  - [How to build a Drag and Drop list in Flutter](https://blog.stackademic.com/how-to-build-a-drag-and-drop-list-in-flutter-guide-to-reorderablelistview-002025c9baa0)
- **Findings**:
  - ReorderableListViewはFlutter標準で提供
  - モバイルではロングプレスで自動的にドラッグ開始
  - proxyDecoratorでドラッグ中の見た目をカスタマイズ可能
  - 各アイテムにユニークなKeyが必須
- **Implications**:
  - 外部パッケージ不要でドラッグ&ドロップ実装可能
  - proxyDecoratorでネオングロー効果を追加してドラッグ中の視覚フィードバックを強化

### アニメーション実装
- **Context**: ネオンエフェクト、画面遷移、マイクロインタラクションの実装方法
- **Sources Consulted**:
  - [flutter_animate package](https://pub.dev/packages/flutter_animate)
  - [Introduction to animations - Flutter](https://docs.flutter.dev/ui/animations)
- **Findings**:
  - flutter_animate: 宣言的API、fade/scale/slide/shimmer等のプリセット効果
  - 拡張メソッド`.animate()`でウィジェットに直接適用可能
  - `2.seconds`や`300.ms`のような直感的なDuration指定
  - ネオングロー効果はBoxShadowの重ね合わせで実現
- **Implications**:
  - flutter_animateを採用してボイラープレートを削減
  - カスタムネオングローウィジェットを共通コンポーネントとして作成

### 画面遷移パターン
- **Context**: 7画面間の遷移とルーティング設計
- **Findings**:
  - Flutter Navigator 2.0はオーバーキル、シンプルなNavigator.pushで十分
  - PageRouteBuilderでカスタム遷移アニメーション可能
  - ゲームフローは線形なので複雑なルーティングは不要
- **Implications**:
  - Named routesで各画面を定義
  - 共通の画面遷移アニメーション（フェード+スライド）をカスタムPageRouteで実装

## Architecture Pattern Evaluation

| Option | Description | Strengths | Risks / Limitations | Notes |
|--------|-------------|-----------|---------------------|-------|
| StatefulWidget Only | 各画面でsetStateを使用 | シンプル、学習コストゼロ | 画面間の状態共有が困難 | 単一画面には適切 |
| Provider + StatefulWidget | Providerで共有状態、画面内はStatefulWidget | 適度な複雑さ、公式推奨 | 小規模にはやや冗長 | **採用** |
| Riverpod | モダンな状態管理 | 型安全、テスタブル | 学習コスト、オーバーエンジニアリング | 将来の拡張時に検討 |

## Design Decisions

### Decision: 状態管理アーキテクチャ
- **Context**: ゲーム状態（プレイヤー、お題、数字、並び順）を画面間で共有する必要がある
- **Alternatives Considered**:
  1. StatefulWidgetのみ — 引数での状態受け渡し
  2. Provider — ChangeNotifierでリアクティブ状態管理
  3. InheritedWidget — 低レベル実装
- **Selected Approach**: Provider + ChangeNotifierパターン
- **Rationale**:
  - ステアリングのtech.mdでStatefulWidgetパターンが言及されているが、複数画面間の状態共有にはProviderが適切
  - 公式推奨で学習リソースが豊富
  - 過度な複雑さなく状態共有を実現
- **Trade-offs**: 初期セットアップのコードが若干増加するが、可読性とメンテナンス性が向上
- **Follow-up**: GameProviderクラスの詳細設計をdesign.mdで定義

### Decision: ドラッグ&ドロップ実装
- **Context**: 並び替え画面でプレイヤーカードを視覚的に並び替える
- **Alternatives Considered**:
  1. ReorderableListView（Flutter標準）
  2. flutter_reorderable_list（外部パッケージ）
  3. カスタムDraggable実装
- **Selected Approach**: ReorderableListView + proxyDecoratorカスタマイズ
- **Rationale**:
  - Flutter標準で追加依存なし
  - proxyDecoratorでドラッグ中のネオン効果をカスタマイズ可能
  - ロングプレス開始がモバイルUXに適合
- **Trade-offs**: 高度なカスタマイズには制限があるが、要件を満たすには十分
- **Follow-up**: PlayerCardウィジェットのドラッグ状態スタイリングを定義

### Decision: アニメーションライブラリ
- **Context**: ネオングロー、タイプライター効果、画面遷移などの多彩なアニメーション
- **Alternatives Considered**:
  1. Flutter標準AnimationController
  2. flutter_animate
  3. Rive/Lottie
- **Selected Approach**: flutter_animate + カスタムBoxShadowアニメーション
- **Rationale**:
  - 宣言的APIでボイラープレート削減
  - チェーン可能なエフェクトで複合アニメーション構築
  - ネオングローはBoxShadowで実現可能
- **Trade-offs**: 外部パッケージ依存が追加されるが、開発効率が大幅に向上
- **Follow-up**: 共通アニメーション設定（duration, curve）を定数化

## Risks & Mitigations
- **パフォーマンス（過度なアニメーション）** — RepaintBoundaryで分離、アニメーション数の制限
- **状態の不整合** — GameProviderで単一ソース管理、状態遷移の明確なルール定義
- **プラットフォーム差異** — Flutter標準ウィジェット中心で互換性確保、各プラットフォームでの動作確認

## References
- [Flutter State Management Guide 2025](https://www.boltuix.com/2025/09/master-flutter-state-management-2025.html)
- [ReorderableListView - Flutter API](https://api.flutter.dev/flutter/material/ReorderableListView-class.html)
- [flutter_animate - pub.dev](https://pub.dev/packages/flutter_animate)
- [Flutter Animation Tutorial](https://docs.flutter.dev/ui/animations/tutorial)
