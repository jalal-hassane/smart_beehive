import 'package:flutter/cupertino.dart';

class Alert {
  AlertType? type; // ex: humidity/temperature
  double? lowerBound;
  double? upperBound;
  String? _description; // generated based on data, upper and lower bounds
  IconData? iconData;
  String? svg;

  String get description {
    return '$_type should be between $lowerBound and $upperBound';
  }

  String get _type {
    if (type == null) return '';
    switch (type) {
      case AlertType.TEMPERATURE:
        return 'Temperature';
      case AlertType.HUMIDITY:
        return 'Humidity';
      case AlertType.POPULATION:
        return 'Population';
      case AlertType.WEIGHT:
        return 'Weight';
      default:
        return '';
    }
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
