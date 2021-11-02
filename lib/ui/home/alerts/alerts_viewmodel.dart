import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../../../main.dart';

class AlertsViewModel extends ChangeNotifier {
  late AlertsHelper helper;

  CollectionReference hives = fireStore.collection(collectionHives);
  CollectionReference properties = fireStore.collection(collectionProperties);

  updateProperties() async {
    final updatedHive =
        beehives.firstWhere((element) => element.id == currentHiveId);

    logInfo('updatedHive ${updatedHive.toMap()}');
    properties
        .doc(updatedHive.propertiesId)
        .update(updatedHive.properties.toMap())
        .then((value) => helper._success())
        .catchError((error) => helper._failure(error));
  }
}

class AlertsHelper {
  AlertsHelper({
    required void Function() success,
    required void Function(String error) failure,
  })  : _success = success,
        _failure = failure;

  final Function() _success;
  final Function(String error) _failure;
}
