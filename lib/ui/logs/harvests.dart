import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/ui/global/about.dart';
import 'package:smart_beehive/utils/extensions.dart';

const _tag = 'Harvests';

class Harvests extends StatefulWidget {
  final LogHarvests? logHarvests;

  const Harvests({Key? key, required this.logHarvests}) : super(key: key);

  @override
  _Harvests createState() => _Harvests();
}

class _Harvests extends State<Harvests> {
  late LogHarvests? _logHarvests;

  @override
  Widget build(BuildContext context) {
    _logHarvests = widget.logHarvests;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            logHarvests,
            style: mTS(),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: right(12),
              child: IconButton(
                icon: const Icon(
                  Icons.info_rounded,
                  color: colorBlack,
                ),
                onPressed: () => _openAbout(),
              ),
            ),
          ],
        ),
        body: Center(
          child: GridView.count(
            key: UniqueKey(),
            crossAxisCount: 3,
            shrinkWrap: true,
            padding: all(12),
            children: _logHarvests!.logs.generateWidgets(_taps),
          ),
        ),
      ),
    );
  }

  _openAbout() => Navigator.of(context)
      .push(enterFromRight(About(items: _logHarvests!.info)));

  final _taps = <Function()>[];

  _generateTaps() {
    for (int i = 0; i < _logHarvests!.logs.length; i++) {
      final f = context.showCustomBottomSheet((p0) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [],
            );
          },
        );
      });
      _taps.add(f);
    }
  }
}
