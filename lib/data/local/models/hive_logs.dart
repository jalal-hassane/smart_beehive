import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/log_utils.dart';

class HiveLogs {
  LogQueen? queen = LogQueen();
  LogHarvests? harvests = LogHarvests();
  LogFeeds? feeds = LogFeeds();
  LogTreatment? treatment = LogTreatment();
  LogGeneral? general = LogGeneral();
  LogWintering? wintering;
  String? hiveId;

  HiveLogs({this.hiveId});

  toMap() {
    return {
      fieldHiveId:hiveId,
      fieldQueen: queen?.toMap(),
      fieldHarvest: harvests?.toMap(),
      fieldFeeds: feeds?.toMap(),
      fieldTreatment: treatment?.toMap(),
    };
  }

  static HiveLogs fromMap(QueryDocumentSnapshot map) {
    return HiveLogs()
      ..hiveId = map[fieldHiveId].toString()
      ..queen = LogQueen.fromMap(map[fieldQueen] as Map<String, dynamic>)
      ..harvests =
          LogHarvests.fromMap(map[fieldHarvest] as Map<String, dynamic>)
      ..feeds = LogFeeds.fromMap(map[fieldFeeds] as Map<String, dynamic>)
      ..treatment =
          LogTreatment.fromMap(map[fieldTreatment] as Map<String, dynamic>);
  }
}

///<editor-fold desc='queen'>
class LogQueen {
  QueenStatus? status;
  QueenMarking? marking;
  QueenCells? cells;
  SwarmStatus? swarmStatus;
  bool? wingsClipped;
  bool? queenExcluder;

  List<ItemLog> queenLogs = [];
  List<ItemAbout> queenInfo = [];

  clear() {
    status = null;
    marking = null;
    cells = null;
    swarmStatus = null;
    wingsClipped = null;
    queenExcluder = null;
    for (ItemLog l in queenLogs) {
      l.reset();
    }
    //queenLogs.clear();
    //queenInfo.clear();
    //queenLogs.addAll(logs);
  }

  bool get isActive {
    return status != null ||
        marking != null ||
        cells != null ||
        swarmStatus != null ||
        wingsClipped != null ||
        queenExcluder != null;
  }

  List<ItemAbout> get info {
    if (queenInfo.isNotEmpty) return queenInfo;
    queenInfo.add(Status.info);
    queenInfo.add(
      ItemAbout(pngQueenWings, logQueenWings, logQueenWingsInfo),
    );
    queenInfo.add(Marking.info);
    // todo add cells
    /*queenInfo.add(QueenCells.supersedure.info);
    queenInfo.add(QueenCells.swarm.info);
    queenInfo.add(QueenCells.layingWorker.info);
    queenInfo.add(QueenCells.drone.info);
    queenInfo.add(QueenCells.youngestBrood.info);*/
    queenInfo.add(Swarm.info);
    // item about wings
    queenInfo.add(
      ItemAbout(pngQueenExcluder, logQueenExcluder, logQueenExcluderInfo),
    ); // item about excluder
    return queenInfo;
  }

  List<ItemLog> get logs {
    if (queenLogs.isNotEmpty) return queenLogs;

    final itemLog1 = ItemLog(pngQueenStatus, logQueenStatus);
    final itemLog2 = ItemLog(pngQueenWings, logQueenWings);
    final itemLog3 = ItemLog(pngQueenMarkerNone, logQueenMarking);
    final itemLog4 = ItemLog(pngQueenSwarmStatus, logSwarmStatus);
    final itemLog5 = ItemLog(pngQueenExcluder, logQueenExcluder);

    if (status != null) {
      itemLog1.setData(status!.icon, status!.description);
      itemLog1.setColor(status!.color);
    }

    if (wingsClipped != null) {
      String icon = wingsClipped! ? pngQueenWingsClipped : pngQueenWings;
      String title =
          wingsClipped! ? logQueenWingsClipped : logQueenWingsNotClipped;
      itemLog2.setData(icon, title);
    }

    if (marking != null) {
      itemLog3.setData(marking!.icon, marking!.text);
      itemLog3.setColor(marking!.color);
    }

    if (swarmStatus != null) {
      itemLog4.setData(pngQueenSwarmStatus, swarmStatus!.description);
      itemLog4.setColor(swarmStatus!.color);
    }

    if (queenExcluder != null) {
      String icon = queenExcluder! ? pngQueenExcluderActive : pngQueenExcluder;
      String title = queenExcluder! ? logExcluder : logNoExcluder;
      itemLog5.setData(icon, title);
    }

    queenLogs.add(itemLog1);
    queenLogs.add(itemLog2);
    queenLogs.add(itemLog3);
    // todo add cells
    /*queenLogs.add(
      ItemLog(
        pngQueenCells,
        logCells,
        //key: const ValueKey(logQueenMarking),
      ),
    );*/
    queenLogs.add(itemLog4);
    queenLogs.add(itemLog5);
    return queenLogs;
  }

  toMap() {
    return {
      fieldStatus: status?.description,
      fieldWingsClipped: wingsClipped,
      fieldMarking: marking?.description,
      fieldSwarmStatus: swarmStatus?.description,
      fieldQueenExcluder: queenExcluder,
    };
  }

  static LogQueen fromMap(Map<String, dynamic> map) {
    return LogQueen()
      ..status = map[fieldStatus].toString().queenStatusFromString
      ..marking = map[fieldMarking].toString().markingFromString
      ..swarmStatus = map[fieldSwarmStatus].toString().swarmStatusFromString
      ..wingsClipped = map[fieldWingsClipped] as bool?
      ..queenExcluder = map[fieldQueenExcluder] as bool?;
  }
}

enum QueenStatus { queenRight, queenLess, timeToReQueen, queenReplaced }

extension Status on QueenStatus {
  String get description {
    switch (index) {
      case 0:
        return logQueenRight;
      case 1:
        return logQueenLess;
      case 2:
        return logTimeToReQueen;
      default:
        return logQueenReplaced;
    }
  }

  String get icon {
    switch (index) {
      case 0:
        return pngQueenRight;
      default:
        return pngQueenLess;
    }
  }

