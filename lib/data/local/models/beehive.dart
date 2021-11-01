import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/data/local/models/hive_overview.dart';
import 'package:smart_beehive/data/local/models/hive_properties.dart';
import 'package:smart_beehive/utils/constants.dart';

class Beehive {
  final String id; // uuid to identify each hive
  final String docId;
  final String keeperId;
  HiveOverview overview = HiveOverview();
  HiveProperties properties = HiveProperties();
  HiveLogs logs = HiveLogs();
  bool? qrScanned = true;
  bool hiveIsSwarming = false;
  bool hasNotifications = false;

  Beehive(this.id, this.keeperId,this.docId);

  toMap() {
    return {
      fieldId: id,
      fieldKeeperId: keeperId,
      fieldOverview: overview.toMap(),
      fieldProperties: properties.toMap(),
      fieldLogs: logs.toMap(),
      fieldSwarming: hiveIsSwarming,
    };
  }
}
