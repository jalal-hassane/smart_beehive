import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/pref_utils.dart';

import '../../../main.dart';

class AlertsViewModel extends ChangeNotifier {
  late AlertsHelper helper;

  CollectionReference beekeepers = fireStore.collection(collectionBeekeeper);

  /// add hive to firestore db
  updateHives() async {
    final authToken = await PrefUtils.authToken;
    final hives = <Beehive>[];
    hives.addAll(beehives);
    if (hives.isNotEmpty) {
      final data = {fieldHives: hives.map((e) => e.toMap()).toList()};
      return beekeepers.doc(authToken).update(data).then((value) {
        helper._success();
      }).catchError((error) {
        helper._failure(error);
      });
    }
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