import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/strings.dart';

class HiveLogs {
  LogQueen? queen = LogQueen();
  LogHarvests? harvests = LogHarvests();
  LogFeeds? feeds = LogFeeds();
  LogTreatment? treatment = LogTreatment();
  LogGeneral? general = LogGeneral();
  LogWintering? wintering;
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
    queenLogs.add(
      ItemLog(
        pngQueenStatus,
        logQueenStatus,
        //key: const ValueKey(logQueenStatus),
      ),
    );
    queenLogs.add(
      ItemLog(
        pngQueenWings,
        logQueenWings,
        //key: const ValueKey(logQueenWings),
      ),
    );
    queenLogs.add(
      ItemLog(
        pngQueenMarkerNone,
        logQueenMarking,
        //key: const ValueKey(logQueenMarking),
      ),
    );
    // todo add cells
    /*queenLogs.add(
      ItemLog(
        pngQueenCells,
        logCells,
        //key: const ValueKey(logQueenMarking),
      ),
    );*/
    queenLogs.add(
      ItemLog(
        pngQueenSwarmStatus,
        logSwarmStatus,
        //key: const ValueKey(logSwarmStatus),
      ),
    );
    queenLogs.add(
      ItemLog(
        pngQueenExcluder,
        logQueenExcluder,
        //key: const ValueKey(logQueenExcluder),
      ),
    );
    return queenLogs;
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

  static ItemAbout get info =>
      ItemAbout(pngQueenStatus, logQueenStatus, logQueenStatusInfo);

  ItemLog get log {
    switch (index) {
      case 0:
        return ItemLog(pngQueenRight, logQueenRight);
      case 1:
        return ItemLog(pngQueenLess, logQueenLess);
      case 2:
        return ItemLog.colored(pngQueenLess, logTimeToReQueen,Colors.deepOrange);
      default:
        return ItemLog.colored(pngQueenLess, logQueenReplaced,Colors.green);
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

  List<ItemLog> harvestsLogs = [];
  List<ItemAbout> harvestsInfo = [];

  clear() {
    beeswax = null;
    honeyComb = null;
    honey = null;
    pollen = null;
    propolis = null;
    royalJelly = null;
    for (ItemLog l in harvestsLogs) {
      l.reset();
    }
  }

  List<ItemAbout> get info {
    if (harvestsInfo.isNotEmpty) return harvestsInfo;

    return harvestsInfo;
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
    return false;
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
    feedsInfo.add(ItemAbout(
        pngFeedHeavySyrup, '$logSyrupHeavy $logSyrup', logSyrupHeavyInfo));
    feedsInfo.add(ItemAbout(
        pngFeedLightSyrup, '$logSyrupLight $logSyrup', logSyrupLightInfo));
    feedsInfo.add(ItemAbout(
        pngFeedPattyPollen, '$logPollen $logPatty', logPattyPollenInfo));
    feedsInfo.add(ItemAbout(
        pngFeedPattyProtein, '$logProtein $logPatty', logPattyProteinInfo));
    feedsInfo.add(
        ItemAbout(pngFeedProbioticsActive, logProbiotics, logProbioticsInfo));
    return feedsInfo;
  }

  List<ItemLog> get logs {
    if (feedsLogs.isNotEmpty) return feedsLogs;
    feedsLogs.add(ItemLog(pngFeedSyrup, logSyrup));
    feedsLogs.add(ItemLog(pngFeedHoney, logHoney));
    feedsLogs.add(ItemLog(pngFeedPatty, logPatty));
    feedsLogs.add(ItemLog(pngFeedProbiotics, logProbiotics));
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
}

enum SyrupType { light, heavy }

extension SyrupTypes on SyrupType {
  ItemLog get log {
    switch (index) {
      case 0:
        return ItemLog(pngFeedLightSyrup, '$logSyrupLight $logSyrup');
      default:
        return ItemLog(pngFeedHeavySyrup, '$logSyrupHeavy $logSyrup');
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
  ItemLog get log {
    switch (index) {
      case 0:
        return ItemLog(pngFeedPattyPollen, logPollen);
      default:
        return ItemLog(pngFeedPattyProtein, logProtein);
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
  List<ItemLog> treatmentLogs = [];
  List<ItemAbout> treatmentInfo = [];

  List<ItemAbout> get info {
    if (treatmentInfo.isNotEmpty) return treatmentInfo;
    treatmentInfo
        .add(ItemAbout(pngQueenStatus, logFullBrood, logFullBroodInfo));
    treatmentInfo
        .add(ItemAbout(pngQueenStatus, logHiveBeetles, logHiveBeetlesInfo));
    treatmentInfo.add(ItemAbout(pngQueenStatus, logNosema, logNosemaInfo));
    treatmentInfo
        .add(ItemAbout(pngQueenStatus, logTrachealMites, logTrachealMitesInfo));
    treatmentInfo
        .add(ItemAbout(pngQueenStatus, logVarroaMites, logVarroaMitesInfo));
    treatmentInfo.add(ItemAbout(pngQueenStatus, logWaxMoths, logWaxMothsInfo));
    return treatmentInfo;
  }

  List<ItemLog> get logs {
    if (treatmentLogs.isNotEmpty) return treatmentLogs;
    treatmentLogs.add(ItemLog(pngQueenStatus, logFullBrood));
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
    for (ItemLog l in treatmentLogs) {
      l.reset();
    }
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
  String? unit;

  ItemHarvest(this.value, this.unit);
}
