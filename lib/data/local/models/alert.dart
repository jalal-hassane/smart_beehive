import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/utils/constants.dart';

class Alert {
  AlertType? type; // ex: humidity/temperature
  double? lowerBound;
  double? upperBound;

  String? get svg => type?.icon;

  Color? get color => type?.color;

  String get description {
    return '$_type should be between $lowerBound and $upperBound';
  }

  String get _type {
    if (type == null) return '';
    return type!.description;
  }

  Alert({AlertType? t, double? lb, double? ub}) {
    type = t;
    lowerBound = lb;
    upperBound = ub;
  }

  toMap() {
    return {
      fieldType: type?.description,
      fieldLowerBound: lowerBound,
      fieldUpperBound: upperBound,
    };
  }

  static Alert fromMap(Map<String, dynamic> map) {
    return Alert()
      ..type = map[fieldType].toString().alertFromString
      ..lowerBound = double.parse(map[fieldLowerBound].toString())
      ..upperBound = double.parse(map[fieldUpperBound].toString());
  }
}

enum AlertType {
  temperature,
  humidity,
  population,
  weight,
  swarming,
}

extension GetType on String {
  AlertType get alertFromString {
    switch (this) {
      case typeTemperature:
        return AlertType.temperature;
      case typeWeight:
        return AlertType.weight;
      case typePopulation:
        return AlertType.population;
      case typeSwarming:
        return AlertType.swarming;
      default:
        return AlertType.humidity;
    }
  }
}

extension E on AlertType {
  String get description {
    switch (index) {
      case 0:
        return typeTemperature;
      case 1:
        return typeHumidity;
      case 2:
        return typePopulation;
      case 3:
        return typeWeight;
      case 4:
        return typeSwarming;
      default:
        return '';
    }
  }

  String get icon {
    switch (index) {
      case 0:
        return svgCelsius;
      case 1:
        return svgHumidity;
      case 2:
        return svgBees;
      case 3:
        return svgScale;
      case 4:
        return pngQueenSwarmStatus;
      default:
        return '';
    }
  }

  Color get color {
    switch (index) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.blue;
      case 2:
        return colorPrimary;
      case 3:
        return Colors.lightGreen;
      case 4:
        return Colors.deepPurpleAccent;
      default:
        return colorWhite;
    }
  }
}
