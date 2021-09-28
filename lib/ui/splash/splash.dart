import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/ui/registration/registration.dart';
import 'package:smart_beehive/utils/pref_utils.dart';

import '../../main.dart';
import '../home.dart';

const _tag = 'Home';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    screenBottomPadding = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.yellow,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    textSmart,
                    style: bTS(size: 38, color: Colors.black),
                  ),
                  Lottie.asset(
                    lottieBee,
                    repeat: true,
                    height: 100,
                    width: 100,
                  ),
                  Text(
                    textHive,
                    style: bTS(size: 38, color: Colors.black),
                  )
                ],
              ),
              Center(
                child: Text(
                  textTrackHint,
                  textAlign: TextAlign.center,
                  style: rTS(size: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _checkLogin() {
    Future.delayed(const Duration(seconds: 5), () async {
      final isLoggedIn = await PrefUtils.isLoggedIn;
      Widget _next;
      String _settings;
      if (isLoggedIn) {
        _next = const Home();
        _settings = settingHome;
      } else {
        _next = const Registration();
        _settings = settingRegistration;
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          settings: RouteSettings(name: _settings),
          builder: (context) => _next,
        ),
      );
    });
  }
}
