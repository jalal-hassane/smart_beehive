import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:smart_beehive/composite/assets.dart';

import '../../main.dart';

const _tag = 'Loading';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _Loading createState() => _Loading();
}

class _Loading extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Lottie.asset(
            lottieLoading,
            repeat: true,
            width: screenWidth * 0.25,
            height: screenWidth * 0.25,
          ),
        ),
      ),
    );
  }
}
