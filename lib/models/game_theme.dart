import '../l10n/app_localizations.dart';

class GameTheme {
  final String id;
  final String titleKey;

  const GameTheme({
    required this.id,
    required this.titleKey,
  });

  String getLocalizedTitle(AppLocalizations l10n) {
    switch (titleKey) {
      case 'theme1': return l10n.theme1;
      case 'theme2': return l10n.theme2;
      case 'theme3': return l10n.theme3;
      case 'theme4': return l10n.theme4;
      case 'theme5': return l10n.theme5;
      case 'theme6': return l10n.theme6;
      case 'theme7': return l10n.theme7;
      case 'theme8': return l10n.theme8;
      case 'theme9': return l10n.theme9;
      case 'theme10': return l10n.theme10;
      case 'theme11': return l10n.theme11;
      case 'theme12': return l10n.theme12;
      case 'theme13': return l10n.theme13;
      case 'theme14': return l10n.theme14;
      case 'theme15': return l10n.theme15;
      case 'theme16': return l10n.theme16;
      case 'theme17': return l10n.theme17;
      case 'theme18': return l10n.theme18;
      case 'theme19': return l10n.theme19;
      case 'theme20': return l10n.theme20;
      case 'theme21': return l10n.theme21;
      case 'theme22': return l10n.theme22;
      case 'theme23': return l10n.theme23;
      case 'theme24': return l10n.theme24;
      case 'theme25': return l10n.theme25;
      case 'theme26': return l10n.theme26;
      case 'theme27': return l10n.theme27;
      case 'theme28': return l10n.theme28;
      case 'theme29': return l10n.theme29;
      case 'theme30': return l10n.theme30;
      default: return titleKey;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameTheme && other.id == id && other.titleKey == titleKey;
  }

  @override
  int get hashCode => Object.hash(id, titleKey);

  @override
  String toString() => 'GameTheme(id: $id, titleKey: $titleKey)';
}
