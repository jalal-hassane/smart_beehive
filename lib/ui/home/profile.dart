import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/strings.dart';

const _tag = 'Profile';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          profile,
        ),
      ),
    );
  }
}
