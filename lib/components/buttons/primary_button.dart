import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';
import 'base_button.dart';

class PrimaryButton extends StatefulWidget {
  final IconData? icon;
  final String? text;
  final Color backgroundColor;
  final Color? onHoverColor;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double fontSize;
  final Color color;
  final bool? isBorder;
  final EdgeInsets? padding;

  const PrimaryButton(
      {Key? key,
      this.icon,
      this.text,
      this.isBorder = false,
      this.backgroundColor = kSupportBlue,
      this.onHoverColor,
      required this.onTap,
      this.width = 162,
      this.height = 48,
      this.fontSize = 16,
      this.color = Colors.white,
      this.padding})
      : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<PrimaryButton> {
  Color? currentColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovering) {
        if (hovering) {
          setState(() {
            currentColor = widget.onHoverColor ?? kPrimaryColor.shade100;
          });
        } else {
          setState(() {
            currentColor = widget.backgroundColor;
          });
        }
      },
      child: AnimatedContainer(
        duration: Times.fast,
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: widget.width != null ? 0 : 16, vertical: 8),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            border: widget.isBorder == true ? Border.all(color: kPlainWhite) : null,
            color: currentColor ?? widget.backgroundColor,
            borderRadius: Corners.smBorder),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[Icon(widget.icon, size: 18, color: widget.color), SizedBox(width: 16)],
            if (widget.text != null)
              Text(
                widget.text!,
                style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.w400, color: widget.color),
              ),
          ],
        ),
      ),
    );
  }
}

class PrimaryElevatedButton extends StatelessWidget {
  const PrimaryElevatedButton(
      {Key? key,
      required this.onTap,
      required this.text,
      this.icon,
      this.textStyle,
      this.isLoading = false,
      this.disabled = false,
      this.width,
      this.height})
      : super(key: key);
  final VoidCallback onTap;
  final String text;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isLoading;
  final bool disabled;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final Widget _child = Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[icon!, SizedBox(width: 16)],
        Text(text, style: textStyle ?? TextStyles.body16.copyWith(color: Colors.white)),
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
        width: width,
        height: height ?? 48);
  }
}
