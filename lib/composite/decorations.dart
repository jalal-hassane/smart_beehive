import 'package:flutter/material.dart';
import 'package:smart_beehive/composite/styles.dart';

import 'colors.dart';
import 'dimensions.dart';

const defaultInputDecoration = InputDecoration(
  disabledBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
);

final hintDecoration = defaultInputDecoration.copyWith(
  hintStyle: mTS(size:18,color: colorBlack35),
);

final horizontalPaddingDecoration = hintDecoration.copyWith(
  contentPadding: symmetric(0, 8),
);
