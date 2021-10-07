import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';

const _tag = 'About';

class About extends StatefulWidget {
  final List<ItemAbout> items;

  const About({Key? key, required this.items}) : super(key: key);

  @override
  _About createState() => _About();
}

class _About extends State<About> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'About',
            style: mTS(),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _itemsBuilder(),
          ),
        ),
      ),
    );
  }

  _itemsBuilder() {
    if (widget.items.isEmpty) return Container();
    var _widgets = <Widget>[];
    for (ItemAbout itemAbout in widget.items) {
      _widgets.add(
        Padding(
          padding: all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.extension,
                    size: 35,
                  ),
                  /*Image.asset(
                    itemAbout.icon,
                    height: 50,
                    width: 50,
                  ),*/
                  Text(
                    itemAbout.title,
                    style: mTS(color: colorGreen),
                  ),
                ],
              ),
              Container(
                margin: left(35),
                child: Text(
                  itemAbout.description,
                  style: rTS(),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return _widgets;
  }
}
