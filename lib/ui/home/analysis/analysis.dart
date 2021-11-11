import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/composite/widgets.dart';
import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/data/local/models/hive_properties.dart';
import 'package:smart_beehive/main.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vibration/vibration.dart';

import 'analysis_viewmodel.dart';

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
  late final _collection =
      fireStore.collection(collectionProperties).doc(_hive.propertiesId);

  late final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  final List<Info> _dataSource = [];
  final List<Info> _last5DataSource = [];
  int _last5Length = 0;
  final List<Info> _dailyDataSource = [];
  int _dailyLength = 0;

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

  late AnalysisViewModel _analysisViewModel;

  _initViewModel() {
    _analysisViewModel = Provider.of<AnalysisViewModel>(context);
    _analysisViewModel.helper = AnalysisHelper(
      success: _success,
      failure: _failure,
    );
  }

  _success() {
    setState(() {});
    logInfo('alert: added successfully');
  }

  _failure(String error) {
    logError('alert: $error');
  }

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Widget _updateValues(
    double value,
    List<Info> last5,
    List<Info> daily,
  ) {
    // add to current

    if (_dataSource.length >= 5) {
      _dataSource.removeAt(0);
    }
    _dataSource.add(Info(DateTime.now(), value));

    if (_last5Length != last5.length) {
      _last5Length = last5.length;
      if (_last5DataSource.length < 8) {
        last5.sort((a, b) => b.time.compareTo(a.time));
        for (var element in last5) {
          if (!_last5DataSource.contains(element) &&
              _last5DataSource.length < 8) {
            _last5DataSource.add(element);
          }
        }
        _last5DataSource.sort((a, b) => a.time.compareTo(b.time));
      } else {
        _last5DataSource.removeAt(0);
        _last5DataSource.add(last5.last);
      }
    }

    if (_dailyLength != daily.length) {
      _dailyLength = daily.length;
      if (_dailyDataSource.length < 8) {
        daily.sort((a, b) => b.time.compareTo(a.time));
        for (var element in daily) {
          if (!_dailyDataSource.contains(element) &&
              _dailyDataSource.length < 8) {
            _dailyDataSource.add(element);
          }
        }
        _dailyDataSource.sort((a, b) => a.time.compareTo(b.time));
      } else {
        _dailyDataSource.removeAt(0);
        _dailyDataSource.add(last5.last);
      }
    }

    logInfo("last 5 ${_last5DataSource.map((e) => e.toMap())}");
    return Column(
      children: [
        _cartesianChartWidget(
          'Current',
          _dataSource,
          _showCurrentAlert,
        ),
        _cartesianChartWidget(
          'Last Five Minutes',
          _last5DataSource,
          _showLast5Alert,
          interval: DateTimeIntervalType.hours,
        ),
        _cartesianChartWidget(
          'Daily',
          _dailyDataSource,
          _showDailyAlert,
          interval: DateTimeIntervalType.days,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _hive = widget.hive;
    _initViewModel();
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
        floatingActionButton: widget.type == AlertType.population
            ? FloatingActionButton(
                onPressed: _showAddBeesSheet,
                child: Padding(
                  padding: all(8),
                  child: SvgPicture.asset(
                    svgBees,
                    color: colorBlack,
                  ),
                ),
                backgroundColor: colorPrimary,
              )
            : null,
        body: widget.type == AlertType.swarming
            ? _swarmingWidget()
            : widget.type == AlertType.population
                ? _populationWidget()
                : SingleChildScrollView(
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: _collection.snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(
                            child: Text('Something went wrong'),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Text("Collecting data"),
                          );
                        }
                        final map =
                            snapshot.requireData.data() as Map<String, dynamic>;
                        return parseData(map);
                      },
                    ),
                ),
      ),
    );
  }

  Widget parseData(Map<String, dynamic> doc) {
    try {
      _hive.properties.temperature =
          double.parse(doc[fieldTemperature].toString());
      _hive.properties.humidity = double.parse(doc[fieldHumidity].toString());
      _hive.properties.weight = double.parse(doc[fieldWeight].toString());
      _hive.properties.population = doc[fieldPopulation] as int;
      logInfo('Properties => ${_hive.properties.toMap()}');

      _hive.properties.lastFiveTemperature =
          (doc[fieldLastFiveTemperature] as List<dynamic>)
              .map((e) => Info.fromMap(e))
              .toList();

      _hive.properties.lastFiveWeight =
          (doc[fieldLastFiveWeight] as List<dynamic>)
              .map((e) => Info.fromMap(e))
              .toList();

      _hive.properties.lastFiveHumidity =
          (doc[fieldLastFiveHumidity] as List<dynamic>)
              .map((e) => Info.fromMap(e))
              .toList();

      _hive.properties.lastFivePopulation =
          (doc[fieldLastFivePopulation] as List<dynamic>)
              .map((e) => Info.fromMap(e))
              .toList();

      switch (widget.type) {
        case AlertType.temperature:
          return _updateValues(
            _hive.properties.temperature!,
            _hive.properties.lastFiveTemperature,
            _hive.properties.dailyTemperature,
          );
        case AlertType.humidity:
          return _updateValues(
            _hive.properties.humidity!,
            _hive.properties.lastFiveHumidity,
            _hive.properties.dailyHumidity,
          );
        case AlertType.population:
          return _updateValues(
            _hive.properties.population!.toDouble(),
            _hive.properties.lastFivePopulation,
            _hive.properties.dailyPopulation,
          );
        case AlertType.weight:
          return _updateValues(
            _hive.properties.weight!,
            _hive.properties.lastFiveWeight,
            _hive.properties.dailyWeight,
          );
        case AlertType.swarming:
          return Container();
      }
    } catch (ex) {
      logError('properties => $ex');
      return Container();
    }
  }

  _updatePopulation({bool remove = false}) {
    var amount = int.parse(_amountController.text);
    if (remove) amount = amount * -1;
    _hive.properties.population = _hive.properties.population! + amount;
    if (_hive.properties.population! < 0) _hive.properties.population = 0;
    // update population
    _analysisViewModel.updatePopulation();
  }

  final _amountController = TextEditingController();

  _showAddBeesSheet() {
    context.show((_) {
      return StatefulBuilder(
        builder: (_, state) {
          return FractionallySizedBox(
            heightFactor: 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  textAddBees,
                  style: bTS(size: 30, color: colorPrimary),
                ),
                sheetTextField(
                  screenWidth,
                  screenHeight,
                  _amountController,
                  textAddBees,
                  type: const TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  align: TextAlign.center,
                  last: true,
                  //submit:(v)=> _updatePopulation(),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                Column(
                  children: [
                    Container(
                      margin: bottom(10),
                      child: ElevatedButton(
                        onPressed: () => state(() => _updatePopulation()),
                        style:buttonStyle,
                        child: SizedBox(
                          width: screenWidth * 0.4,
                          height: screenHeight * 0.056,
                          child: Center(
                            child: Text(
                              textAdd,
                              style: mTS(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidth * 0.3,
                      height: screenHeight * 0.05,
                      child: Center(
                        child: Text(
                          textRemove,
                          style: mTS(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  _populationWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            svgBees,
            width: screenWidth * 0.7,
            height: screenHeight * 0.5,
            color: Colors.green,
          ),
          Center(
            child: Padding(
              padding: all(8),
              child: Text(
                "${_hive.properties.population}",
                textAlign: TextAlign.center,
                style: sbTS(size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _swarmingWidget() {
    if (_hive.hiveIsSwarming) {
      _vibrate();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                    'Date: ' +
                        formatDate(
                            swarmingTime!, [yyyy, ' ', M, ' ', dd]),
                    style: sbTS(color: Colors.red),
                  ),
                ),
              ),
              Visibility(
                visible: _hive.hiveIsSwarming,
                child: Container(
                  margin: top(6),
                  child: Text(
                    'Time: ' +
                        formatDate(
                            swarmingTime!, [hh, ':', nn, ' ', am]),
                    style: sbTS(color: Colors.red),
                  ),
                ),
              ),
              Visibility(
                visible: _hive.hiveIsSwarming,
                child: ElevatedButton(
                onPressed: _stopSwarming,
                child: Text(textStop, style: mTS()),
                style: buttonStyle,
              ),)
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              margin: top(10),
              padding: all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    textBeekeeperTips,
                    style: bTS(size: 24),
                  ),
                  Padding(
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
                                          _bulletPointWidget(textDoNot2, top(6)),
                                          _bulletPointWidget(textDoNot3, top(6)),
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
                ],
              ),
            ),
          ),
        ),

      ],
    );
  }

  _stopSwarming() => _analysisViewModel.stopSwarming();

  _cartesianChartWidget(
    String title,
    List<Info> source,
    bool alert, {
    DateTimeIntervalType interval = DateTimeIntervalType.seconds,
  }) {
    return Padding(
      padding: all(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SfCartesianChart(
            primaryXAxis: DateTimeCategoryAxis(
              interval: 1,
              intervalType: interval,
              autoScrollingMode: AutoScrollingMode.start,
              labelPlacement: LabelPlacement.onTicks,
              labelStyle: mTS(size: 10),
            ),
            primaryYAxis: NumericAxis(labelStyle: mTS(size: 10)),
            title: ChartTitle(
              text: title,
              textStyle: mTS(),
            ),
            tooltipBehavior: TooltipBehavior(enable: true, canShowMarker: true),
            series: <StackedLineSeries<Info, DateTime>>[
              StackedLineSeries<Info, DateTime>(
                color: widget.type.color,
                name: widget.type.description,
                dataSource: source,
                xValueMapper: (Info info, _) => info.time,
                yValueMapper: (Info info, _) => info.value,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  builder: (data, point, series, pointIndex, seriesIndex) {
                    final _value =
                        (double.parse((data as Info).value.toString()))
                            .toPrecision(2);
                    return Text(
                      _value.toString(),
                      style: sbTS(size: 10),
                    );
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
    bool? canVibrate = await Vibration.hasVibrator();
    if (canVibrate ?? false) {
      Vibration.vibrate();
      await Future.delayed(const Duration(seconds: 1), () {
        if (!mounted) return;
        _vibrate();
      });
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
    Vibration.cancel();
    super.dispose();
  }
}

class BeeType {
  final String name;
  final int value;

  BeeType(this.name, this.value);
}
