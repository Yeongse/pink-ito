import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('ko'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'Pink Ito'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In ja, this message translates to:
  /// **'秘密の数字を、言葉で繋げ。'**
  String get tagline;

  /// No description provided for @adultsOnly.
  ///
  /// In ja, this message translates to:
  /// **'— Adults Only —'**
  String get adultsOnly;

  /// No description provided for @play.
  ///
  /// In ja, this message translates to:
  /// **'PLAY'**
  String get play;

  /// No description provided for @howToPlay.
  ///
  /// In ja, this message translates to:
  /// **'How To Play'**
  String get howToPlay;

  /// No description provided for @playerSetup.
  ///
  /// In ja, this message translates to:
  /// **'プレイヤー設定'**
  String get playerSetup;

  /// No description provided for @playerCount.
  ///
  /// In ja, this message translates to:
  /// **'プレイヤー人数'**
  String get playerCount;

  /// No description provided for @playerCountFormat.
  ///
  /// In ja, this message translates to:
  /// **'{count}人'**
  String playerCountFormat(int count);

  /// No description provided for @playerLabel.
  ///
  /// In ja, this message translates to:
  /// **'プレイヤー {number}'**
  String playerLabel(int number);

  /// No description provided for @playerNameHint.
  ///
  /// In ja, this message translates to:
  /// **'名前を入力'**
  String get playerNameHint;

  /// No description provided for @startGame.
  ///
  /// In ja, this message translates to:
  /// **'ゲーム開始'**
  String get startGame;

  /// No description provided for @startGameConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'ゲーム開始'**
  String get startGameConfirmTitle;

  /// No description provided for @startGameConfirmMessage.
  ///
  /// In ja, this message translates to:
  /// **'この設定でゲームを開始しますか？'**
  String get startGameConfirmMessage;

  /// No description provided for @start.
  ///
  /// In ja, this message translates to:
  /// **'開始'**
  String get start;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @currentTheme.
  ///
  /// In ja, this message translates to:
  /// **'今回のお題'**
  String get currentTheme;

  /// No description provided for @distributeNumbers.
  ///
  /// In ja, this message translates to:
  /// **'数字を配る'**
  String get distributeNumbers;

  /// No description provided for @numberDistribution.
  ///
  /// In ja, this message translates to:
  /// **'数字配布'**
  String get numberDistribution;

  /// No description provided for @yourNumber.
  ///
  /// In ja, this message translates to:
  /// **'あなたの数字'**
  String get yourNumber;

  /// No description provided for @passingTo.
  ///
  /// In ja, this message translates to:
  /// **'{name}さんに渡してね'**
  String passingTo(String name);

  /// No description provided for @confirmAndPass.
  ///
  /// In ja, this message translates to:
  /// **'確認したら次へ'**
  String get confirmAndPass;

  /// No description provided for @numberIs.
  ///
  /// In ja, this message translates to:
  /// **'{name}さんの番号は'**
  String numberIs(String name);

  /// No description provided for @tapToReveal.
  ///
  /// In ja, this message translates to:
  /// **'タップして確認'**
  String get tapToReveal;

  /// No description provided for @passPhone.
  ///
  /// In ja, this message translates to:
  /// **'スマホを渡してください'**
  String get passPhone;

  /// No description provided for @playerTurn.
  ///
  /// In ja, this message translates to:
  /// **'さんの番です'**
  String get playerTurn;

  /// No description provided for @tapToSeeNumber.
  ///
  /// In ja, this message translates to:
  /// **'タップして数字を見る'**
  String get tapToSeeNumber;

  /// No description provided for @playerNumber.
  ///
  /// In ja, this message translates to:
  /// **'{name} の数字'**
  String playerNumber(String name);

  /// No description provided for @rememberNumber.
  ///
  /// In ja, this message translates to:
  /// **'この数字を覚えてね'**
  String get rememberNumber;

  /// No description provided for @dontShowOthers.
  ///
  /// In ja, this message translates to:
  /// **'他の人には見せないでね！'**
  String get dontShowOthers;

  /// No description provided for @rememberedNext.
  ///
  /// In ja, this message translates to:
  /// **'覚えたら次へ'**
  String get rememberedNext;

  /// No description provided for @toDiscussion.
  ///
  /// In ja, this message translates to:
  /// **'議論へ'**
  String get toDiscussion;

  /// No description provided for @nextPerson.
  ///
  /// In ja, this message translates to:
  /// **'次の人へ'**
  String get nextPerson;

  /// No description provided for @allNumbersDistributed.
  ///
  /// In ja, this message translates to:
  /// **'全員に数字を配りました。\n議論に進んでよいですか？'**
  String get allNumbersDistributed;

  /// No description provided for @passToNext.
  ///
  /// In ja, this message translates to:
  /// **'次の人にスマホを渡しますか？'**
  String get passToNext;

  /// No description provided for @goToDiscussion.
  ///
  /// In ja, this message translates to:
  /// **'議論へ進む'**
  String get goToDiscussion;

  /// No description provided for @pass.
  ///
  /// In ja, this message translates to:
  /// **'渡す'**
  String get pass;

  /// No description provided for @expressionTime.
  ///
  /// In ja, this message translates to:
  /// **'表現タイム'**
  String get expressionTime;

  /// No description provided for @expressionDescription.
  ///
  /// In ja, this message translates to:
  /// **'お題に沿って自分の数字を表現しよう！\n数字そのものは言わないでね'**
  String get expressionDescription;

  /// No description provided for @goToReorder.
  ///
  /// In ja, this message translates to:
  /// **'並び替えへ'**
  String get goToReorder;

  /// No description provided for @adPreparingTitle.
  ///
  /// In ja, this message translates to:
  /// **'広告を準備中...'**
  String get adPreparingTitle;

  /// No description provided for @adPreparingMessage.
  ///
  /// In ja, this message translates to:
  /// **'広告が流れた後に並び替えてもらうから、\n話す準備をしていてね！'**
  String get adPreparingMessage;

  /// No description provided for @discussNow.
  ///
  /// In ja, this message translates to:
  /// **'今のうちに話し合おう！'**
  String get discussNow;

  /// No description provided for @reorder.
  ///
  /// In ja, this message translates to:
  /// **'並び替え'**
  String get reorder;

  /// No description provided for @reorderDescription.
  ///
  /// In ja, this message translates to:
  /// **'数字が小さい順に並べよう'**
  String get reorderDescription;

  /// No description provided for @yourHand.
  ///
  /// In ja, this message translates to:
  /// **'手元のカード'**
  String get yourHand;

  /// No description provided for @placedCards.
  ///
  /// In ja, this message translates to:
  /// **'並べた順番（小さい→大きい）'**
  String get placedCards;

  /// No description provided for @emptySlot.
  ///
  /// In ja, this message translates to:
  /// **'空き'**
  String get emptySlot;

  /// No description provided for @slotNumber.
  ///
  /// In ja, this message translates to:
  /// **'{number}番目'**
  String slotNumber(int number);

  /// No description provided for @submit.
  ///
  /// In ja, this message translates to:
  /// **'決定'**
  String get submit;

  /// No description provided for @submitConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'並び替え確定'**
  String get submitConfirmTitle;

  /// No description provided for @submitConfirmMessage.
  ///
  /// In ja, this message translates to:
  /// **'この順番で決定しますか？'**
  String get submitConfirmMessage;

  /// No description provided for @confirm.
  ///
  /// In ja, this message translates to:
  /// **'確定'**
  String get confirm;

  /// No description provided for @placeAllCards.
  ///
  /// In ja, this message translates to:
  /// **'全てのカードを並べてください'**
  String get placeAllCards;

  /// No description provided for @stillEmpty.
  ///
  /// In ja, this message translates to:
  /// **'まだ空きがあります'**
  String get stillEmpty;

  /// No description provided for @placeAllRanks.
  ///
  /// In ja, this message translates to:
  /// **'全ての順位にカードを配置してください。'**
  String get placeAllRanks;

  /// No description provided for @checkAnswer.
  ///
  /// In ja, this message translates to:
  /// **'答え合わせ'**
  String get checkAnswer;

  /// No description provided for @checkAnswerConfirm.
  ///
  /// In ja, this message translates to:
  /// **'この順番で答え合わせをしますか？'**
  String get checkAnswerConfirm;

  /// No description provided for @smallestFirst.
  ///
  /// In ja, this message translates to:
  /// **'小さい順に並べてね'**
  String get smallestFirst;

  /// No description provided for @tapToPlace.
  ///
  /// In ja, this message translates to:
  /// **'空きスロットをタップして配置'**
  String get tapToPlace;

  /// No description provided for @selectCardToPlace.
  ///
  /// In ja, this message translates to:
  /// **'カードを選んでスロットに配置'**
  String get selectCardToPlace;

  /// No description provided for @arrangementOrder.
  ///
  /// In ja, this message translates to:
  /// **'並び順'**
  String get arrangementOrder;

  /// No description provided for @arrangementHint.
  ///
  /// In ja, this message translates to:
  /// **'ドラッグで順番変更・×で差し戻し'**
  String get arrangementHint;

  /// No description provided for @tapToPlaceHere.
  ///
  /// In ja, this message translates to:
  /// **'タップして配置'**
  String get tapToPlaceHere;

  /// No description provided for @handHint.
  ///
  /// In ja, this message translates to:
  /// **'カードを選んで上の枠に配置してね'**
  String get handHint;

  /// No description provided for @moving.
  ///
  /// In ja, this message translates to:
  /// **'移動中...'**
  String get moving;

  /// No description provided for @allPlaced.
  ///
  /// In ja, this message translates to:
  /// **'全員を配置しました'**
  String get allPlaced;

  /// No description provided for @handCardsCount.
  ///
  /// In ja, this message translates to:
  /// **'{count}人'**
  String handCardsCount(int count);

  /// No description provided for @result.
  ///
  /// In ja, this message translates to:
  /// **'答え合わせ'**
  String get result;

  /// No description provided for @tapToFlip.
  ///
  /// In ja, this message translates to:
  /// **'タップしてめくろう'**
  String get tapToFlip;

  /// No description provided for @flipNext.
  ///
  /// In ja, this message translates to:
  /// **'次をめくる ({count}枚)'**
  String flipNext(int count);

  /// No description provided for @success.
  ///
  /// In ja, this message translates to:
  /// **'SUCCESS!'**
  String get success;

  /// No description provided for @allCorrect.
  ///
  /// In ja, this message translates to:
  /// **'全員正解!'**
  String get allCorrect;

  /// No description provided for @failed.
  ///
  /// In ja, this message translates to:
  /// **'残念...'**
  String get failed;

  /// No description provided for @checkCorrectOrder.
  ///
  /// In ja, this message translates to:
  /// **'正しい順番を確認しよう'**
  String get checkCorrectOrder;

  /// No description provided for @playAgain.
  ///
  /// In ja, this message translates to:
  /// **'もう一度遊ぶ'**
  String get playAgain;

  /// No description provided for @changeSettings.
  ///
  /// In ja, this message translates to:
  /// **'設定を変えて遊ぶ'**
  String get changeSettings;

  /// No description provided for @backToTop.
  ///
  /// In ja, this message translates to:
  /// **'トップに戻る'**
  String get backToTop;

  /// No description provided for @theme.
  ///
  /// In ja, this message translates to:
  /// **'お題'**
  String get theme;

  /// No description provided for @tap.
  ///
  /// In ja, this message translates to:
  /// **'タップ!'**
  String get tap;

  /// No description provided for @hidden.
  ///
  /// In ja, this message translates to:
  /// **'???'**
  String get hidden;

  /// No description provided for @howToPlayTitle.
  ///
  /// In ja, this message translates to:
  /// **'How To Play'**
  String get howToPlayTitle;

  /// No description provided for @whatIsIto.
  ///
  /// In ja, this message translates to:
  /// **'Itoとは？'**
  String get whatIsIto;

  /// No description provided for @itoDescription.
  ///
  /// In ja, this message translates to:
  /// **'価値観のズレを楽しむ協力パーティーゲーム！\n\nお題に対して自分の数字を「言葉」で表現し、\nみんなで小さい順に並べることを目指します。'**
  String get itoDescription;

  /// No description provided for @step1Title.
  ///
  /// In ja, this message translates to:
  /// **'お題を確認'**
  String get step1Title;

  /// No description provided for @step1Description.
  ///
  /// In ja, this message translates to:
  /// **'ランダムに選ばれたお題が表示されます。\n例：「怖いもの」「嬉しいこと」など'**
  String get step1Description;

  /// No description provided for @step2Title.
  ///
  /// In ja, this message translates to:
  /// **'数字を受け取る'**
  String get step2Title;

  /// No description provided for @step2Description.
  ///
  /// In ja, this message translates to:
  /// **'各プレイヤーに1〜100の数字がランダムに配られます。\n自分の数字は他の人には見せないでね！'**
  String get step2Description;

  /// No description provided for @step3Title.
  ///
  /// In ja, this message translates to:
  /// **'表現タイム'**
  String get step3Title;

  /// No description provided for @step3Description.
  ///
  /// In ja, this message translates to:
  /// **'お題に沿って、自分の数字を言葉や身振りで表現しよう！\n数字そのものは言っちゃダメ！\n\n例：お題「怖いもの」で数字が80なら\n「死」「戦争」など大きめのものを表現'**
  String get step3Description;

  /// No description provided for @step4Title.
  ///
  /// In ja, this message translates to:
  /// **'並び替え'**
  String get step4Title;

  /// No description provided for @step4Description.
  ///
  /// In ja, this message translates to:
  /// **'全員の表現を聞いたら、数字が小さい順に並べよう！\n相談してもOK！'**
  String get step4Description;

  /// No description provided for @step5Title.
  ///
  /// In ja, this message translates to:
  /// **'答え合わせ'**
  String get step5Title;

  /// No description provided for @step5Description.
  ///
  /// In ja, this message translates to:
  /// **'並べた順番が正しいかチェック！\n全員正解でクリア！'**
  String get step5Description;

  /// No description provided for @tips.
  ///
  /// In ja, this message translates to:
  /// **'コツ'**
  String get tips;

  /// No description provided for @tip1.
  ///
  /// In ja, this message translates to:
  /// **'数字の大小は相対的！みんなの価値観を想像しよう'**
  String get tip1;

  /// No description provided for @tip2.
  ///
  /// In ja, this message translates to:
  /// **'具体的な例を出すと伝わりやすい'**
  String get tip2;

  /// No description provided for @tip3.
  ///
  /// In ja, this message translates to:
  /// **'曖昧な表現も面白い！解釈の違いを楽しもう'**
  String get tip3;

  /// No description provided for @theme1.
  ///
  /// In ja, this message translates to:
  /// **'エッチまでの興奮するシチュエーション'**
  String get theme1;

  /// No description provided for @theme2.
  ///
  /// In ja, this message translates to:
  /// **'好きなエッチ中の体位'**
  String get theme2;

  /// No description provided for @theme3.
  ///
  /// In ja, this message translates to:
  /// **'されて嬉しいエッチ中のプレイ'**
  String get theme3;

  /// No description provided for @theme4.
  ///
  /// In ja, this message translates to:
  /// **'本当はやりたくないエッチ中のプレイ'**
  String get theme4;

  /// No description provided for @theme5.
  ///
  /// In ja, this message translates to:
  /// **'この状況、100%やれたのに...というシチュエーション'**
  String get theme5;

  /// No description provided for @theme6.
  ///
  /// In ja, this message translates to:
  /// **'学校/会社で「俺/私のこと好きなのか？」と思う異性の言動'**
  String get theme6;

  /// No description provided for @theme7.
  ///
  /// In ja, this message translates to:
  /// **'「絶対ヤリチン/ヤリマンだわ」と思う言動'**
  String get theme7;

  /// No description provided for @theme8.
  ///
  /// In ja, this message translates to:
  /// **'ヤリモクだと確信する男の言動'**
  String get theme8;

  /// No description provided for @theme9.
  ///
  /// In ja, this message translates to:
  /// **'エッチ後に「この人とはもう会わないな」と思う言動'**
  String get theme9;

  /// No description provided for @theme10.
  ///
  /// In ja, this message translates to:
  /// **'マッチングアプリで「業者/ヤリモクだな」と思うプロフィール'**
  String get theme10;

  /// No description provided for @theme11.
  ///
  /// In ja, this message translates to:
  /// **'エッチするのに最高な場所'**
  String get theme11;

  /// No description provided for @theme12.
  ///
  /// In ja, this message translates to:
  /// **'セクシーだと思う異性の仕草'**
  String get theme12;

  /// No description provided for @theme13.
  ///
  /// In ja, this message translates to:
  /// **'抜けるAVのジャンル'**
  String get theme13;

  /// No description provided for @theme14.
  ///
  /// In ja, this message translates to:
  /// **'エロそうでエロくない言葉'**
  String get theme14;

  /// No description provided for @theme15.
  ///
  /// In ja, this message translates to:
  /// **'エロい声'**
  String get theme15;

  /// No description provided for @theme16.
  ///
  /// In ja, this message translates to:
  /// **'デート中に「この後ホテルないな」と思う言動'**
  String get theme16;

  /// No description provided for @theme17.
  ///
  /// In ja, this message translates to:
  /// **'ムラムラするシチュエーション'**
  String get theme17;

  /// No description provided for @theme18.
  ///
  /// In ja, this message translates to:
  /// **'理想の告白のシチュエーション'**
  String get theme18;

  /// No description provided for @theme19.
  ///
  /// In ja, this message translates to:
  /// **'エッチ中に萎える言葉'**
  String get theme19;

  /// No description provided for @theme20.
  ///
  /// In ja, this message translates to:
  /// **'エッチの誘いを断る上手い言い訳'**
  String get theme20;

  /// No description provided for @theme21.
  ///
  /// In ja, this message translates to:
  /// **'セフレにしやすそうな女'**
  String get theme21;

  /// No description provided for @theme22.
  ///
  /// In ja, this message translates to:
  /// **'チ⚪︎コがデカそうな男'**
  String get theme22;

  /// No description provided for @theme23.
  ///
  /// In ja, this message translates to:
  /// **'フ⚪︎ラが上手そうな女'**
  String get theme23;

  /// No description provided for @theme24.
  ///
  /// In ja, this message translates to:
  /// **'裏でめっちゃヤってそうな有名人'**
  String get theme24;

  /// No description provided for @theme25.
  ///
  /// In ja, this message translates to:
  /// **'マッチングアプリで当たりな男/女'**
  String get theme25;

  /// No description provided for @theme26.
  ///
  /// In ja, this message translates to:
  /// **'「この人絶対浮気するわ」と思う男/女'**
  String get theme26;

  /// No description provided for @theme27.
  ///
  /// In ja, this message translates to:
  /// **'見かけに反して実は性欲が強そうな女'**
  String get theme27;

  /// No description provided for @theme28.
  ///
  /// In ja, this message translates to:
  /// **'童貞そうなポケモン'**
  String get theme28;

  /// No description provided for @theme29.
  ///
  /// In ja, this message translates to:
  /// **'ヤリチンそうなポケモン'**
  String get theme29;

  /// No description provided for @theme30.
  ///
  /// In ja, this message translates to:
  /// **'ヤリマンそうなポケモン'**
  String get theme30;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
