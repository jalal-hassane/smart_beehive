import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../main.dart';

const _tag = 'Analysis';

class Analysis extends StatefulWidget {
  final int index;

  const Analysis({Key? key, required this.index}) : super(key: key);

  @override
  _Analysis createState() => _Analysis();
}

class _Analysis extends State<Analysis> with TickerProviderStateMixin {
  final audioPlayer = AudioPlayer();

  String _selectedHive = '';
  late Beehive _hive;
  late final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  final List<TempInfo> _temp = [];
  final List<Info> _weight = [];
  double weight = 5000;
  final List<BeeType> _population = [
    BeeType('Type1', 5000),
    BeeType('Type2', 1000),
    BeeType('Type3', 200),
  ];

  bool _showWeightAlert = false;
  bool _showTempAlert = false;
  bool _highTemp = false;

  @override
  void initState() {
    super.initState();
    _hive = beehives[widget.index];
    _selectedHive = _hive.name ?? '';
    _addValues();
    _initPlayer();
  }

  _addValues() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        if (_temp.length >= 5) {
          _temp.removeAt(0);
        }
        double rand = Random().nextDouble() * 4 + 37;
        if (rand >= 40) {
          _showTempAlert = true;
          _highTemp = true;
        }
        if (rand <= 39) {
          _showTempAlert = true;
          _highTemp = false;
        }
        _temp.add(TempInfo(DateTime.now(), rand));

        if (_weight.length >= 5) {
          _weight.removeAt(0);
        }

        if (weight == 6000) {
          weight = 2000;
          _showWeightAlert = true;
        } else {
          weight += 100;
        }
        _weight.add(Info(DateTime.now(), weight));
      });
      _addValues();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            analysis,
            style: mTS(),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: right(12),
              child: IconButton(
                icon: const Icon(
                  Icons.date_range,
                  color: colorBlack,
                ),
                onPressed: () {
                  // show previous tests
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: all(12),
                child: Stack(
                  children: [
                    SfCartesianChart(
                      primaryXAxis: DateTimeCategoryAxis(
                        interval: 1,
                        intervalType: DateTimeIntervalType.seconds,
                        autoScrollingMode: AutoScrollingMode.start,
                        labelPlacement: LabelPlacement.onTicks,
                      ),
                      title: ChartTitle(
                        text: textTemperature,
                        textStyle: mTS(),
                      ),
                      tooltipBehavior: _tooltipBehavior,
                      series: <StackedLineSeries<TempInfo, DateTime>>[
                        StackedLineSeries<TempInfo, DateTime>(
                          color: Colors.red,
                          dataSource: _temp,
                          xValueMapper: (TempInfo info, _) => info.time,
                          yValueMapper: (TempInfo info, _) =>
                              info.value.toPrecision(2),
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            builder:
                                (data, point, series, pointIndex, seriesIndex) {
                              final _value =
                                  (data as TempInfo).value.toPrecision(2);
                              return Text(_value.toString());
                            },
                          ),
                          markerSettings: const MarkerSettings(isVisible: true),
                          animationDuration: 0,
                          dataLabelMapper: (datum, index) =>
                              datum.value.toString(),
                        ),
                      ],
                      trackballBehavior:
                          TrackballBehavior(shouldAlwaysShow: true),
                    ),
                    Positioned.fill(
                      child: _tempAlertWidget(_showTempAlert, _highTemp),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: all(12),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SfCartesianChart(
                      primaryXAxis: DateTimeCategoryAxis(
                        interval: 1,
                        intervalType: DateTimeIntervalType.seconds,
                        autoScrollingMode: AutoScrollingMode.start,
                        labelPlacement: LabelPlacement.onTicks,
                      ),
                      title: ChartTitle(
                        text: textWeight,
                        textStyle: mTS(),
                      ),
                      tooltipBehavior: _tooltipBehavior,
                      series: <StackedLineSeries<Info, DateTime>>[
                        StackedLineSeries<Info, DateTime>(
                          color: Colors.red,
                          dataSource: _weight,
                          xValueMapper: (Info info, _) => info.time,
                          yValueMapper: (Info info, _) => info.value,
                          dataLabelSettings: DataLabelSettings(
                            isVisible: true,
                            builder:
                                (data, point, series, pointIndex, seriesIndex) {
                              final _value =
                                  (data as Info).value.toPrecision(2);
                              return Text(_value.toString());
                            },
                          ),
                          markerSettings: const MarkerSettings(isVisible: true),
                          animationDuration: 0,
                          dataLabelMapper: (datum, index) =>
                              datum.value.toString(),
                        ),
                      ],
                      trackballBehavior:
                          TrackballBehavior(shouldAlwaysShow: true),
                    ),
                    Positioned.fill(
                      child: _weightAlertWidget(_showWeightAlert),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: all(12),
                child: SfCircularChart(
                  // Chart title
                  title: ChartTitle(
                    text: textPopulation,
                    textStyle: mTS(),
                  ),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: _tooltipBehavior,
                  series: <PieSeries<BeeType, String>>[
                    PieSeries<BeeType, String>(
                      dataSource: _population,
                      xValueMapper: (datum, index) => datum.name,
                      yValueMapper: (datum, index) => datum.value,
                      // Enable data label
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _initPlayer() async {
    await audioPlayer.setAsset(soundAlert);
    await audioPlayer.setLoopMode(LoopMode.one);
    await audioPlayer.load();
  }

  raiseAlert() async {
    await audioPlayer.play();
  }

  stopAlert({bool temp = false}) async {
    setState(() {
      if (temp) {
        _showTempAlert = false;
      } else {
        _showWeightAlert = false;
      }
    });
    if (!_showTempAlert && _showWeightAlert) {
      await audioPlayer.stop();
    }
  }

  _weightAlertWidget(bool show) {
    if (show) raiseAlert();
    return Visibility(
      visible: show,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: Container(
        color: Colors.red[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              textAlert,
              style: bTS(size: 30),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: const Icon(
                Icons.warning_rounded,
                size: 40,
                color: colorPrimary,
              ),
            ),
            Padding(
              padding: all(6),
              child: Text(
                alertWeight,
                style: rTS(),
              ),
            ),
            ElevatedButton(
              onPressed: () async => await stopAlert(),
              child: Text(
                btTurnOff,
                style: mTS(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _tempAlertWidget(bool show, bool highTemp) {
    if (show) raiseAlert();
    return Visibility(
      visible: show,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: Container(
        color: Colors.red[100],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              textAlert,
              style: bTS(size: 30),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: const Icon(
                Icons.warning_rounded,
                size: 40,
                color: colorPrimary,
              ),
            ),
            Padding(
              padding: all(6),
              child: Text(
                highTemp ? alertTempHigh : alertTempLow,
                style: rTS(),
              ),
            ),
            ElevatedButton(
              onPressed: () async => await stopAlert(temp: true),
              child: Text(
                btTurnOff,
                style: mTS(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late final AnimationController _scaleController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
  )..repeat(reverse: true);

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 1.0,
    end: 0.0,
  ).animate(
    CurvedAnimation(
      parent: _scaleController,
      curve: Curves.ease,
    ),
  );

  @override
  void dispose() {
    _scaleController.dispose();
    audioPlayer.dispose();
    super.dispose();
  }
}

class TempInfo {
  final DateTime time;
  final double value;

  TempInfo(this.time, this.value);
}

class Info {
  final DateTime time;
  final double value;

  Info(this.time, this.value);
}

class BeeType {
  final String name;
  final int value;

  BeeType(this.name, this.value);
}
