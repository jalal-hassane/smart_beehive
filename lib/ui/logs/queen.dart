import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/ui/global/about.dart';
import 'package:smart_beehive/ui/hive/logs/logs_viewmodel.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../../main.dart';

const _tag = 'Queen';

class Queen extends StatefulWidget {
  final LogQueen? logQueen;

  const Queen({Key? key, required this.logQueen}) : super(key: key);

  @override
  _Queen createState() => _Queen();
}

class _Queen extends State<Queen> {
  late LogQueen? _logQueen;

  late LogsViewModel _logsViewModel;

  _initViewModel(){
    _logsViewModel = Provider.of<LogsViewModel>(context);
    _logsViewModel.helper = LogsHelper(success: _success, failure: _failure);
  }

  _success(){
    setState(() {});
    logInfo('success');
  }

  _failure(String error){
    logError('Error $error');
  }

  @override
  Widget build(BuildContext context) {
    _logQueen = widget.logQueen;
    _initViewModel();
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: GridView.count(
                key: UniqueKey(),
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: all(12),
                children: _logQueen!.logs.generateWidgets(_taps),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                _logQueen?.clear();
                _logsViewModel.updateLogs();
              },
              style: buttonStyle,
              child: SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.056,
                child: Center(
                  child: Text(
                    textClear,
                    style: mTS(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openAbout() =>
      Navigator.of(context).push(enterFromRight(About(items: _logQueen!.info,treatment: false,)));

  final _taps = <Function()>[];

  _generateTaps() {
    for (ItemLog item in _logQueen!.logs) {
      Function() f;
      switch (item.id) {
        case logQueenWings:
          f = () {
            if (_logQueen!.wingsClipped == null) {
              _logQueen!.wingsClipped = true;
            } else {
              _logQueen!.wingsClipped = !_logQueen!.wingsClipped!;
            }
            String icon =
                _logQueen!.wingsClipped! ? pngQueenWingsClipped : pngQueenWings;
            String title = _logQueen!.wingsClipped!
                ? logQueenWingsClipped
                : logQueenWingsNotClipped;
            _logQueen!.logs[1].setData(icon, title);

            _logsViewModel.updateLogs();
          };
          break;
        case logQueenExcluder:
          f = () {
            if (_logQueen!.queenExcluder == null) {
              _logQueen!.queenExcluder = true;
            } else {
              _logQueen!.queenExcluder = !_logQueen!.queenExcluder!;
            }
            String icon = _logQueen!.queenExcluder!
                ? pngQueenExcluderActive
                : pngQueenExcluder;
            String title =
                _logQueen!.queenExcluder! ? logExcluder : logNoExcluder;
            _logQueen!.logs.last.setData(icon, title);
            _logsViewModel.updateLogs();
          };
          break;
        default:
          f = () {
            return context.show((p0) {
              return StatefulBuilder(
                builder: (context, state) {
                  return FractionallySizedBox(
                    heightFactor: 0.75,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          item.id!,
                          style: bTS(size: 30, color: colorPrimary),
                        ),
                        Center(
                          child: GridView.count(
                            key: UniqueKey(),
                            crossAxisCount: 3,
                            shrinkWrap: true,
                            padding: all(12),
                            children: _processItem(item, state),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _resetItem(item);
                            Navigator.pop(context);
                          },
                          style: buttonStyle,
                          child: SizedBox(
                            width: screenWidth * 0.4,
                            height: screenHeight * 0.056,
                            child: Center(
                              child: Text(
                                textClear,
                                style: mTS(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            });
          };
      }
      _taps.add(f);
    }
  }

  _resetItem(ItemLog item) {
    setState(() {
      item.reset();
      switch (item.id) {
        case logQueenStatus:
          _logQueen?.status = null;
          break;
        case logQueenMarking:
          _logQueen?.marking = null;
          break;
        case logCells:
          _logQueen?.cells = null;
          break;
        default:
          _logQueen?.swarmStatus = null;
      }
    });
    _logsViewModel.updateLogs();
  }

  _processItem(ItemLog itemLog, Function(void Function()) setState) {
    switch (itemLog.id) {
      case logQueenStatus:
        return _queenStatusWidgets(itemLog, setState);
      case logQueenMarking:
        return _markingWidgets(itemLog);
      case logCells:
        return _cellsWidgets(itemLog);
      default:
        return _swarmStatusWidgets(itemLog);
    }
  }

  _itemLogWidget(String icon, String text) {}

  _queenStatusWidgets(ItemLog itemLog, Function(void Function()) state) {
    f(String icon, String title, QueenStatus status,Color? color) {
      for (ItemLog it in Status.logs) {
        it.isActive = false;
      }
      Navigator.pop(context);
        _logQueen!.status = status;
        itemLog.setData(icon, title);
        itemLog.setColor(color);
        _logsViewModel.updateLogs();
    }

    return Status.logs.generateQueenStatusWidgets(f);
  }

  _markingWidgets(ItemLog itemLog) {
    f(String icon, String title, QueenMarking marking) {
      for (ItemLog it in Marking.logs) {
        it.isActive = false;
      }

      Navigator.pop(context);
        _logQueen!.marking = marking;
        itemLog.setData(icon, title);
        _logsViewModel.updateLogs();
    }

    return Marking.logs.generateMarkingWidgets(f);
  }

  _cellsWidgets(ItemLog itemLog) {
    f(String icon, String title, QueenCells cells) {
      for (ItemLog it in Cells.logs) {
        it.isActive = false;
      }
      Navigator.pop(context);
        _logQueen!.cells = cells;
        itemLog.setData(icon, title);
        _logsViewModel.updateLogs();
    }

    return Cells.logs.generateCellsWidgets(f);
  }

  _swarmStatusWidgets(ItemLog itemLog) {
    f(String icon, String title, SwarmStatus status,Color? color) {
      for (ItemLog it in Swarm.logs) {
        it.isActive = false;
      }
      Navigator.pop(context);
        _logQueen!.swarmStatus = status;
        itemLog.setData(icon, title);
        itemLog.setColor(color);
        _logsViewModel.updateLogs();
    }

    return Swarm.logs.generateSwarmStatusWidgets(f);
  }
}
