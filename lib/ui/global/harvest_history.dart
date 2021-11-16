import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/main.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const _tag = 'HarvestHistory';

class HarvestHistory extends StatefulWidget {
  final List<ItemHarvestHistory> history;

  const HarvestHistory({Key? key, required this.history}) : super(key: key);

  @override
  _HarvestHistory createState() => _HarvestHistory();
}

class _HarvestHistory extends State<HarvestHistory>
    with TickerProviderStateMixin {
  String _selectedYear = 'All';

  HarvestFilter _filter = HarvestFilter.all;
  MonthFilter _month = MonthFilter.all;

  bool get _typeFilterApplied => _filter != HarvestFilter.all;

  bool get _timeFilterApplied =>
      _month != MonthFilter.all || _selectedYear != 'All';

  bool get _filtersApplied => _typeFilterApplied && _timeFilterApplied;

  final List<ItemHarvest> _totalBeeswax = [];
  final List<ItemHarvest> _totalHoney = [];
  final List<ItemHarvest> _totalHoneycomb = [];
  final List<ItemHarvest> _totalPollen = [];
  final List<ItemHarvest> _totalPropolis = [];
  final List<ItemHarvest> _totalRoyalJelly = [];

  int selectedTypeIndex = 0;
  int selectedYearIndex = 0;
  int selectedMonthIndex = 0;

  List<String> get _years {
    final list = <String>['All'];
    for (int i = DateTime.now().year; i >= 1970; i--) {
      list.add('$i');
    }
    return list;
  }

  late final AnimationController _fadeInController = animationController();
  late final Animation<double> _fadeInAnimation =
      doubleAnimation(_fadeInController);

  _refreshData() {
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      setState(() {});
    });
  }

  showPicker() {
    context.show((BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.3,
        child: Container(
          color: colorWhite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'Harvest Type Filter',
                    style: bTS(size: 16, color: colorPrimary),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: CupertinoPicker(
                  magnification: 1.2,
                  scrollController: FixedExtentScrollController(
                      initialItem: selectedTypeIndex),
                  onSelectedItemChanged: (value) {
                    selectedTypeIndex = value;
                    _filter = HarvestFilter.values[value];
                  },
                  itemExtent: 48.0,
                  children: HarvestFilter.values
                      .map((e) => Center(child: Text(e.description)))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }, onClosing: () {
      _refreshData();
    });
  }

  showCupertinoYearPicker() {
    context.show((BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.3,
        child: Container(
          color: colorWhite,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'Year Filter',
                    style: bTS(size: 16, color: colorPrimary),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  magnification: 1.2,
                  scrollController: FixedExtentScrollController(
                      initialItem: selectedYearIndex),
                  onSelectedItemChanged: (value) {
                    selectedYearIndex = value;
                    _selectedYear = _years[value];
                  },
                  itemExtent: 48.0,
                  children: [for (String i in _years) Center(child: Text(i))],
                ),
              ),
            ],
          ),
        ),
      );
    }, onClosing: () {
      _refreshData();
    });
  }

  showCupertinoMonthPicker() {
    context.show((BuildContext context) {
      return FractionallySizedBox(
        heightFactor: 0.3,
        child: Container(
          color: colorWhite,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    'Month Filter',
                    style: bTS(size: 16, color: colorPrimary),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: CupertinoPicker(
                  backgroundColor: Colors.white,
                  magnification: 1.2,
                  scrollController: FixedExtentScrollController(
                      initialItem: selectedMonthIndex),
                  onSelectedItemChanged: (value) {
                    selectedMonthIndex = value;
                    _month = MonthFilter.values[value];
                  },
                  itemExtent: 48.0,
                  children: MonthFilter.values
                      .map((e) => Center(child: Text(e.description)))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      );
    }, onClosing: () {
      _refreshData();
    });
  }

  @override
  Widget build(BuildContext context) {
    _fadeInController.forward(from: 0);
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
                  Expanded(
                    flex: 30,
                    child: Column(
                      children: [
                        Text(
                          textType,
                          style: rTS(),
                        ),
                        AbsorbPointer(
                          absorbing: widget.history.isEmpty,
                          child: Opacity(
                            opacity: widget.history.isEmpty ? 0.5 : 1.0,
                            child: ElevatedButton(
                              style: buttonStyle,
                              onPressed: () {
                                showPicker();
                              },
                              child: Center(
                                  child: Text(
                                _filter.description,
                                style: mTS(size: 10),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 30,
                    child: Column(
                      children: [
                        Text(
                          textYear,
                          style: rTS(),
                        ),
                        AbsorbPointer(
                          absorbing: widget.history.isEmpty,
                          child: Opacity(
                            opacity: widget.history.isEmpty ? 0.5 : 1.0,
                            child: ElevatedButton(
                              style: buttonStyle,
                              onPressed: () {
                                showCupertinoYearPicker();
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
                  ),
                  Expanded(
                    flex: 5,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 30,
                    child: Column(
                      children: [
                        Text(
                          textMonth,
                          style: rTS(),
                        ),
                        AbsorbPointer(
                          absorbing: widget.history.isEmpty,
                          child: Opacity(
                            opacity: widget.history.isEmpty ? 0.5 : 1.0,
                            child: ElevatedButton(
                              style: buttonStyle,
                              onPressed: () {
                                showCupertinoMonthPicker();
                              },
                              child: Center(
                                child: Text(
                                  _month.description,
                                  style: mTS(size: 10),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  _totalWidget(List<ItemHarvest> list) {
    if (list.isEmpty) return Container();
    if (_typeFilterApplied && _filter.description != list.first.title) {
      return Container();
    }
    final _widgets = <Widget>[
      Text(list.first.title, style: bTS()),
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
  }

  _generateWidgets(List<ItemHarvestHistory> list) {
    var _widgets = <Widget>[];
    _clearTotalLists();
    _getTotals(list);
    _logTotalLists();
    /*final _totals = <Widget>[];
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
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(textNoData, style: rTS()),
            ),
          ],
        ),
      );
    }*/
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
    if (_widgets.isEmpty) {
      _widgets.add(
        SizedBox(
          height: screenHeight * 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(textNoData, style: rTS()),
              ),
            ],
          ),
        ),
      );
    }
    return _widgets;
  }

  _generateCharts(List<ItemHarvest> harvest, String icon, Color color) {
    final filter =
        _timeFilterApplied ? '${_month.description} $_selectedYear' : '';
    var title = harvest.first.title;
    title += filter.isNotEmpty ? ' - $filter' : '';
    return FadeTransition(
      opacity: _fadeInAnimation,
      child: Padding(
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
                        style: bTS(size: 10),
                      );
                    },
                  ),
                  width: 0.5,
                ),
              ],
            ),
          ],
        ),
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
    logInfo("total beeswax => " +
        _totalBeeswax.map((e) => e.toMapWithName()).toList().toString());
    logInfo("total honey => " +
        _totalHoney.map((e) => e.toMapWithName()).toList().toString());
    logInfo("total honeycomb => " +
        _totalHoneycomb.map((e) => e.toMapWithName()).toList().toString());
    logInfo("total pollen => " +
        _totalPollen.map((e) => e.toMapWithName()).toList().toString());
    logInfo("total propolis => " +
        _totalPropolis.map((e) => e.toMapWithName()).toList().toString());
    logInfo("total royal jelly => " +
        _totalRoyalJelly.map((e) => e.toMapWithName()).toList().toString());
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
    if (widget.history.isEmpty) {
      return <Widget>[
        SizedBox(
          height: screenHeight * 0.5,
          child: Center(
              child: Text(
            'No Harvest History',
            style: rTS(),
          )),
        )
      ];
    }
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
      if (item.year == _selectedYear || _selectedYear == 'All') {
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

  @override
  void dispose() {
    _fadeInController.dispose();
    super.dispose();
  }
}
