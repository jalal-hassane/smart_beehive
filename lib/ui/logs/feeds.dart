import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/routes.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/ui/global/about.dart';
import 'package:smart_beehive/utils/extensions.dart';

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
        body: Center(
          child: GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            padding: all(12),
            children: _logFeeds!.logs.generateWidgets(),
          ),
        ),
      ),
    );
  }

  _openAbout() =>
      Navigator.of(context).push(enterFromRight(About(items: _logFeeds!.info)));
}
