import 'package:flutter/cupertino.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/strings.dart';

class DataType {
  String? name;
  String? svg;
  IconData? iconData;

  DataType humidity() => DataType()
    ..name = typeHumidity
    ..svg = svgHumidity;

  DataType temperature() => DataType()
    ..name = typeTemperature
    ..svg = svgCelsius;

  DataType weight() => DataType()
    ..name = typeWeight
    ..svg = svgScale;

  DataType population() => DataType()
    ..name = typePopulation
    ..svg = svgBees;
}
