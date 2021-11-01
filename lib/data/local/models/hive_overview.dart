import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/utils/constants.dart';

class HiveOverview {
  String? name = 'hive #1';
  HiveType? type;
  Species? species;
  String? mLocation;
  DateTime? date = DateTime.now();

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
    if (difference < 1) {
      /*final dayDifference = now.difference(date!).inDays;
      if(dayDifference<1){
        final hoursDifference = now.difference(date!).inHours;
        if(hoursDifference<1){
          final minutesDifference = now.difference(date!).inMinutes;
          if(minutesDifference<1){
            final secDifference = now.difference(date!).inSeconds;
          }
        }
      }*/
      return '${now.difference(date!).inDays} Days';
    }
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

  toMap() {
    return {
      fieldName: name,
      fieldType: type?.description,
      fieldSpecies: species?.description,
      fieldDate: Timestamp.fromDate(date ?? DateTime.now()),
      fieldLocation: mLocation,
      fieldPosition: position == null
          ? null
          : GeoPoint(position!.latitude, position!.longitude),
    };
  }

  static HiveOverview fromMap(Map<String, dynamic> map) {
    final geo = map[fieldPosition] as GeoPoint?;
    return HiveOverview()
      ..name = map[fieldName].toString()
      ..mLocation = map[fieldLocation].toString()
      ..date = (map[fieldDate] as Timestamp).toDate()
      ..type = map[fieldType].toString().hiveTypeFromString
      ..species = map[fieldSpecies].toString().speciesFromString
      ..position = geo != null
          ? Position.fromMap({
              'latitude': geo.latitude,
              'longitude': geo.longitude,
            })
          : null;
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
  Species? get speciesFromString {
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
      case spScutellata:
        return Species.meliferaScutellata;
      default:
        return null;
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
  HiveType? get hiveTypeFromString {
    switch (this) {
      case htLangstroth:
        return HiveType.langstroth;
      case htWarre:
        return HiveType.warre;
      case htTopBar:
        return HiveType.topBar;
      default:
        return null;
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
