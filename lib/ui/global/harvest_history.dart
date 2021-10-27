import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/utils/log_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const _tag = 'HarvestHistory';

class HarvestHistory extends StatefulWidget {
  final List<ItemHarvestHistory> history;

  const HarvestHistory({Key? key, required this.history}) : super(key: key);

  @override
  _HarvestHistory createState() => _HarvestHistory();
}

class _HarvestHistory extends State<HarvestHistory> {
  String _selectedYear = '';
  String _selectedMonth = '';
  String _selectedDay = '';

  double _typeOpacity = 0.5;
  double _allTimeOpacity = 1.0;
  double _yearOpacity = 0.5;
  double _monthOpacity = 0.5;

  HarvestFilter _filter = HarvestFilter.all;
  MonthFilter _month = MonthFilter.all;

  late final TooltipBehavior _tooltipBehavior = TooltipBehavior(
    enable: true,
    borderColor: Colors.red,
  );

  bool get _typeFilterApplied => _filter != HarvestFilter.all;

  bool get _timeFilterApplied => _allTimeOpacity == 0.5;

  bool get _monthFilterApplied => _month != MonthFilter.all;

  bool get _filtersApplied => _typeFilterApplied && _timeFilterApplied;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            textHarvestHistory,
            style: mTS(),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    textFilters,
                    style: rTS(),
                  ),
                  Column(
                    children: [
                      Text(
                        textType,
                        style: rTS(),
                      ),
                      //_dropDownWidget((p0) {}),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: all(1),
                        ),
                        onPressed: () {
                          //_datePickerWidget(year: true);
                        },
                        child: Center(
                          child: _dropDownWidget(),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        textAllTime,
                        style: rTS(),
                      ),
                      Opacity(
                        opacity: _allTimeOpacity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: all(6),
                          ),
                          onPressed: () {
                            _enableDatePickers();
                          },
                          child: Center(
                            child: Text(
                              textAll,
                              style: mTS(size: 10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        textYear,
                        style: rTS(),
                      ),
                      AbsorbPointer(
                        absorbing: _yearOpacity == 0.5,
                        child: Opacity(
                          opacity: _yearOpacity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: all(6),
                            ),
                            onPressed: () {
                              _datePickerWidget(year: true);
                            },
                            child: Center(
                              child: Text(
                                '2021',
                                style: mTS(size: 10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        textMonth,
                        style: rTS(),
                      ),
                      AbsorbPointer(
                        absorbing: _monthOpacity == 0.5,
                        child: Opacity(
                          opacity: _monthOpacity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size.zero,
                              padding: all(6),
                            ),
                            onPressed: () {
                              _datePickerWidget();
                            },
                            child: Center(
                              child: Text(
                                'Oct',
                                style: mTS(size: 10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red[200],
                      minimumSize: Size.zero,
                      padding: all(8),
                    ),
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          textApply,
                          style: mTS(color: colorWhite),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _processItems(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _generateWidgets(List<ItemHarvestHistory> list) {
    var _widgets = <Widget>[];
    for (ItemHarvestHistory item in list) {
      _widgets.add(
        Padding(
          padding: all(12),
          child: SfCartesianChart(
            // Chart title
            title: ChartTitle(
              text: item.date.toString(),
              textStyle: mTS(),
            ),
            primaryXAxis: CategoryAxis(labelRotation: 45),
            tooltipBehavior: _tooltipBehavior,
            series: <ColumnSeries<ItemHarvest?, String>>[
              ColumnSeries<ItemHarvest?, String>(
                name: logHarvests,
                dataSource: item.history ?? [],
                xValueMapper: (datum, index) =>
                    '${datum?.title}' '\n(${datum?.unit!.description})',
                yValueMapper: (datum, index) => datum?.value,
                // Enable data label
                dataLabelSettings: const DataLabelSettings(
                  isVisible: true,
                ),
                width: 0.5,
              ),
            ],
          ),
        ),
      );
    }
    return _widgets;
  }

  _processItems() {
    if (widget.history.isEmpty) return <Widget>[];
    List<ItemHarvestHistory> _list = [];
    // todo handle filters
    if (_filtersApplied) {
      // apply both filters
      //_widgets.add();
    } else if (_typeFilterApplied) {
      _list.addAll(_typeFilteredHarvests());
    } else if (_timeFilterApplied) {
    } else {
      _list.addAll(widget.history);
    }

    return _generateWidgets(_list);
  }

  _typeFilteredHarvests() {
    final List<ItemHarvestHistory> _filteredHistory = [];
    for (ItemHarvestHistory item in widget.history) {
      if (item.history == null) continue;
      for (ItemHarvest? harvest in item.history!) {
        if (harvest?.title == _filter.description) {
          _filteredHistory.add(item);
        }
      }
    }
    return _filteredHistory;
  }

  _timeFilteredHarvests() {
    final List<ItemHarvestHistory> _filteredHistory = [];
    for (ItemHarvestHistory item in widget.history) {
      if (item.history == null) continue;
      for (ItemHarvest? harvest in item.history!) {
        if (harvest?.title == _filter.description) {
          _filteredHistory.add(item);
        }
      }
    }
    return _filteredHistory;
  }

  _filteredHarvests() {}

  _enableDatePickers() {
    setState(() {
      if (_allTimeOpacity == 1.0) {
        _allTimeOpacity = 0.5;
        _yearOpacity = 1.0;
        _monthOpacity = 1.0;
      } else {
        _allTimeOpacity = 1.0;
        _yearOpacity = 0.5;
        _monthOpacity = 0.5;
      }
    });
  }

  _datePickerWidget({
    bool year = false,
  }) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        lastDate: DateTime.now(),
        firstDate: DateTime(2000, 1, 1),
        initialDatePickerMode: year ? DatePickerMode.year : DatePickerMode.day);
  }

  _dropDownWidget() {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          iconSize: 0,
          value: _filter.description,
          onChanged: (String? newValue) {
            setState(() {
              _filter = newValue!.filterFromString;
            });
          },
          style: mTS(size: 10),
          isDense: true,
          alignment: Alignment.center,
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(Icons.arrow_downward),
          items: _typeDropDownWidget(),
        ),
      ),
    );
  }

  _typeDropDownWidget() {
    return HarvestFilter.values
        .map<DropdownMenuItem<String>>((HarvestFilter value) {
      return DropdownMenuItem<String>(
        alignment: Alignment.center,
        value: value.description,
        child: Text(
          value.description,
          style: mTS(size: 10),
        ),
      );
    }).toList();
  }
}
