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

const _tag = 'Feeds';

class Feeds extends StatefulWidget {
  final LogFeeds? logFeeds;

  const Feeds({Key? key, required this.logFeeds}) : super(key: key);

  @override
  _Feeds createState() => _Feeds();
}

class _Feeds extends State<Feeds> {
  late LogFeeds? _logFeeds;

  late LogsViewModel _logsViewModel;

  _initViewModel() {
    _logsViewModel = Provider.of<LogsViewModel>(context);
    _logsViewModel.helper = LogsHelper(success: _success, failure: _failure);
  }

  _success() {
    //setState(() {});
    logInfo('success');
  }

  _failure(String error) {
    logError('Error $error');
  }

  @override
  Widget build(BuildContext context) {
    _logFeeds = widget.logFeeds;
    _initViewModel();
    _generateTaps();
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            logFeeds,
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
                children: _logFeeds!.logs.generateWidgets(_taps),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _logFeeds?.clear();
                  _logsViewModel.updateLogs();
                });
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

  _openAbout() => Navigator.of(context).push(enterFromRight(About(
        items: _logFeeds!.info,
        treatment: false,
      )));

  final _taps = <Function()>[];

  _generateTaps() {
    for (ItemLog item in _logFeeds!.logs) {
      Function() f;
      switch (item.id) {
        case logHoney:
          f = () {
            if (_logFeeds!.honey == null) {
              _logFeeds!.honey = true;
            } else {
              _logFeeds!.honey = !_logFeeds!.honey!;
            }
            String icon = _logFeeds!.honey! ? pngFeedHoneyActive : pngFeedHoney;
            _logFeeds!.logs[1].setIcon(icon, _logFeeds!.honey!);
            setState(() {});
            _logsViewModel.updateLogs();
          };
          break;
        case logProbiotics:
          f = () {
            if (_logFeeds!.probiotics == null) {
              _logFeeds!.probiotics = true;
            } else {
              _logFeeds!.probiotics = !_logFeeds!.probiotics!;
            }
            String icon = _logFeeds!.probiotics!
                ? pngFeedProbioticsActive
                : pngFeedProbiotics;
            _logFeeds!.logs.last.setIcon(icon, _logFeeds!.probiotics!);
            setState(() {});
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
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            padding: all(12),
                            children: _processItem(item, state),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            state(() {
                              _resetItem(item);
                            });
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
        case logSyrup:
          _logFeeds?.syrup = null;
          break;
        default:
          _logFeeds?.patty = null;
      }
    });
  }

  _processItem(ItemLog itemLog, Function(void Function()) setState) {
    switch (itemLog.id) {
      case logSyrup:
        return _syrupWidgets(itemLog);
      default:
        return _pattyWidgets(itemLog);
    }
  }

  _syrupWidgets(ItemLog itemLog) {
    f(String icon, String title, SyrupType syrup) {
      for (ItemLog it in SyrupTypes.logs) {
        it.isActive = false;
      }
      Navigator.pop(context);
      _logsViewModel.updateLogs();
      setState(() {
        _logFeeds!.syrup = syrup;
        itemLog.setData(icon, title);
      });
    }

    return SyrupTypes.logs.generateSyrupWidgets(f);
  }

  _pattyWidgets(ItemLog itemLog) {
    f(String icon, String title, PattyType pattyType) {
      for (ItemLog it in PattyTypes.logs) {
        it.isActive = false;
      }
      Navigator.pop(context);
      _logsViewModel.updateLogs();
      setState(() {
        _logFeeds!.patty = pattyType;
        itemLog.setData(icon, title);
      });
    }

    return PattyTypes.logs.generatePattyWidgets(f);
  }
}
