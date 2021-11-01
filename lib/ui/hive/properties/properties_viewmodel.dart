import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../../../main.dart';

class PropertiesViewModel extends ChangeNotifier {
  late PropertiesHelper helper;

  CollectionReference hives = fireStore.collection(collectionHives);

  Stream<DocumentSnapshot<Object?>>? getStream() {
    hives
        .where(fieldId, isEqualTo: currentHiveId)
        .limit(1)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        logInfo('docs not empty');
        final doc = snapshot.docs[0];
        return hives.doc(doc.id).snapshots();
      }
    });
  }
}

class PropertiesHelper {
  PropertiesHelper({
    required void Function() success,
    required void Function(String error) failure,
  })  : _success = success,
        _failure = failure;

  final Function() _success;
  final Function(String error) _failure;
}
