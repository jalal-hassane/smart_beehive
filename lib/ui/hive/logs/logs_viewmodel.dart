import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';
import 'package:smart_beehive/utils/pref_utils.dart';

import '../../../main.dart';

class LogsViewModel extends ChangeNotifier {
  late LogsHelper helper;

  CollectionReference hives = fireStore.collection(collectionHives);
  CollectionReference logs = fireStore.collection(collectionLogs);

  updateLogs() async {
    final updatedHive =
    beehives.firstWhere((element) => element.id == currentHiveId);

    logInfo('updatedHive ${updatedHive.toMap()}');
    logs
        .doc(updatedHive.logsId)
        .update(updatedHive.logs.toMap())
        .then((value) => helper._success())
        .catchError((error) => helper._failure(error));
  }

}

class LogsHelper {
  LogsHelper({
    required void Function() success,
    required void Function(String error) failure,
  })  : _success = success,
        _failure = failure;

  final Function() _success;
  final Function(String error) _failure;
}
