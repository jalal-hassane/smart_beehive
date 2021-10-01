import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/main.dart';

const _tag = 'Overview';

class Overview extends StatefulWidget {
  final Beehive beehive;

  const Overview({Key? key, required this.beehive}) : super(key: key);

  @override
  _Overview createState() => _Overview();
}

class _Overview extends State<Overview> with TickerProviderStateMixin {
  late Beehive _hive;

  @override
  Widget build(BuildContext context) {
    _hive = widget.beehive;
    _animationController.forward(from: 0);
    return Padding(
      padding: all(16),
      child: Column(
        children: [
          _overviewItem(
            textName,
            _hive.overview.name,
            _offsetAnimation(-1.0),
          ),
          //_divider,
          _overviewItem(
            textHiveType,
            _hive.overview.type,
            _offsetAnimation(-2.0),
          ),
          //_divider,
          _overviewItem(
            textInstallationDate,
            _hive.overview.installationDate,
            _offsetAnimation(-3.0),
          ),
          //_divider,
          _overviewItem(
            textColonyAge,
            _hive.overview.colonyAge,
            _offsetAnimation(1.0),
          ),
          //_divider,
          _overviewItem(
            textSpecies,
            _hive.overview.species,
            _offsetAnimation(2.0),
          ),
          //_divider,
          _overviewItem(
            textLocation,
            _hive.overview.location,
            _offsetAnimation(3.0),
          ),
        ],
      ),
    );
  }

  final _divider = const Flexible(
    child: Divider(
      height: 1,
      indent: 3,
      color: colorBlack,
    ),
  );

  _overviewItem(String title, String? value, Animation<Offset> tween) {
    return SlideTransition(
      position: tween,
      child: SizedBox(
        height: screenHeight * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: mTS(color: colorBlack),
            ),
            Text(
              value!,
              style: rTS(color: colorBlack),
            ),
          ],
        ),
      ),
    );
  }

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  Animation<Offset> _offsetAnimation(double start) {
    return Tween<Offset>(
      begin: Offset(0.0, start),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.ease,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
