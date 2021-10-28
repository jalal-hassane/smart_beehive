import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/pref_utils.dart';

import '../../../main.dart';

class FarmViewModel extends ChangeNotifier {
  late FarmHelper helper;

  CollectionReference hives = fireStore.collection(collectionHives);

  insertHive(Beehive beehive) async {
    hives.add(beehive.toMap()).then((snapshot) {
      helper._success();
    }).catchError((error) {
      helper._failure(error);
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
