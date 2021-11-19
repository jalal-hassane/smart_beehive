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
  List<Alert> alerts = [];
  String? hiveId;
  String? hiveKeeperId;

  List<Info> lastFiveTemperature = [];
  List<Info> lastFiveHumidity = [];
  List<Info> lastFiveWeight = [];
  List<Info> lastFivePopulation = [];

  List<Info> dailyTemperature = [];
  List<Info> dailyHumidity = [];
  List<Info> dailyWeight = [];
  List<Info> dailyPopulation = [];

  HiveProperties({this.hiveId, this.hiveKeeperId});

  generateNewProperties() {
    temperature = (Random().nextDouble() * 3 + 37).toPrecision(2);
    humidity = (Random().nextDouble() * 20 + 80).toPrecision(1);
    weight = (Random().nextDouble() * 5 + 5).toPrecision(1);
    population = population! + 3;
  }

  toMap() {
    return {
      fieldHiveId: hiveId,
      fieldKeeperId: hiveKeeperId,
      fieldTemperature: temperature,
      fieldHumidity: humidity,
      fieldWeight: weight,
      fieldPopulation: population,
      fieldAlerts: alerts.map((e) => e.toMap()).toList(),
      fieldLastFiveTemperature:
          lastFiveTemperature.map((e) => e.toMap()).toList(),
      fieldLastFiveWeight: lastFiveHumidity.map((e) => e.toMap()).toList(),
      fieldLastFiveHumidity: lastFiveWeight.map((e) => e.toMap()).toList(),
      fieldLastFivePopulation:
          lastFivePopulation.map((e) => e.toMap()).toList(),
      fieldDailyFiveTemperature:
          dailyTemperature.map((e) => e.toMap()).toList(),
      fieldDailyFiveWeight: dailyHumidity.map((e) => e.toMap()).toList(),
      fieldDailyFiveHumidity: dailyWeight.map((e) => e.toMap()).toList(),
      fieldDailyFivePopulation:
          dailyPopulation.map((e) => e.toMap()).toList(),
    };
  }

  static HiveProperties fromMap(QueryDocumentSnapshot map) {
    return HiveProperties()
      ..hiveId = map[fieldHiveId].toString()
      ..hiveKeeperId = map[fieldKeeperId].toString()
      ..temperature = double.parse(map[fieldTemperature].toString())
      ..humidity = double.parse(map[fieldHumidity].toString())
      ..weight =double.parse( map[fieldWeight].toString())
      ..population = map[fieldPopulation] as int
      ..alerts = (map[fieldAlerts] as List<dynamic>)
          .map((e) => Alert.fromMap(e))
          .toList()
      ..lastFiveTemperature = (map[fieldLastFiveTemperature] as List<dynamic>)
          .map((e) => Info.fromMap(e))
          .toList()
      ..lastFiveHumidity = (map[fieldLastFiveHumidity] as List<dynamic>)
          .map((e) => Info.fromMap(e))
          .toList()
      ..lastFiveWeight = (map[fieldLastFiveWeight] as List<dynamic>)
          .map((e) => Info.fromMap(e))
          .toList()
      ..lastFivePopulation = (map[fieldLastFivePopulation] as List<dynamic>)
          .map((e) => Info.fromMap(e))
          .toList()
      ..dailyTemperature = (map[fieldDailyFiveTemperature] as List<dynamic>)
          .map((e) => Info.fromMap(e))
          .toList()
      ..dailyHumidity = (map[fieldDailyFiveHumidity] as List<dynamic>)
          .map((e) => Info.fromMap(e))
          .toList()
      ..dailyWeight = (map[fieldDailyFiveWeight] as List<dynamic>)
          .map((e) => Info.fromMap(e))
          .toList()
      ..dailyPopulation = (map[fieldDailyFivePopulation] as List<dynamic>)
          .map((e) => Info.fromMap(e))
          .toList();
  }
}

class Info {
  final DateTime time;
  final dynamic value;

  Info(this.time, this.value);

  toMap() {
    return {
      fieldDate: Timestamp.fromDate(time),
      fieldValue: value,
    };
  }

  static Info fromMap(Map<String, dynamic> map) {
    return Info((map[fieldDate] as Timestamp).toDate(), map[fieldValue]);
  }
}
