import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/data/local/models/beehive.dart';

import '../../main.dart';

const _tag = 'Logs';

class Logs extends StatefulWidget {
  final Beehive beehive;
  const Logs({Key? key,required this.beehive}) : super(key: key);

  @override
  _Logs createState() => _Logs();
}

class _Logs extends State<Logs> {
  late Beehive _hive;
  @override
  Widget build(BuildContext context) {
    _hive = widget.beehive;
    return Center(
      child: Text('Logs'),
    );
  }
}
