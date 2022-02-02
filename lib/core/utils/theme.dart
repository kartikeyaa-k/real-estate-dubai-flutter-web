import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';

import 'constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
      primaryColor: kPrimaryColor,
      accentColor: kAccentColor,
      backgroundColor: kPrimaryColor[5],
      scrollbarTheme: ScrollbarThemeData(isAlwaysShown: true, showTrackOnHover: true));
}
