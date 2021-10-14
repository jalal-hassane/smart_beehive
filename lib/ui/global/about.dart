import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/hive_logs.dart';
import 'package:smart_beehive/main.dart';

const _tag = 'About';

class About extends StatefulWidget {
  final List<ItemAbout> items;

  final bool treatment;

  const About({
    Key? key,
    required this.items,
    required this.treatment,
  }) : super(key: key);

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
            textAbout,
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
    var _widgets = <Widget>[];
    if (widget.items.isEmpty) return _widgets;

    for (ItemAbout itemAbout in widget.items) {
      if (widget.treatment) {
        _widgets.add(_treatmentItem(itemAbout));
      } else {
        _widgets.add(_aboutItem(itemAbout));
      }
    }
    return _widgets;
  }

  _aboutItem(ItemAbout itemAbout) {
    return Padding(
      padding: all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                itemAbout.icon,
                height: 35,
                width: 35,
              ),
              Container(
                margin: left(5),
                child: Text(
                  itemAbout.title,
                  style: mTS(color: colorGreen),
                ),
              ),
            ],
          ),
          Container(
            margin: left(40),
            child: Text(
              itemAbout.description,
              style: rTS(),
            ),
          ),
        ],
      ),
    );
  }

  _treatmentItem(ItemAbout itemAbout) {
    return Padding(
      padding: all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemAbout.title,
            style: mTS(color: colorGreen),
          ),
          Image.asset(
            itemAbout.icon,
            //height: screenHeight * 0.25,
            width: screenWidth,
            fit: BoxFit.fitWidth,
          ),
          Container(
            margin: top(12),
            child: Text(
              itemAbout.description,
              style: rTS(),
            ),
          ),
        ],
      ),
    );
  }
}
