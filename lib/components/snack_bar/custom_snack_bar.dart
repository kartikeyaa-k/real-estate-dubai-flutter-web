import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:real_estate_portal/core/utils/constants.dart';

import '../../core/utils/styles.dart';

class CustomSnackBar {
  static SnackBar successSnackBar(String message) {
    return SnackBar(
      duration: Times.slower,
      backgroundColor: kPrimaryColor,
      // behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: Row(
        children: [
          SvgPicture.asset("assets/icons/check-circle.svg"),
          SizedBox(width: 18),
          Flexible(child: Text(message, style: TextStyles.body16.copyWith(color: kPrimaryColor[100])))
        ],
      ),
      action: SnackBarAction(
        label: 'X',
        textColor: kBlackVariant,
        onPressed: () {},
      ),
    );
  }

  static SnackBar errorSnackBar(String message) {
    return SnackBar(
      duration: Times.slower,
      backgroundColor: kErrorShade,
      // behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: Row(
        children: [
          SvgPicture.asset("assets/icons/error-triangle.svg"),
          SizedBox(width: 18),
          Flexible(child: Text(message, style: TextStyles.body16.copyWith(color: kErrorColor)))
        ],
      ),
      action: SnackBarAction(
        label: 'X',
        textColor: kBlackVariant,
        onPressed: () {},
      ),
    );
  }
}