  Color? get color {
    switch (index) {
      case 2:
        return Colors.deepOrange;
      case 3:
        return Colors.green;
      default:
        return null;
    }
  }

  static ItemAbout get info =>
      ItemAbout(pngQueenStatus, logQueenStatus, logQueenStatusInfo);

  ItemLog get log {
    switch (index) {
      case 0:
        return ItemLog(pngQueenRight, logQueenRight);
      case 1:
        return ItemLog(pngQueenLess, logQueenLess);
      case 2:
        return ItemLog.colored(
            pngQueenLess, logTimeToReQueen, Colors.deepOrange);
      default:
        return ItemLog.colored(pngQueenLess, logQueenReplaced, Colors.green);
    }
  }

  static List<ItemLog> get logs {
    return [
      QueenStatus.queenRight.log,
      QueenStatus.queenLess.log,
      QueenStatus.timeToReQueen.log,
      QueenStatus.queenReplaced.log,
    ];
  }
}

enum QueenMarking { white, yellow, red, green, blue }

extension Marking on QueenMarking {
  String get description {
    switch (index) {
      case 0:
        return logOneSix;
      case 1:
        return logTwoSeven;
      case 2:
        return logThreeEight;
      case 3:
        return logFourNine;
      default:
        return logFiveZero;
    }
  }

  String get text {
    switch (index) {
      case 0:
        return 'White';
      case 1:
        return 'Yellow';
      case 2:
        return 'Red';
      case 3:
        return 'Green';
      default:
        return 'Blue';
    }
  }

  String get icon {
    switch (index) {
      case 0:
        return pngQueenMarkerWhite;
      case 1:
        return pngQueenMarkerYellow;
      case 2:
        return pngQueenMarkerRed;
      case 3:
        return pngQueenMarkerGreen;
      default:
        return pngQueenMarkerBlue;
    }
  }

