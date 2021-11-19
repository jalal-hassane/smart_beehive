import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/composite/widgets.dart';
import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../../../main.dart';
import 'alerts_viewmodel.dart';

const _tag = 'Alerts';

class Alerts extends StatefulWidget {
  final Beehive hive;

  const Alerts({Key? key, required this.hive}) : super(key: key);

  @override
  _Alerts createState() => _Alerts();
}

class _Alerts extends State<Alerts> with TickerProviderStateMixin {
  late Beehive _hive;
  final _lowestController = TextEditingController();
  final _highestController = TextEditingController();
  AlertType _alertType = AlertType.temperature;

  late AlertsViewModel _alertsViewModel;
  final _alertExpandableController = ExpandableController();

  @override
  void initState() {
    super.initState();
    _hive = widget.hive;
  }

  @override
  Widget build(BuildContext context) {
    _initViewModel();
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            alerts,
            style: mTS(),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addAlert,
          child: const Icon(
            Icons.add,
            color: colorBlack,
          ),
          backgroundColor: colorPrimary,
        ),
        body: Column(
          children: [
            Expanded(
              child: _checkAlerts(),
            ),
          ],
        ),
      ),
    );
  }

  _checkAlerts() {
    if (_hive.properties.alerts.isNotEmpty) {
      logInfo("Alerts ${_hive.properties.alerts.length}");
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        padding: all(8),
        children: [
          for (Alert i in _hive.properties.alerts) _alertWidget(i),
        ],
      );
    } else {
      // show add widget
      return GestureDetector(
        onTap: _addAlert,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                pngAlert,
                width: 100,
                height: 100,
              ),
              Text(
                textNoAlertsHint,
                textAlign: TextAlign.center,
                style: mTS(),
              ),
            ],
          ),
        ),
      );
    }
  }

  _alertWidget(Alert alert) {
    //final beehive = beehives[widget.index];

    return GestureDetector(
      onTap: () => _addAlert(edit: true, alert: alert),
      child: Container(
        margin: all(12),
        decoration: BoxDecoration(
          color: colorWhite,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              offset: const Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: FractionallySizedBox(
                heightFactor: 0.5,
                child: Image.asset(
                  alert.icon ?? '',
                ),
              ),
            ),
            Expanded(
                child: Text(
              alert.type?.description ?? '',
              style: bTS(),
            )),
            Expanded(
              child: Text(
                alert.description,
                style: mTS(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _removeAlert(Alert alert) {
    _hive.properties.alerts.remove(alert);
    _alertsViewModel.updateProperties();
  }

  _addAlert({bool edit = false, Alert? alert}) {
    if (edit) {
      _alertType = alert!.type!;
      _lowestController.text = alert.lowerBound!.toString();
      _highestController.text = alert.upperBound!.toString();
      setState(() {});
    }
    context.show((_) {
      return StatefulBuilder(
        builder: (con, state) {
          return FractionallySizedBox(
            heightFactor: 0.75,
            child: Scaffold(
              body: WillPopScope(
                // todo fix onWillPop preventing bottom sheet from dragging
                onWillPop: () async {
                  _toggleController();
                  _alertType = AlertType.temperature;
                  _lowestController.clear();
                  _highestController.clear();
                  return true;
                },
                child: GestureDetector(
                  onTap: () => unFocus(con),
                  onPanDown: (details) {
                    _toggleController();
                    unFocus(con);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        edit ? textEditAlert : textCreateAlert,
                        style: bTS(size: 30, color: colorPrimary),
                      ),
                      SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: bottom(10),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: left(16),
                                    child: Text(
                                      textType,
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
                                      controller: _alertExpandableController,
                                      child: Padding(
                                        padding: symmetric(4, 0),
                                        child: ScrollOnExpand(
                                          child: Column(
                                            children: <Widget>[
                                              ExpandablePanel(
                                                theme:
                                                    const ExpandableThemeData(
                                                  headerAlignment:
                                                      ExpandablePanelHeaderAlignment
                                                          .center,
                                                  tapHeaderToExpand: true,
                                                  tapBodyToExpand: true,
                                                  tapBodyToCollapse: false,
                                                  hasIcon: false,
                                                ),
                                                header: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        _alertType.description,
                                                        style: rTS(
                                                          color: colorBlack,
                                                        ),
                                                      ),
                                                    ),
                                                    ExpandableIcon(
                                                      theme:
                                                          const ExpandableThemeData(
                                                        expandIcon: Icons
                                                            .arrow_drop_down,
                                                        collapseIcon: Icons
                                                            .arrow_drop_down,
                                                        iconColor: colorPrimary,
                                                        iconSize: 24.0,
                                                        hasIcon: false,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                collapsed: Container(),
                                                expanded: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: _dropDown(state),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: bottom(10),
                              child: _sheetItemWidget(
                                  _lowestController, textLowest),
                            ),
                            _sheetItemWidget(
                              _highestController,
                              textHighest,
                              isLast: true,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                _createAlert(edit: edit, alert: alert),
                            style: buttonStyle,
                            child: SizedBox(
                              width: screenWidth * 0.4,
                              height: screenHeight * 0.056,
                              child: Center(
                                child: Text(
                                  edit ? textSaveAlert : textCreateAlert,
                                  style: mTS(),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: edit,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(con);
                                _removeAlert(alert!);
                              },
                              child: Container(
                                margin: top(16),
                                child: Center(
                                  child: Text(
                                    textRemove,
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
              ),
            ),
          );
        },
      );
    });
  }

  _toggleController() {
    if (_alertExpandableController.expanded) {
      _alertExpandableController.toggle();
    }
  }

  _sheetItemWidget(
    TextEditingController controller,
    String text, {
    TextInputType type = const TextInputType.numberWithOptions(decimal: true),
    bool isLast = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: left(16),
          child: Text(
            text,
            style: boTS(),
          ),
        ),
        sheetTextField(
          screenWidth,
          screenHeight,
          controller,
          text,
          type: type,
          last: isLast,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*"))
          ],
        ),
      ],
    );
  }

  _createAlert({bool edit = false, Alert? alert}) {
    final lowest = _lowestController.text;
    final highest = _highestController.text;
    try {
      assert(!lowest.isNullOrEmpty);
      assert(!highest.isNullOrEmpty);
    } catch (e) {
      _showError('All fields are required');
      logError(e.toString());
      return;
    }

    final lb = double.parse(lowest.toString());
    final ub = double.parse(highest.toString());

    try {
      assert(lb < ub);
    } catch (e) {
      _showError('Lowest should be less than highest');
      logError(e.toString());
      return;
    }

    if (edit) {
      alert!.type = _alertType;
      alert.lowerBound = lb;
      alert.upperBound = ub;
      Navigator.pop(context);
    } else {
      _hive.properties.alerts.insert(
        0,
        Alert(
          t: _alertType,
          lb: lb,
          ub: ub,
        ),
      );

      _lowestController.clear();
      _highestController.clear();
    }

    //_listKey.currentState?.insertItem(0);

    _alertsViewModel.updateProperties();
  }

  _initViewModel() {
    _alertsViewModel = Provider.of<AlertsViewModel>(context);
    _alertsViewModel.helper =
        AlertsHelper(success: _success, failure: _failure);
  }

  _success() {
    setState(() {});
    logInfo('alert: added successfully');
  }

  _failure(String error) {
    showSnackBar(context, error);
    logError('alert: $error');
  }

  _showError(String content) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Error',
            style: mTS(size: 18),
          ),
          content: Text(
            content,
            style: rTS(),
          ),
          actions: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                textOk,
                style: rTS(),
              ),
            ),
          ],
          actionsPadding: all(8),
        );
      },
    );
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
    final alerts = <AlertType>[];
    alerts.addAll(AlertType.values);
    alerts.removeLast();
    final widgets = <Widget>[];
    for (AlertType alert in alerts) {
      widgets.add(GestureDetector(
        onTap: () {
          state(() {
            _alertType = alert;
          });
        },
        child: _dropDownItemWidget2(alert.description),
      ));
      if (alert != alerts.last) {
        widgets.add(divider);
      }
    }
    return widgets;
  }
}
