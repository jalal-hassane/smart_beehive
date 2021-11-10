import 'package:flutter/cupertino.dart';

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

const extraBoldFontStyle = TextStyle(
  fontFamily: robotoExtraBold,
  height: 1,
);

const blackFontStyle = TextStyle(
  fontFamily: robotoBlack,
  height: 1,
);

const semiBoldFontStyle = TextStyle(
  fontFamily: robotoSemiBold,
  height: 1,
);

// black textStyle
TextStyle bTS({
  double size = 15,
  Color color = colorBlack,
}) =>
    blackFontStyle.copyWith(fontSize: size, color: color);

// regular textStyle
TextStyle rTS({
  double size = 15,
  Color color = colorBlack,
}) =>
    regularFontStyle.copyWith(fontSize: size, color: color);

// medium textStyle
TextStyle mTS({
  double size = 15,
  Color color = colorBlack,
}) =>
    mediumFontStyle.copyWith(fontSize: size, color: color);

// bold textStyle
TextStyle boTS({
  double size = 15,
  Color color = colorBlack,
}) =>
    blackFontStyle.copyWith(fontSize: size, color: color);

// semiBold textStyle
TextStyle sbTS({
  double size = 15,
  Color color = colorBlack,
}) =>
    blackFontStyle.copyWith(fontSize: size, color: color);

// extraBold textStyle
TextStyle ebTS({
  double size = 15,
  Color color = colorBlack,
}) =>
    blackFontStyle.copyWith(fontSize: size, color: color);

final bottomNavigationTextStyle = regularFontStyle.copyWith(
  color: colorPrimary,
  fontSize: 12,
);
