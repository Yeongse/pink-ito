// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Pink Ito';

  @override
  String get tagline => '비밀의 숫자를 말로 이어라.';

  @override
  String get adultsOnly => '— 성인 전용 —';

  @override
  String get play => 'PLAY';

  @override
  String get howToPlay => '게임 방법';

  @override
  String get playerSetup => '플레이어 설정';

  @override
  String get playerCount => '플레이어 수';

  @override
  String playerCountFormat(int count) {
    return '$count명';
  }

  @override
  String playerLabel(int number) {
    return 'Player $number';
  }

  @override
  String get playerNameHint => '이름 입력';

  @override
  String get startGame => '게임 시작';

  @override
  String get startGameConfirmTitle => '게임 시작';

  @override
  String get startGameConfirmMessage => '이 설정으로 게임을 시작하시겠습니까?';

  @override
  String get start => '시작';

  @override
  String get cancel => '취소';

  @override
  String get currentTheme => '이번 주제';

  @override
  String get distributeNumbers => '숫자 배분';

  @override
  String get numberDistribution => '숫자 배분';

  @override
  String get yourNumber => '당신의 숫자';

  @override
  String passingTo(String name) {
    return '$name님에게 전달하세요';
  }

  @override
  String get confirmAndPass => '확인 후 다음';

  @override
  String numberIs(String name) {
    return '$name님의 번호는';
  }

  @override
  String get tapToReveal => '탭해서 확인';

  @override
  String get passPhone => '스마트폰을 전달해주세요';

  @override
  String get playerTurn => '님 차례입니다';

  @override
  String get tapToSeeNumber => '탭해서 숫자 확인';

  @override
  String playerNumber(String name) {
    return '$name의 숫자';
  }

  @override
  String get rememberNumber => '이 숫자를 기억하세요';

  @override
  String get dontShowOthers => '다른 사람에게 보여주지 마세요!';

  @override
  String get rememberedNext => '기억했으면 다음';

  @override
  String get toDiscussion => '토론으로';

  @override
  String get nextPerson => '다음 사람';

  @override
  String get allNumbersDistributed => '모든 사람에게 숫자를 배분했습니다.\n토론으로 진행하시겠습니까?';

  @override
  String get passToNext => '다음 사람에게 스마트폰을 전달하시겠습니까?';

  @override
  String get goToDiscussion => '토론으로 가기';

  @override
  String get pass => '전달';

  @override
  String get expressionTime => '표현 타임';

  @override
  String get expressionDescription => '주제에 맞춰 자신의 숫자를 표현하세요!\n숫자 자체는 말하지 마세요';

  @override
  String get goToReorder => '정렬하러 가기';

  @override
  String get adPreparingTitle => '광고 준비 중...';

  @override
  String get adPreparingMessage => '광고가 끝나면 정렬을 시작합니다.\n그동안 이야기를 나눠보세요!';

  @override
  String get discussNow => '지금 이야기하세요!';

  @override
  String get reorder => '정렬하기';

  @override
  String get reorderDescription => '숫자가 작은 순서대로 정렬하세요';

  @override
  String get yourHand => '내 카드';

  @override
  String get placedCards => '정렬 순서 (작음 → 큼)';

  @override
  String get emptySlot => '빈칸';

  @override
  String slotNumber(int number) {
    return '$number번째';
  }

  @override
  String get submit => '결정';

  @override
  String get submitConfirmTitle => '정렬 확정';

  @override
  String get submitConfirmMessage => '이 순서로 확정하시겠습니까?';

  @override
  String get confirm => '확정';

  @override
  String get placeAllCards => '모든 카드를 배치해주세요';

  @override
  String get stillEmpty => '빈 자리가 있습니다';

  @override
  String get placeAllRanks => '모든 순위에 카드를 배치해주세요.';

  @override
  String get checkAnswer => '정답 확인';

  @override
  String get checkAnswerConfirm => '이 순서로 정답을 확인하시겠습니까?';

  @override
  String get smallestFirst => '작은 순서대로 정렬하세요';

  @override
  String get tapToPlace => '빈 슬롯을 탭해서 배치';

  @override
  String get selectCardToPlace => '카드를 선택하여 배치';

  @override
  String get arrangementOrder => '정렬 순서';

  @override
  String get arrangementHint => '드래그로 순서 변경, ×로 되돌리기';

  @override
  String get tapToPlaceHere => '탭하여 배치';

  @override
  String get handHint => '카드를 선택해서 위의 칸에 배치하세요';

  @override
  String get moving => '이동 중...';

  @override
  String get allPlaced => '모두 배치되었습니다';

  @override
  String handCardsCount(int count) {
    return '$count장';
  }

  @override
  String get result => '정답 확인';

  @override
  String get tapToFlip => '탭해서 공개';

  @override
  String flipNext(int count) {
    return '다음 공개 ($count장)';
  }

  @override
  String get success => 'SUCCESS!';

  @override
  String get allCorrect => '전원 정답!';

  @override
  String get failed => '아쉽네요...';

  @override
  String get checkCorrectOrder => '정확한 순서를 확인하세요';

  @override
  String get playAgain => '다시 플레이';

  @override
  String get changeSettings => '설정 변경 후 플레이';

  @override
  String get backToTop => '처음으로';

  @override
  String get theme => '주제';

  @override
  String get tap => '탭!';

  @override
  String get hidden => '???';

  @override
  String get howToPlayTitle => '게임 방법';

  @override
  String get whatIsIto => 'Ito란?';

  @override
  String get itoDescription =>
      '가치관의 차이를 즐기는 협력 파티 게임!\n\n주제에 대해 자신의 숫자를 \'말\'로 표현하고,\n모두 함께 작은 순서대로 정렬하는 것을 목표로 합니다.';

  @override
  String get step1Title => '주제 확인';

  @override
  String get step1Description => '무작위로 선택된 주제가 표시됩니다.\n예: \"무서운 것\" \"기쁜 일\" 등';

  @override
  String get step2Title => '숫자 받기';

  @override
  String get step2Description =>
      '각 플레이어에게 1~100 사이의 숫자가 무작위로 배분됩니다.\n자신의 숫자를 다른 사람에게 보여주지 마세요!';

  @override
  String get step3Title => '표현 타임';

  @override
  String get step3Description =>
      '주제에 맞춰 자신의 숫자를 말이나 몸짓으로 표현하세요!\n숫자 자체는 말하면 안 돼요!\n\n예: 주제 \"무서운 것\"에서 숫자가 80이면\n\"죽음\" \"전쟁\" 등 큰 것을 표현';

  @override
  String get step4Title => '정렬하기';

  @override
  String get step4Description => '모든 사람의 표현을 듣고 숫자가 작은 순서대로 정렬하세요!\n상의해도 OK!';

  @override
  String get step5Title => '정답 확인';

  @override
  String get step5Description => '정렬 순서가 맞는지 확인!\n전원 정답이면 클리어!';

  @override
  String get tips => '팁';

  @override
  String get tip1 => '숫자의 크기는 상대적! 모두의 가치관을 상상해보세요';

  @override
  String get tip2 => '구체적인 예시를 들면 전달하기 쉬워요';

  @override
  String get tip3 => '애매한 표현도 재미있어요! 해석의 차이를 즐기세요';

  @override
  String get theme1 => '섹스까지 흥분되는 상황';

  @override
  String get theme2 => '좋아하는 섹스 체위';

  @override
  String get theme3 => '받으면 기쁜 섹스 중 플레이';

  @override
  String get theme4 => '사실 하고 싶지 않은 섹스 중 플레이';

  @override
  String get theme5 => '이 상황, 100% 할 수 있었는데...라는 상황';

  @override
  String get theme6 => '학교/회사에서 "나 좋아하나?"라고 생각되는 이성의 행동';

  @override
  String get theme7 => '"완전 바람둥이네"라고 생각되는 행동';

  @override
  String get theme8 => '원나잇만 노린다고 확신하는 남자의 행동';

  @override
  String get theme9 => '섹스 후 "이 사람과는 다시 안 만나겠다"라고 생각되는 행동';

  @override
  String get theme10 => '소개팅 앱에서 "사기꾼/원나잇충이네"라고 생각되는 프로필';

  @override
  String get theme11 => '섹스하기 최고인 장소';

  @override
  String get theme12 => '섹시하다고 생각되는 이성의 행동';

  @override
  String get theme13 => '자위할 수 있는 야동 장르';

  @override
  String get theme14 => '야해 보이지만 야하지 않은 말';

  @override
  String get theme15 => '야한 목소리';

  @override
  String get theme16 => '데이트 중 "오늘 호텔 없겠다"라고 생각되는 행동';

  @override
  String get theme17 => '흥분되는 상황';

  @override
  String get theme18 => '이상적인 고백 상황';

  @override
  String get theme19 => '섹스 중 식는 말';

  @override
  String get theme20 => '섹스 제안을 거절하는 좋은 핑계';

  @override
  String get theme21 => '섹프로 만들기 쉬워 보이는 여자';

  @override
  String get theme22 => '거시기가 클 것 같은 남자';

  @override
  String get theme23 => '펠라가 잘할 것 같은 여자';

  @override
  String get theme24 => '뒤에서 엄청 하고 있을 것 같은 유명인';

  @override
  String get theme25 => '소개팅 앱에서 대박인 남자/여자';

  @override
  String get theme26 => '"이 사람 절대 바람 피우겠다"라고 생각되는 남자/여자';

  @override
  String get theme27 => '겉보기와 달리 실은 성욕이 강할 것 같은 여자';

  @override
  String get theme28 => '총각 같은 포켓몬';

  @override
  String get theme29 => '바람둥이 같은 포켓몬';

  @override
  String get theme30 => '걸레 같은 포켓몬';
}
