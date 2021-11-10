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
import 'package:smart_beehive/ui/home/analysis/analysis.dart';
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

  late DocumentReference _collection =
      fireStore.collection(collectionProperties).doc(_hive.propertiesId);

  @override
  Widget build(BuildContext context) {
    _hive = widget.beehive;
    _collection =
        fireStore.collection(collectionProperties).doc(_hive.propertiesId);
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
        return parseData(map);
      },
    );
  }

  parseData(Map<String, dynamic> doc) {
    logInfo("DOC => " + doc.toString());
    logInfo("DOC => " + doc[fieldTemperature].toString());
    logInfo("DOC => " + doc[fieldHumidity].toString());
    logInfo("DOC => " + doc[fieldWeight].toString());
    logInfo("DOC => " + doc[fieldPopulation].toString());
    try {
      final oldTemperature = _hive.properties.temperature;
      final oldHumidity = _hive.properties.humidity;
      final oldWeight = _hive.properties.weight;
      final oldPopulation = _hive.properties.population;
      _hive.properties.temperature =
          double.parse(doc[fieldTemperature].toString());
      _hive.properties.humidity = double.parse(doc[fieldHumidity].toString());
      _hive.properties.weight = double.parse(doc[fieldWeight].toString());
      _hive.properties.population = doc[fieldPopulation] as int;

      logInfo('old temperature $oldTemperature');
      logInfo('old humidity $oldHumidity');
      logInfo('old weight $oldWeight');
      logInfo('old population $oldPopulation');

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
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _propertyItem(
                pngTemperature,
                _hive.properties.temperature?.toPrecision(2),
                _doubleAnimation(_tempUpdateScaleController),
                //colorAnimation(_tempUpdateScaleController),
              ),
              _propertyItem(
                pngWeight,
                _hive.properties.weight?.toPrecision(2),
                _doubleAnimation(_weiUpdateScaleController),
                //colorAnimation(_weiUpdateScaleController),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _propertyItem(
                pngBeesCount,
                _hive.properties.population,
                _doubleAnimation(_popUpdateScaleController),
                //colorAnimation(_popUpdateScaleController),
              ),
              _propertyItem(
                pngHumidity,
                '${_hive.properties.humidity?.toPrecision(2)}%',
                _doubleAnimation(_humUpdateScaleController),
                //colorAnimation(_humUpdateScaleController),
              ),
            ],
          ),
        ],
      );
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
                pngAlert,
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
    String png,
    dynamic text,
    Animation<double> scale,
    //Animation<Color> color,
  ) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _fadeInAnimation,
        child: Column(
          children: [
            Container(
              margin: bottom(10),
              child: Image.asset(
                png,
                width: screenHeight * 0.07,
                height: screenHeight * 0.07,
              ),
            ),
            ScaleTransition(
              scale: scale,
              child: Text(
                '$text',
                style: ebTS(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _propertyIconItem(String png, String text, Function()? press) {
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
                child: Image.asset(png, width: screenHeight * 0.06,height: screenHeight * 0.06,),
              ),
            ),
            ElevatedButton(
              onPressed: press,
              style: ElevatedButton.styleFrom(
                  primary: colorPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(31)
                  )
              ),
              child: Text(text, style: mTS()),
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
                    child: Image.asset(
                      type.icon,
                      width: screenHeight * type.size,
                      height: screenHeight * type.size,
                    ),
                  ),
                  /*Icon(
                    Icons.bar_chart,
                    size: 18,
                    color: type.color,
                  ),*/
                ],
              ),
            ),
            ElevatedButton(
              onPressed: press,
              style: ElevatedButton.styleFrom(
                primary: colorPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(31)
                )
              ),
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
    logInfo('dispose from properties');
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
