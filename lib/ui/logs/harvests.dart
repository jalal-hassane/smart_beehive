import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/composite/widgets.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/ui/global/harvest_history.dart';
import 'package:smart_beehive/ui/hive/logs/logs_viewmodel.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../../main.dart';

const _tag = 'Harvests';

class Harvests extends StatefulWidget {
  final LogHarvests? logHarvests;

  const Harvests({Key? key, required this.logHarvests}) : super(key: key);

  @override
  _Harvests createState() => _Harvests();
}

class _Harvests extends State<Harvests> {
  late LogHarvests? _logHarvests;
  Unit _unit = Unit.g;
  late TextEditingController _textController;

  double get _saveOpacity {
    if (_logHarvests?.isActive ?? false) return 1.0;
    return 0.5;
  }

  final _unitExpandableController = ExpandableController();

  late LogsViewModel _logsViewModel;

  _initViewModel() {
    _logsViewModel = Provider.of<LogsViewModel>(context);
    _logsViewModel.helper = LogsHelper(success: _success, failure: _failure);
  }

  _success() {
    logInfo('success');
  }

  _failure(String error) {
    logError('Error $error');
  }

  @override
  Widget build(BuildContext context) {
    _logHarvests = widget.logHarvests;
    _initViewModel();
    _generateTaps();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            logHarvests,
            style: mTS(),
          ),
          actions: [
            Container(
              margin: right(12),
              child: IconButton(
                icon: const Icon(
                  Icons.history,
                  color: colorBlack,
                ),
                onPressed: () => _openHarvestHistory(),
              ),
            ),
          ],
          centerTitle: true,
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
                children: _logHarvests!.logs2.generateHarvestsWidgets(_taps),
              ),
            ),
            Column(
              children: [
                AbsorbPointer(
                  absorbing: _saveOpacity == 0.5,
                  child: Opacity(
                    opacity: _saveOpacity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _saveHarvest();
                        });
                      },
                      style: buttonStyle,
                      child: SizedBox(
                        width: screenWidth * 0.5,
                        height: screenHeight * 0.056,
                        child: Center(
                          child: Text(
                            textSaveHarvest,
                            style: mTS(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: top(16),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _logHarvests?.clear();
                        _logsViewModel.updateLogs();
                      });
                    },
                    child: SizedBox(
                      width: screenWidth * 0.35,
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
          ],
        ),
      ),
    );
  }

  _openHarvestHistory() => Navigator.of(context).push(
        enterFromRight(
          HarvestHistory(
            history: _logHarvests!.history,
          ),
        ),
      );

  final _taps = <Function()>[];

  _generateSingleTap(ItemHarvest itemHarvest) {
    if (itemHarvest.value != null) {
      _textController =
          TextEditingController(text: itemHarvest.value.toString());
    } else {
      _textController = TextEditingController();
    }
    if (itemHarvest.unit != null) {
      _unit = itemHarvest.unit!;
    } else {
      _unit = Unit.g;
    }
  }

  _generateTaps() {
    for (ItemHarvest item in _logHarvests!.logs2) {
      f() {
        _generateSingleTap(item);
        return context.show(
          (p0) {
            return StatefulBuilder(
              builder: (con, state) {
                return FractionallySizedBox(
                  heightFactor: 0.75,
                  child: Scaffold(
                    body: WillPopScope(
                      onWillPop: () async {
                        _toggleController();
                        return true;
                      },
                      child: GestureDetector(
                        onTap: () {
                          logInfo('tap');
                          unFocus(con);
                        },
                        onPanDown: (details) {
                          _toggleController();
                          unFocus(con);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                              child: Text(
                                item.id!,
                                style: bTS(size: 30, color: colorPrimary),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: left(16),
                                  child: Text(
                                    textUnit,
                                    style: bTS(),
                                  ),
                                ),
                                Container(
                                  margin: symmetric(4, 16),
                                  padding: left(8),
                                  decoration: BoxDecoration(
                                    color: colorBgTextField,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ExpandableNotifier(
                                    controller: _unitExpandableController,
                                    child: Padding(
                                      padding: symmetric(4, 0),
                                      child: ScrollOnExpand(
                                        child: Column(
                                          children: <Widget>[
                                            ExpandablePanel(
                                              theme: const ExpandableThemeData(
                                                headerAlignment:
                                                    ExpandablePanelHeaderAlignment
                                                        .center,
                                                tapBodyToExpand: false,
                                                tapBodyToCollapse: false,
                                                hasIcon: false,
                                              ),
                                              header: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _unit.description,
                                                      style: rTS(),
                                                    ),
                                                  ),
                                                  ExpandableIcon(
                                                    theme:
                                                        const ExpandableThemeData(
                                                      expandIcon:
                                                          Icons.arrow_drop_down,
                                                      collapseIcon:
                                                          Icons.arrow_drop_down,
                                                      iconColor: colorPrimary,
                                                      iconSize: 24.0,
                                                      hasIcon: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              collapsed: Container(),
                                              expanded: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: _dropDown(state),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                sheetTextField(
                                  screenWidth,
                                  screenHeight,
                                  _textController,
                                  item.title,
                                  type: const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                  last: true,
                                  submit: (string) => _closeSheetAndSave(item),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  margin: bottom(10),
                                  child: ElevatedButton(
                                    onPressed: () => _closeSheetAndSave(item),
                                    style: buttonStyle,
                                    child: SizedBox(
                                      width: screenWidth * 0.4,
                                      height: screenHeight * 0.056,
                                      child: Center(
                                        child: Text(
                                          textSave,
                                          style: mTS(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    state(() {
                                      item.reset();
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: SizedBox(
                                    width: screenWidth * 0.3,
                                    height: screenHeight * 0.05,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      }

      _taps.add(f);
    }
  }

  _toggleController() {
    if (_unitExpandableController.expanded) {
      _unitExpandableController.toggle();
    }
  }

  _saveHarvest() async {
    final List<ItemHarvest> _history = [];
    for (ItemHarvest item in _logHarvests!.harvests) {
      if (item.isActive) {
        final harv = ItemHarvest(item.icon, item.title)
          ..value = item.value
          ..unit = item.unit;
        _history.add(harv);
      }
    }

    _logHarvests!.history.add(ItemHarvestHistory(_history));
    _logHarvests!.clear();
    setState(() {});
    _logsViewModel.updateLogs();
  }

  _closeSheetAndSave(ItemHarvest item) {
    Navigator.pop(context);
    logInfo('Closing');
    final harvest = _textController.text.toString();
    try {
      final dHarvest = double.parse(harvest);
      setState(() {
        final index = _logHarvests!.logs2.indexOf(item);
        String icon;
        switch (index) {
          case 0:
            icon = pngHarvestsBeeswaxActive;
            break;
          case 1:
            icon = pngHarvestsHoneycombActive;
            break;
          case 2:
            icon = pngHarvestsHoneyActive;
            break;
          case 3:
            icon = pngHarvestsPollenActive;
            break;
          case 4:
            icon = pngHarvestsPropolisActive;
            break;
          default:
            icon = pngHarvestsRoyalJellyActive;
        }
        item.setData(dHarvest, _unit, icon);
        //_logHarvests!.logs[index].setIcon(icon, true);
      });

      _textController.clear();
      logInfo('harvests ${_logHarvests?.toMap()}');
      _logsViewModel.updateLogs();
      setState(() {});
    } catch (e) {
      showSnackBar(context, 'Value entered is malformed!');
    }
  }

  _dropDownItemWidget2(String value) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: all(10),
      decoration: BoxDecoration(
        color: colorBgTextField,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        value,
        style: rTS(size: 12),
      ),
    );
  }

  _dropDown(void Function(void Function()) state) {
    final widgets = <Widget>[];
    for (Unit unit in Unit.values) {
      widgets.add(GestureDetector(
        onTap: () {
          state(() {
            _unit = unit;
          });
        },
        child: _dropDownItemWidget2(unit.description),
      ));
      if (unit != Unit.values.last) {
        widgets.add(divider);
      }
    }
    return widgets;
  }
}
