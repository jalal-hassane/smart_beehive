import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/main.dart';
import 'package:smart_beehive/ui/logs/feeds.dart';
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _itemLogWidget(pngQueen, logQueen, () => _openPage(1)),
              _itemLogWidget(pngFeeds, logFeeds, () => _openPage(3)),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _itemLogWidget(pngHarvests, logHarvests, () => _openPage(2)),
              _itemLogWidget(pngTreatment, logTreatment, () => _openPage(4)),
            ],
          ),
        ],
      ),
    );
  }

  _openPage(int page) {
    Widget _screen;
    switch (page) {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            asset,
            width: screenHeight * 0.07,
            height: screenHeight * 0.07,
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
    );
  }
}
