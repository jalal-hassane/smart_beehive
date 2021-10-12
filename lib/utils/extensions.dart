import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';

import '../main.dart';

extension IsNullOrEmpty on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  String capitalize() {
    return "${this![0].toUpperCase()}${this!.substring(1)}";
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension ContextExtension on BuildContext {
  showCustomBottomSheet(Widget Function(BuildContext) builder) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      enableDrag: false,
      builder: (_) {
        return GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.delta.dy > 1) Navigator.pop(_);
          },
          child: FractionallySizedBox(
            heightFactor: 0.9,
            child: BottomSheet(
              backgroundColor: colorBlack.withOpacity(0.7),
              enableDrag: false,
              constraints: BoxConstraints(
                maxHeight: screenHeight * 0.9,
                minHeight: screenHeight * 0.9,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              onClosing: () {},
              builder: builder,
            ),
          ),
        );
      },
    );
  }
}

// unfocus
unFocus(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}

/*Future<void> launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
    );
  } else {
    throw 'Could not launch $url';
  }
}*/

showSnackBar(BuildContext context, String text, {SnackBarAction? action}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
      ),
      action: action,
    ),
  );
}

String uuid() {
  Random random = Random(DateTime.now().millisecond);

  const String hexDigits = "0123456789abcdef";
  List<String> uuid = List.filled(36, '0');

  for (int i = 0; i < 36; i++) {
    final int hexPos = random.nextInt(16);
    uuid[i] = (hexDigits.substring(hexPos, hexPos + 1));
  }

  int pos = (int.parse(uuid[19], radix: 16) & 0x3) |
      0x8; // bits 6-7 of the clock_seq_hi_and_reserved to 01

  uuid[14] = "4"; // bits 12-15 of the time_hi_and_version field to 0010
  uuid[19] = hexDigits.substring(pos, pos + 1);

  uuid[8] = uuid[13] = uuid[18] = uuid[23] = "-";

  final StringBuffer buffer = StringBuffer();
  buffer.writeAll(uuid);
  return buffer.toString();
}

extension WidgetsGenerator on List<ItemLog> {
  generateWidgets(List<Function()> taps) {
    return List.generate(length, (index) {
      return GestureDetector(
        onTap: () => taps[index].call(),
        child: _itemLogWidget(this[index], stayActive: false),
      );
    });
  }

  generateQueenStatusWidgets(
    Function(String t, String i, QueenStatus status) tap,
  ) {
    return List.generate(length, (index) {
      return GestureDetector(
        onTap: () {
          tap.call(
              this[index].icon, this[index].title, QueenStatus.values[index]);
        },
        child: _itemLogWidget(this[index]),
      );
    });
  }

  generateMarkingWidgets(
    Function(String t, String i, QueenMarking marking) tap,
  ) {
    return List.generate(length, (index) {
      return GestureDetector(
        onTap: () {
          tap.call(
            this[index].icon,
            QueenMarking.values[index].text,
            QueenMarking.values[index],
          );
        },
        child: _itemLogWidget(this[index]),
      );
    });
  }

  generateCellsWidgets(
    Function(String t, String i, QueenCells cells) tap,
  ) {
    return List.generate(length, (index) {
      return GestureDetector(
        onTap: () {
          tap.call(
            this[index].icon,
            this[index].title,
            QueenCells.values[index],
          );
        },
        child: _itemLogWidget(this[index]),
      );
    });
  }

  generateSwarmStatusWidgets(
    Function(
      String t,
      String i,
      SwarmStatus status,
      Color? color,
    )
        tap,
  ) {
    return List.generate(length, (index) {
      return GestureDetector(
        onTap: () {
          tap.call(
            this[index].icon,
            this[index].title,
            SwarmStatus.values[index],
            this[index].color,
          );
        },
        child: _coloredItemLogWidget(this[index]),
      );
    });
  }

  _coloredItemLogWidget(ItemLog itemLog,) {
    return Column(
      children: [
        Image.asset(
          itemLog.icon,
          height: 40,
          width: 40,
          color: itemLog.color,
        ),
        Container(
          margin: top(12),
          child: Text(
            itemLog.title,
            style: mTS(
              size: 10,
              color: colorWhite,
            ),
          ),
        ),
      ],
    );
  }

  _itemLogWidget(ItemLog itemLog, {bool stayActive = true}) {
    return Column(
      children: [
        Image.asset(
          itemLog.icon,
          height: 40,
          width: 40,
          color: stayActive
              ? null
              : itemLog.isActive
                  ? itemLog.color
                  : Colors.blueGrey,
        ),
        Container(
          margin: top(12),
          child: Text(
            itemLog.title,
            style: mTS(
              size: 10,
              color: stayActive
                  ? colorWhite
                  : itemLog.isActive
                      ? colorBlack
                      : Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}
