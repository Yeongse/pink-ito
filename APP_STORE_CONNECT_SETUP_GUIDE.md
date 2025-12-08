# App Store Connect 初回アーカイブ送信ガイド

このガイドでは、Flutterプロジェクト「ピンク Ito」をXcodeでアーカイブし、App Store Connectに送信する手順を説明します。

## 前提条件

- Apple Developer Programに登録済み（年間$99）
- App Store Connectでアプリを登録済み（またはこれから登録する）
- Xcodeがインストール済み（最新版推奨）
- macOSで作業していること

---

## ステップ1: App Store Connectでアプリを登録

### 1.1 App Store Connectにアクセス
1. [App Store Connect](https://appstoreconnect.apple.com) にログイン
2. 「マイApp」をクリック
3. 「+」ボタンから「新しいApp」を選択

### 1.2 アプリ情報を入力
- **プラットフォーム**: iOS
- **名前**: ピンク Ito（または希望の名前）
- **プライマリ言語**: 日本語
- **Bundle ID**: 既存のものを選択、または新規作成
  - ⚠️ **重要**: このBundle IDは後でXcodeプロジェクトと一致させる必要があります
- **SKU**: 任意の一意の識別子（例: `pink-ito-001`）
- **ユーザーアクセス**: フルアクセス（推奨）

### 1.3 年齢制限の設定
- このアプリは下ネタコンテンツを含むため、**17+**または**18+**の年齢制限を設定してください
- App Store Connectの「App情報」→「年齢制限」で設定

---

## ステップ2: Bundle IDの確認と設定

### 2.1 現在のBundle IDを確認
現在のプロジェクトのBundle IDは `com.example.pinkIto` です。

### 2.2 Bundle IDを変更する場合
App Store Connectで登録したBundle IDと一致させる必要があります。

**変更が必要な場合:**
1. Xcodeで `ios/Runner.xcworkspace` を開く
2. 左側のプロジェクトナビゲーターで「Runner」を選択
3. 「TARGETS」→「Runner」を選択
4. 「Signing & Capabilities」タブを開く
5. 「Bundle Identifier」を変更（例: `com.yourcompany.pinkito`）

**または、Xcodeプロジェクトファイルを直接編集:**
- `ios/Runner.xcodeproj/project.pbxproj` 内の `PRODUCT_BUNDLE_IDENTIFIER` を変更

---

## ステップ3: バージョン情報の確認

### 3.1 pubspec.yamlの確認
現在の設定:
```yaml
version: 1.0.0+1
```
- `1.0.0` = バージョン名（CFBundleShortVersionString）
- `1` = ビルド番号（CFBundleVersion）

### 3.2 ビルド番号の増加
App Store Connectに送信するたびに、ビルド番号を増やす必要があります。
- 初回: `1.0.0+1`
- 次回: `1.0.0+2` または `1.0.1+1`

---

## ステップ4: Xcodeでプロジェクトを開く

### 4.1 ワークスペースを開く
```bash
cd /Users/yogns/dev/pink-ito
open ios/Runner.xcworkspace
```

⚠️ **重要**: `.xcworkspace` を開くこと。`.xcodeproj` ではない。

### 4.2 Flutterの依存関係を取得
```bash
cd /Users/yogns/dev/pink-ito
flutter pub get
cd ios
pod install
cd ..
```

---

## ステップ5: Xcodeでの署名とプロビジョニング設定

### 5.1 プロジェクト設定を開く
1. Xcodeの左側で「Runner」プロジェクトを選択
2. 「TARGETS」→「Runner」を選択
3. 「Signing & Capabilities」タブを開く

### 5.2 自動署名を有効化
1. 「Automatically manage signing」にチェックを入れる
2. 「Team」で自分のApple Developerアカウントを選択
   - まだ表示されない場合は、Xcodeの「Preferences」→「Accounts」でApple IDを追加

### 5.3 Bundle Identifierの確認
- App Store Connectで登録したBundle IDと一致していることを確認

### 5.4 プロビジョニングプロファイル
- 自動署名を有効にすると、Xcodeが自動的にApp Store用のプロビジョニングプロファイルを生成します
- 「Signing Certificate」が「Apple Distribution」になっていることを確認

---

## ステップ6: ビルド設定の確認

### 6.1 スキームとデバイスの選択
1. Xcodeの上部ツールバーで:
   - **スキーム**: 「Runner」を選択
   - **デバイス**: 「Any iOS Device (arm64)」を選択
     - ⚠️ 実機やシミュレーターではなく、「Any iOS Device」を選択すること

### 6.2 ビルド構成の確認
1. 「Product」→「Scheme」→「Edit Scheme...」
2. 「Archive」の「Build Configuration」が「Release」になっていることを確認

---

## ステップ7: アーカイブの作成

### 7.1 アーカイブを開始
1. Xcodeのメニューから「Product」→「Archive」を選択
2. ビルドが開始されます（数分かかる場合があります）

### 7.2 ビルドエラーが発生した場合
よくあるエラーと対処法:

**エラー: "No signing certificate found"**
- Apple Developerアカウントが正しく設定されているか確認
- 「Preferences」→「Accounts」でApple IDを追加/更新

**エラー: "Provisioning profile doesn't match"**
- Bundle IDがApp Store Connectと一致しているか確認
- 「Automatically manage signing」を一度オフにして、再度オンにする

**エラー: "Flutter framework not found"**
```bash
cd /Users/yogns/dev/pink-ito
flutter clean
flutter pub get
cd ios
pod install
cd ..
```
その後、Xcodeで再度アーカイブを試す

---

## ステップ8: Organizerでアーカイブを確認

### 8.1 Organizerウィンドウ
アーカイブが完了すると、自動的に「Organizer」ウィンドウが開きます。
開かない場合は、「Window」→「Organizer」から開けます。

### 8.2 アーカイブの確認
- 作成されたアーカイブが一覧に表示されます
- バージョン番号とビルド番号を確認

---

## ステップ9: App Store Connectにアップロード

### 9.1 配布方法の選択
Organizerウィンドウで、作成したアーカイブを選択し、「Distribute App」をクリック

### 9.2 配布オプション
1. **「App Store Connect」** を選択
2. 「Next」をクリック

### 9.3 配布オプションの詳細
1. **「Upload」** を選択（App Store Connectに直接アップロード）
2. 「Next」をクリック

### 9.4 配布内容の確認
- 「Automatically manage signing」が推奨されます
- 「Next」をクリック

### 9.5 アップロードの実行
1. アップロードの準備が完了したら、「Upload」をクリック
2. アップロードが開始されます（数分〜数十分かかる場合があります）

### 9.6 アップロード完了
- 「Upload Successful」と表示されたら完了です
- 「Done」をクリックして閉じます

---

## ステップ10: App Store Connectでアップロードを確認

### 10.1 アップロードの確認
1. [App Store Connect](https://appstoreconnect.apple.com) にアクセス
2. 「マイApp」→ アプリを選択
3. 「TestFlight」タブを開く
4. 数分待つと、アップロードされたビルドが表示されます

### 10.2 処理の待機
- アップロード後、Appleの処理に**10分〜数時間**かかることがあります
- 「処理中」の状態から「処理済み」になるまで待ちます

### 10.3 エラーが表示された場合
- 「処理済み」になった後、エラーがある場合は詳細を確認
- よくあるエラー:
  - **ITMS-90035**: アイコンが不足している → 1024x1024のアイコンを追加
  - **ITMS-90096**: プライバシー情報が不足 → Info.plistにプライバシー説明を追加

---

## ステップ11: アプリ情報の入力（初回のみ）

### 11.1 基本情報
App Store Connectの「App情報」で以下を入力:
- カテゴリ
- プライバシーポリシーURL（必要に応じて）
- サポートURL（必要に応じて）

### 11.2 価格と販売地域
- 「価格と販売地域」で価格を設定（無料の場合は「無料」を選択）
- 販売地域を選択

### 11.3 年齢制限
- 「App情報」→「年齢制限」で適切な年齢制限を設定（17+または18+）

---

## ステップ12: バージョン情報の入力

### 12.1 新しいバージョンを作成
1. 「App Store」タブを開く
2. 「+ バージョンまたはプラットフォーム」をクリック
3. バージョン番号を入力（例: `1.0.0`）

### 12.2 必須情報の入力
- **スクリーンショット**: 必須（各種デバイスサイズ）
- **説明**: アプリの説明文
- **キーワード**: 検索用キーワード
- **サポートURL**: 必要に応じて
- **マーケティングURL**: 必要に応じて
- **プライバシーポリシーURL**: 必要に応じて

### 12.3 年齢制限の確認
- 「年齢制限」で適切な設定を確認

### 12.4 ビルドの選択
1. 「ビルド」セクションで「+」をクリック
2. アップロードしたビルドを選択

---

## ステップ13: 審査情報の入力

### 13.1 審査情報
- **連絡先情報**: 必須
- **メモ**: Apple審査チームへのメモ（任意）
- **デモアカウント**: 必要に応じて

### 13.2 バージョンの公開
- 「このバージョンを公開する」にチェックを入れると、審査通過後に自動公開されます
- チェックを外すと、手動で公開する必要があります

---

## ステップ14: 審査に提出

### 14.1 最終確認
- すべての必須項目が入力されているか確認
- 右上の「審査に提出」ボタンをクリック

### 14.2 提出後の流れ
1. **審査待ち**: 通常1-3営業日
2. **審査中**: Appleがアプリを審査
3. **審査結果**:
   - **承認**: App Storeに公開（「このバージョンを公開する」にチェックしている場合）
   - **却下**: 理由を確認して修正後、再提出

---

## トラブルシューティング

### よくある問題と解決方法

#### 1. アーカイブが作成できない
```bash
# Flutterのクリーンビルド
cd /Users/yogns/dev/pink-ito
flutter clean
flutter pub get
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

#### 2. 署名エラー
- Xcodeの「Preferences」→「Accounts」でApple IDを確認
- 「Download Manual Profiles」をクリック
- Xcodeで「Automatically manage signing」を一度オフにして、再度オンにする

#### 3. ビルド番号のエラー
- pubspec.yamlのバージョンを確認
- App Store Connectで既に使用されているビルド番号は使用できない
- ビルド番号を増やして再アーカイブ

#### 4. アイコンが表示されない
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/` に1024x1024のアイコンが必要
- Xcodeで「Assets.xcassets」→「AppIcon」を開き、すべてのサイズが設定されているか確認

#### 5. プライバシー情報のエラー
Info.plistに以下を追加（必要に応じて）:
```xml
<key>NSUserTrackingUsageDescription</key>
<string>この説明を追加</string>
```

---

## チェックリスト

アーカイブ送信前に確認:

- [ ] Apple Developer Programに登録済み
- [ ] App Store Connectでアプリを登録済み
- [ ] Bundle IDがApp Store Connectと一致している
- [ ] バージョン番号とビルド番号が適切に設定されている
- [ ] Xcodeで署名設定が完了している
- [ ] アプリアイコン（1024x1024）が設定されている
- [ ] Flutterの依存関係が最新（`flutter pub get`、`pod install`）
- [ ] アーカイブが正常に作成できる
- [ ] App Store Connectにアップロードが成功した
- [ ] アプリ情報がすべて入力されている
- [ ] スクリーンショットがアップロードされている
- [ ] 年齢制限が適切に設定されている

---

## 参考リンク

- [App Store Connect](https://appstoreconnect.apple.com)
- [Apple Developer Documentation](https://developer.apple.com/documentation)
- [Flutter iOS Deployment](https://docs.flutter.dev/deployment/ios)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)

---

## 次のステップ

アーカイブ送信後:
1. App Store Connectでビルドの処理を待つ
2. アプリ情報を入力
3. 審査に提出
4. 審査結果を待つ
5. 公開（承認後）

Good luck! 🚀
