import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:real_estate_portal/components/buttons/base_button.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

class PrimaryFlatButton extends StatefulWidget {
  PrimaryFlatButton(
      {Key? key, this.icon, this.mobileCoverScreen = false, this.text, this.onTap, this.backgroundColor = kPlainWhite})
      : super(key: key);
  final Widget? icon;
  final Widget? text;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool? mobileCoverScreen;

  @override
  _PrimaryFlatButtonState createState() => _PrimaryFlatButtonState();
}

class _PrimaryFlatButtonState extends State<PrimaryFlatButton> {
  @override
  Widget build(BuildContext context) {
    Widget child = Row(
      children: [
        if (widget.icon != null) widget.icon!,
        SizedBox(width: 10),
        if (widget.text != null) widget.text!,
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
      mobileCover: widget.mobileCoverScreen ?? false,
      onTap: widget.onTap ?? () {},
      loader: _spinkit,
      disabled: false,
      disableColor: kDisableColor,
      child: child,
      backgroundColor: widget.backgroundColor ?? Colors.white,
      boxShadow: [BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.25), spreadRadius: 0, blurRadius: 4, offset: Offset(4, 4))],
    );
  }
}
