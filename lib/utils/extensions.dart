import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/data/local/models/alert.dart';

extension IsNullOrEmpty on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  AlertType get alertFromString{
    switch(this){
      case typeTemperature: return AlertType.TEMPERATURE;
      case typeWeight: return AlertType.WEIGHT;
      case typePopulation: return AlertType.POPULATION;
      default: return AlertType.HUMIDITY;
    }
  }
}

extension Ex on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
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
