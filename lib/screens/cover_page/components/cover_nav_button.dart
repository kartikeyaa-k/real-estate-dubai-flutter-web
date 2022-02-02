import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:real_estate_portal/components/buttons/base_button.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

class CoverNavButton extends StatelessWidget {
  const CoverNavButton(
      {Key? key,
      required this.onTap,
      required this.text,
      this.icon,
      this.textStyle,
      this.isLoading = false,
      this.disabled = false})
      : super(key: key);
  final VoidCallback onTap;
  final String text;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isLoading;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final Widget _child = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text, style: textStyle ?? TextStyles.body16.copyWith(color: Colors.white)),
        if (icon != null) ...[
          SizedBox(width: 16),
          icon!,
        ],
      ],
    );

    final Widget _spinkit = Center(
      child: SpinKitThreeBounce(
        color: Colors.white,
        duration: Times.slower,
        size: 12,
      ),
    );

    return BaseButton(
      onTap: onTap,
      backgroundColor: kSupportBlue,
      child: _child,
      loader: _spinkit,
      isLoading: isLoading,
      disabled: disabled,
      disableColor: kDisableColor,
    );
  }
}
