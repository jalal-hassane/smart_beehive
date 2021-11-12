import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'fonts.dart';

const regularFontStyle = TextStyle(
  fontFamily: robotoRegular,
  height: 1,
);

const mediumFontStyle = TextStyle(
  fontFamily: robotoMedium,
  height: 1,
);

const boldFontStyle = TextStyle(
  fontFamily: robotoBold,
  height: 1,
);


const blackFontStyle = TextStyle(
  fontFamily: robotoBlack,
  height: 1,
);

// black textStyle
TextStyle bTS({
  double size = 14,
  Color color = colorBlack,
}) =>
    blackFontStyle.copyWith(fontSize: size, color: color);

// regular textStyle
TextStyle rTS({
  double size = 14,
  Color color = colorBlack,
}) =>
    regularFontStyle.copyWith(fontSize: size, color: color);

// medium textStyle
TextStyle mTS({
  double size = 14,
  Color color = colorBlack,
}) =>
    mediumFontStyle.copyWith(fontSize: size, color: color);

// bold textStyle
TextStyle boTS({
  double size = 14,
  Color color = colorBlack,
}) =>
    boldFontStyle.copyWith(fontSize: size, color: color);


final bottomNavigationTextStyle = regularFontStyle.copyWith(
  color: colorPrimary,
  fontSize: 12,
);

final buttonStyle = ElevatedButton.styleFrom(
  primary: colorPrimary,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(31),
  ),
);
