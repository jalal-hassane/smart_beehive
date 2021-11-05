import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../../../main.dart';

class OverviewViewModel extends ChangeNotifier {
  late OverviewHelper helper;

  CollectionReference hives = fireStore.collection(collectionHives);
  CollectionReference overview = fireStore.collection(collectionOverview);

  updateOverview() async {
    final updatedHive = beehives.firstWhere((element) {
      logInfo("element id => ${element.id}");
      logInfo("currentHiveId => $currentHiveId");
      return element.id == currentHiveId;
    });

    logInfo('updatedHive ${updatedHive.toMap()}');
    overview
        .doc(updatedHive.overviewId)
        .update(updatedHive.overview.toMap())
        .then((value) => helper._success())
        .catchError((error) => helper._failure(error));
  }
}

class OverviewHelper {
  OverviewHelper({
    required void Function() success,
    required void Function(String error) failure,
  })  : _success = success,
        _failure = failure;

  final Function() _success;
  final Function(String error) _failure;
}