  Color get color {
    switch (index) {
      case 0:
        return Colors.white;
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.red;
      case 3:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  static ItemAbout get info =>
      ItemAbout(pngQueenMarkerNone, logQueenMarking, logQueenMarkingInfo);

  ItemLog get log {
    switch (index) {
      case 0:
        return ItemLog(pngQueenMarkerWhite, logOneSix);
      case 1:
        return ItemLog(pngQueenMarkerYellow, logTwoSeven);
      case 2:
        return ItemLog(pngQueenMarkerRed, logThreeEight);
      case 3:
        return ItemLog(pngQueenMarkerGreen, logFourNine);
      default:
        return ItemLog(pngQueenMarkerBlue, logFiveZero);
    }
  }

  static List<ItemLog> get logs {
    return [
      QueenMarking.white.log,
      QueenMarking.yellow.log,
      QueenMarking.red.log,
      QueenMarking.green.log,
      QueenMarking.blue.log,
    ];
  }
}

enum QueenCells {
  emergency,
  supersedure,
  swarm,
  layingWorker,
  drone,
  youngestBrood
}

extension Cells on QueenCells {
  String get description {
    switch (index) {
      case 0:
        return logCellEmergency;
      case 1:
        return logCellSupersedure;
      case 2:
        return logCellSwarm;
      case 3:
        return logCellLayingWorker;
      case 4:
        return logCellDrone;
      default:
        return logCellYoungestBrood;
    }
  }

  ItemAbout get info {
    switch (index) {
      case 0:
        return ItemAbout('', '', '');
      case 1:
        return ItemAbout(
            '', '$logCellSupersedure Cells', logCellSupersedureInfo);
      case 2:
        return ItemAbout('', '$logCellSwarm Cells', logCellSwarmInfo);
      case 3:
        return ItemAbout(
            '', '$logCellLayingWorker Cells', logCellLayingWorkerInfo);
      case 4:
        return ItemAbout('', '$logCellDrone Cells', logCellDroneInfo);
      default:
        return ItemAbout(
            '', '$logCellYoungestBrood Cells', logCellYoungestBroodInfo);
    }
  }

  // todo fix icons
  ItemLog get log {
    switch (index) {
      case 0:
        return ItemLog(pngQueenMarkerWhite, logCellEmergency);
      case 1:
        return ItemLog(pngQueenMarkerYellow, logCellSupersedure);
      case 2:
        return ItemLog(pngQueenMarkerRed, logCellSwarm);
      case 3:
        return ItemLog(pngQueenMarkerGreen, logCellLayingWorker);
      case 4:
        return ItemLog(pngQueenMarkerGreen, logCellDrone);
      default:
        return ItemLog(pngQueenMarkerBlue, logCellYoungestBrood);
    }
  }

  static List<ItemLog> get logs {
    return [
      QueenCells.emergency.log,
      QueenCells.supersedure.log,
      QueenCells.swarm.log,
      QueenCells.layingWorker.log,
      QueenCells.drone.log,
      QueenCells.youngestBrood.log,
    ];
  }
}

enum SwarmStatus { notSwarming, preSwarming, swarming }

extension Swarm on SwarmStatus {
  String get description {
    switch (index) {
      case 0:
        return logNotSwarming;
      case 1:
        return logPreSwarming;
      default:
        return logSwarming;
    }
  }

  Color? get color {
    switch (index) {
      case 0:
        return Colors.red;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return null;
    }
  }

  static ItemAbout get info =>
      ItemAbout(pngQueenSwarmStatus, logSwarmStatus, logSwarmStatusInfo);

  ItemLog get log {
    switch (index) {
      case 0:
        return ItemLog.colored(pngQueenSwarmStatus, logNotSwarming, Colors.red);
      case 1:
        return ItemLog.colored(
            pngQueenSwarmStatus, logPreSwarming, Colors.orange);
      default:
        return ItemLog.colored(pngQueenSwarmStatus, logSwarming, Colors.green);
    }
  }

  static List<ItemLog> get logs {
    return [
      SwarmStatus.notSwarming.log,
      SwarmStatus.preSwarming.log,
      SwarmStatus.swarming.log,
    ];
  }
}

///</editor-fold>

///<editor-fold desc='harvests'>
class LogHarvests {
  ItemHarvest? beeswax;
  ItemHarvest? honeyComb;
  ItemHarvest? honey;
  ItemHarvest? pollen;
  ItemHarvest? propolis;
  ItemHarvest? royalJelly;

  List<ItemHarvest> harvests = [];

  List<ItemLog> harvestsLogs = [];
  List<ItemAbout> harvestsInfo = [];

  List<ItemHarvestHistory> history = [];

  clear() {
    /*beeswax = null;
    honeyComb = null;
    honey = null;
    pollen = null;
    propolis = null;
    royalJelly = null;*/
    for (ItemHarvest l in harvests) {
      l.reset();
    }
    for (ItemLog l in harvestsLogs) {
      l.reset();
    }
  }

  List<ItemAbout> get info {
    if (harvestsInfo.isNotEmpty) return harvestsInfo;

    return harvestsInfo;
  }

  List<ItemHarvest> get logs2 {
    if (harvests.isNotEmpty) return harvests;

    final h1 = ItemHarvest(pngHarvestsBeeswax, logBeeswax);
    final h2 = ItemHarvest(pngHarvestsHoneycomb, logHoneycomb);
    final h3 = ItemHarvest(pngHarvestsHoney, logHoney);
    final h4 = ItemHarvest(pngHarvestsPollen, logPollen);
    final h5 = ItemHarvest(pngHarvestsPropolis, logPropolis);
    final h6 = ItemHarvest(pngHarvestsRoyalJelly, logRoyalJelly);

    if (beeswax != null) {
      if (beeswax!.value != null) {
        h1.setData(beeswax!.value, beeswax!.unit, pngHarvestsBeeswaxActive);
      }
    }
    beeswax = h1;
    harvests.add(beeswax!);

    if (honeyComb != null) {
      if (honeyComb!.value != null) {
        h2.setData(
            honeyComb!.value, honeyComb!.unit, pngHarvestsHoneycombActive);
      }
    }
    honeyComb = h2;
    harvests.add(honeyComb!);

    if (honey != null) {
      if (honey!.value != null) {
        h3.setData(honey!.value, honey!.unit, pngHarvestsHoneyActive);
      }
    }
    honey = h3;
    harvests.add(honey!);

    if (pollen != null) {
      if (pollen!.value != null) {
        h4.setData(pollen!.value, pollen!.unit, pngHarvestsPollenActive);
      }
    }
    pollen = h4;
    harvests.add(pollen!);

    if (propolis != null) {
      if (propolis!.value != null) {
        h5.setData(propolis!.value, propolis!.unit, pngHarvestsPropolisActive);
      }
    }
    propolis = h5;
    harvests.add(propolis!);

    if (royalJelly != null) {
      if (royalJelly!.value != null) {
        h6.setData(
            royalJelly!.value, royalJelly!.unit, pngHarvestsRoyalJellyActive);
      }
    }
    royalJelly = h6;
    harvests.add(royalJelly!);

    return harvests;
  }

  List<ItemLog> get logs {
    if (harvestsLogs.isNotEmpty) return harvestsLogs;
    harvestsLogs.add(ItemLog(pngHarvestsBeeswax, logBeeswax));
    harvestsLogs.add(ItemLog(pngHarvestsHoneycomb, logHoneycomb));
    harvestsLogs.add(ItemLog(pngHarvestsHoney, logHoney));
    harvestsLogs.add(ItemLog(pngHarvestsPollen, logPollen));
    harvestsLogs.add(ItemLog(pngHarvestsPropolis, logPropolis));
    harvestsLogs.add(ItemLog(pngHarvestsRoyalJelly, logRoyalJelly));
    return harvestsLogs;
  }

  bool get isActive {
    return harvests.any((element) => element.isActive);
  }

  toMap() {
    return {
      fieldBeeswax: beeswax?.toMap(),
      fieldHoneyComb: honeyComb?.toMap(),
      fieldHoney: honey?.toMap(),
      fieldPollen: pollen?.toMap(),
      fieldPropolis: propolis?.toMap(),
      fieldRoyalJelly: royalJelly?.toMap(),
      fieldHistory: history.map((e) => e.toMap()).toList()
    };
  }

  static LogHarvests fromMap(Map<String, dynamic> map) {
    return LogHarvests()
      ..beeswax =
          ItemHarvest.beeswaxFromMap(map[fieldBeeswax] as Map<String, dynamic>?)
      ..honeyComb = ItemHarvest.honeyCombFromMap(
          map[fieldHoneyComb] as Map<String, dynamic>?)
      ..honey =
          ItemHarvest.honeyFromMap(map[fieldHoney] as Map<String, dynamic>?)
      ..pollen =
          ItemHarvest.pollenFromMap(map[fieldPollen] as Map<String, dynamic>?)
      ..propolis = ItemHarvest.propolisFromMap(
          map[fieldPropolis] as Map<String, dynamic>?)
      ..royalJelly = ItemHarvest.royalJellyFrom(
          map[fieldRoyalJelly] as Map<String, dynamic>?)
      ..history =
          ((map[fieldHistory] as List<dynamic>?) ?? <ItemHarvestHistory>[])
              .map((e) => ItemHarvestHistory.fromMap(e as Map<String, dynamic>))
              .toList();
  }
}

class ItemHarvestHistory {
  DateTime date = DateTime.now();
  List<ItemHarvest?>? history;

  final mFormat = [MM];
  final yFormat = [yyyy];

  String get month {
    return formatDate(date, mFormat);
  }

  String get year {
    return formatDate(date, yFormat);
  }

  ItemHarvestHistory(this.history);

  toMap() {
    return {
      fieldDate: Timestamp.fromDate(date),
      fieldHarvest: history?.map((e) => e?.toMapWithName()).toList()
    };
  }

  static ItemHarvestHistory fromMap(Map<String, dynamic> map) {
    final harvest = (map[fieldHarvest] as List<dynamic>).map((e) {
      if (e != null) {
        return ItemHarvest.fromMapWithName(e)!;
      }
    }).toList();

    final time = (map[fieldDate] as Timestamp).toDate();
    return ItemHarvestHistory(harvest)..date = time;
  }
}

enum HarvestFilter {
  all,
  beeswax,
  honeyComb,
  honey,
  pollen,
  propolis,
  royalJelly
}

extension Filters on HarvestFilter {
  String get description {
    switch (this) {
      case HarvestFilter.all:
        return textAll;
      case HarvestFilter.beeswax:
        return logBeeswax;
      case HarvestFilter.honeyComb:
        return logHoneycomb;
      case HarvestFilter.honey:
        return logHoney;
      case HarvestFilter.pollen:
        return logPollen;
      case HarvestFilter.propolis:
        return logPropolis;
      case HarvestFilter.royalJelly:
        return logRoyalJelly;
    }
  }
}

extension GetFilter on String {
  HarvestFilter get filterFromString {
    switch (this) {
      case textAll:
        return HarvestFilter.all;
      case logBeeswax:
        return HarvestFilter.beeswax;
      case logHoneycomb:
        return HarvestFilter.honeyComb;
      case logHoney:
        return HarvestFilter.honey;
      case logPollen:
        return HarvestFilter.pollen;
      case logPropolis:
        return HarvestFilter.propolis;
      default:
        return HarvestFilter.royalJelly;
    }
  }
}

enum MonthFilter {
  all,
  jan,
  feb,
  mar,
  apr,
  may,
  jun,
  jul,
  aug,
  sep,
  oct,
  nov,
  dec
}

extension Mon on MonthFilter {
  String get description {
    switch (this) {
      case MonthFilter.all:
        return textAll;
      case MonthFilter.jan:
        return textJan;
      case MonthFilter.feb:
        return textFeb;
      case MonthFilter.mar:
        return textMar;
      case MonthFilter.apr:
        return textApr;
      case MonthFilter.may:
        return textMay;
      case MonthFilter.jun:
        return textJun;
      case MonthFilter.jul:
        return textJul;
      case MonthFilter.aug:
        return textAug;
      case MonthFilter.sep:
        return textSep;
      case MonthFilter.oct:
        return textOct;
      case MonthFilter.nov:
        return textNov;
      case MonthFilter.dec:
        return textDec;
    }
  }
}

extension GetMonth on String {
  MonthFilter get monthFromString {
    switch (this) {
      case textAll:
        return MonthFilter.all;
      case textJan:
        return MonthFilter.jan;
      case textFeb:
        return MonthFilter.feb;
      case textMar:
        return MonthFilter.mar;
      case textApr:
        return MonthFilter.apr;
      case textMay:
        return MonthFilter.may;
      case textJun:
        return MonthFilter.jun;
      case textJul:
        return MonthFilter.jul;
      case textAug:
        return MonthFilter.aug;
      case textSep:
        return MonthFilter.sep;
      case textOct:
        return MonthFilter.oct;
      case textNov:
        return MonthFilter.nov;
      default:
        return MonthFilter.dec;
    }
  }
}

///</editor-fold>

///<editor-fold desc='feeds'
class LogFeeds {
  SyrupType? syrup;
  bool? honey;
  PattyType? patty;
  bool? probiotics;

  List<ItemLog> feedsLogs = [];
  List<ItemAbout> feedsInfo = [];

  List<ItemAbout> get info {
    if (feedsInfo.isNotEmpty) return feedsInfo;
    feedsInfo.add(
      ItemAbout(
        pngFeedHeavySyrup,
        '$logSyrupHeavy $logSyrup',
        logSyrupHeavyInfo,
      ),
    );
    feedsInfo.add(
      ItemAbout(
        pngFeedLightSyrup,
        '$logSyrupLight $logSyrup',
        logSyrupLightInfo,
      ),
    );
    feedsInfo.add(
      ItemAbout(
        pngFeedPattyPollen,
        '$logPollen $logPatty',
        logPattyPollenInfo,
      ),
    );
    feedsInfo.add(
      ItemAbout(
        pngFeedPattyProtein,
        '$logProtein $logPatty',
        logPattyProteinInfo,
      ),
    );
    feedsInfo.add(
      ItemAbout(
        pngFeedProbioticsActive,
        logProbiotics,
        logProbioticsInfo,
      ),
    );
    return feedsInfo;
  }

  List<ItemLog> get logs {
    if (feedsLogs.isNotEmpty) return feedsLogs;
    final l1 = ItemLog(pngFeedSyrup, logSyrup);
    final l2 = ItemLog(pngFeedHoney, logHoney);
    final l3 = ItemLog(pngFeedPatty, logPatty);
    final l4 = ItemLog(pngFeedProbiotics, logProbiotics);

    if (syrup != null) {
      if (syrup == SyrupType.light) {
        l1.setData(pngFeedLightSyrup, syrup!.description);
      }
      if (syrup == SyrupType.heavy) {
        l1.setData(pngFeedHeavySyrup, syrup!.description);
      }
    }
    if (honey != null && honey!) {
      l2.setIcon(pngFeedHoneyActive, true);
    }
    if (patty != null) {
      if (patty == PattyType.pollen) {
        l3.setData(pngFeedPattyPollen, patty!.description);
      }
      if (patty == PattyType.protein) {
        l3.setData(pngFeedPattyProtein, patty!.description);
      }
    }
    if (probiotics != null && probiotics!) {
      l4.setIcon(pngFeedProbioticsActive, true);
    }
    feedsLogs.add(l1);
    feedsLogs.add(l2);
    feedsLogs.add(l3);
    feedsLogs.add(l4);
    return feedsLogs;
  }

  bool get isActive {
    return false;
  }

  clear() {
    syrup = null;
    honey = null;
    patty = null;
    probiotics = null;
    for (ItemLog l in feedsLogs) {
      l.reset();
    }
  }

  toMap() {
    return {
      fieldSyrup: syrup?.description,
      fieldHoney: honey,
      fieldPatty: patty?.description,
      fieldProbiotics: probiotics,
    };
  }

  static LogFeeds fromMap(Map<String, dynamic> map) {
    return LogFeeds()
      ..syrup = map[fieldSyrup].toString().syrupTypeFromString
      ..honey = map[fieldHoney] as bool?
      ..patty = map[fieldPatty].toString().pattyTypeFromString
      ..probiotics = map[fieldProbiotics] as bool?;
  }
}

enum SyrupType { light, heavy }

extension SyrupTypes on SyrupType {
  String get description {
    switch (index) {
      case 0:
        return '$logSyrupLight $logSyrup';
      default:
        return '$logSyrupHeavy $logSyrup';
    }
  }

  ItemLog get log {
    switch (index) {
      case 0:
        return ItemLog(pngFeedLightSyrup, description);
      default:
        return ItemLog(pngFeedHeavySyrup, description);
    }
  }

  static List<ItemLog> get logs {
    return [
      SyrupType.light.log,
      SyrupType.heavy.log,
    ];
  }
}

enum PattyType { pollen, protein }

extension PattyTypes on PattyType {
  String get description {
    switch (index) {
      case 0:
        return logPollen;
      default:
        return logProtein;
    }
  }

  ItemLog get log {
    switch (index) {
      case 0:
        return ItemLog(pngFeedPattyPollen, description);
      default:
        return ItemLog(pngFeedPattyProtein, description);
    }
  }

  static List<ItemLog> get logs {
    return [
      PattyType.pollen.log,
      PattyType.protein.log,
    ];
  }
}

///</editor-fold>

///<editor-fold desc='treatment'>
class LogTreatment {
  ItemTreatment? foulBrood = ItemTreatment.foulBroodTreatment(
    pngFoulbrood,
    logFoulBrood,
    pngFoulbroodActive,
  );
  ItemTreatment? hiveBeetles = ItemTreatment.hiveBeetlesTreatment(
    pngHiveBeetles,
    logHiveBeetles,
    pngHiveBeetlesActive,
  );
  ItemTreatment? nosema = ItemTreatment.nosemaTreatment(
    pngNosema,
    logNosema,
    pngNosemaActive,
  );
  ItemTreatment? trachealMites = ItemTreatment.trachealMitesTreatment(
    pngTrachealMites,
    logTrachealMites,
    pngTrachealMitesActive,
  );
  ItemTreatment? varroaMites = ItemTreatment.varroaMitesTreatment(
    pngVarroaMites,
    logVarroaMites,
    pngVarroaMitesActive,
  );
  ItemTreatment? waxMoths = ItemTreatment.waxMothsTreatment(
    pngWaxMoths,
    logWaxMoths,
    pngWaxMothsActive,
  );

  List<ItemLog> treatmentLogs = [];
  List<ItemAbout> treatmentInfo = [];

  List<ItemAbout> get info {
    if (treatmentInfo.isNotEmpty) return treatmentInfo;
    treatmentInfo
        .add(ItemAbout(pngFoulbroodDisease, logFoulBrood, logFoulBroodInfo));
    treatmentInfo.add(
        ItemAbout(pngHiveBeetlesDisease, logHiveBeetles, logHiveBeetlesInfo));
    treatmentInfo.add(ItemAbout(pngNosemaDisease, logNosema, logNosemaInfo));
    treatmentInfo.add(ItemAbout(
        pngTrachealMitesDisease, logTrachealMites, logTrachealMitesInfo));
    treatmentInfo.add(
        ItemAbout(pngVarroaMitesDisease, logVarroaMites, logVarroaMitesInfo));
    treatmentInfo
        .add(ItemAbout(pngWaxMothsDisease, logWaxMoths, logWaxMothsInfo));
    return treatmentInfo;
  }

  List<ItemTreatment> treatmentLogs2 = [];

  List<ItemTreatment> get logs2 {
    if (treatmentLogs2.isNotEmpty) return treatmentLogs2;
    if (foulBrood!._treatments.isNotEmpty) {
      foulBrood!.isActive = true;
    }
    treatmentLogs2.add(foulBrood!);
    if (hiveBeetles!._treatments.isNotEmpty) {
      hiveBeetles!.isActive = true;
    }
    treatmentLogs2.add(hiveBeetles!);
    if (nosema!._treatments.isNotEmpty) {
      nosema!.isActive = true;
    }
    treatmentLogs2.add(nosema!);
    if (trachealMites!._treatments.isNotEmpty) {
      trachealMites!.isActive = true;
    }
    treatmentLogs2.add(trachealMites!);
    if (varroaMites!._treatments.isNotEmpty) {
      varroaMites!.isActive = true;
    }
    treatmentLogs2.add(varroaMites!);
    if (waxMoths!._treatments.isNotEmpty) {
      waxMoths!.isActive = true;
    }
    treatmentLogs2.add(waxMoths!);
    return treatmentLogs2;
  }

  List<ItemLog> get logs {
    if (treatmentLogs.isNotEmpty) return treatmentLogs;
    treatmentLogs.add(ItemLog(pngQueenStatus, logFoulBrood));
    treatmentLogs.add(ItemLog(pngQueenStatus, logHiveBeetles));
    treatmentLogs.add(ItemLog(pngQueenStatus, logNosema));
    treatmentLogs.add(ItemLog(pngQueenStatus, logTrachealMites));
    treatmentLogs.add(ItemLog(pngQueenStatus, logVarroaMites));
    treatmentLogs.add(ItemLog(pngQueenStatus, logWaxMoths));
    return treatmentLogs;
  }

  bool get isActive {
    return false;
  }

  clear() {
    for (ItemTreatment l in treatmentLogs2) {
      l.reset();
    }
  }

  toMap() {
    return {
      fieldFoulBrood: foulBrood?.toMap(),
      fieldHiveBeetles: hiveBeetles?.toMap(),
      fieldNosema: nosema?.toMap(),
      fieldTrachealMites: trachealMites?.toMap(),
      fieldVarroaMites: varroaMites?.toMap(),
      fieldWaxMoths: waxMoths?.toMap(),
    };
  }

  static LogTreatment fromMap(Map<String, dynamic> map) {
    return LogTreatment()
      ..foulBrood = ItemTreatment.foulBroodFromMap(
          map[fieldFoulBrood] as Map<String, dynamic>)
      ..hiveBeetles = ItemTreatment.hiveBeetlesFromMap(
          map[fieldHiveBeetles] as Map<String, dynamic>)
      ..nosema =
          ItemTreatment.nosemaFromMap(map[fieldNosema] as Map<String, dynamic>)
      ..trachealMites = ItemTreatment.trachealMitesFromMap(
          map[fieldTrachealMites] as Map<String, dynamic>)
      ..varroaMites = ItemTreatment.varroaMitesFromMap(
          map[fieldVarroaMites] as Map<String, dynamic>)
      ..waxMoths = ItemTreatment.waxMothsFromMap(
          map[fieldWaxMoths] as Map<String, dynamic>);
  }
}

///</editor-fold>

///<editor-fold desc='general'>
class LogGeneral {
  clear() {}

  List<ItemAbout> get info {
    return [];
  }

  List<ItemLog> get logs {
    final res = <ItemLog>[];
    return res;
  }

  bool get isActive {
    return false;
  }
}

///</editor-fold>

class LogWintering {
  List<ItemAbout> get info {
    return [];
  }

  List<ItemLog> get logs {
    final res = <ItemLog>[];
    return res;
  }

  bool get isActive {
    return false;
  }
}

// todo implement Item class in the app instead of ItemLog/ItemAbout/ItemHarvest/ItemTreatment, new branch
enum ItemType { log, harvest, treatment, about }

class Item {
  String? id;
  String icon;
  String title;
  ItemType? type;
  bool isActive = false;
  String? initialIcon;
  String? initialTitle;
  Color? color;

  /// only for type harvest
  double? value;
  Unit? unit;

  /// only for type treatment
  final List<CheckableItem> _treatments = [];

  List<CheckableItem> get treatments => _treatments;

  Item.log(this.title, this.icon, {Color? mColor})
      : id = title,
        color = mColor,
        initialIcon = icon,
        initialTitle = title,
        type = ItemType.log;

  Item.about(this.title, this.icon, {Color? mColor})
      : id = title,
        color = mColor,
        initialIcon = icon,
        initialTitle = title,
        type = ItemType.about;

  Item.harvest(this.title, this.icon, {Color? mColor})
      : id = title,
        color = mColor,
        initialIcon = icon,
        initialTitle = title,
        type = ItemType.harvest;

  Item.treatment(this.title, this.icon, {Color? mColor})
      : id = title,
        color = mColor,
        initialIcon = icon,
        initialTitle = title,
        type = ItemType.treatment;

  Item.foulBroodTreatment(this.icon, this.title) {
    id = title;
    type = ItemType.treatment;
    _treatments.add(CheckableItem(logTerraPatties));
    _treatments.add(CheckableItem(logTerraPro));
    _treatments.add(CheckableItem(logTerramycin));
    _treatments.add(CheckableItem(logTetraBeeMix));
    _treatments.add(CheckableItem(logTylan));
  }

  Item.hiveBeetlesTreatment(this.icon, this.title) {
    id = title;
    type = ItemType.treatment;
    _treatments.add(CheckableItem(logDiatomacsiousEarth));
    _treatments.add(CheckableItem(logGardStar));
    _treatments.add(CheckableItem(logPermethrinSFR));
  }

  Item.nosemaTreatment(this.icon, this.title) {
    id = title;
    type = ItemType.treatment;
    _treatments.add(CheckableItem(logFumidilB));
  }

  Item.trachealMitesTreatment(this.icon, this.title) {
    id = title;
    type = ItemType.treatment;
    _treatments.add(CheckableItem(logMiteAThol));
  }

  Item.varroaMitesTreatment(this.icon, this.title) {
    id = title;
    type = ItemType.treatment;
    _treatments.add(CheckableItem(logAmitraz));
    _treatments.add(CheckableItem(logApiBioxal));
    _treatments.add(CheckableItem(logApiGuard));
    _treatments.add(CheckableItem(logApiStan));
    _treatments.add(CheckableItem(logApiVarStrips));
    _treatments.add(CheckableItem(logCheckMite));
    _treatments.add(CheckableItem(logDroneComb));
    _treatments.add(CheckableItem(logFormicPro));
    _treatments.add(CheckableItem(logHopGuard));
    _treatments.add(CheckableItem(logMiteAway));
    _treatments.add(CheckableItem(logMiteStrips));
    _treatments.add(CheckableItem(logOxalicAcidFumigate));
    _treatments.add(CheckableItem(logOxalicAcidDrip));
    _treatments.add(CheckableItem(logOxalicAcidGlycerine));
    _treatments.add(CheckableItem(logOxyBee));
    _treatments.add(CheckableItem(logTactic));
  }

  Item.waxMothsTreatment(this.icon, this.title) {
    id = title;
    type = ItemType.treatment;
    _treatments.add(CheckableItem(logB401));
    _treatments.add(CheckableItem(logParaMoth));
  }

  setData(
    String mIcon,
    String mTitle,
  ) {
    isActive = true;
    icon = mIcon;
    title = mTitle;
  }

  setIcon(String mIcon, bool active) {
    isActive = active;
    icon = mIcon;
  }

  setColor(Color? mColor) {
    color = mColor;
  }

  reset() {
    if (type == null) return;
    switch (type!) {
      case ItemType.log:
        resetLog();
        break;
      case ItemType.harvest:
        resetHarvest();
        break;
      case ItemType.treatment:
        resetTreatment();
        break;
      case ItemType.about:
        break;
    }
    isActive = false;
    icon = initialIcon ?? '';
    title = initialTitle ?? '';
  }

  resetLog() {
    isActive = false;
    icon = initialIcon ?? '';
    title = initialTitle ?? '';
  }

  resetHarvest() {
    value = null;
    unit = null;
    icon = initialIcon ?? '';
    isActive = false;
  }

  resetTreatment() {
    isActive = false;
    for (CheckableItem item in _treatments) {
      item.isChecked = false;
    }
  }
}

class ItemAbout {
  final String icon;
  final String title;
  final String description;

  ItemAbout(this.icon, this.title, this.description);
}

class ItemLog {
  Key? key;

  String? id;
  String icon;
  String title;
  bool isActive = false;
  String? initialIcon;
  String? initialTitle;
  Color? color;

  ItemLog(this.icon, this.title, {Key? key}) {
    id = title;
    initialIcon = icon;
    initialTitle = title;
  }

  ItemLog.colored(this.icon, this.title, this.color, {Key? key}) {
    id = title;
    initialIcon = icon;
    initialTitle = title;
  }

  setData(
    String mIcon,
    String mTitle,
  ) {
    isActive = true;
    icon = mIcon;
    title = mTitle;
  }

  setIcon(String mIcon, bool active) {
    isActive = active;
    icon = mIcon;
  }

  setColor(Color? mColor) {
    color = mColor;
  }

  reset() {
    isActive = false;
    icon = initialIcon ?? '';
    title = initialTitle ?? '';
  }
}

class ItemHarvest {
  double? value;
  Unit? unit;

  String? id;
  String icon;
  String title;
  String? initialIcon;
  bool isActive = false;

  ItemHarvest(this.icon, this.title, {Key? key})
      : id = title,
        initialIcon = icon;

  reset() {
    value = null;
    unit = null;
    icon = initialIcon ?? '';
    isActive = false;
  }

  setData(double? value, Unit? unit, String icon) {
    isActive = true;
    this.value = value;
    this.unit = unit;
    this.icon = icon;
  }

  toMap() => {fieldValue: value, fieldUnit: unit?.description};

  toMapWithName() => {
        fieldName: title,
        fieldValue: value,
        fieldUnit: unit?.description,
      };

  static ItemHarvest? fromMapWithName(Map<String, dynamic>? map) {
    if (map == null) return null;
    final name = map[fieldName].toString();
    switch (name) {
      case logBeeswax:
        return beeswaxFromMap(map);
      case logHoneycomb:
        return honeyCombFromMap(map);
      case logHoney:
        return honeyFromMap(map);
      case logPollen:
        return pollenFromMap(map);
      case logPropolis:
        return propolisFromMap(map);
      default:
        return royalJellyFrom(map);
    }
  }

  static ItemHarvest? beeswaxFromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return ItemHarvest(pngHarvestsBeeswax, logBeeswax)
      ..value = double.tryParse(map[fieldValue].toString())
      ..unit = map[fieldUnit].toString().unitFromString;
  }

  static ItemHarvest? honeyCombFromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return ItemHarvest(pngHarvestsHoneycomb, logHoneycomb)
      ..value =double.tryParse( map[fieldValue].toString())
      ..unit = map[fieldUnit].toString().unitFromString;
  }

