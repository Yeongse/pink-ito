// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Pink Ito';

  @override
  String get tagline => '秘密の数字を、言葉で繋げ。';

  @override
  String get adultsOnly => '— Adults Only —';

  @override
  String get play => 'PLAY';

  @override
  String get howToPlay => 'How To Play';

  @override
  String get playerSetup => 'プレイヤー設定';

  @override
  String get playerCount => 'プレイヤー人数';

  @override
  String playerCountFormat(int count) {
    return '$count人';
  }

  @override
  String playerLabel(int number) {
    return 'プレイヤー $number';
  }

  @override
  String get playerNameHint => '名前を入力';

  @override
  String get startGame => 'ゲーム開始';

  @override
  String get startGameConfirmTitle => 'ゲーム開始';

  @override
  String get startGameConfirmMessage => 'この設定でゲームを開始しますか？';

  @override
  String get start => '開始';

  @override
  String get cancel => 'キャンセル';

  @override
  String get currentTheme => '今回のお題';

  @override
  String get distributeNumbers => '数字を配る';

  @override
  String get numberDistribution => '数字配布';

  @override
  String get yourNumber => 'あなたの数字';

  @override
  String passingTo(String name) {
    return '$nameさんに渡してね';
  }

  @override
  String get confirmAndPass => '確認したら次へ';

  @override
  String numberIs(String name) {
    return '$nameさんの番号は';
  }

  @override
  String get tapToReveal => 'タップして確認';

  @override
  String get passPhone => 'スマホを渡してください';

  @override
  String get playerTurn => 'さんの番です';

  @override
  String get tapToSeeNumber => 'タップして数字を見る';

  @override
  String playerNumber(String name) {
    return '$name の数字';
  }

  @override
  String get rememberNumber => 'この数字を覚えてね';

  @override
  String get dontShowOthers => '他の人には見せないでね！';

  @override
  String get rememberedNext => '覚えたら次へ';

  @override
  String get toDiscussion => '議論へ';

  @override
  String get nextPerson => '次の人へ';

  @override
  String get allNumbersDistributed => '全員に数字を配りました。\n議論に進んでよいですか？';

  @override
  String get passToNext => '次の人にスマホを渡しますか？';

  @override
  String get goToDiscussion => '議論へ進む';

  @override
  String get pass => '渡す';

  @override
  String get expressionTime => '表現タイム';

  @override
  String get expressionDescription => 'お題に沿って自分の数字を表現しよう！\n数字そのものは言わないでね';

  @override
  String get goToReorder => '並び替えへ';

  @override
  String get adPreparingTitle => '広告を準備中...';

  @override
  String get adPreparingMessage => '広告が流れた後に並び替えてもらうから、\n話す準備をしていてね！';

  @override
  String get discussNow => '今のうちに話し合おう！';

  @override
  String get reorder => '並び替え';

  @override
  String get reorderDescription => '数字が小さい順に並べよう';

  @override
  String get yourHand => '手元のカード';

  @override
  String get placedCards => '並べた順番（小さい→大きい）';

  @override
  String get emptySlot => '空き';

  @override
  String slotNumber(int number) {
    return '$number番目';
  }

  @override
  String get submit => '決定';

  @override
  String get submitConfirmTitle => '並び替え確定';

  @override
  String get submitConfirmMessage => 'この順番で決定しますか？';

  @override
  String get confirm => '確定';

  @override
  String get placeAllCards => '全てのカードを並べてください';

  @override
  String get stillEmpty => 'まだ空きがあります';

  @override
  String get placeAllRanks => '全ての順位にカードを配置してください。';

  @override
  String get checkAnswer => '答え合わせ';

  @override
  String get checkAnswerConfirm => 'この順番で答え合わせをしますか？';

  @override
  String get smallestFirst => '小さい順に並べてね';

  @override
  String get tapToPlace => '空きスロットをタップして配置';

  @override
  String get selectCardToPlace => 'カードを選んでスロットに配置';

  @override
  String get arrangementOrder => '並び順';

  @override
  String get arrangementHint => 'ドラッグで順番変更・×で差し戻し';

  @override
  String get tapToPlaceHere => 'タップして配置';

  @override
  String get handHint => 'カードを選んで上の枠に配置してね';

  @override
  String get moving => '移動中...';

  @override
  String get allPlaced => '全員を配置しました';

  @override
  String handCardsCount(int count) {
    return '$count人';
  }

  @override
  String get result => '答え合わせ';

  @override
  String get tapToFlip => 'タップしてめくろう';

  @override
  String flipNext(int count) {
    return '次をめくる ($count枚)';
  }

  @override
  String get success => 'SUCCESS!';

  @override
  String get allCorrect => '全員正解!';

  @override
  String get failed => '残念...';

  @override
  String get checkCorrectOrder => '正しい順番を確認しよう';

  @override
  String get playAgain => 'もう一度遊ぶ';

  @override
  String get changeSettings => '設定を変えて遊ぶ';

  @override
  String get backToTop => 'トップに戻る';

  @override
  String get theme => 'お題';

  @override
  String get tap => 'タップ!';

  @override
  String get hidden => '???';

  @override
  String get howToPlayTitle => 'How To Play';

  @override
  String get whatIsIto => 'Itoとは？';

  @override
  String get itoDescription =>
      '価値観のズレを楽しむ協力パーティーゲーム！\n\nお題に対して自分の数字を「言葉」で表現し、\nみんなで小さい順に並べることを目指します。';

  @override
  String get step1Title => 'お題を確認';

  @override
  String get step1Description => 'ランダムに選ばれたお題が表示されます。\n例：「怖いもの」「嬉しいこと」など';

  @override
  String get step2Title => '数字を受け取る';

  @override
  String get step2Description =>
      '各プレイヤーに1〜100の数字がランダムに配られます。\n自分の数字は他の人には見せないでね！';

  @override
  String get step3Title => '表現タイム';

  @override
  String get step3Description =>
      'お題に沿って、自分の数字を言葉や身振りで表現しよう！\n数字そのものは言っちゃダメ！\n\n例：お題「怖いもの」で数字が80なら\n「死」「戦争」など大きめのものを表現';

  @override
  String get step4Title => '並び替え';

  @override
  String get step4Description => '全員の表現を聞いたら、数字が小さい順に並べよう！\n相談してもOK！';

  @override
  String get step5Title => '答え合わせ';

  @override
  String get step5Description => '並べた順番が正しいかチェック！\n全員正解でクリア！';

  @override
  String get tips => 'コツ';

  @override
  String get tip1 => '数字の大小は相対的！みんなの価値観を想像しよう';

  @override
  String get tip2 => '具体的な例を出すと伝わりやすい';

  @override
  String get tip3 => '曖昧な表現も面白い！解釈の違いを楽しもう';

  @override
  String get theme1 => 'エッチまでの興奮するシチュエーション';

  @override
  String get theme2 => '好きなエッチ中の体位';

  @override
  String get theme3 => 'されて嬉しいエッチ中のプレイ';

  @override
  String get theme4 => '本当はやりたくないエッチ中のプレイ';

  @override
  String get theme5 => 'この状況、100%やれたのに...というシチュエーション';

  @override
  String get theme6 => '学校/会社で「俺/私のこと好きなのか？」と思う異性の言動';

  @override
  String get theme7 => '「絶対ヤリチン/ヤリマンだわ」と思う言動';

  @override
  String get theme8 => 'ヤリモクだと確信する男の言動';

  @override
  String get theme9 => 'エッチ後に「この人とはもう会わないな」と思う言動';

  @override
  String get theme10 => 'マッチングアプリで「業者/ヤリモクだな」と思うプロフィール';

  @override
  String get theme11 => 'エッチするのに最高な場所';

  @override
  String get theme12 => 'セクシーだと思う異性の仕草';

  @override
  String get theme13 => '抜けるAVのジャンル';

  @override
  String get theme14 => 'エロそうでエロくない言葉';

  @override
  String get theme15 => 'エロい声';

  @override
  String get theme16 => 'デート中に「この後ホテルないな」と思う言動';

  @override
  String get theme17 => 'ムラムラするシチュエーション';

  @override
  String get theme18 => '理想の告白のシチュエーション';

  @override
  String get theme19 => 'エッチ中に萎える言葉';

  @override
  String get theme20 => 'エッチの誘いを断る上手い言い訳';

  @override
  String get theme21 => 'セフレにしやすそうな女';

  @override
  String get theme22 => 'チ⚪︎コがデカそうな男';

  @override
  String get theme23 => 'フ⚪︎ラが上手そうな女';

  @override
  String get theme24 => '裏でめっちゃヤってそうな有名人';

  @override
  String get theme25 => 'マッチングアプリで当たりな男/女';

  @override
  String get theme26 => '「この人絶対浮気するわ」と思う男/女';

  @override
  String get theme27 => '見かけに反して実は性欲が強そうな女';

  @override
  String get theme28 => '童貞そうなポケモン';

  @override
  String get theme29 => 'ヤリチンそうなポケモン';

  @override
  String get theme30 => 'ヤリマンそうなポケモン';
}
