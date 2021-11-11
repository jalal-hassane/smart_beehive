import 'dart:math';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/assets.dart';
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
  String _selectedYear = formatDate(DateTime.now(), [yyyy]);
  String _selectedMonth = formatDate(DateTime.now(), [M]);

  double _allTimeOpacity = 1.0;
  double _yearOpacity = 0.5;
  double _monthOpacity = 0.5;

  HarvestFilter _filter = HarvestFilter.all;
  MonthFilter _month = MonthFilter.all;

  bool get _typeFilterApplied => _filter != HarvestFilter.all;

  bool get _timeFilterApplied => _allTimeOpacity == 0.5;

  bool get _filtersApplied => _typeFilterApplied && _timeFilterApplied;

  final List<ItemHarvest> _totalBeeswax = [];
  final List<ItemHarvest> _totalHoney = [];
  final List<ItemHarvest> _totalHoneycomb = [];
  final List<ItemHarvest> _totalPollen = [];
  final List<ItemHarvest> _totalPropolis = [];
  final List<ItemHarvest> _totalRoyalJelly = [];

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
                        style: buttonStyle/*.copyWith(
                          minimumSize: Size.zero,
                          padding: all(1),
                        )*/,
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
                          style: buttonStyle/*.styleFrom(
                            minimumSize: Size.zero,
                            padding: all(6),
                          )*/,
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
                            style: buttonStyle/*.styleFrom(
                              minimumSize: Size.zero,
                              padding: all(6),
                            )*/,
                            onPressed: () {
                              _datePickerWidget(year: true);
                            },
                            child: Center(
                              child: Text(
                                _selectedYear,
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
                            style: buttonStyle/*.styleFrom(
                              minimumSize: Size.zero,
                              padding: all(1),
                            )*/,
                            onPressed: () {},
                            child: Center(
                              child: _monthDropDownWidget(),
                            ),
                          ),
                        ),
                      ),
                    ],
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

  _totalWidget(List<ItemHarvest> list) {
    if (list.isEmpty) return Container();
    if (_typeFilterApplied && _filter.description != list.first.title)
      return Container();
    final _widgets = <Widget>[
      Text(list.first.title, style: sbTS()),
    ];
    for (ItemHarvest itemHarvest in list) {
      _widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${itemHarvest.value} ', style: mTS()),
            Text(itemHarvest.unit!.description, style: rTS()),
          ],
        ),
      );
    }
    return Column(children: _widgets);
    return Container(
        color: Color.fromRGBO(
            (Random().nextDouble() * 255).toInt(),
            (Random().nextDouble() * 255).toInt(),
            (Random().nextDouble() * 255).toInt(),
            1.0),
        child: Column(children: _widgets));
  }

  _generateWidgets(List<ItemHarvestHistory> list) {
    var _widgets = <Widget>[];
    _clearTotalLists();
    _getTotals(list);
    _logTotalLists();
    final _totals = <Widget>[];
    if (_totalBeeswax.isNotEmpty) {
      if (!_typeFilterApplied || _filter.description == logBeeswax) {
        _totals.add(_totalWidget(_totalBeeswax));
      }
    }
    if (_totalHoney.isNotEmpty) {
      if (!_typeFilterApplied || _filter.description == logHoney) {
        _totals.add(_totalWidget(_totalHoney));
      }
    }
    if (_totalHoneycomb.isNotEmpty) {
      if (!_typeFilterApplied || _filter.description == logHoneycomb) {
        _totals.add(_totalWidget(_totalHoneycomb));
      }
    }
    if (_totalPollen.isNotEmpty) {
      if (!_typeFilterApplied || _filter.description == logPollen) {
        _totals.add(_totalWidget(_totalPollen));
      }
    }
    if (_totalPropolis.isNotEmpty) {
      if (!_typeFilterApplied || _filter.description == logPropolis) {
        _totals.add(_totalWidget(_totalPropolis));
      }
    }
    if (_totalRoyalJelly.isNotEmpty) {
      if (!_typeFilterApplied || _filter.description == logRoyalJelly) {
        _totals.add(_totalWidget(_totalRoyalJelly));
      }
    }
    if (_totals.isNotEmpty) {
      _widgets.add(
        Padding(
          padding: all(8),
          child: Column(
            children: [
              Container(
                margin: bottom(10),
                child: Text(
                  textTotal,
                  style: boTS(size: 20, color: Colors.green),
                ),
              ),
              Center(
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  children: _totals,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      _widgets.add(
        Center(
          child: Text(textNoData, style: rTS()),
        ),
      );
    }
    if (!_typeFilterApplied || _filter.description == logBeeswax) {
      if (_totalBeeswax.isNotEmpty) {
        _widgets.add(
          _generateCharts(
            _totalBeeswax,
            pngHarvestsBeeswaxActive,
            Colors.blueGrey,
          ),
        );
      }
    }
    if (!_typeFilterApplied || _filter.description == logHoney) {
      if (_totalHoney.isNotEmpty) {
        _widgets.add(
          _generateCharts(
            _totalHoney,
            pngHarvestsHoneyActive,
            Colors.amber,
          ),
        );
      }
    }
    if (!_typeFilterApplied || _filter.description == logHoneycomb) {
      if (_totalHoneycomb.isNotEmpty) {
        _widgets.add(
          _generateCharts(
            _totalHoneycomb,
            pngHarvestsHoneycombActive,
            Colors.deepOrangeAccent,
          ),
        );
      }
    }
    if (!_typeFilterApplied || _filter.description == logPollen) {
      if (_totalPollen.isNotEmpty) {
        _widgets.add(
          _generateCharts(
            _totalPollen,
            pngHarvestsPollenActive,
            Colors.yellow,
          ),
        );
      }
    }
    if (!_typeFilterApplied || _filter.description == logPropolis) {
      if (_totalPropolis.isNotEmpty) {
        _widgets.add(
          _generateCharts(
            _totalPropolis,
            pngHarvestsPropolisActive,
            Colors.brown,
          ),
        );
      }
    }
    if (!_typeFilterApplied || _filter.description == logRoyalJelly) {
      if (_totalRoyalJelly.isNotEmpty) {
        _widgets.add(
          _generateCharts(
            _totalRoyalJelly,
            pngHarvestsRoyalJellyActive,
            Colors.deepOrange,
          ),
        );
      }
    }
    /*for (ItemHarvestHistory item in list) {
      _widgets.add(
        Padding(
          padding: all(12),
          child: SfCartesianChart(
            title: ChartTitle(
              text: formatDate(
                item.date,
                [yyyy, ' ', M, ' ', dd, ' ', hh, ':', nn, ' ', am],
              ),
              textStyle: mTS(),
            ),
            primaryXAxis: CategoryAxis(
              labelRotation: 45,
              labelStyle: mTS(size: 10),
            ),
            primaryYAxis: NumericAxis(labelStyle: mTS(size: 10)),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              borderColor: Colors.red,
            ),
            series: <ColumnSeries<ItemHarvest?, String>>[
              ColumnSeries<ItemHarvest?, String>(
                name: logHarvests,
                dataSource: item.history ?? [],
                xValueMapper: (datum, index) =>
                    '${datum?.title}' '\n(${datum?.unit!.description})',
                yValueMapper: (datum, index) => datum?.value,
                // Enable data label
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  builder: (data, point, series, pointIndex, seriesIndex) {
                    return Text(
                      (data as ItemHarvest).value.toString(),
                      style: sbTS(size: 10),
                    );
                  },
                ),
                width: 0.5,
              ),
            ],
          ),
        ),
      );
    }*/
    return _widgets;
  }

  _generateCharts(List<ItemHarvest> harvest, String icon, Color color) {
    final filter =
        _timeFilterApplied ? '${_month.description} $_selectedYear' : '';
    var title = harvest.first.title;
    title += filter.isNotEmpty ? ' - $filter' : '';
    return Padding(
      padding: all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: 20,
                width: 20,
              ),
              Container(
                margin: left(4),
                child: Text(title, style: mTS()),
              ),
            ],
          ),
          SfCartesianChart(
            /*title: ChartTitle(
              text: harvest.first.title,
              textStyle: mTS(),
            ),*/
            primaryXAxis: CategoryAxis(labelStyle: mTS(size: 10)),
            primaryYAxis: NumericAxis(labelStyle: mTS(size: 10)),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              borderColor: Colors.red,
            ),
            series: <ColumnSeries<ItemHarvest?, String>>[
              ColumnSeries<ItemHarvest?, String>(
                name: harvest.first.title,
                color: color,
                dataSource: harvest,
                xValueMapper: (datum, index) => '${datum?.unit!.description}',
                yValueMapper: (datum, index) => datum?.value,
                // Enable data label
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  builder: (data, point, series, pointIndex, seriesIndex) {
                    return Text(
                      (data as ItemHarvest).value.toString(),
                      style: sbTS(size: 10),
                    );
                  },
                ),
                width: 0.5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _clearTotalLists() {
    _totalBeeswax.clear();
    _totalHoney.clear();
    _totalHoneycomb.clear();
    _totalPollen.clear();
    _totalPropolis.clear();
    _totalRoyalJelly.clear();
  }

  _logTotalLists() {
    logInfo("total beeswax => " + _totalBeeswax.map((e) => e.toMapWithName()).toList().toString() );
    logInfo("total honey => " + _totalHoney.map((e) => e.toMapWithName()).toList().toString() );
    logInfo("total honeycomb => " + _totalHoneycomb.map((e) => e.toMapWithName()).toList().toString() );
    logInfo("total pollen => " + _totalPollen.map((e) => e.toMapWithName()).toList().toString() );
    logInfo("total propolis => " + _totalPropolis.map((e) => e.toMapWithName()).toList().toString() );
    logInfo("total royal jelly => " + _totalRoyalJelly.map((e) => e.toMapWithName()).toList().toString() );
  }

  _getTotals(List<ItemHarvestHistory> list) {
    for (ItemHarvestHistory item in list) {
      logInfo(item.history.toString());
      if (item.history == null) continue;
      logInfo(item.history!.map((e) => e?.toMapWithName()).toString());
      for (ItemHarvest? harvest in item.history!) {
        if (harvest != null) {
          logInfo(harvest.title.toString());
          switch (harvest.title) {
            case logBeeswax:
              _addBeeswax(harvest);
              continue;
            case logHoneycomb:
              _addHoneycomb(harvest);
              continue;
            case logHoney:
              _addHoney(harvest);
              continue;
            case logPollen:
              _addPollen(harvest);
              continue;
            case logPropolis:
              _addPropolis(harvest);
              continue;
            case logRoyalJelly:
              _addRoyalJelly(harvest);
              continue;
          }
        }
      }
    }
  }

  _addBeeswax(ItemHarvest harvest) {
    final h =
        _totalBeeswax.indexWhere((element) => element.unit == harvest.unit);
    logInfo('Beeswax index is $h');
    if (h == -1) {
      _totalBeeswax.add(harvest.copy());
    } else {
      logInfo('Beeswax index is $h');
      _totalBeeswax[h].value = _totalBeeswax[h].value! + harvest.value!;
    }
  }

  _addHoneycomb(ItemHarvest harvest) {
    final h =
        _totalHoneycomb.indexWhere((element) => element.unit == harvest.unit);
    if (h == -1) {
      _totalHoneycomb.add(harvest.copy());
    } else {
      _totalHoneycomb[h].value = _totalHoneycomb[h].value! + harvest.value!;
    }
  }

  _addHoney(ItemHarvest harvest) {
    final h = _totalHoney.indexWhere((element) => element.unit == harvest.unit);
    if (h == -1) {
      _totalHoney.add(harvest.copy());
    } else {
      _totalHoney[h].value = _totalHoney[h].value! + harvest.value!;
    }
  }

  _addPollen(ItemHarvest harvest) {
    final h =
        _totalPollen.indexWhere((element) => element.unit == harvest.unit);
    if (h == -1) {
      _totalPollen.add(harvest);
    } else {
      _totalPollen[h].value = _totalPollen[h].value! + harvest.value!;
    }
  }

  _addPropolis(ItemHarvest harvest) {
    final h =
        _totalPropolis.indexWhere((element) => element.unit == harvest.unit);
    if (h == -1) {
      _totalPropolis.add(harvest.copy());
    } else {
      _totalPropolis[h].value = _totalPropolis[h].value! + harvest.value!;
    }
  }

  _addRoyalJelly(ItemHarvest harvest) {
    final h =
        _totalRoyalJelly.indexWhere((element) => element.unit == harvest.unit);
    if (h == -1) {
      _totalRoyalJelly.add(harvest.copy());
    } else {
      _totalRoyalJelly[h].value = _totalRoyalJelly[h].value! + harvest.value!;
    }
  }

  _processItems() {
    if (widget.history.isEmpty) return <Widget>[];
    List<ItemHarvestHistory> _list = [];

    if (_filtersApplied || _timeFilterApplied) {
      _list.addAll(_timeFilteredHarvests());
    } else if (_typeFilterApplied) {
      _list.addAll(_typeFilteredHarvests());
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
    final month = _month.description;
    final List<ItemHarvestHistory> _filteredHistory = [];
    for (ItemHarvestHistory item in widget.history) {
      if (item.history == null) continue;
      if (item.year == _selectedYear) {
        if (_month == MonthFilter.all) {
          if (_filter == HarvestFilter.all) {
            _filteredHistory.add(item);
          } else {
            for (ItemHarvest? harvest in item.history!) {
              if (harvest?.title == _filter.description) {
                _filteredHistory.add(item);
              }
            }
          }
        } else {
          if (item.month == month) {
            if (_filter == HarvestFilter.all) {
              _filteredHistory.add(item);
            } else {
              for (ItemHarvest? harvest in item.history!) {
                if (harvest?.title == _filter.description) {
                  _filteredHistory.add(item);
                }
              }
            }
          }
        }
      }
    }
    return _filteredHistory;
  }

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
    if (date != null) {
      _selectedYear = date.year.toString();
      _selectedMonth = formatDate(date, [MM]);
      _month = _selectedMonth.monthFromString;
      setState(() {});
    }
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

  _monthDropDownWidget() {
    return Center(
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          iconSize: 0,
          value: _month.description,
          onChanged: (String? newValue) {
            setState(() {
              _month = newValue!.monthFromString;
            });
          },
          style: mTS(size: 10),
          isDense: true,
          alignment: Alignment.center,
          borderRadius: BorderRadius.circular(8),
          icon: const Icon(Icons.arrow_downward),
          items: _monthDropDownItems(),
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

  _monthDropDownItems() {
    return MonthFilter.values
        .map<DropdownMenuItem<String>>((MonthFilter value) {
      return DropdownMenuItem<String>(
        alignment: Alignment.center,
        value: value.description,
        child: Text(
          value.description,
          style: mTS(size: 10),
        ),
        onTap: () => setState(() {}),
      );
    }).toList();
  }
}