  static ItemHarvest? honeyFromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return ItemHarvest(pngHarvestsHoney, logHoney)
      ..value = double.tryParse( map[fieldValue].toString())
      ..unit = map[fieldUnit].toString().unitFromString;
  }

  static ItemHarvest? pollenFromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return ItemHarvest(pngHarvestsPollen, logPollen)
      ..value = double.tryParse( map[fieldValue].toString())
      ..unit = map[fieldUnit].toString().unitFromString;
  }

  static ItemHarvest? propolisFromMap(Map<String, dynamic>? map) {
    if (map == null) return null;
    return ItemHarvest(pngHarvestsPropolis, logPropolis)
      ..value = double.tryParse( map[fieldValue].toString())
      ..unit = map[fieldUnit].toString().unitFromString;
  }

  static ItemHarvest? royalJellyFrom(Map<String, dynamic>? map) {
    if (map == null) return null;
    return ItemHarvest(pngHarvestsRoyalJelly, logRoyalJelly)
      ..value = double.tryParse( map[fieldValue].toString())
      ..unit = map[fieldUnit].toString().unitFromString;
  }
}

enum Unit { g, kg, oz, lbs, frames }

extension WeightUnit on Unit {
  String get description {
    switch (index) {
      case 0:
        return logG;
      case 1:
        return logKg;
      case 2:
        return logOz;
      case 3:
        return logLbs;
      default:
        return logFrames;
    }
  }
}

