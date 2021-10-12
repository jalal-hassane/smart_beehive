import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/ui/global/about.dart';
import 'package:smart_beehive/utils/extensions.dart';

import '../../main.dart';

const _tag = 'Treatment';

class Treatment extends StatefulWidget {
  final LogTreatment? logTreatment;

  const Treatment({Key? key, required this.logTreatment}) : super(key: key);

  @override
  _Treatment createState() => _Treatment();
}

class _Treatment extends State<Treatment> {
  late LogTreatment? _logTreatment;

  @override
  Widget build(BuildContext context) {
    _logTreatment = widget.logTreatment;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            logTreatment,
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: GridView.count(
                key: UniqueKey(),
                crossAxisCount: 3,
                shrinkWrap: true,
                padding: all(12),
                children: _logTreatment!.logs.generateWidgets(_taps),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _logTreatment?.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red[200],
              ),
              child: SizedBox(
                width: screenWidth * 0.4,
                height: screenHeight * 0.056,
                child: Center(
                  child: Text(
                    textClear,
                    style: mTS(color: colorWhite),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _openAbout() => Navigator.of(context)
      .push(enterFromRight(About(items: _logTreatment!.info)));
  final _taps = <Function()>[];

  _generateTaps() {
    for (int i = 0; i < _logTreatment!.logs.length; i++) {
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
