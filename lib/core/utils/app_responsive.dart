import 'package:flutter/material.dart';

class ScreenUtils {
  MediaQueryData query;

  ScreenUtils(this.query);

  double wp(percentage) {
    double result = (percentage * query.size.width) / 100;
    return result;
  }

  double hp(percentage) {
    double result = (percentage * query.size.height) / 100;
    return result;
  }

  bool isDeviceTablet() {
    var shortestSide = query.size.shortestSide;
//  600 here is a common breakpoint for a typical 7-inch tablet.
    return shortestSide > 600;
  }

  /// This method converts the text size in sp to percentage
  /// 1 sp = 0.130%
  double getFontSize(sp) {
    double result = hp(sp * 0.130);
    return result;
  }
}
