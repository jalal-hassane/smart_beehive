import 'dart:math';

import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import 'alert.dart';

class HiveProperties {
  double? temperature = 37.5;
  double? humidity = 85;
  double? weight = 5.5;
  int? population = 2000;
  List<Alert>? alerts = [];

  generateNewProperties() {
    temperature = (Random().nextDouble() * 3 + 37).toPrecision(2);
    humidity = (Random().nextDouble() * 20 + 80).toPrecision(1);
    weight = (Random().nextDouble() * 5 + 5).toPrecision(1);
    population = population! + 3;
  }

  toMap() {
    return {
      fieldTemperature: temperature,
      fieldHumidity: humidity,
      fieldWeight: weight,
      fieldPopulation: population,
      fieldAlerts: alerts?.map((e) => e.toMap()).toList()
    };
  }

  static HiveProperties fromMap(Map<String, dynamic> map) {
    return HiveProperties()
      ..temperature = map[fieldTemperature] as double
      ..humidity = map[fieldHumidity] as double
      ..weight = map[fieldWeight] as double
      ..population = map[fieldPopulation] as int
      ..alerts = (map[fieldAlerts] as List<dynamic>)
          .map((e) => Alert.fromMap(e))
          .toList();
  }
}
