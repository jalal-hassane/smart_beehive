import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/strings.dart';

const _tag = 'Notifications';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  _Notifications createState() => _Notifications();
}

class _Notifications extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          notifications,
        ),
      ),
    );
  }
}
