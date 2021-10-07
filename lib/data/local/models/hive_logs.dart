import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/strings.dart';

class HiveLogs {
  LogQueen? queen = LogQueen();
  LogHarvests? harvests;
  LogFeeds? feeds;
  LogTreatment? treatment;
  LogGeneral? general;
  LogWintering? wintering;
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
      ItemAbout('', logQueenStatus, logQueenStatusInfo);
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
      ItemAbout('', logQueenMarking, logQueenMarkingInfo);
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
        return ItemAbout('', '$logCellSupersedure Cells', logCellSupersedureInfo);
      case 2:
        return ItemAbout('', '$logCellSwarm Cells', logCellSwarmInfo);
      case 3:
        return ItemAbout('', '$logCellLayingWorker Cells', logCellLayingWorkerInfo);
      case 4:
        return ItemAbout('', '$logCellDrone Cells', logCellDroneInfo);
      default:
        return ItemAbout('', '$logCellYoungestBrood Cells', logCellYoungestBroodInfo);
    }
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
      ItemAbout('', logSwarmStatus, logSwarmStatusInfo);
}

class LogQueen {
  QueenStatus? status;
  QueenMarking? marking;
  QueenCells? cells;
  SwarmStatus? swarmStatus;
  bool? wingsClipped;
  bool? queenExcluder;

  List<ItemAbout> get info {
    final res = <ItemAbout>[];
    res.add(Status.info);
    res.add(
      ItemAbout('', logQueenWings, logQueenWingsInfo),
    );
    res.add(Marking.info);
    res.add(QueenCells.supersedure.info);
    res.add(QueenCells.swarm.info);
    res.add(QueenCells.layingWorker.info);
    res.add(QueenCells.drone.info);
    res.add(QueenCells.youngestBrood.info);
    res.add(Swarm.info);
   // item about wings
    res.add(
      ItemAbout('', logQueenExcluder, logQueenExcluderInfo),
    ); // item about excluder
    return res;
  }
}

class LogHarvests {}

class LogFeeds {}

class LogTreatment {}

class LogGeneral {}

class LogWintering {}

class ItemAbout {
  final String icon;
  final String title;
  final String description;

  ItemAbout(this.icon, this.title, this.description);
}
