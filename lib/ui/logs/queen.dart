import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/ui/global/about.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

const _tag = 'Queen';

class Queen extends StatefulWidget {
  final LogQueen? logQueen;

  const Queen({Key? key, required this.logQueen}) : super(key: key);

  @override
  _Queen createState() => _Queen();
}

class _Queen extends State<Queen> {
  late LogQueen? _logQueen;

  @override
  Widget build(BuildContext context) {
    _logQueen = widget.logQueen;
    _generateTaps();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            logQueen,
            style: mTS(),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: right(12),
              child: IconButton(
                icon: const Icon(
                  Icons.info_rounded,
                  color: colorBlack,
                ),
                onPressed: () => _openAbout(),
              ),
            ),
          ],
        ),
        body: Center(
          child: GridView.count(
            key: UniqueKey(),
            crossAxisCount: 3,
            shrinkWrap: true,
            padding: all(12),
            children: _logQueen!.logs.generateWidgets(_taps),
          ),
        ),
      ),
    );
  }

  _openAbout() =>
      Navigator.of(context).push(enterFromRight(About(items: _logQueen!.info)));

  final _taps = <Function()>[];

  _generateTaps() {
    for (ItemLog item in _logQueen!.logs) {
      Function() f;
      switch (item.title) {
        case logQueenWings:
          f = () {
            if (_logQueen!.wingsClipped == null) {
              _logQueen!.wingsClipped = true;
            } else {
              _logQueen!.wingsClipped = !_logQueen!.wingsClipped!;
            }
            logInfo("Clicking wings");
            setState((){});
          };
          break;
        case logQueenExcluder:
          f = () {
            if (_logQueen!.queenExcluder == null) {
              _logQueen!.queenExcluder = true;
            } else {
              _logQueen!.queenExcluder = !_logQueen!.queenExcluder!;
            }
            logInfo("Clicking excluder");
            _logQueen!.queenExcluder = true;
            setState((){});
          };
          break;
        default:
          f = () {
            return context.showCustomBottomSheet((p0) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        item.title,
                        style: bTS(size: 30, color: colorPrimary),
                      ),
                      Center(
                        child: GridView.count(
                          key: UniqueKey(),
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          padding: all(12),
                          children: _processItem(item,setState),
                        ),
                      ),
                    ],
                  );
                },
              );
            });
          };
      }
      _taps.add(f);
    }
  }

  _processItem(ItemLog itemLog,Function(void Function()) setState) {
    switch (itemLog.title) {
      case logQueenStatus:
        return _generateStatusWidgets(itemLog,setState);
      case logQueenMarking:
        return _generateMarkingWidgets(itemLog);
      case logCells:
        return _generateCellsWidgets(itemLog);
      default:
        return _generateSwarmStatusWidgets(itemLog);
    }
  }

  _itemLogWidget(String icon, String text) {}

  _generateStatusWidgets(ItemLog itemLog,Function(void Function()) setState) {
    f() {
      logInfo('init f');
      for (ItemLog it in Status.logs) {
        it.isActive = false;
        logInfo('${it.title} isActive ${it.isActive}');
      }
      _logQueen!.status = QueenStatus.queenLess;

      setState((){itemLog.isActive = true;});
      Navigator.pop(context);
    }

    return Status.logs.generateSameTapWidgets(f,setState);
  }

  _generateMarkingWidgets(ItemLog itemLog) {
    return Column(
      children: [
        Text(
          itemLog.title,
          style: bTS(size: 30, color: colorPrimary),
        ),
      ],
    );
  }

  _generateCellsWidgets(ItemLog itemLog) {
    return Column(
      children: [
        Text(
          itemLog.title,
          style: bTS(size: 30, color: colorPrimary),
        ),
      ],
    );
  }

  _generateSwarmStatusWidgets(ItemLog itemLog) {
    return Column(
      children: [
        Text(
          itemLog.title,
          style: bTS(size: 30, color: colorPrimary),
        ),
      ],
    );
  }
}
