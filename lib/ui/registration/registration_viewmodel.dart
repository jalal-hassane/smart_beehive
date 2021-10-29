import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/data/local/models/beekeeper.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/data/local/models/hive_overview.dart';
import 'package:smart_beehive/data/local/models/hive_properties.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';
import 'package:smart_beehive/utils/pref_utils.dart';

import '../../main.dart';

const _tag = 'RegistrationViewModel';

class RegistrationViewModel extends ChangeNotifier {
  late RegistrationHelper helper;

  CollectionReference beekeepers = fireStore.collection(collectionBeekeeper);
  CollectionReference hives = fireStore.collection(collectionHives);

  checkUsernameAvailability(String username, String password) {
    bool usernameIsAvailable = true;
    String docId = '';
    beekeepers.get().then((collection) {
      for (var doc in collection.docs) {
        if (doc[fieldUsername] == username) {
          usernameIsAvailable = false;
          docId = doc.id;
          break;
        }
      }
      if (usernameIsAvailable) {
        registerUser(username, password);
      } else {
        login(docId, username, password);
      }
    });
  }

  checkIn() async {
    final authToken = await PrefUtils.authToken;
    logInfo("auth token $authToken");
    if (authToken.isNotEmpty) {
      return beekeepers.doc(authToken).get().then((snapshot) async {
        final id = snapshot[fieldId].toString();
        final firebaseId = authToken;
        final username = snapshot[fieldUsername].toString();
        final password = snapshot[fieldPassword].toString();
        String profileImage = '';
        try {
          profileImage = snapshot[fieldImage].toString();
        } catch (ex) {
          logError(ex.toString());
        }
        final _hives = await _getBeehives(id);
        await handleRefreshFirebaseToken();
        final beekeeper = Beekeeper(id)
          ..firebaseId = firebaseId
          ..username = username
          ..password = password
          ..profileImage = profileImage
          ..beehives = _hives;
        helper._success(beekeeper);
      }).catchError((error) {
        logInfo(error.toString());
        helper._failure(errorSomethingWrong);
      });
    } else {
      helper._failure(errorNoAuthToken);
    }
  }

  _getBeehives(String id) async {
    final _hives = <Beehive>[];
    hives.where(fieldKeeperId, isEqualTo: id).get().then((querySnapshot) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        try {
          final hiveId = doc[fieldId].toString();
          final swarming = doc[fieldSwarming] as bool;
          final beehive = Beehive(hiveId, id)..hiveIsSwarming = swarming;
          try {
            final overview = HiveOverview.fromMap(
                doc[fieldOverview] as Map<String, dynamic>);
            beehive.overview = overview;
          } catch (ex) {
            logError('overview => $ex');
          }
          try {
            final properties = HiveProperties.fromMap(
                doc[fieldProperties] as Map<String, dynamic>);
            beehive.properties = properties;
          } catch (ex) {
            logError('properties => $ex');
          }
          try {
            final logs =
                HiveLogs.fromMap(doc[fieldLogs] as Map<String, dynamic>);
            beehive.logs = logs;
          } catch (ex) {
            logError('logs => $ex');
          }
          _hives.add(beehive);
        } catch (ex) {
          logError(ex.toString());
        }
      }
    }).catchError((error) {});
    return _hives;
  }

  login(String docId, String username, String password) {
    logInfo('docId: ' + docId);
    beekeepers.doc(docId).get().then((docSnapshot) {
      if (docSnapshot[fieldPassword] == password) {
        PrefUtils.setAuthToken(docId);
        checkIn();
      } else {
        helper._failure(errorWrongCredentials);
      }
    }).catchError((error) {
      helper._failure(error.toString());
    });
  }

  registerUser(String username, String password) {
    final id = uuid();
    final map = HashMap.of({
      fieldId: id,
      fieldUsername: username,
      fieldPassword: password,
    });
    return beekeepers.add(map).then((docRef) async{
      PrefUtils.setAuthToken(docRef.id);
      await handleRefreshFirebaseToken();
      helper._success(
        Beekeeper(id)
          ..username = username
          ..password = password
          ..firebaseId = docRef.id,
      );
    }).catchError((error) {
      helper._failure(errorSomethingWrong);
    });
  }
}

class RegistrationHelper {
  RegistrationHelper({
    required void Function(Beekeeper beekeeper) success,
    required void Function(String error) failure,
  })  : _success = success,
        _failure = failure;

  final Function(Beekeeper beekeeper) _success;
  final Function(String error) _failure;
}
