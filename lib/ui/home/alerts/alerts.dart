import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
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
            Icons.add_alarm,
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
    if (_hive.properties.alerts!.isNotEmpty) {
      logInfo("Alerts ${_hive.properties.alerts!.length}");
      return ListView.builder(
        itemCount: _hive.properties.alerts!.length,
        shrinkWrap: true,
        padding: all(8),
        itemBuilder: (context, index) {
          return _alertWidget(index);
        },
      );
    } else {
      // show add widget
      return GestureDetector(
        onTap: _addAlert,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_alarm,
                size: 100,
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

  _alertWidget(int index) {
    //final beehive = beehives[widget.index];
    final alert = _hive.properties.alerts![index];

    return Slidable(
      actionPane: const SlidableScrollActionPane(),
      closeOnScroll: true,
      secondaryActions: [
        /*_secondaryActionWidget(
          Icons.volume_up_rounded,
          btChange,
          () => _changeSound(index),
        ),*/
        _secondaryActionWidget(
          Icons.delete_forever,
          btRemove,
          () => _removeAlert(index),
        ),
      ],
      actionExtentRatio: 1 / 5,
      child: GestureDetector(
        onTap: () => _addAlert(edit: true, alert: alert),
        child: SizedBox(
          height: screenHeight * 0.1,
          child: Card(
            margin: bottom(10),
            shadowColor: colorPrimary,
            elevation: 2,
            child: ListTile(
              horizontalTitleGap: 10,
              leading: SizedBox(
                height: double.maxFinite,
                child: _alertLeadingIcon(alert),
              ),
              title: Center(
                child: Text(
                  alert.description,
                  style: rTS(size: 16),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _secondaryActionWidget(
    IconData icon,
    String caption,
    Function()? onTap,
  ) {
    return Container(
      margin: bottom(10),
      child: IconSlideAction(
        color: colorBlack,
        icon: icon,
        caption: caption,
        foregroundColor: colorPrimary,
        onTap: onTap,
      ),
    );
  }

  _removeAlert(int index) {
    _hive.properties.alerts?.removeAt(index);
    _alertsViewModel.updateProperties();
  }

  _changeSound(int index) {}

  _alertLeadingIcon(Alert alert) {
    Widget _icon;
    if (alert.svg != null) {
      if (alert.svg!.isPng()) {
        _icon = Image.asset(
          alert.svg!,
          width: 24,
          height: 24,
          color: alert.color,
        );
      } else {
        _icon = SvgPicture.asset(
          alert.svg!,
          width: 24,
          height: 24,
          color: alert.color,
        );
      }
    } else {
      _icon = Icon(
        Icons.notifications_active,
        size: 24,
        color: alert.color,
      );
    }
    return _icon;
  }

  _dropDownItems() {
    final alerts = <AlertType>[];
    alerts.addAll(AlertType.values);
    alerts.removeLast();
    return alerts.map<DropdownMenuItem<String>>((AlertType value) {
      Widget icon;
      if (value.icon.isPng()) {
        icon = Image.asset(
          value.icon,
          color: value.color,
          width: 24,
          height: 24,
        );
      } else {
        icon = SvgPicture.asset(
          value.icon,
          color: value.color,
          width: 24,
          height: 24,
        );
      }
      return DropdownMenuItem<String>(
        alignment: Alignment.center,
        value: value.description,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Container(
              margin: left(8),
              child: Text(
                value.description,
                style: rTS(color: value.color),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  _addAlert({bool edit = false, Alert? alert}) {
    if (edit) {
      _alertType = alert!.type!;
      _lowestController.text = alert.lowerBound!.toString();
      _highestController.text = alert.upperBound!.toString();
      setState(() {});
    }
    context.showCustomScaffoldBottomSheet((_) {
      return StatefulBuilder(
        builder: (_, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                edit ? textEditAlert : textCreateAlert,
                style: bTS(size: 30, color: colorPrimary),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: left(16),
                    child: Text(
                      textType,
                      style: boTS(color: colorPrimary),
                    ),
                  ),
                  Container(
                    margin: symmetric(0, 16),
                    child: _dropDownWidget(setState),
                  ),
                ],
              ),
              Column(
                children: [
                  _sheetItemWidget(_lowestController, textLowest),
                  Container(
                    margin: top(16),
                    child: _sheetItemWidget(
                      _highestController,
                      textHighest,
                      isLast: true,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _createAlert(edit: edit, alert: alert),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red[200],
                  /*shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),*/
                ),
                child: SizedBox(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.056,
                  child: Center(
                    child: Text(
                      edit ? textSaveAlert : textCreateAlert,
                      style: mTS(color: colorWhite),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  _dropDownWidget(void Function(void Function()) state) {
    return Center(
      child: DropdownButton<String>(
        iconSize: 0,
        value: _alertType.description,
        onChanged: (String? newValue) {
          state(() {
            _alertType = newValue!.alertFromString;
          });
        },
        dropdownColor: Colors.black87,
        isExpanded: true,
        borderRadius: BorderRadius.circular(8),
        icon: const Icon(Icons.arrow_downward),
        items: _dropDownItems(),
      ),
    );
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
            style: boTS(color: colorPrimary),
          ),
        ),
        sheetTextField(
          screenWidth,
          screenHeight,
          controller,
          text,
          type: type,
          last: isLast,
        ),
      ],
    );
  }

  _createAlert({bool edit = false, Alert? alert}) {
    final lowest = _lowestController.text;
    final highest = _highestController.text;
    try{
      assert(!lowest.isNullOrEmpty);
      assert(!highest.isNullOrEmpty);
    }catch(e){
      _showError('All fields are required');
      logError(e.toString());
      return;
    }

    final lb = double.parse(lowest.toString());
    final ub = double.parse(highest.toString());

    try{
      assert(lb < ub);
    }catch(e){
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
      _hive.properties.alerts?.insert(
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
    logError('alert: $error');
  }

  _showError(String content){
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
}
