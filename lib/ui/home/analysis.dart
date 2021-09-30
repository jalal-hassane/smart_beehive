import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/dimensions.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';

import '../../main.dart';

const _tag = 'Analysis';

class Analysis extends StatefulWidget {
  final int index;

  const Analysis({Key? key, required this.index}) : super(key: key);

  @override
  _Analysis createState() => _Analysis();
}

class _Analysis extends State<Analysis> {
  String _selectedHive = '';
  late Beehive _hive;

  @override
  void initState() {
    super.initState();
    _hive = beehives[widget.index];
    _selectedHive = _hive.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            analysis,
            style: mTS(color: colorBlack),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: right(12),
              child: IconButton(
                icon: const Icon(
                  Icons.date_range,
                  color: colorBlack,
                ),
                onPressed: () {
                  // show previous tests
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _startAnalysis,
          child: const Icon(
            Icons.add,
            color: colorBlack,
          ),
          backgroundColor: colorPrimary,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Hive',
                      style: boTS(color: colorBlack),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: DropdownButtonHideUnderline(
                    child: Container(
                      margin: right(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black45,
                      ),
                      child: Center(
                        child: DropdownButton<String>(
                          iconSize: 0,
                          value: _selectedHive,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedHive = newValue!;
                              _hive = beehives.firstWhere(
                                  (element) => _selectedHive == element.name);
                            });
                          },
                          dropdownColor: Colors.black45,
                          isExpanded: true,
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          ),
                          icon: const Icon(Icons.arrow_downward),
                          items: _dropDownItems(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: screenHeight * 0.15,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorBlack,
                            boxShadow: [
                              BoxShadow(
                                color: colorPrimary,
                                offset: Offset(0, 1.0), //(x,y)
                                blurRadius: 6.0,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.mic,
                            size: screenHeight * 0.12,
                            color: colorPrimary,
                          ),
                        ),
                        Text(
                          'Start Analysis',
                          style: rTS(color: colorBlack),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: _showTutorial,
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: trbl(12, 16, 0, 0),
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.black45,
                          ),
                          child: Center(
                            child: Text(
                              'i',
                              style: boTS(size: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _dropDownItems() {
    return beehives.map<DropdownMenuItem<String>>((Beehive value) {
      return DropdownMenuItem<String>(
        alignment: Alignment.center,
        value: value.name ?? '',
        child: Text(
          value.name ?? '',
          style: rTS(),
        ),
      );
    }).toList();
  }

  _startAnalysis() {}

  _showTutorial() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      builder: (_) {
        return BottomSheet(
          backgroundColor: colorBlack.withOpacity(0.8),
          constraints: BoxConstraints(
              maxHeight: screenHeight * 0.4, minHeight: screenHeight * 0.4),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          onClosing: () {},
          builder: (_) {
            return StatefulBuilder(
              builder: (_, setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'About The Analysis',
                      style: bTS(size: 30),
                    ),
                    Text(
                      'Record your bees buzzing for 15 seconds to get the results',
                      textAlign: TextAlign.center,
                      style: rTS(size: 16),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: screenWidth * 0.4,
                        height: screenHeight * 0.7 * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorWhite,
                        ),
                        child: Center(child: Text('Got It',style: mTS(),)),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