extension Conversions on String {
  QueenStatus? get queenStatusFromString {
    switch (this) {
      case logQueenRight:
        return QueenStatus.queenRight;
      case logQueenLess:
        return QueenStatus.queenLess;
      case logQueenReplaced:
        return QueenStatus.queenReplaced;
      case logTimeToReQueen:
        return QueenStatus.timeToReQueen;
      default:
        return null;
    }
  }

  QueenMarking? get markingFromString {
    switch (this) {
      case logOneSix:
        return QueenMarking.white;
      case logTwoSeven:
        return QueenMarking.yellow;
      case logThreeEight:
        return QueenMarking.red;
      case logFourNine:
        return QueenMarking.green;
      case logFiveZero:
        return QueenMarking.blue;
      default:
        return null;
    }
  }

  SwarmStatus? get swarmStatusFromString {
    switch (this) {
      case logNotSwarming:
        return SwarmStatus.notSwarming;
      case logPreSwarming:
        return SwarmStatus.preSwarming;
      case logSwarming:
        return SwarmStatus.swarming;
      default:
        return null;
    }
  }

  Unit? get unitFromString {
    switch (this) {
      case logG:
        return Unit.g;
      case logKg:
        return Unit.kg;
      case logOz:
        return Unit.oz;
      case logLbs:
        return Unit.lbs;
      case logFrames:
        return Unit.frames;
      default:
        return null;
    }
  }

