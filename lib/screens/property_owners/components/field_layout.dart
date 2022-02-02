import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

class FieldLayout extends StatelessWidget {
  const FieldLayout({
    Key? key,
    required String caption,
    required Widget child,
  })  : _caption = caption,
        _child = child,
        super(key: key);

  final String _caption;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(_caption, style: TextStyles.body12.copyWith(color: Color(0xFF99C9E7))), SizedBox(height: 4), _child],
    );
  }
}
