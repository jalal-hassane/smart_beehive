import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/strings.dart';

class HiveLogs {
  Queen? queen;
  Harvests? harvests;
  Feeds? feeds;
  Treatments? treatments;
  Standard? standard;
  Wintering? wintering;
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

  static String get info => logQueenStatusInfo;
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

  static String get info => logQueenMarkingInfo;
}

enum QueenCells {
  emergency,
  supersedure,
  swarm,
  layingWorker,
  drone,
  youngestBrood
}

extension Cells on QueenCells{
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

  String get info{
    switch (index) {
      case 0:
        return '';
      case 1:
        return logCellSupersedureInfo;
      case 2:
        return logCellSwarmInfo;
      case 3:
        return logCellLayingWorkerInfo;
      case 4:
        return logCellDroneInfo;
      default:
        return logCellYoungestBroodInfo;
    }
  }
}

enum SwarmStatus { notSwarming, preSwarming, swarming }

extension Swarm on SwarmStatus{
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

  static String get info => logSwarmStatusInfo;

}
class Queen {
  QueenStatus? status;
  QueenMarking? marking;
  QueenCells? cells;
  SwarmStatus? swarmStatus;
  bool? wingsClipped;
  bool? queenExcluder;
}

class Harvests {}

class Feeds {}

class Treatments {}

class Standard {}

class Wintering {}
