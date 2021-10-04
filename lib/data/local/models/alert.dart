import 'package:flutter/cupertino.dart';
import 'package:smart_beehive/composite/assets.dart';

class Alert {
  AlertType? type; // ex: humidity/temperature
  double? lowerBound;
  double? upperBound;
  IconData? iconData;
  String? svg;

  String get description {
    return '$_type should be between $lowerBound and $upperBound';
  }

  String get _type {
    if (type == null) return '';
    return type!.description;
  }

  Alert({AlertType? t, double? lb, double? ub, IconData? id, String? sv}) {
    type = t;
    lowerBound = lb;
    upperBound = ub;
    iconData = id;
    svg = sv;
  }
}

enum AlertType {
  TEMPERATURE,
  HUMIDITY,
  POPULATION,
  WEIGHT,
}

extension E on AlertType {
  String get description {
    switch (index) {
      case 0:
        return 'Temperature';
      case 1:
        return 'Humidity';
      case 2:
        return 'Population';
      case 3:
        return 'Weight';
      default:
        return '';
    }
  }

  String get icon{
    switch (index) {
      case 0:
        return svgCelsius;
      case 1:
        return svgHumidity;
      case 2:
        return svgBees;
      case 3:
        return svgScale;
      default:
        return '';
    }
  }
}
