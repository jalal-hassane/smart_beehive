import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/main.dart';
import 'package:smart_beehive/ui/home/alerts/alerts.dart';
import 'package:smart_beehive/ui/home/analysis.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/extensions.dart';
import 'package:smart_beehive/utils/log_utils.dart';

const _tag = 'Properties';

class Properties extends StatefulWidget {
  final Beehive beehive;
  final bool showOnlyAnalysis;

  const Properties(
      {Key? key, required this.beehive, required this.showOnlyAnalysis})
      : super(key: key);

  @override
  _Properties createState() => _Properties();
}

class _Properties extends State<Properties> with TickerProviderStateMixin {
  late Beehive _hive;

  Color _animatedTextColor = colorBlack;

  late final _collection =
      fireStore.collection(collectionHives).doc(_hive.docId);

  @override
  Widget build(BuildContext context) {
    _hive = widget.beehive;
    _celsiusController.forward(from: 0);
    if (widget.showOnlyAnalysis) return _showOnlyAnalysis();
    return StreamBuilder<DocumentSnapshot>(
        stream: _collection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Collecting data"));
          }
          final map = snapshot.requireData.data() as Map<String, dynamic>;
          parseData(map);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _propertyItem(
                    svgCelsius,
                    _hive.properties.temperature?.toPrecision(2),
                    _doubleAnimation(_tempUpdateScaleController),
                    colorAnimation(_tempUpdateScaleController),
                  ),
                  _propertyItem(
                    svgScale,
                    _hive.properties.weight?.toPrecision(2),
                    _doubleAnimation(_weiUpdateScaleController),
                    colorAnimation(_weiUpdateScaleController),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _propertyItem(
                    svgBees,
                    _hive.properties.population,
                    _doubleAnimation(_popUpdateScaleController),
                    colorAnimation(_popUpdateScaleController),
                  ),
                  _propertyItem(
                    svgHumidity,
                    '${_hive.properties.humidity?.toPrecision(2)}%',
                    _doubleAnimation(_humUpdateScaleController),
                    colorAnimation(_humUpdateScaleController),
                  ),
                ],
              ),
            ],
          );
        });
  }

  parseData(Map<String, dynamic> doc) {
    try {
      final properties = doc[fieldProperties] as Map<String, dynamic>;
      final oldTemperature = _hive.properties.temperature;
      final oldHumidity = _hive.properties.humidity;
      final oldWeight = _hive.properties.weight;
      final oldPopulation = _hive.properties.population;
      _hive.properties.temperature = properties[fieldTemperature] as double;
      _hive.properties.humidity = properties[fieldHumidity] as double;
      _hive.properties.weight = properties[fieldWeight] as double;
      _hive.properties.population = properties[fieldPopulation] as int;
      if (oldTemperature != _hive.properties.temperature) {
        _tempUpdateScaleController.forward(from: 0).whenComplete(() {
          _tempUpdateScaleController.reverse(from: 1);
        });
      }
      if (oldHumidity != _hive.properties.humidity) {
        _humUpdateScaleController.forward(from: 0).whenComplete(() {
          _humUpdateScaleController.reverse(from: 1);
        });
      }
      if (oldWeight != _hive.properties.weight) {
        _weiUpdateScaleController.forward(from: 0).whenComplete(() {
          _weiUpdateScaleController.reverse(from: 1);
        });
      }
      if (oldPopulation != _hive.properties.population) {
        _popUpdateScaleController.forward(from: 0).whenComplete(() {
          _popUpdateScaleController.reverse(from: 1);
        });
      }
      logInfo('Properties => ${_hive.properties.toMap()}');
    } catch (ex) {
      logError('properties => $ex');
    }
  }

  _showOnlyAnalysis() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _openAlerts(_hive),
              child: _propertyIconItem(
                Icons.alarm,
                alerts,
                () => _openAlerts(_hive),
              ),
            ),
            GestureDetector(
              onTap: () => _openAnalysis(_hive, AlertType.temperature),
              child: _analysisItem(
                AlertType.temperature,
                () => _openAnalysis(_hive, AlertType.temperature),
              ),
            ),
            GestureDetector(
              onTap: () => _openAnalysis(_hive, AlertType.weight),
              child: _analysisItem(
                AlertType.weight,
                () => _openAnalysis(_hive, AlertType.weight),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _openAnalysis(_hive, AlertType.swarming),
              child: _analysisItem(
                AlertType.swarming,
                () => _openAnalysis(_hive, AlertType.swarming),
              ),
            ),
            GestureDetector(
              onTap: () => _openAnalysis(_hive, AlertType.humidity),
              child: _analysisItem(
                AlertType.humidity,
                () => _openAnalysis(_hive, AlertType.humidity),
              ),
            ),
            GestureDetector(
              onTap: () => _openAnalysis(_hive, AlertType.population),
              child: _analysisItem(
                AlertType.population,
                () => _openAnalysis(_hive, AlertType.population),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // todo add color animation when updating values from database
  _propertyItem(
    String svg,
    dynamic text,
    Animation<double> scale,
    Animation<Color> color,
  ) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeInAnimation,
        child: Column(
          children: [
            Container(
              margin: bottom(10),
              child: SvgPicture.asset(
                svg,
                width: screenHeight * 0.07,
                height: screenHeight * 0.07,
              ),
            ),
            ScaleTransition(
              scale: scale,
              child: Text(
                '$text',
                style: ebTS(color: color.value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _propertyIconItem(IconData data, String text, Function()? press) {
    return SlideTransition(
      position: _iconOffsetAnimation,
      child: FadeTransition(
        opacity: _fadeInAnimation,
        child: Column(
          children: [
            Container(
              margin: bottom(10),
              child: Padding(
                padding: all(2),
                child: Icon(
                  data,
                  size: screenHeight * 0.07,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: press,
              child: Text(
                text,
                style: mTS(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _analysisItem(AlertType type, Function()? press) {
    return SlideTransition(
      position: _iconOffsetAnimation,
      child: FadeTransition(
        opacity: _fadeInAnimation,
        child: Column(
          children: [
            Container(
              margin: bottom(10),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Padding(
                    padding: all(2),
                    child: type != AlertType.swarming
                        ? SvgPicture.asset(
                            type.icon,
                            width: screenHeight * 0.07,
                            height: screenHeight * 0.07,
                          )
                        : Image.asset(
                            type.icon,
                            width: screenHeight * 0.07,
                            height: screenHeight * 0.07,
                          ),
                  ),
                  Icon(
                    Icons.bar_chart,
                    size: 18,
                    color: type.color,
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: press,
              child: Text(
                type.description,
                style: mTS(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late final AnimationController _celsiusController = animationController();
  late final Animation<Offset> _iconOffsetAnimation =
      offsetAnimation(_celsiusController);
  late final Animation<double> _fadeInAnimation =
      doubleAnimation(_celsiusController);
  late final Animation<double> _scaleAnimation =
      doubleAnimation(_celsiusController);

  late final AnimationController _tempUpdateScaleController =
      animationController(duration: const Duration(milliseconds: 500));
  late final AnimationController _humUpdateScaleController =
      animationController(duration: const Duration(milliseconds: 500));
  late final AnimationController _weiUpdateScaleController =
      animationController(duration: const Duration(milliseconds: 500));
  late final AnimationController _popUpdateScaleController =
      animationController(duration: const Duration(milliseconds: 500));

  _doubleAnimation(parent) => doubleAnimation(parent, begin: 1.0, end: 1.2);

  @override
  void dispose() {
    _celsiusController.dispose();
    _tempUpdateScaleController.dispose();
    _humUpdateScaleController.dispose();
    _weiUpdateScaleController.dispose();
    _popUpdateScaleController.dispose();
    super.dispose();
  }

  _openAlerts(Beehive hive) {
    Navigator.of(context).push(
      enterFromRight(
        Alerts(hive: hive),
      ),
    );
  }

  _openAnalysis(Beehive hive, AlertType type) {
    Navigator.of(context).push(
      enterFromRight(
        Analysis(
          hive: hive,
          type: type,
        ),
      ),
    );
  }
}
