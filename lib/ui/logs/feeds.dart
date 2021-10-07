import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';

const _tag = 'Feeds';

class Feeds extends StatefulWidget {
  final LogFeeds? logFeeds;

  const Feeds({Key? key, required this.logFeeds}) : super(key: key);

  @override
  _Feeds createState() => _Feeds();
}

class _Feeds extends State<Feeds> {
  late LogFeeds? _logFeeds;

  @override
  Widget build(BuildContext context) {
    _logFeeds = widget.logFeeds;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            logFeeds,
            style: mTS(),
          ),
          centerTitle: true,
        ),
        body: Container(),
      ),
    );
  }
}
