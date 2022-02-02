import 'package:flutter/material.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';

class PrimaryOutlinedButton extends StatefulWidget {
  final IconData? icon;
  final String? text;
  final Color borderColor;
  final Color? onHoverColor;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final double fontSize;
  final Color color;

  const PrimaryOutlinedButton(
      {Key? key,
      this.icon,
      this.text,
      this.borderColor = kSupportBlue,
      this.onHoverColor,
      required this.onTap,
      this.width,
      this.height = 48,
      this.fontSize = 16,
      this.color = kSupportBlue})
      : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<PrimaryOutlinedButton> {
  List<BoxShadow>? shadow;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovering) {
        if (hovering) {
          print("the pointer is $hovering");
          setState(() {
            shadow = Shadows.small;
          });
        } else {
          setState(() {
            shadow = [];
          });
        }
      },
      child: AnimatedContainer(
        duration: Times.fast,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: widget.borderColor, width: 1),
            boxShadow: shadow,
            borderRadius: Corners.smBorder),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
