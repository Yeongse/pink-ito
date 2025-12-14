# Requirements Document

## Introduction
本ドキュメントは「ピンク Ito」アプリケーションの全画面実装に関する要件を定義する。オフライン完結型のパーティゲームとして、2-10人のプレイヤーがゲームをプレイできるよう、タイトル画面からリザルト画面までの全7画面を実装する。

## Project Description (Input)
アプリケーションをプレイできるように, 全画面を揃えて

---

## Requirements

### Requirement 1: タイトル画面
**Objective:** As a プレイヤー, I want アプリ起動時にゲームのタイトル画面を見る, so that ゲームの雰囲気を感じてプレイを開始できる

#### Acceptance Criteria
1. When アプリが起動される, the TitleScreen shall ネオンサイン風の「ピンク Ito」ロゴを中央に表示する
2. When タイトル画面が表示される, the TitleScreen shall サブタイトル「大人の数字当てゲーム」を控えめに表示する
3. When タイトル画面が表示される, the TitleScreen shall 「スタート」ボタンをパルスアニメーション付きで表示する
4. When ユーザーが「スタート」ボタンをタップする, the TitleScreen shall プレイヤー設定画面に遷移する
5. While タイトル画面が表示されている, the TitleScreen shall ネオングローを2秒周期でゆっくり明滅させる

### Requirement 2: プレイヤー設定画面
**Objective:** As a プレイヤー, I want プレイヤー人数と名前を設定する, so that ゲームに参加するメンバーを登録できる

#### Acceptance Criteria
1. When プレイヤー設定画面が表示される, the PlayerSetupScreen shall 2-10人のプレイヤー数選択スライダーを表示する
2. When ユーザーがプレイヤー数を変更する, the PlayerSetupScreen shall 選択された人数分の名前入力フィールドを動的に表示する
3. When ユーザーが名前入力フィールドに入力する, the PlayerSetupScreen shall 入力完了行にチェックマークを表示する
4. While 全プレイヤーの名前が入力されていない, the PlayerSetupScreen shall 「ゲーム開始」ボタンを無効状態で表示する
5. When 全プレイヤーの名前が入力される, the PlayerSetupScreen shall 「ゲーム開始」ボタンを有効化する
6. When ユーザーが「ゲーム開始」ボタンをタップする, the PlayerSetupScreen shall お題表示画面に遷移する

### Requirement 3: お題表示画面
**Objective:** As a プレイヤー, I want ランダムな下ネタ系のお題を確認する, so that 全員でお題を共有してゲームを開始できる

#### Acceptance Criteria
1. When お題表示画面が表示される, the ThemeDisplayScreen shall 30個のお題プールからランダムに1つ選択して表示する
2. When お題が表示される, the ThemeDisplayScreen shall タイプライター効果で1文字ずつ（各50ms遅延）お題を出現させる
3. While セッション内で既に使用されたお題がある, the ThemeDisplayScreen shall 使用済みお題を除外して選択する
4. If 全30個のお題が使用済みになった場合, the ThemeDisplayScreen shall お題の使用履歴をリセットして再利用可能にする
5. When ユーザーが「数字を配る」ボタンをタップする, the ThemeDisplayScreen shall 数字配布画面に遷移する

### Requirement 4: 数字配布画面（ハンドオフ）
**Objective:** As a プレイヤー, I want 順番にスマホを回して自分の数字を確認する, so that 他のプレイヤーに数字を見られずに確認できる

#### Acceptance Criteria
1. When 数字配布が開始される, the NumberDistributionScreen shall 1-100の範囲でプレイヤー人数分の重複しない数字をランダム生成する
2. When プレイヤーへのハンドオフが必要な時, the NumberDistributionScreen shall 「{プレイヤー名}さんに渡してください」メッセージを表示する
3. When ハンドオフ画面でユーザーがタップする, the NumberDistributionScreen shall 該当プレイヤーの数字表示画面に遷移する
4. When 数字表示画面が表示される, the NumberDistributionScreen shall プレイヤー名と配布された数字を超大型（120px以上）で中央に表示する
5. While 数字が表示されている, the NumberDistributionScreen shall 数字にネオングロー効果を適用する
6. When ユーザーが「覚えたら次へ」ボタンをタップする, the NumberDistributionScreen shall 次のプレイヤーのハンドオフ画面に遷移する
7. When 全プレイヤーへの数字配布が完了する, the NumberDistributionScreen shall 表現タイム画面に遷移する

### Requirement 5: 表現タイム画面
**Objective:** As a プレイヤー, I want お題を確認しながら話し合いの時間を持つ, so that 自分の数字を言葉で表現して話し合える

