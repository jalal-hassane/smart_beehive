import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';

import '../main.dart';

extension StringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  String capitalize() {
    return "${this![0].toUpperCase()}${this!.substring(1)}";
  }

  bool isPng() => this!.endsWith('.png');
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}

extension ContextExtension on BuildContext {
  showCustomBottomSheet(Widget Function(BuildContext) builder,
      {Function()? onClosing, bool wrap = false}) {
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
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              onClosing: onClosing ?? () {},
              builder: builder,
            ),
          ),
        );
      },
    );
  }

  showCustomScaffoldBottomSheet(Widget Function(BuildContext) builder,
      {Function()? onClosing, bool wrap = false}) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      barrierColor: colorBlack.withOpacity(0.7),
      enableDrag: false,
      builder: (_) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 1) Navigator.pop(_);
            },
            child: FractionallySizedBox(
              heightFactor: 0.75,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: BottomSheet(
                  backgroundColor: colorWhite,
                  enableDrag: false,
                  constraints: BoxConstraints(
                    maxHeight: screenHeight * 0.75,
                    minHeight: screenHeight * 0.75,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  onClosing: onClosing ?? () {},
                  builder: builder,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  show(Widget Function(BuildContext) builder,
      {Function()? onClosing, bool wrap = false}) {
    showMaterialModalBottomSheet(
      context: this,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      expand: false,
      builder: builder,
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
      behavior: SnackBarBehavior.floating,
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

extension TreatmentWidgetsGenerator on List<ItemTreatment> {
  generateTreatmentsWidgets(List<Function()> taps) {
    return List.generate(length, (index) {
      return GestureDetector(
        onTap: () => taps[index].call(),
        child: _itemLogWidget(this[index], stayActive: true),
      );
    });
  }

  _itemLogWidget(ItemTreatment itemLog, {bool stayActive = true}) {
    return Column(
      children: [
        Image.asset(
          itemLog.isActive2 ? itemLog.activeIcon! : itemLog.icon,
          height: 40,
          width: 40,
          color: itemLog.isActive2 ? null : Colors.blueGrey,
        ),
        Container(
          margin: top(12),
          child: Text(
            itemLog.description,
            style: mTS(
              size: 10,
              color: itemLog.isActive2 ? colorBlack : Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
}

extension HarvestWidgetsGenerator on List<ItemHarvest> {
  generateHarvestsWidgets(List<Function()> taps) {
    return List.generate(length, (index) {
      return GestureDetector(
        onTap: () => taps[index].call(),
        child: Column(
          children: [
            Visibility(
              visible: this[index].isActive,
              maintainState: true,
              maintainAnimation: true,
              maintainSize: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    this[index].value?.toString() ?? '',
                    style: sbTS(size: 12),
                  ),
                  Text(
                    this[index].unit?.description ?? '',
                    style: rTS(size: 8),
                  ),
                ],
              ),
            ),
            _itemLogWidget(this[index], stayActive: true),
          ],
        ),
      );
    });
  }

  _itemLogWidget(ItemHarvest itemLog, {bool stayActive = true}) {
    return Column(
      children: [
        Image.asset(
          itemLog.icon,
          height: 40,
          width: 40,
          color: itemLog.isActive ? null : Colors.blueGrey,
        ),
        Container(
          margin: top(12),
          child: Text(
            itemLog.title,
            style: mTS(
              size: 10,
              color: itemLog.isActive ? colorBlack : Colors.blueGrey,
            ),
          ),
        ),
      ],
    );
  }
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
    Function(String t, String i, QueenStatus status, Color? color) tap,
  ) {
    return List.generate(length, (index) {
      return GestureDetector(
        onTap: () {
          tap.call(
            this[index].icon,
            this[index].title,
            QueenStatus.values[index],
            this[index].color,
          );
        },
        child: _coloredItemLogWidget(this[index]),
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

  generateSyrupWidgets(
    Function(String t, String i, SyrupType status) tap,
  ) {
    return List.generate(length, (index) {
      return GestureDetector(
          onTap: () {
            tap.call(
                this[index].icon, this[index].title, SyrupType.values[index]);
          },
          child: _itemLogWidget(this[index]));
    });
  }

  generatePattyWidgets(
    Function(String t, String i, PattyType status) tap,
  ) {
    return List.generate(length, (index) {
      return GestureDetector(
        onTap: () {
          tap.call(
              this[index].icon, this[index].title, PattyType.values[index]);
        },
        child: _itemLogWidget(
          this[index],
        ),
      );
    });
  }

  _coloredItemLogWidget(
    ItemLog itemLog,
  ) {
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

extension AnimationHandler on TickerProviderStateMixin {
  AnimationController animationController(
          {Duration duration = const Duration(seconds: 1)}) =>
      AnimationController(
        duration: duration,
        vsync: this,
        lowerBound: 0.0,
        upperBound: 1.0,
      );

  Animation<double> doubleAnimation(
    AnimationController parent, {
    double begin = 0.0,
    double end = 1.0,
  }) =>
      Tween<double>(
        begin: begin,
        end: end,
      ).animate(
        CurvedAnimation(
          parent: parent,
          curve: Curves.ease,
        ),
      );

  Animation<Offset> offsetAnimation(
    AnimationController parent, {
    Offset? begin,
    Offset end = Offset.zero,
  }) =>
      Tween<Offset>(
        begin: begin ?? const Offset(0.0, 2.0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: parent,
          curve: Curves.ease,
        ),
      );

  Animation<Color> colorAnimation(
    AnimationController parent, {
    Color begin = Colors.black,
    Color end = Colors.blue,
  }) =>
      Tween<Color>(
        begin: begin,
        end: end,
      ).animate(parent);
}
