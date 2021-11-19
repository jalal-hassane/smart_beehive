import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/data/local/models/hive_overview.dart';
import 'package:smart_beehive/data/local/models/hive_properties.dart';
import 'package:smart_beehive/utils/constants.dart';

import '../../../main.dart';

class FarmViewModel extends ChangeNotifier {
  late FarmHelper helper;

  CollectionReference hives = fireStore.collection(collectionHives);
  CollectionReference overview = fireStore.collection(collectionOverview);
  CollectionReference properties = fireStore.collection(collectionProperties);
  CollectionReference logs = fireStore.collection(collectionLogs);

  insertHive(Beehive beehive) async {
    hives.add(beehive.toMap()).then((snapshot) async {
      final docID = snapshot.id;
      await _addLogs(beehive, docID);
      await _addOverview(beehive, docID);
      await _addProperties(beehive, docID);
      helper._success();
    }).catchError((error) {
      helper._failure(error);
    });
  }

  _addLogs(Beehive beehive, String hiveId) async {
    final _logs = HiveLogs(hiveId: hiveId);
    beehive.logs = _logs;
    return logs.add(_logs.toMap()).then((doc) {
      beehive.logsId = doc.id;
      hives.doc(hiveId).update({fieldLogsId: doc.id});
    });
  }

  _addOverview(Beehive beehive, String hiveId) async {
    final _overview = HiveOverview(name: 'hive #$hiveCounter', hiveId: hiveId);
    beehive.overview = _overview;
    return overview.add(_overview.toMap()).then((doc) {
      beehive.overviewId = doc.id;
      hives.doc(hiveId).update({fieldOverviewId: doc.id});
    });
  }

  _addProperties(Beehive beehive, String hiveId) async {
    final _properties =
        HiveProperties(hiveId: hiveId, hiveKeeperId: beehive.keeperId);
    beehive.properties = _properties;
    return properties.add(_properties.toMap()).then((doc) {
      beehive.propertiesId = doc.id;
      hives.doc(hiveId).update({fieldPropertiesId: doc.id});
    });
  }
}

class FarmHelper {
  FarmHelper({
    required void Function() success,
    required void Function(String error) failure,
  })  : _success = success,
        _failure = failure;

  final Function() _success;
  final Function(String error) _failure;
}
