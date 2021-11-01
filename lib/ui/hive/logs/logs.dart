import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/main.dart';
import 'package:smart_beehive/ui/logs/feeds.dart';
import 'package:smart_beehive/ui/logs/general.dart';
import 'package:smart_beehive/ui/logs/harvests.dart';
import 'package:smart_beehive/ui/logs/queen.dart';
import 'package:smart_beehive/ui/logs/treatment.dart';

const _tag = 'Logs';

class Logs extends StatefulWidget {
  final Beehive beehive;

  const Logs({Key? key, required this.beehive}) : super(key: key);

  @override
  _Logs createState() => _Logs();
}

class _Logs extends State<Logs> {
  late Beehive _hive;

  @override
  Widget build(BuildContext context) {
    _hive = widget.beehive;
    return Padding(
      padding: all(8),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //_itemLogWidget(pngGeneral, logGeneral, () => _openPage(0)),
                _itemLogWidget(pngQueen, logQueen, () => _openPage(1)),
                _itemLogWidget(pngHarvests, logHarvests, () => _openPage(2)),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _itemLogWidget(pngFeeds, logFeeds, () => _openPage(3)),
                _itemLogWidget(pngTreatment, logTreatment, () => _openPage(4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _openPage(int page) {
    Widget _screen;
    switch (page) {
      case 0:
        _screen = General(
          logGeneral: _hive.logs.general,
        );
        break;
      case 1:
        _screen = Queen(
          logQueen: _hive.logs.queen,
        );
        break;
      case 2:
        _screen = Harvests(
          logHarvests: _hive.logs.harvests,
        );
        break;
      case 3:
        _screen = Feeds(
          logFeeds: _hive.logs.feeds,
        );
        break;
      default:
        _screen = Treatment(
          logTreatment: _hive.logs.treatment,
        );
    }

    Navigator.of(context).push(enterFromBottom(_screen));
  }

  _itemLogWidget(String asset, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: screenHeight * 0.06,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              asset,
              width: screenHeight * 0.04,
              height: screenHeight * 0.04,
              fit: BoxFit.contain,
            ),
            Container(
              margin: top(12),
              child: Text(
                title,
                style: rTS(size: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
