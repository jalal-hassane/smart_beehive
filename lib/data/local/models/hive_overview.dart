import 'package:smart_beehive/composite/strings.dart';

class HiveOverview {
  String? name = 'hive #1';
  String? installationDate = '30-9-2019';
  String? colonyAge = '2 years';
  String? type = 'Langstroth';
  String? species = 'Apis Millifera';
  String? location = 'Lebanon'; // todo add location in app
}

enum Species {
  melifera,
  meliferaCaucasia,
  meliferaCamica,
  meliferaLigustica,
  meliferaMelifera,
  meliferaScutellata,
  other
}

extension Sp on Species {
  String get description {
    String res = '';
    switch (index) {
      case 0:
        return spMelifera;
      case 1:
        return spCaucasia;
      case 2:
        return spCamica;
      case 3:
        return spLigustica;
      case 4:
        return spMeliferaMelifera;
      case 5:
        return spScutellata;
      default:
        return textOther;
    }
  }
}

enum HiveType {
  langstroth,
  warre,
  topBar,
  other,
}

extension Ht on HiveType {
  String get description {
    switch (index) {
      case 0:
        return htLangstroth;
      case 1:
        return htWarre;
      case 2:
        return htTopBar;
      default:
        return textOther;
    }
  }
}
