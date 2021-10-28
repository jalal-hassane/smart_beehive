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

  CollectionReference beekeepers = fireStore.collection(collectionBeekeeper);
  CollectionReference hives = fireStore.collection(collectionHives);

  /// add hive to firestore db
  updateHive() async {
    final updatedHive =
        beehives.firstWhere((element) => element.id == currentHiveId);

    hives
        .where(fieldId, isEqualTo: currentHiveId)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs[0];
        hives
            .doc(doc.id)
            .update(updatedHive.toMap())
            .then((value) => helper._success())
            .catchError((error) => helper._failure(error));
      }
    });
  }

  updateQueen() {
    final keeper = me?.id;
    if (keeper.isNullOrEmpty) {}
  }

  updateHarvests() {
    final keeper = me?.id;
    if (keeper.isNullOrEmpty) {}
  }

  updateFeeds() {
    final keeper = me?.id;
    if (keeper.isNullOrEmpty) {}
  }

  updateTreatments() {
    final keeper = me?.id;
    if (keeper.isNullOrEmpty) {}
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
