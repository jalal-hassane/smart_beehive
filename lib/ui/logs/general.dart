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

const _tag = 'General';

class General extends StatefulWidget {
  final LogGeneral? logGeneral;

  const General({Key? key, required this.logGeneral}) : super(key: key);

  @override
  _General createState() => _General();
}

class _General extends State<General> {
  late LogGeneral? _logGeneral;

  @override
  Widget build(BuildContext context) {
    _logGeneral = widget.logGeneral;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            logGeneral,
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
                children: _logGeneral!.logs.generateWidgets(_taps),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _logGeneral?.clear();
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
      .push(enterFromRight(About(items: _logGeneral!.info,treatment: false,)));

  final _taps = <Function()>[];

  _generateTaps() {
    for (int i = 0; i < _logGeneral!.logs.length; i++) {
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
