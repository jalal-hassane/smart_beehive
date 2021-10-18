import 'package:date_format/date_format.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_beehive/composite/strings.dart';

class HiveOverview {
  String? name = 'hive #1';
  HiveType? type;
  Species? species;
  String? mLocation; // todo add location in app
  DateTime? date;

  Position? position;

  HiveOverview({this.name});

  String get installationDate {
    if (date == null) return textNA;
    return formatDate(date!, [yyyy, ' ', M, ' ', dd]);
  }

  String get colonyAge {
    if (date == null) return textNA;
    final now = DateTime.now();
    final difference = now.difference(date!).inDays ~/ 365;
    if (difference < 1) return '${now.difference(date!).inDays} Days';
    return '$difference Years';
  }

  String get hiveType {
    if (type == null) return textNA;
    return type!.description;
  }

  String get speciesType {
    if (species == null) return textNA;
    return species!.description;
  }

  String get location {
    if (position == null) return textNA;
    return mLocation!;
  }
}

enum Species {
  melifera,
  meliferaCaucasia,
  meliferaCamica,
  meliferaLigustica,
  meliferaMelifera,
  meliferaScutellata,
}

extension Sps on String {
  Species get speciesFromString {
    switch (this) {
      case spMelifera:
        return Species.melifera;
      case spCaucasia:
        return Species.meliferaCaucasia;
      case spCamica:
        return Species.meliferaCamica;
      case spIgustica:
        return Species.meliferaLigustica;
      case spMeliferaMelifera:
        return Species.meliferaMelifera;
      default:
        return Species.meliferaScutellata;
    }
  }
}

extension Sp on Species {
  String get description {
    switch (index) {
      case 0:
        return spMelifera;
      case 1:
        return spCaucasia;
      case 2:
        return spCamica;
      case 3:
        return spIgustica;
      case 4:
        return spMeliferaMelifera;
      default:
        return spScutellata;
    }
  }
}

enum HiveType { langstroth, warre, topBar }

extension Hts on String {
  HiveType get hiveTypeFromString {
    switch (this) {
      case htLangstroth:
        return HiveType.langstroth;
      case htWarre:
        return HiveType.warre;
      default:
        return HiveType.topBar;
    }
  }
}

extension Ht on HiveType {
  String get description {
    switch (index) {
      case 0:
        return htLangstroth;
      case 1:
        return htWarre;
      default:
        return htTopBar;
    }
  }
}
