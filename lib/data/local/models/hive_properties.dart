import 'package:smart_beehive/utils/constants.dart';

import 'alert.dart';

class HiveProperties {
  double? temperature = 37.5;
  double? humidity = 85;
  double? weight = 5.5;
  int? population = 2000;
  List<Alert>? alerts = [];

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
