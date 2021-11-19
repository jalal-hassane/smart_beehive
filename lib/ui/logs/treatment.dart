import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

const _tag = 'Treatment';

class Treatment extends StatefulWidget {
  final LogTreatment? logTreatment;

  const Treatment({Key? key, required this.logTreatment}) : super(key: key);

  @override
  _Treatment createState() => _Treatment();
}

class _Treatment extends State<Treatment> with TickerProviderStateMixin {
  late LogTreatment? _logTreatment;

  final _controller = ScrollController(keepScrollOffset: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late LogsViewModel _logsViewModel;

  _initViewModel() {
    _logsViewModel = Provider.of<LogsViewModel>(context);
    _logsViewModel.helper = LogsHelper(success: _success, failure: _failure);
  }

  _success() {
    setState(() {});
    logInfo('success');
  }

  _failure(String error) {
    logError('Error $error');
  }

  @override
  Widget build(BuildContext context) {
    _logTreatment = widget.logTreatment;
    _initViewModel();
    _generateTaps();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            logTreatment,
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
                //key: UniqueKey(),
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: all(12),
                children: _logTreatment!.logs2.generateTreatmentsWidgets(_taps),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _logTreatment?.clear();
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
        items: _logTreatment!.info,
        treatment: true,
      )));
  final _taps = <Function()>[];

  _generateTaps() {
    for (ItemTreatment item in _logTreatment!.logs2) {
      f() {
        return context.show((p0) {
          return StatefulBuilder(
            builder: (context, state) {
              return FractionallySizedBox(
                heightFactor: item.treatments.length <= 3
                    ? 0.5
                    : item.treatments.length <= 12
                        ? 0.75
                        : 1,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            item.id!,
                            style: bTS(size: 30, color: colorPrimary),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: item.treatments.length <= 3 ? 5 : 9,
                        child: GridView.count(
                          //key: UniqueKey(),
                          crossAxisCount: 3,
                          children: item.treatments
                              .map((e) => _itemBuilder(e, state))
                              .toList(),
                          shrinkWrap: true,
                          controller: _controller,
                          padding: all(12),
                        ),
                      ),
                      /*Flexible(
                        flex: 5,
                        child: Center(
                          child: ListView.builder(
                            //key: UniqueKey(),
                            itemCount: item.treatments.length,
                            shrinkWrap: true,
                            controller: _controller,
                            padding: all(12),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return _itemBuilder(item.treatments[index], state);
                            },
                          ),
                        ),
                      ),*/
                      Flexible(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            state(() {
                              item.reset();
                            });
                            _logsViewModel.updateLogs();
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
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }, wrap: true);
      }

      _taps.add(f);
    }
  }

  Widget _itemBuilder(CheckableItem item, Function(void Function()) state) {
    return GestureDetector(
      onTap: () {
        state(() {
          item.isChecked = !item.isChecked;
          setState(() {});
          _logsViewModel.updateLogs();
        });
      },
      child: Container(
        width: screenWidth * 0.25,
        margin: trbl(12, 12, 12, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: item.isChecked ? colorGreen : colorWhite,
          shape: BoxShape.rectangle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              offset: const Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            item.description,
            style: rTS(),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
