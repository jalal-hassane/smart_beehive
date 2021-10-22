import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_beehive/composite/colors.dart';
import 'package:smart_beehive/composite/strings.dart';
import 'package:smart_beehive/composite/styles.dart';

import 'assets.dart';
import 'decorations.dart';
import 'dimensions.dart';

Widget inAppLogo({Color textColor = colorBlack}) => Row(
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
        style: rTS(),
        cursorColor: colorBlack,
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
      child: Center(child: Text(text, style: mTS(size: 18))),
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
          period: const Duration(milliseconds: 2500),
          baseColor: Colors.white10,
          highlightColor: Colors.orangeAccent.withOpacity(0.5),
        ),
      ),
    ],
  );
}

Widget sheetTextField(
  double width,
  double height,
  TextEditingController controller,
  String hint, {
  TextInputType type = TextInputType.text,
  bool shouldHideText = false,
  bool last = false,
  void Function(String string)? submit,
  bool focus = true,
  bool alignVertical = false,
  Widget? suffix,
  ScrollController? scrollController,
}) {
  return Container(
    margin: symmetric(4, 16),
    decoration: BoxDecoration(
      color: colorBgRegistrationTextField,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Padding(
      padding: left(8),
      child: TextField(
        enabled: focus,
        autofocus: false,
        controller: controller,
        scrollController: scrollController,
        textAlignVertical: alignVertical?TextAlignVertical.center:null,
        textInputAction: last ? TextInputAction.done : TextInputAction.next,
        maxLines: 1,
        style: rTS(),
        cursorColor: colorBlack,
        keyboardType: type,
        obscureText: shouldHideText ? true : false,
        decoration: hintDecoration.copyWith(
          hintText: hint,
          suffixIcon: suffix,
        ),
        onSubmitted: last ? submit : null,
      ),
    ),
  );
}

overviewSheetItemWidget(
  TextEditingController controller,
  double width,
  double height,
  String text, {
  bool enabled = true,
  bool alignVertical = false,
  bool isLast = false,
  Widget? suffix,
  ScrollController? scrollController,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: left(16),
        child: Text(text, style: boTS(color: colorPrimary)),
      ),
      sheetTextField(
        width,
        height * 0.7,
        controller,
        text,
        last: isLast,
        focus: enabled,
        suffix: suffix,
        scrollController: scrollController,
        alignVertical:alignVertical
      ),
    ],
  );
}
