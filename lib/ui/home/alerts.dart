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
import 'package:smart_beehive/utils/log_utils.dart';

import '../../main.dart';

const _tag = 'Alerts';

class Alerts extends StatefulWidget {
  final int index;

  const Alerts({Key? key, required this.index}) : super(key: key);

  @override
  _Alerts createState() => _Alerts();
}

class _Alerts extends State<Alerts> {
  String _selectedHive = '';
  late Beehive _hive;
  final _typeController = TextEditingController();
  final _lowestController = TextEditingController();
  final _highestController = TextEditingController();

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
            Row(
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
                /* Expanded(
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
                ),*/
                Expanded(
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
                ),
              ],
            ),
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
        Container(
          margin: bottom(10),
          child: IconSlideAction(
            color: colorBlack,
            icon: Icons.delete_forever,
            caption: 'remove',
            foregroundColor: colorPrimary,
            onTap: () {
              //_deleteMessage(message);
            },
          ),
        ),
      ],
      actionExtentRatio: 1 / 5,
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
                style: rTS(size: 16,color: colorBlack),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _alertLeadingIcon(Alert alert) {
    Widget _icon;
    if (alert.svg != null) {
      _icon = SvgPicture.asset(
        alert.svg!,
        width: 24,
        height: 24,
      );
    } else {
      _icon = Icon(
        alert.iconData,
        size: 24,
      );
    }
    return _icon;
  }

  _dropDownItems() {
    return beehives.map<DropdownMenuItem<String>>((Beehive value) {
      return DropdownMenuItem<String>(
        alignment: Alignment.center,
        value: value.name ?? '',
        child: Text(
          value.name ?? '',
          style: rTS(),
        ),
      );
    }).toList();
  }

  _addAlert() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      builder: (_) {
        return BottomSheet(
          backgroundColor: colorBlack.withOpacity(0.8),
          constraints: BoxConstraints(
              maxHeight: screenHeight * 0.7, minHeight: screenHeight * 0.7),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          onClosing: () {},
          builder: (_) {
            return StatefulBuilder(
              builder: (_, setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Create Alert',
                      style: bTS(size: 30),
                    ),
                    _sheetItemWidget(_typeController,'Type',type: TextInputType.text),
                    _sheetItemWidget(_lowestController,'Lowest'),
                    _sheetItemWidget(_highestController,'Highest',isLast: true),
                    TextButton(
                      onPressed: () {
                        //
                      },
                      child: Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.7 * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorWhite,
                        ),
                        child: Center(child: Text('Create Alert',style: mTS(),)),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
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

  _proceed() {}
}
