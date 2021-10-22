import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/data/local/models/beekeeper.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/data/local/models/hive_overview.dart';
import 'package:smart_beehive/data/local/models/hive_properties.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/log_utils.dart';
import 'package:smart_beehive/utils/pref_utils.dart';

class SplashViewModel extends ChangeNotifier {
  late SplashHelper helper;

  CollectionReference beekeepers =
      FirebaseFirestore.instance.collection(collectionBeekeeper);

  checkIn() async {
    final authToken = await PrefUtils.authToken;
    logInfo("auth token $authToken");
    if (authToken.isNotEmpty) {
      return beekeepers.doc(authToken).get().then((snapshot) {
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
        final hives = <Beehive>[];
        try {
          final fBeehives = snapshot[fieldHives] as List<dynamic>;
          for (Map<String, dynamic> h in fBeehives) {
            final hiveId = h[fieldId].toString();
            final swarming = h[fieldSwarming] as bool;
            final beehive = Beehive(hiveId)..hiveIsSwarming = swarming;
            try {
              final overview = HiveOverview.fromMap(
                  h[fieldOverview] as Map<String, dynamic>);
              beehive.overview = overview;
            } catch (ex) {
              logError('overview => $ex');
            }
            try {
              final properties = HiveProperties.fromMap(
                  h[fieldProperties] as Map<String, dynamic>);
              beehive.properties = properties;
            } catch (ex) {
              logError('properties => $ex');
            }
            try {
              final logs =
                  HiveLogs.fromMap(h[fieldLogs] as Map<String, dynamic>);
              beehive.logs = logs;
            } catch (ex) {
              logError('logs => $ex');
            }
            hives.add(beehive);
          }
        } catch (ex) {
          logError(ex.toString());
        }

        final beekeeper = Beekeeper(id)
          ..firebaseId = firebaseId
          ..username = username
          ..password = password
          ..profileImage = profileImage
          ..beehives = hives;
        helper._success(beekeeper);
      }).catchError((error) {
        logInfo(error.toString());
        helper._failure(errorSomethingWrong);
      });
    } else {
      helper._failure(errorNoAuthToken);
    }
  }
}

class SplashHelper {
  SplashHelper({
    required void Function(Beekeeper beekeeper) success,
    required void Function(String error) failure,
  })  : _success = success,
        _failure = failure;

  final Function(Beekeeper beekeeper) _success;
  final Function(String error) _failure;
}
