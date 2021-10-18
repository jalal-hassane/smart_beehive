import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const _tag = 'Analysis';

class Analysis extends StatefulWidget {
  final Beehive hive;
  final AlertType type;

  const Analysis({
    Key? key,
    required this.hive,
    required this.type,
  }) : super(key: key);

  @override
  _Analysis createState() => _Analysis();
}

class _Analysis extends State<Analysis> with TickerProviderStateMixin {
  final audioPlayer = AudioPlayer();

  late Beehive _hive;
  late final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  final List<TempInfo> _temp = [];
  final List<Info> _dataSource = [];
  final List<Info> _last5DataSource = [];
  final List<Info> _dailyDataSource = [];
  double weight = 5000;
  final List<BeeType> _population = [
    BeeType('Type1', 5000),
    BeeType('Type2', 1000),
    BeeType('Type3', 200),
  ];

  bool _showCurrentAlert = false;
  bool _showLast5Alert = false;
  bool _showDailyAlert = false;
  bool _showTempAlert = false;
  bool _highTemp = false;

  @override
  void initState() {
    super.initState();
    _hive = widget.hive;
    _addValues();
    _initPlayer();
  }

  _addTempValues() {
    _addTemp1();
    _addTemp2();
    _addTemp3();
  }

  _addTemp1() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        if (_dataSource.length >= 5) {
          _dataSource.removeAt(0);
        }
        double rand = Random().nextDouble() * 4 + 37;
        if (rand >= 40) {
          _showCurrentAlert = true;
          _highTemp = true;
        }
        if (rand <= 39) {
          _showCurrentAlert = true;
          _highTemp = false;
        }
        _dataSource.add(Info(DateTime.now(), rand));
      });
      _addTemp1();
    });
  }

  _addTemp2() {
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() {
        if (_last5DataSource.length >= 5) {
          _last5DataSource.removeAt(0);
        }
        double rand = Random().nextDouble() * 4 + 37;
        if (rand >= 40) {
          _showLast5Alert = true;
          _highTemp = true;
        }
        if (rand <= 39) {
          _showLast5Alert = true;
          _highTemp = false;
        }
        _last5DataSource.add(Info(DateTime.now(), rand));
      });
      _addTemp2();
    });
  }

  _addTemp3() {
    Future.delayed(const Duration(seconds: 15), () {
      if (!mounted) return;
      setState(() {
        if (_dailyDataSource.length >= 5) {
          _dailyDataSource.removeAt(0);
        }
        double rand = Random().nextDouble() * 4 + 37;
        if (rand >= 40) {
          _showDailyAlert = true;
          _highTemp = true;
        }
        if (rand <= 39) {
          _showDailyAlert = true;
          _highTemp = false;
        }
        _dailyDataSource.add(Info(DateTime.now(), rand));
      });
      _addTemp3();
    });
  }

  _addWeightValues() {
    _addWeight1();
    _addWeight2();
    _addWeight3();
  }

  _addWeight1() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        if (_dataSource.length >= 5) {
          _dataSource.removeAt(0);
        }
        if (weight == 6000) {
          weight = 2000;
          _showCurrentAlert = true;
        } else {
          weight += 100;
        }
        _dataSource.add(Info(DateTime.now(), weight));
        _addWeight1();
      });
    });
  }

  _addWeight2() {
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() {
        if (_last5DataSource.length >= 5) {
          _last5DataSource.removeAt(0);
        }
        if (weight == 6000) {
          weight = 2000;
          _showLast5Alert = true;
        } else {
          weight += 100;
        }
        _last5DataSource.add(Info(DateTime.now(), weight));
        _addWeight2();
      });
    });
  }

  _addWeight3() {
    Future.delayed(const Duration(seconds: 15), () {
      if (!mounted) return;
      setState(() {
        if (_dailyDataSource.length >= 5) {
          _dailyDataSource.removeAt(0);
        }
        if (weight == 6000) {
          weight = 2000;
          _showDailyAlert = true;
        } else {
          weight += 100;
        }
        _dailyDataSource.add(Info(DateTime.now(), weight));
      });
      _addWeight3();
    });
  }

  _addHumidityValues() {
    _addHumidity1();
    _addHumidity2();
    _addHumidity3();
  }

  _addHumidity1() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        if (_dataSource.length >= 5) {
          _dataSource.removeAt(0);
        }
        double rand = Random().nextDouble() * 4 + 75;

        _dataSource.add(Info(DateTime.now(), rand));
      });
      _addHumidity1();
    });
  }

  _addHumidity2() {
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() {
        if (_last5DataSource.length >= 5) {
          _last5DataSource.removeAt(0);
        }
        double rand = Random().nextDouble() * 4 + 75;

        _last5DataSource.add(Info(DateTime.now(), rand));
      });
      _addHumidity2();
    });
  }

  _addHumidity3() {
    Future.delayed(const Duration(seconds: 15), () {
      if (!mounted) return;
      setState(() {
        if (_dailyDataSource.length >= 5) {
          _dailyDataSource.removeAt(0);
        }
        double rand = Random().nextDouble() * 4 + 75;

        _dailyDataSource.add(Info(DateTime.now(), rand));
      });
      _addHumidity3();
    });
  }

  _addPopulationValues() {}

  _addValues() {
    switch (widget.type) {
      case AlertType.temperature:
        _addTempValues();
        break;
      case AlertType.humidity:
        _addHumidityValues();
        break;
      case AlertType.population:
        _addPopulationValues();
        break;
      case AlertType.weight:
        _addWeightValues();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            '$analysis - ${widget.type.description}',
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
              _cartesianChartWidget(
                'Current',
                _dataSource,
                _showCurrentAlert,
              ),
              _cartesianChartWidget(
                'Last Five Minutes (testing: 10 seconds)',
                _last5DataSource,
                _showLast5Alert,
              ),
              _cartesianChartWidget(
                'Daily (testing: 15 seconds)',
                _dailyDataSource,
                _showDailyAlert,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _cartesianChartWidget(String title, List<Info> source, bool alert) {
    return Padding(
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
              text: title,
              textStyle: mTS(),
            ),
            tooltipBehavior: _tooltipBehavior,
            series: <StackedLineSeries<Info, DateTime>>[
              StackedLineSeries<Info, DateTime>(
                color: widget.type.color,
                dataSource: source,
                xValueMapper: (Info info, _) => info.time,
                yValueMapper: (Info info, _) => info.value,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  builder: (data, point, series, pointIndex, seriesIndex) {
                    final _value = (data as Info).value.toPrecision(2);
                    return Text(_value.toString());
                  },
                ),
                markerSettings: const MarkerSettings(isVisible: true),
                animationDuration: 0,
                dataLabelMapper: (datum, index) => datum.value.toString(),
              ),
            ],
            trackballBehavior: TrackballBehavior(shouldAlwaysShow: true),
          ),
          Positioned.fill(
            child: widget.type == AlertType.temperature
                ? _tempAlertWidget(alert, _highTemp)
                : _alertWidget(alert),
          ),
        ],
      ),
    );
  }

  _circularChartWidget() {
    return Padding(
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
            dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }

  // alert widget
  _initPlayer() async {
    await audioPlayer.setAsset(soundAlert);
    await audioPlayer.setLoopMode(LoopMode.one);
    await audioPlayer.setVolume(0.1);
    await audioPlayer.load();
  }

  raiseAlert() async {
    await audioPlayer.play();
  }

  stopAlert({bool temp = false}) async {
    setState(() {
      _showCurrentAlert = false;
      _showLast5Alert = false;
      _showDailyAlert = false;
    });
    await audioPlayer.stop();
  }

  _alertWidget(bool show) {
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
