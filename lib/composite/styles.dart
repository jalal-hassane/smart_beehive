import 'package:flutter/cupertino.dart';

import 'colors.dart';
import 'fonts.dart';

const regularFontStyle = TextStyle(
  fontFamily: montserratRegular,
  height: 1,
);

const mediumFontStyle = TextStyle(
  fontFamily: montserratMedium,
  height: 1,
);

const boldFontStyle = TextStyle(
  fontFamily: montserratBold,
  height: 1,
);

const extraBoldFontStyle = TextStyle(
  fontFamily: montserratExtraBold,
  height: 1,
);

const blackFontStyle = TextStyle(
  fontFamily: montserratBlack,
  height: 1,
);

const semiBoldFontStyle = TextStyle(
  fontFamily: montserratSemiBold,
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
    blackFontStyle.copyWith(fontSize: size, color: color);

// semiBold textStyle
TextStyle sbTS({
  double size = 14,
  Color color = colorBlack,
}) =>
    blackFontStyle.copyWith(fontSize: size, color: color);

// extraBold textStyle
TextStyle ebTS({
  double size = 14,
  Color color = colorBlack,
}) =>
    blackFontStyle.copyWith(fontSize: size, color: color);

final bottomNavigationTextStyle = regularFontStyle.copyWith(
  color: colorPrimary,
  fontSize: 12,
);
