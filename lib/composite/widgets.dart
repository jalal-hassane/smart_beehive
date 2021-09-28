import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';

import 'assets.dart';
import 'decorations.dart';
import 'dimensions.dart';

Widget inAppLogo({
  Color textColor = colorBlack
}) => Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Text(
      textSmart,
      style: bTS(size: 20, color: textColor),
    ),
    Lottie.asset(
      lottieBee,
      repeat: true,
      height: 50,
      width: 50,
    ),
    Text(
      textHive,
      style: bTS(size: 20, color: textColor),
    )
  ],
);

Widget registrationTextField(
  double width,
  double height,
  TextEditingController controller,
  String hint, {
  TextInputType type = TextInputType.text,
  bool shouldHideText = false,
  bool last = false,
  void Function(String string)? submit,
}) {
  return Container(
    margin: symmetric(0, 8),
    width: width * 0.9,
    height: height * 0.05,
    decoration: BoxDecoration(
      color: colorBgRegistrationTextField,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Center(
      child: TextField(
        textAlign: TextAlign.center,
        autofocus: false,
        controller: controller,
        textInputAction: last ? TextInputAction.done : TextInputAction.next,
        maxLines: 1,
        style: rTS(color: colorBlack),
        keyboardType: type,
        obscureText: shouldHideText ? true : false,
        decoration: horizontalPaddingDecoration.copyWith(hintText: hint),
        onSubmitted: last ? submit : null,
      ),
    ),
  );
}

Widget proceedButton(double width, double height, String text,
    {bool showShimmer = true}) {
  final _center = Center(
    child: Container(
      width: width * 0.6,
      height: height * 0.055,
      decoration: BoxDecoration(
        color: colorPrimary,
        borderRadius: BorderRadius.circular(32),
        image: const DecorationImage(
          image: AssetImage(backgroundHoney_7),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: mTS(color: colorBlack, size: 18),
        ),
      ),
    ),
  );
  return Stack(
    children: [
      _center,
      Visibility(
        visible: showShimmer,
        maintainState: true,
        maintainAnimation: true,
        maintainSize: true,
        child: Shimmer.fromColors(
          child: _center,
          period: const Duration(
            milliseconds: 2500,
          ),
          baseColor: Colors.white10,
          highlightColor: Colors.orangeAccent.withOpacity(0.5),
        ),
      ),
    ],
  );
}
