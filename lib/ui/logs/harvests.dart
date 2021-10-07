import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';

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
        ),
        body: Container(),
      ),
    );
  }
}