  SyrupType? get syrupTypeFromString {
    switch (this) {
      case '$logSyrupLight $logSyrup':
        return SyrupType.light;
      case '$logSyrupHeavy $logSyrup':
        return SyrupType.heavy;
      default:
        return null;
    }
  }

  PattyType? get pattyTypeFromString {
    switch (this) {
      case logPollen:
        return PattyType.pollen;
      case logProtein:
        return PattyType.protein;
      default:
        return null;
    }
  }
}

class ItemTreatment {
  String description;
  String icon;
  String? id;
  String? activeIcon;
  final List<CheckableItem> _treatments = [];

  List<CheckableItem> get treatments => _treatments;

  bool get isActive2 {
    return _treatments.any((element) => element.isChecked);
  }

  bool isActive = false;

  reset() {
    isActive = false;
    for (CheckableItem item in _treatments) {
      item.isChecked = false;
    }
  }

  setIcon(String icon, bool active) {
    isActive = active;
    this.icon = icon;
  }

  ItemTreatment(this.icon, this.description);

  ItemTreatment.foulBroodTreatment(this.icon, this.description, this.activeIcon,
      {bool fill = true}) {
    id = description;
    if (fill) {
      _treatments.add(CheckableItem(logTerraPatties));
      _treatments.add(CheckableItem(logTerraPro));
      _treatments.add(CheckableItem(logTerramycin));
      _treatments.add(CheckableItem(logTetraBeeMix));
      _treatments.add(CheckableItem(logTylan));
    }
  }

