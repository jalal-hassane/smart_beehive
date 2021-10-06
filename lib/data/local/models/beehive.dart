import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/data/local/models/hive_overview.dart';
import 'package:smart_beehive/data/local/models/hive_properties.dart';
import 'package:smart_beehive/ui/hive/overview.dart';

class Beehive{
  final String id; // uuid to identify each hive
  String? name;
  HiveOverview overview = HiveOverview();
  HiveProperties properties  = HiveProperties();
  HiveLogs logs = HiveLogs();
  bool? qrScanned;
  Beehive(this.id);
}