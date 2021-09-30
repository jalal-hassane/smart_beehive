import 'dart:ui';

class HiveLogs{
  Queen? queen;
  Harvests? harvests;
  Feeds? feeds;
  Treatments? treatments;
  Standard? standard;
  Wintering? wintering;
}
enum QUEEN_STATUS{
  QUEENRIGHT,QUEENLESS,TIME_TO_REQUEEN,QUEEN_REPLACED
}
class Queen{
  String? status;
  bool? wingsClipped;
  Color? marking;
  String? cells;
  String? swarmStatus;
  bool? queenExcluder;
}
class Harvests{}
class Feeds{}
class Treatments{}
class Standard{}
class Wintering{}