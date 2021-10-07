import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';

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
        ),
        body: Container(),
      ),
    );
  }
}