  ItemTreatment.hiveBeetlesTreatment(
      this.icon, this.description, this.activeIcon,
      {bool fill = true}) {
    id = description;
    if (fill) {
      _treatments.add(CheckableItem(logDiatomacsiousEarth));
      _treatments.add(CheckableItem(logGardStar));
      _treatments.add(CheckableItem(logPermethrinSFR));
    }
  }

  ItemTreatment.nosemaTreatment(this.icon, this.description, this.activeIcon,
      {bool fill = true}) {
    id = description;
    if (fill) {
      _treatments.add(CheckableItem(logFumidilB));
    }
  }

  ItemTreatment.trachealMitesTreatment(
      this.icon, this.description, this.activeIcon,
      {bool fill = true}) {
    id = description;
    if (fill) {
      _treatments.add(CheckableItem(logMiteAThol));
    }
  }

  ItemTreatment.varroaMitesTreatment(
      this.icon, this.description, this.activeIcon,
      {bool fill = true}) {
    id = description;
    if (fill) {
      _treatments.add(CheckableItem(logAmitraz));
      _treatments.add(CheckableItem(logApiBioxal));
      _treatments.add(CheckableItem(logApiGuard));
      _treatments.add(CheckableItem(logApiStan));
      _treatments.add(CheckableItem(logApiVarStrips));
      _treatments.add(CheckableItem(logCheckMite));
      _treatments.add(CheckableItem(logDroneComb));
      _treatments.add(CheckableItem(logFormicPro));
      _treatments.add(CheckableItem(logHopGuard));
      _treatments.add(CheckableItem(logMiteAway));
      _treatments.add(CheckableItem(logMiteStrips));
      _treatments.add(CheckableItem(logOxalicAcidFumigate));
      _treatments.add(CheckableItem(logOxalicAcidDrip));
      _treatments.add(CheckableItem(logOxalicAcidGlycerine));
      _treatments.add(CheckableItem(logOxyBee));
      _treatments.add(CheckableItem(logTactic));
    }
  }

