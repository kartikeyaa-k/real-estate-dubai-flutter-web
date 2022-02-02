import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:textfield_tags/textfield_tags.dart';

class PrimaryTextField extends StatelessWidget {
  final String text;
  final Color focusedColor;
  final Color enabledColor;
  final Color errorColor;
  final Color? fillColor;
  final bool obscureText;
  final Widget? suffixIcon;
  final BoxConstraints? suffixIconConstraints;
  final ValueChanged<String>? onChanged;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final double? height;
  final int? minLines;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? initialValue;
  final bool readOnly;
  final bool enabled;
  final String? errorText;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final Widget? prefix;

  const PrimaryTextField(
      {Key? key,
      TextEditingController? controller,
      required this.text,
      this.focusedColor = kSupportBlue,
      this.enabledColor = kLightBlue,
      this.errorColor = kErrorColor,
      this.fillColor,
      this.obscureText = false,
      this.suffixIcon,
      this.suffixIconConstraints,
      this.onChanged,
      this.onTap,
      this.inputFormatters,
      this.maxLength,
      this.height = 48,
      this.minLines,
      this.maxLines = 1,
      this.keyboardType,
      this.initialValue,
      this.readOnly = false,
      this.enabled = true,
      this.errorText,
      this.prefixText,
      this.prefixStyle,
      this.prefix})
      : _controller = controller,
        super(key: key);

  final TextEditingController? _controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: readOnly,
      obscureText: obscureText,
      maxLength: maxLength,
      minLines: minLines,
      enabled: enabled,
      textAlignVertical: TextAlignVertical.center,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      initialValue: initialValue,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: text,
        errorText: errorText,
        hintStyle: TextStyles.body16.copyWith(color: kDarkGrey),
        prefixText: prefixText,
        prefixStyle: prefixStyle,
        prefix: prefix,
        suffixIcon: suffixIcon,
        suffixIconConstraints: suffixIconConstraints,
        filled: fillColor != null,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 2.5, color: focusedColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 2, color: enabledColor),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide(width: 2, color: errorColor)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)), borderSide: BorderSide(width: 2, color: errorColor)),
      ),
    );
  }
}
