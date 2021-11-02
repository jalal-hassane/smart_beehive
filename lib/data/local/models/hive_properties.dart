import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/extensions.dart';

import 'alert.dart';

class HiveProperties {
  double? temperature = 37.5;
  double? humidity = 85;
  double? weight = 5.5;
  int? population = 2000;
  List<Alert>? alerts = [];
  String? hiveId;

  HiveProperties({this.hiveId});

  generateNewProperties() {
    temperature = (Random().nextDouble() * 3 + 37).toPrecision(2);
    humidity = (Random().nextDouble() * 20 + 80).toPrecision(1);
    weight = (Random().nextDouble() * 5 + 5).toPrecision(1);
    population = population! + 3;
  }

  toMap() {
    return {
      fieldHiveId: hiveId,
      fieldTemperature: temperature,
      fieldHumidity: humidity,
      fieldWeight: weight,
      fieldPopulation: population,
      fieldAlerts: alerts?.map((e) => e.toMap()).toList()
    };
  }

  static HiveProperties fromMap(QueryDocumentSnapshot map) {
    return HiveProperties()
      ..hiveId = map[fieldHiveId].toString()
      ..temperature = map[fieldTemperature] as double
      ..humidity = map[fieldHumidity] as double
      ..weight = map[fieldWeight] as double
      ..population = map[fieldPopulation] as int
      ..alerts = (map[fieldAlerts] as List<dynamic>)
          .map((e) => Alert.fromMap(e))
          .toList();
  }
}
