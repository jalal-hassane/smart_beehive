import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';

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
        ),
        body: Container(),
      ),
    );
  }
}