#### Acceptance Criteria
1. When 表現タイム画面が表示される, the ExpressionTimeScreen shall 「楽しく話し合ってね」メッセージを中央に大きく表示する
2. When 表現タイム画面が表示される, the ExpressionTimeScreen shall 現在のお題を画面上部にリマインダーとして小さく表示する
3. While 表現タイム画面が表示されている, the ExpressionTimeScreen shall ゆっくり動くパーティクルまたは光の粒を装飾として表示する
4. When ユーザーが「並び替えへ」ボタンをタップする, the ExpressionTimeScreen shall 並び替え画面に遷移する

### Requirement 6: 並び替え画面
**Objective:** As a プレイヤー, I want 話し合いの結果を元にプレイヤーを順番に並べる, so that 数字が小さい順に正しく並べられる

#### Acceptance Criteria
1. When 並び替え画面が表示される, the ReorderScreen shall 「小さい順に並べてね」という説明テキストを表示する
2. When 並び替え画面が表示される, the ReorderScreen shall 全プレイヤーをドラッグ可能なカードリストとして表示する
3. When ユーザーがカードをロングプレスする, the ReorderScreen shall ドラッグモードを開始してカードを浮遊状態（シャドウ増加、スケール1.05）にする
4. While カードがドラッグ中, the ReorderScreen shall 他のカードが自動的にスペースを空けてドロップ可能位置をハイライト表示する
5. When ユーザーがカードをドロップする, the ReorderScreen shall カードを滑らかにスロットインさせる
6. When ユーザーが「答え合わせ」ボタンをタップする, the ReorderScreen shall リザルト画面に遷移する

### Requirement 7: リザルト画面
**Objective:** As a プレイヤー, I want 答え合わせの結果を確認する, so that ゲームの成功/失敗を知り次のプレイに進める

#### Acceptance Criteria
1. When リザルト画面が表示される, the ResultScreen shall 各プレイヤーの実際の数字を1.5秒間隔で順番に公開する
2. When プレイヤーの数字が公開される, the ResultScreen shall カードをフリップまたはスライドアニメーションで表示する
3. If プレイヤーの順番が正しい場合, the ResultScreen shall グリーンのハイライトとチェックマークを表示する
4. If プレイヤーの順番が間違っている場合, the ResultScreen shall レッドのハイライトと×マークを表示する
5. When 全プレイヤーが正しい順番に並んでいる場合, the ResultScreen shall 「SUCCESS!」テキストと紙吹雪アニメーションを表示する
6. When プレイヤーの順番に間違いがある場合, the ResultScreen shall 「残念...」テキストと正しい順番を表示する
7. When ユーザーが「もう一度遊ぶ」ボタンをタップする, the ResultScreen shall プレイヤー設定を維持したままお題表示画面に遷移する
8. When ユーザーが「最初から」ボタンをタップする, the ResultScreen shall タイトル画面に遷移する

### Requirement 8: 共通UI/UXデザイン
**Objective:** As a プレイヤー, I want 一貫したネオン×アダルトバー風のデザインを体験する, so that 洗練された大人のパーティゲームを楽しめる

#### Acceptance Criteria
1. The Application shall ダークモードベース（#0D0D0F, #1A1A1F）にネオンピンク（#FF2D7B）のアクセントを適用する
2. The Application shall 画面遷移時にフェード+スライドアニメーション（300-400ms）を適用する
3. When ボタンがタップされる, the Application shall スケールアニメーション（1.0→0.95→1.0）とリップル効果を適用する
4. The Application shall 最小タッチターゲットサイズ44×44pxを確保する
5. The Application shall Noto Sans JPをボディフォント、Bebas Neueを数字専用フォントとして使用する

### Requirement 9: お題データ管理
**Objective:** As a 開発者, I want お題データを定数として管理する, so that 簡単にお題を追加・編集できる

#### Acceptance Criteria
1. The Application shall 30個の下ネタ系お題を定数配列（lib/constants/themes.dart）で管理する
2. The Application shall 各お題にID（一意識別子）とタイトル（お題の文言）を持たせる
3. While アプリがメモリ上で動作している, the Application shall 使用済みお題のIDをセッション内で記憶する
4. The Application shall オフライン完結型として、インターネット接続なしで全機能を動作させる

---

## Non-Functional Requirements

### パフォーマンス
- アニメーションは60fpsを維持する
- 画面遷移は400ms以内に完了する
- アプリ起動から操作可能になるまで3秒以内

### アクセシビリティ
- 本文テキストのコントラスト比4.5:1以上を確保
- `prefers-reduced-motion`対応でアニメーションを控えめにするオプションを提供

### プラットフォーム対応
- iOS、Android、Web、Windows、macOS、Linuxで動作
- 年齢制限（17+または18+）をストアガイドラインに準拠
