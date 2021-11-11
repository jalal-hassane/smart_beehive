import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smart_beehive/composite/assets.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';
import 'package:smart_beehive/data/local/models/beekeeper.dart';
import 'package:smart_beehive/ui/registration/registration.dart';
import 'package:smart_beehive/utils/constants.dart';
import 'package:smart_beehive/utils/log_utils.dart';
import 'package:smart_beehive/utils/pref_utils.dart';

import '../../main.dart';
import '../home.dart';
import 'splash_viewmodel.dart';

const _tag = 'Splash';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {
  late SplashViewModel _splashViewModel;

  @override
  Widget build(BuildContext context) {
    _initViewModel();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    screenBottomPadding = MediaQuery.of(context).padding.bottom;
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorPrimary,
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
    Future.delayed(const Duration(seconds: 1), () async {
      if (!mounted) return;
      final isLoggedIn = await PrefUtils.isLoggedIn;
      Widget _next;
      String _settings;
      if (isLoggedIn) {
        _splashViewModel.checkIn();
      } else {
        _next = const Registration();
        _settings = settingRegistration;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            settings: RouteSettings(name: _settings),
            builder: (context) => _next,
          ),
        );
      }
    });
  }

  _initViewModel() {
    _splashViewModel = Provider.of<SplashViewModel>(context);
    _splashViewModel.helper = SplashHelper(
      success: _success,
      failure: _failure,
    );
    _checkLogin();
  }

  _success(Beekeeper beekeeper) {
    me = beekeeper;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        settings: const RouteSettings(name: settingHome),
        builder: (context) => const Home(),
      ),
    );
  }

  _failure(String error) {
    if (error == errorNoAuthToken) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          settings: const RouteSettings(name: settingRegistration),
          builder: (context) => const Registration(),
        ),
      );
    } else {
      // handle more errors later
      logInfo(error);
    }
  }
}
