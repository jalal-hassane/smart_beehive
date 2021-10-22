import 'dart:ui';

import 'package:date_format/date_format.dart';
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

  toMap(){}
  static HiveLogs fromMap(Map<String,dynamic> map){
    return HiveLogs();
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
  ItemHarvest? beeswax = ItemHarvest(pngHarvestsBeeswax, logBeeswax);
  ItemHarvest? honeyComb = ItemHarvest(pngHarvestsHoneycomb, logHoneycomb);
  ItemHarvest? honey = ItemHarvest(pngHarvestsHoney, logHoney);
  ItemHarvest? pollen = ItemHarvest(pngHarvestsPollen, logPollen);
  ItemHarvest? propolis = ItemHarvest(pngHarvestsPropolis, logPropolis);
  ItemHarvest? royalJelly = ItemHarvest(pngHarvestsRoyalJelly, logRoyalJelly);

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
    harvests.add(beeswax!);
    harvests.add(honeyComb!);
    harvests.add(honey!);
    harvests.add(pollen!);
    harvests.add(propolis!);
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
}

class ItemHarvestHistory {
  DateTime date = DateTime.now();
  List<ItemHarvest>? history;

  final mFormat = [M];
  final yFormat = [yyyy];
  String get month{
    return formatDate(date, mFormat);
  }

  int get year{
    return int.parse(formatDate(date, yFormat));
  }

  ItemHarvestHistory(this.history);
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

enum MonthFilter { all, jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec }

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
  ItemTreatment? foulBrood = ItemTreatment.foulBroodTreatment(
      pngFoulbrood, logFoulBrood, pngFoulbroodActive);
  ItemTreatment? hiveBeetles = ItemTreatment.hiveBeetlesTreatment(
      pngHiveBeetles, logHiveBeetles, pngHiveBeetlesActive);
  ItemTreatment? nosema =
      ItemTreatment.nosemaTreatment(pngNosema, logNosema, pngNosemaActive);
  ItemTreatment? trachealMites = ItemTreatment.trachealMitesTreatment(
      pngTrachealMites, logTrachealMites, pngTrachealMitesActive);
  ItemTreatment? varroaMites = ItemTreatment.varroaMitesTreatment(
      pngVarroaMites, logVarroaMites, pngVarroaMitesActive);
  ItemTreatment? waxMoths = ItemTreatment.waxMothsTreatment(
      pngWaxMoths, logWaxMoths, pngWaxMothsActive);

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
    treatmentLogs2.add(foulBrood!);
    treatmentLogs2.add(hiveBeetles!);
    treatmentLogs2.add(nosema!);
    treatmentLogs2.add(trachealMites!);
    treatmentLogs2.add(varroaMites!);
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

extension GetUnit on String {
  Unit get unitFromString {
    switch (this) {
      case logG:
        return Unit.g;
      case logKg:
        return Unit.kg;
      case logOz:
        return Unit.oz;
      case logLbs:
        return Unit.lbs;
      default:
        return Unit.frames;
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

  ItemTreatment.foulBroodTreatment(
      this.icon, this.description, this.activeIcon) {
    id = description;
    _treatments.add(CheckableItem(logTerraPatties));
    _treatments.add(CheckableItem(logTerraPro));
    _treatments.add(CheckableItem(logTerramycin));
    _treatments.add(CheckableItem(logTetraBeeMix));
    _treatments.add(CheckableItem(logTylan));
  }

  ItemTreatment.hiveBeetlesTreatment(
      this.icon, this.description, this.activeIcon) {
    id = description;
    _treatments.add(CheckableItem(logDiatomacsiousEarth));
    _treatments.add(CheckableItem(logGardStar));
    _treatments.add(CheckableItem(logPermethrinSFR));
  }

  ItemTreatment.nosemaTreatment(this.icon, this.description, this.activeIcon) {
    id = description;
    _treatments.add(CheckableItem(logFumidilB));
  }

  ItemTreatment.trachealMitesTreatment(
      this.icon, this.description, this.activeIcon) {
    id = description;
    _treatments.add(CheckableItem(logMiteAThol));
  }

  ItemTreatment.varroaMitesTreatment(
      this.icon, this.description, this.activeIcon) {
    id = description;
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

  ItemTreatment.waxMothsTreatment(
      this.icon, this.description, this.activeIcon) {
    id = description;
    _treatments.add(CheckableItem(logB401));
    _treatments.add(CheckableItem(logParaMoth));
  }
}

class CheckableItem {
  String description;
  bool isChecked = false;

  CheckableItem(this.description);
}
