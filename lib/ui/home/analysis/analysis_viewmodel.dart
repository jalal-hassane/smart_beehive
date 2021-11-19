import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../../../main.dart';

class AnalysisViewModel extends ChangeNotifier {
  late AnalysisHelper helper;

  CollectionReference properties = fireStore.collection(collectionProperties);
  CollectionReference hives = fireStore.collection(collectionHives);

  updatePopulation() async {
    final updatedHive =
        beehives.firstWhere((element) => element.id == currentHiveId);

    logInfo('updatedHive ${updatedHive.toMap()}');
    properties
        .doc(updatedHive.propertiesId)
        .update({fieldPopulation: updatedHive.properties.population})
        .then((value) => helper._success())
        .catchError((error) => helper._failure(error));
  }

  stopSwarming() async {
    final updatedHive =
        beehives.firstWhere((element) => element.id == currentHiveId);
    updatedHive.hiveIsSwarming = false;
    logInfo('updatedHive ${updatedHive.toMap()}');
    hives
        .doc(updatedHive.docId)
        .update({fieldSwarming: false})
        .then((value) => helper._success())
        .catchError((error) => helper._failure(error));
  }
}

class AnalysisHelper {
  AnalysisHelper({
    required void Function() success,
    required void Function(String error) failure,
  })  : _success = success,
        _failure = failure;

  final Function() _success;
  final Function(String error) _failure;
}
