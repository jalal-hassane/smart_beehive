import 'package:flutter/cupertino.dart';

EdgeInsets top(double margin) {
  return EdgeInsets.only(top: margin);
}

EdgeInsets bottom(double margin) {
  return EdgeInsets.only(bottom: margin);
}

EdgeInsets left(double margin) {
  return EdgeInsets.only(left: margin);
}

EdgeInsets right(double margin) {
  return EdgeInsets.only(right: margin);
}

EdgeInsets all(double margin) {
  return EdgeInsets.all(margin);
}

EdgeInsets trbl(double top, double right, double bottom, double left) {
  return EdgeInsets.only(top: top, right: right, bottom: bottom, left: left);
}

EdgeInsets symmetric(double vertical, double horizontal) {
  return EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
}
