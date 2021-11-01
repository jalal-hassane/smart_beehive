import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/alert.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/main.dart';
import 'package:smart_beehive/ui/home/alerts/alerts.dart';
import 'package:smart_beehive/ui/home/analysis.dart';
import 'package:smart_beehive/utils/extensions.dart';

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

  @override
  Widget build(BuildContext context) {
    _hive = widget.beehive;
    _hive.properties.generateNewProperties();
    _celsiusController.forward(from: 0);
    if (widget.showOnlyAnalysis) return _showOnlyAnalysis();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _propertyItem(
              svgCelsius,
              _hive.properties.temperature?.toPrecision(1),
            ),
            _propertyItem(
              svgScale,
              _hive.properties.weight?.toPrecision(1),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _propertyItem(svgBees, _hive.properties.population),
            _propertyItem(
              svgHumidity,
              '${_hive.properties.humidity?.toPrecision(1)}%',
            ),
          ],
        ),
      ],
    );
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

  _propertyItem(
    String svg,
    dynamic text,
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
            Text(
              text.toString(),
              style: ebTS(),
            ),
          ],
        ),
      ),
    );
  }

  _propertyIconItem(IconData data, String text, Function()? press) {
    return SlideTransition(
      position: _iconOffsetAnimation,
      //scale: _scaleAnimation,
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
      //scale: _scaleAnimation,
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

  late final AnimationController _celsiusController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  late final Animation<Offset> _iconOffsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, 2.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _celsiusController,
    curve: Curves.ease,
  ));

  late final Animation<double> _fadeInAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _celsiusController,
      curve: Curves.ease,
    ),
  );

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _celsiusController,
      curve: Curves.ease,
    ),
  );

  @override
  void dispose() {
    _celsiusController.dispose();
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
