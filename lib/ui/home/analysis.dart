import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:just_audio/just_audio.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/main.dart';
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
  bool stateExpanded = false;

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
      case AlertType.swarming:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _hive.hiveIsSwarming = Random().nextBool();
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
        ),
        body: SingleChildScrollView(
          child: widget.type == AlertType.swarming
              ? _swarmingWidget()
              : Column(
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

  _swarmingWidget() {
    if (_hive.hiveIsSwarming) {
      // vibrate
      _vibrate();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                    _hive.hiveIsSwarming
                        ? pngQueenSwarmStatus
                        : pngQueenSwarmStatusActive,
                    height: screenHeight * 0.2,
                    width: double.maxFinite,
                    color: _hive.hiveIsSwarming ? Colors.red : null,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: _hive.hiveIsSwarming,
                        child: Container(
                          margin: bottom(6),
                          child: const Icon(
                            Icons.warning_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Text(
                        _hive.hiveIsSwarming
                            ? textHiveSwarming
                            : textHiveNotSwarming,
                        style: sbTS(
                          color:
                              _hive.hiveIsSwarming ? Colors.red : Colors.green,
                        ),
                      ),
                      Visibility(
                        visible: _hive.hiveIsSwarming,
                        child: Container(
                          margin: top(6),
                          child: Text(
                            'date: 2021 Oct 19',
                            style: sbTS(color: Colors.red),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: _hive.hiveIsSwarming,
                        child: Container(
                          margin: top(6),
                          child: Text(
                            'time: 4:06 pm',
                            style: sbTS(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          margin: top(10),
          child: Padding(
            padding: all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      textBeekeeperTips,
                      style: bTS(size: 24),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (stateExpanded) {
                          _analysisScaleController.reverse();
                          _analysisFadeController.forward().whenComplete(() {
                            setState(() => stateExpanded = false);
                            _analysisFadeController.reverse();
                          });
                        } else {
                          _analysisScaleController.forward();
                          _analysisFadeController.forward().whenComplete(() {
                            setState(() => stateExpanded = true);
                            _analysisFadeController.reverse();
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.black12),
                        padding: all(4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FadeTransition(
                              opacity: _analysisFadeAnimation,
                              child: Text(
                                stateExpanded ? textLess : textMore,
                                style: rTS(),
                              ),
                            ),
                            RotationTransition(
                              turns: _analysisRotationAnimation,
                              child: const Icon(Icons.arrow_drop_down_sharp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizeTransition(
                  sizeFactor: _analysisScaleAnimation,
                  child: Padding(
                    padding: all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textReasons,
                          style: sbTS(color: colorGreen),
                        ),
                        Padding(
                          padding: all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _bulletPointWidget(textReasons1, null),
                              _bulletPointWidget(textReasons2, top(6)),
                              _bulletPointWidget(textReasons3, top(6)),
                              Container(
                                margin: top(10),
                                child: Text(
                                  textReasonsExplanation,
                                  style: rTS(),
                                ),
                              ),
                              Container(
                                margin: top(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      textAvoidCongestion,
                                      style: mTS(),
                                    ),
                                    Padding(
                                      padding: all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _bulletPointWidget(
                                              textAvoidCongestion1, null),
                                          _bulletPointWidget(
                                              textAvoidCongestion2, top(6)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: top(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      textGoodVentilation,
                                      style: mTS(),
                                    ),
                                    Padding(
                                      padding: all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _bulletPointWidget(
                                              textGoodVentilation1, null),
                                          _bulletPointWidget(
                                              textGoodVentilation2, top(6)),
                                          _bulletPointWidget(
                                              textGoodVentilation3, top(6)),
                                          Padding(
                                            padding: all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                _bulletPointWidget(
                                                    textHotWeather1, null),
                                                _bulletPointWidget(
                                                    textHotWeather2, top(6)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: top(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                textRecommendations,
                                style: sbTS(color: colorGreen),
                              ),
                              Padding(
                                padding: all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      textDo,
                                      style: mTS(),
                                    ),
                                    Padding(
                                      padding: all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _bulletPointWidget(textDo1, null),
                                          _bulletPointWidget(textDo2, top(6)),
                                          _bulletPointWidget(textDo3, top(6)),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      textDoNot,
                                      style: mTS(),
                                    ),
                                    Padding(
                                      padding: all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _bulletPointWidget(textDoNot1, null),
                                          _bulletPointWidget(
                                              textDoNot2, top(6)),
                                          _bulletPointWidget(
                                              textDoNot3, top(6)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: top(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                textRaces,
                                style: sbTS(color: colorGreen),
                              ),
                              Padding(
                                padding: all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _bulletPointWidget(textRaces1, null),
                                    _bulletPointWidget(textRaces2, top(6)),
                                    _bulletPointWidget(textRaces3, top(6)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  _bulletPointWidget(String text, EdgeInsetsGeometry? margin) {
    return Container(
      margin: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: trbl(2, 8, 0, 0),
            child: const Icon(
              Icons.brightness_1,
              size: 8,
            ),
          ),
          Flexible(
            child: Text(
              text,
              style: rTS(),
            ),
          ),
        ],
      ),
    );
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

  _vibrate() async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.vibrateWithPauses(const [
        Duration(milliseconds: 500),
      ]).whenComplete(() => _vibrate());
    }
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

  late final AnimationController _analysisScaleController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> _analysisRotationAnimation = Tween<double>(
    begin: 1.0,
    end: 0.5,
  ).animate(
    CurvedAnimation(
      parent: _analysisScaleController,
      curve: Curves.ease,
    ),
  );

  late final AnimationController _analysisFadeController = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<double> _analysisFadeAnimation = Tween<double>(
    begin: 1.0,
    end: 0.1,
  ).animate(
    CurvedAnimation(
      parent: _analysisFadeController,
      curve: Curves.ease,
    ),
  );

  late final Animation<double> _analysisScaleAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _analysisScaleController,
      curve: Curves.ease,
    ),
  );

  @override
  void dispose() {
    _scaleController.dispose();
    _analysisScaleController.dispose();
    _analysisFadeController.dispose();
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
