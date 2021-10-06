import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/composite/widgets.dart';
import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

import '../../main.dart';

const _tag = 'Alerts';

class Alerts extends StatefulWidget {
  final int index;

  const Alerts({Key? key, required this.index}) : super(key: key);

  @override
  _Alerts createState() => _Alerts();
}

class _Alerts extends State<Alerts> with TickerProviderStateMixin {
  String _selectedHive = '';
  late Beehive _hive;
  final _typeController = TextEditingController();
  final _lowestController = TextEditingController();
  final _highestController = TextEditingController();
  AlertType _alertType = AlertType.temperature;

  final _listKey = GlobalKey<AnimatedListState>();

  //String _alertType = AlertType.TEMPERATURE.description;

  @override
  void initState() {
    super.initState();
    _hive = beehives[widget.index];
    _selectedHive = _hive.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            alerts,
            style: mTS(color: colorBlack),
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
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Hive',
                      style: boTS(color: colorBlack),
                    ),
                  ),
                ),
                */ /* Expanded(
                  flex: 3,
                  child: PopupMenuButton<String>(
                    initialValue: _selectedHive,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    color: Colors.black45,
                    onSelected: (String result) {
                      setState(() {
                        _selectedHive = result;
                      });
                    },
                    offset: Offset(0, 145),
                    itemBuilder: (BuildContext context) {
                      return _dropDownItems2();
                    },
                    child: Container(
                      height: 45,
                      margin: right(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black45,
                      ),
                      child: Center(
                        child: Text(
                          _selectedHive,
                          style: rTS(),
                        ),
                      ),
                    ),
                  ),
                ),*/ /*
                */ /*Expanded(
                  flex: 3,
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      margin: right(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black45,
                      ),
                      child: Center(
                        child: DropdownButton<String>(
                          iconSize: 0,
                          value: _selectedHive,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedHive = newValue!;
                              _hive = beehives.firstWhere(
                                  (element) => _selectedHive == element.name);
                            });
                          },
                          dropdownColor: Colors.black45,
                          isExpanded: true,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          icon: const Icon(Icons.arrow_downward),
                          items: _dropDownItems(),
                        ),
                      ),
                    ),
                  ),
                ),*/ /*
              ],
            ),*/
            Expanded(
              child: _checkAlerts(),
            ),
          ],
        ),
      ),
    );
  }

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  Animation<Offset> _offsetAnimation(double dx, Animation<double> animation) {
    return Tween<Offset>(
      begin: Offset(dx, 0.0),
      end: Offset.zero,
    ).animate(animation);
  }

  _checkAlerts() {
    if (_hive.properties.alerts!.isNotEmpty) {
      logInfo("Alerts ${_hive.properties.alerts!.length}");
      //_animationController.forward(from: 0);
      /*return AnimatedList(
        key: _listKey,
        padding: all(8),
        initialItemCount: _hive.properties.alerts!.length,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          return SlideTransition(
            position: _offsetAnimation(-1, animation),
            child: _alertWidget(index),
          );
          //return _alertWidget(index);
        },
      );*/
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
                style: mTS(color: colorBlack),
              ),
            ],
          ),
        ),
      );
    }
  }

  _alertWidget(int index) {
    final beehive = beehives[widget.index];
    final alert = beehive.properties.alerts![index];

    return Slidable(
      actionPane: const SlidableScrollActionPane(),
      closeOnScroll: true,
      secondaryActions: [
        _secondaryActionWidget(
          Icons.volume_up_rounded,
          btChange,
          () => _changeSound(index),
        ),
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
                  style: rTS(size: 16, color: colorBlack),
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
    setState(() {});
  }

  _changeSound(int index) {}

  _alertLeadingIcon(Alert alert) {
    Widget _icon;
    if (alert.svg != null) {
      _icon = SvgPicture.asset(
        alert.svg!,
        width: 24,
        height: 24,
        color: alert.color,
      );
    } else {
      _icon = Icon(
        alert.iconData,
        size: 24,
        color: alert.color,
      );
    }
    return _icon;
  }

  _dropDownItems() {
    return AlertType.values.map<DropdownMenuItem<String>>((AlertType value) {
      return DropdownMenuItem<String>(
        alignment: Alignment.center,
        value: value.description,
        child: Text(
          value.description,
          style: rTS(),
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
    context.showCustomBottomSheet((_) {
      return StatefulBuilder(
        builder: (_, setState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                edit ? textEditAlert : textCreateAlert,
                style: bTS(size: 30),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: left(16),
                    child: Text(
                      textType,
                      style: boTS(),
                    ),
                  ),
                  Container(
                    margin: symmetric(0, 16),
                    child: _dropDownWidget(setState),
                  ),
                ],
              ),
              _sheetItemWidget(_lowestController, textLowest),
              _sheetItemWidget(
                _highestController,
                textHighest,
                isLast: true,
              ),
              TextButton(
                onPressed: () => _createAlert(edit: edit, alert: alert),
                child: Container(
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.7 * 0.08,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.red[200],
                  ),
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
            style: boTS(),
          ),
        ),
        sheetTextField(
          screenWidth,
          screenHeight * 0.7,
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
    assert(!lowest.isNullOrEmpty);
    assert(!highest.isNullOrEmpty);
    final lb = double.parse(lowest.toString());
    final ub = double.parse(highest.toString());

    if (edit) {
      alert!.type = _alertType;
      alert.lowerBound = lb;
      alert.upperBound = ub;
      alert.svg = _alertType.icon;
      alert.color = _alertType.color;
      Navigator.pop(context);
    } else {
      _hive.properties.alerts?.insert(
        0,
        Alert(
          t: _alertType,
          lb: lb,
          ub: ub,
          sv: _alertType.icon,
          c: _alertType.color,
        ),
      );

      _lowestController.clear();
      _highestController.clear();
    }

    //_listKey.currentState?.insertItem(0);

    setState(() {});
  }

  _proceed() {}
}