  ItemTreatment.waxMothsTreatment(this.icon, this.description, this.activeIcon,
      {bool fill = true}) {
    id = description;
    if (fill) {
      _treatments.add(CheckableItem(logB401));
      _treatments.add(CheckableItem(logParaMoth));
    }
  }

  toMap() => {fieldTreatments: _treatments.map((e) => e.toMap()).toList()};

  static ItemTreatment foulBroodFromMap(Map<String, dynamic> map) {
    final list = _getTreatments(map[fieldTreatments] as List<dynamic>);
    return ItemTreatment.foulBroodTreatment(
      pngFoulbrood,
      logFoulBrood,
      pngFoulbroodActive,
      fill: false,
    ).._treatments.addAll(list);
  }

  static ItemTreatment hiveBeetlesFromMap(Map<String, dynamic> map) {
    final list = _getTreatments(map[fieldTreatments] as List<dynamic>);
    return ItemTreatment.hiveBeetlesTreatment(
      pngHiveBeetles,
      logHiveBeetles,
      pngHiveBeetlesActive,
      fill: false,
    ).._treatments.addAll(list);
  }

  static ItemTreatment nosemaFromMap(Map<String, dynamic> map) {
    final list = _getTreatments(map[fieldTreatments] as List<dynamic>);
    return ItemTreatment.nosemaTreatment(
      pngNosema,
      logNosema,
      pngNosemaActive,
      fill: false,
    ).._treatments.addAll(list);
  }

  static ItemTreatment trachealMitesFromMap(Map<String, dynamic> map) {
    final list = _getTreatments(map[fieldTreatments] as List<dynamic>);
    return ItemTreatment.trachealMitesTreatment(
      pngTrachealMites,
      logTrachealMites,
      pngTrachealMitesActive,
      fill: false,
    ).._treatments.addAll(list);
  }

  static ItemTreatment varroaMitesFromMap(Map<String, dynamic> map) {
    logInfo('treat:' + map[fieldTreatments].toString());
    final list = _getTreatments(map[fieldTreatments] as List<dynamic>);
    return ItemTreatment.varroaMitesTreatment(
      pngVarroaMites,
      logVarroaMites,
      pngVarroaMitesActive,
      fill: false,
    ).._treatments.addAll(list);
  }

  static ItemTreatment waxMothsFromMap(Map<String, dynamic> map) {
    final list = _getTreatments(map[fieldTreatments] as List<dynamic>);
    return ItemTreatment.waxMothsTreatment(
      pngWaxMoths,
      logWaxMoths,
      pngWaxMothsActive,
      fill: false,
    ).._treatments.addAll(list);
  }

  static List<CheckableItem> _getTreatments(List<dynamic> list) {
    return list
        .map((e) => CheckableItem.fromMap(e as Map<String, dynamic>))
        .toList();
  }
}

class CheckableItem {
  String description;
  bool isChecked = false;

  CheckableItem(this.description);

  toMap() {
    return {
      fieldDescription: description,
      fieldChecked: isChecked,
    };
  }

  static CheckableItem fromMap(Map<String, dynamic> map) {
    return CheckableItem(map[fieldDescription].toString())
      ..isChecked = map[fieldChecked] as bool;
  }
}
