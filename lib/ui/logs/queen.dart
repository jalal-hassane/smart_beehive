import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/ui/global/about.dart';

const _tag = 'Queen';

class Queen extends StatefulWidget {
  final LogQueen? logQueen;

  const Queen({Key? key, required this.logQueen}) : super(key: key);

  @override
  _Queen createState() => _Queen();
}

class _Queen extends State<Queen> {
  late LogQueen? _logQueen;

  @override
  Widget build(BuildContext context) {
    _logQueen = widget.logQueen;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            logQueen,
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
                onPressed: ()=>_openAbout(),
              ),
            ),
          ],
        ),
        body: Container(),
      ),
    );
  }

  _openAbout() =>
      Navigator.of(context).push(enterFromRight(About(items: _logQueen!.info)));
}
