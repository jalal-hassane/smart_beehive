import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/ui/home/alerts.dart';
import 'package:smart_beehive/ui/home/analysis.dart';

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
    _celsiusController.forward(from: 0);
    if (widget.showOnlyAnalysis) return _showOnlyAnalysis();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _propertyItem(svgCelsius, _hive.properties.temperature),
            _propertyItem(svgScale, _hive.properties.weight),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _propertyItem(svgBees, _hive.properties.population),
            _propertyItem(svgHumidity, '${_hive.properties.humidity}%'),
          ],
        )
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
              onTap: () => _openPage(alerts, _hive, 1),
              child: _propertyIconItem(
                Icons.alarm,
                alerts,
                () => _openPage(alerts, _hive, 1),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _openPage(analysis, _hive, 1),
              child: _propertyIconItem(
                Icons.bar_chart,
                analysis,
                () => _openPage(analysis, _hive, 1),
              ),
            ),
          ],
        )
      ],
    );
  }

  _propertyItem(String svg, dynamic text) {
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
                width: 50,
                height: 50,
              ),
            ),
            Text(
              text.toString(),
              style: ebTS(size: 18),
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
            Icon(
              data,
              size: 50,
            ),
            ElevatedButton(
              onPressed: press,
              child: Text(
                text,
                style: ebTS(size: 18),
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

  _openPage(String page, Beehive hive, int index) {
    Widget _screen;
    if (page == alerts) {
      _screen = Alerts(hive: hive, index: index);
    } else {
      _screen = Analysis(hive: hive, index: index);
    }
    Navigator.of(context).push(enterFromRight(_screen));
  }
}
