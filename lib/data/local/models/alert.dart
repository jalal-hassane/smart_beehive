import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';

class Alert {
  AlertType? type; // ex: humidity/temperature
  double? lowerBound;
  double? upperBound;
  IconData? iconData;
  String? svg;
  Color? color;

  String get description {
    return '$_type should be between $lowerBound and $upperBound';
  }

  String get _type {
    if (type == null) return '';
    return type!.description;
  }

  Alert({AlertType? t, double? lb, double? ub, IconData? id, String? sv,Color? c}) {
    type = t;
    lowerBound = lb;
    upperBound = ub;
    iconData = id;
    svg = sv;
    color = c;
  }
}

enum AlertType {
  temperature,
  humidity,
  population,
  weight,
}
extension GetType on String{
  AlertType get alertFromString{
    switch(this){
      case typeTemperature: return AlertType.temperature;
      case typeWeight: return AlertType.weight;
      case typePopulation: return AlertType.population;
      default: return AlertType.humidity;
    }
  }
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

  Color get color{
    switch (index) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.blue;
      case 2:
        return colorBlack;
      case 3:
        return Colors.lightGreen;
      default:
        return colorWhite;
    }
  }
}
