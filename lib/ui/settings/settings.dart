import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/strings.dart';

const _tag = 'Settings';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _Settings createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          settings,
        ),
      ),
    );
  }
}
