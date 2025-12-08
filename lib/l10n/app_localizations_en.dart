// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pink Ito';

  @override
  String get tagline => 'Connect secret numbers with words.';

  @override
  String get adultsOnly => '— Adults Only —';

  @override
  String get play => 'PLAY';

  @override
  String get howToPlay => 'How To Play';

  @override
  String get playerSetup => 'Player Setup';

  @override
  String get playerCount => 'Number of Players';

  @override
  String playerCountFormat(int count) {
    return '$count players';
  }

  @override
  String playerLabel(int number) {
    return 'Player $number';
  }

  @override
  String get playerNameHint => 'Enter name';

  @override
  String get startGame => 'Start Game';

  @override
  String get startGameConfirmTitle => 'Start Game';

  @override
  String get startGameConfirmMessage => 'Start the game with these settings?';

  @override
  String get start => 'Start';

  @override
  String get cancel => 'Cancel';

  @override
  String get currentTheme => 'Today\'s Theme';

  @override
  String get distributeNumbers => 'Deal Numbers';

  @override
  String get numberDistribution => 'Number Distribution';

  @override
  String get yourNumber => 'Your Number';

  @override
  String passingTo(String name) {
    return 'Pass to $name';
  }

  @override
  String get confirmAndPass => 'Confirm & Next';

  @override
  String numberIs(String name) {
    return '$name\'s number is';
  }

  @override
  String get tapToReveal => 'Tap to reveal';

  @override
  String get passPhone => 'Please pass the phone';

  @override
  String get playerTurn => '\'s turn';

  @override
  String get tapToSeeNumber => 'Tap to see your number';

  @override
  String playerNumber(String name) {
    return '$name\'s Number';
  }

  @override
  String get rememberNumber => 'Remember this number';

  @override
  String get dontShowOthers => 'Don\'t show it to others!';

  @override
  String get rememberedNext => 'Got it, next!';

  @override
  String get toDiscussion => 'To Discussion';

  @override
  String get nextPerson => 'Next Person';

  @override
  String get allNumbersDistributed =>
      'All numbers have been distributed.\nProceed to discussion?';

  @override
  String get passToNext => 'Pass the phone to the next person?';

  @override
  String get goToDiscussion => 'Go to Discussion';

  @override
  String get pass => 'Pass';

  @override
  String get expressionTime => 'Expression Time';

  @override
  String get expressionDescription =>
      'Express your number based on the theme!\nDon\'t say the actual number';

  @override
  String get goToReorder => 'Go to Arrange';

  @override
  String get adPreparingTitle => 'Preparing ad...';

  @override
  String get adPreparingMessage =>
      'You\'ll arrange after the ad plays,\nso get ready to discuss!';

  @override
  String get discussNow => 'Discuss while you wait!';

  @override
  String get reorder => 'Arrange';

  @override
  String get reorderDescription => 'Arrange from smallest to largest';

  @override
  String get yourHand => 'Your Hand';

  @override
  String get placedCards => 'Arranged Order (Small → Large)';

  @override
  String get emptySlot => 'Empty';

  @override
  String slotNumber(int number) {
    return '#$number';
  }

  @override
  String get submit => 'Submit';

  @override
  String get submitConfirmTitle => 'Confirm Order';

  @override
  String get submitConfirmMessage => 'Submit this order?';

  @override
  String get confirm => 'Confirm';

  @override
  String get placeAllCards => 'Please place all cards';

  @override
  String get stillEmpty => 'Still Empty Slots';

  @override
  String get placeAllRanks => 'Please place cards in all ranks.';

  @override
  String get checkAnswer => 'Check Answer';

  @override
  String get checkAnswerConfirm => 'Check the answer with this order?';

  @override
  String get smallestFirst => 'Arrange from smallest';

  @override
  String get tapToPlace => 'Tap empty slot to place';

  @override
  String get selectCardToPlace => 'Select a card to place';

  @override
  String get arrangementOrder => 'Order';

  @override
  String get arrangementHint => 'Drag to reorder, × to return';

  @override
  String get tapToPlaceHere => 'Tap to place';

  @override
  String get handHint => 'Select a card and place it above';

  @override
  String get moving => 'Moving...';

  @override
  String get allPlaced => 'All players placed';

  @override
  String handCardsCount(int count) {
    return '$count cards';
  }

  @override
  String get result => 'Results';

  @override
  String get tapToFlip => 'Tap to reveal';

  @override
  String flipNext(int count) {
    return 'Flip Next ($count left)';
  }

  @override
  String get success => 'SUCCESS!';

  @override
  String get allCorrect => 'All Correct!';

  @override
  String get failed => 'Oh no...';

  @override
  String get checkCorrectOrder => 'Check the correct order';

  @override
  String get playAgain => 'Play Again';

  @override
  String get changeSettings => 'Change Settings';

  @override
  String get backToTop => 'Back to Title';

  @override
  String get theme => 'Theme';

  @override
  String get tap => 'Tap!';

  @override
  String get hidden => '???';

  @override
  String get howToPlayTitle => 'How To Play';

  @override
  String get whatIsIto => 'What is Ito?';

  @override
  String get itoDescription =>
      'A cooperative party game where you enjoy the gap in values!\n\nExpress your number in \"words\" based on the theme,\nand try to arrange everyone in ascending order.';

  @override
  String get step1Title => 'Check the Theme';

  @override
  String get step1Description =>
      'A randomly selected theme will be displayed.\nExample: \"Scary things\" \"Happy moments\" etc.';

  @override
  String get step2Title => 'Receive Your Number';

  @override
  String get step2Description =>
      'Each player receives a random number from 1 to 100.\nDon\'t show your number to others!';

  @override
  String get step3Title => 'Expression Time';

  @override
  String get step3Description =>
      'Express your number with words or gestures based on the theme!\nDon\'t say the actual number!\n\nExample: Theme \"Scary things\" with number 80\nExpress something big like \"death\" or \"war\"';

  @override
  String get step4Title => 'Arrange';

  @override
  String get step4Description =>
      'After hearing everyone\'s expressions, arrange from smallest to largest!\nDiscussing is OK!';

  @override
  String get step5Title => 'Check Results';

  @override
  String get step5Description =>
      'Check if the order is correct!\nAll correct to clear!';

  @override
  String get tips => 'Tips';

  @override
  String get tip1 => 'Numbers are relative! Imagine everyone\'s values';

  @override
  String get tip2 => 'Specific examples are easier to understand';

  @override
  String get tip3 =>
      'Vague expressions are fun too! Enjoy different interpretations';

  @override
  String get theme1 => 'Exciting situations before sex';

  @override
  String get theme2 => 'Favorite sex positions';

  @override
  String get theme3 => 'Things you like during sex';

  @override
  String get theme4 => 'Things you don\'t actually want to do during sex';

  @override
  String get theme5 => 'Situations where you could\'ve 100% scored but didn\'t';

  @override
  String get theme6 =>
      'Actions that make you think \'Do they like me?\' at school/work';

  @override
  String get theme7 => 'Actions that scream \'total player\'';

  @override
  String get theme8 => 'Things guys do that confirm they just want hookups';

  @override
  String get theme9 =>
      'Post-sex actions that make you think \'Never seeing them again\'';

  @override
  String get theme10 => 'Dating app profiles that scream \'fake/hookup only\'';

  @override
  String get theme11 => 'Best places to have sex';

  @override
  String get theme12 => 'Sexy gestures from the opposite sex';

  @override
  String get theme13 => 'Adult video genres that work';

  @override
  String get theme14 => 'Words that sound dirty but aren\'t';

  @override
  String get theme15 => 'Sexy voices';

  @override
  String get theme16 => 'Date actions that make you think \'No hotel tonight\'';

  @override
  String get theme17 => 'Situations that turn you on';

  @override
  String get theme18 => 'Ideal confession scenarios';

  @override
  String get theme19 => 'Mood-killing words during sex';

  @override
  String get theme20 => 'Good excuses to decline sex';

  @override
  String get theme21 => 'Women who seem easy to make FWB';

  @override
  String get theme22 => 'Men who seem well-endowed';

  @override
  String get theme23 => 'Women who seem skilled at oral';

  @override
  String get theme24 => 'Celebrities who secretly get around';

  @override
  String get theme25 => 'Dating app wins';

  @override
  String get theme26 => 'People who definitely cheat';

  @override
  String get theme27 => 'Women who are secretly very horny';

  @override
  String get theme28 => 'Pokémon that seem like virgins';

  @override
  String get theme29 => 'Pokémon that seem like players (male)';

  @override
  String get theme30 => 'Pokémon that seem like players (female)';
}
