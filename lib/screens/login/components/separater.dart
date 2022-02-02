import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class Separator extends StatelessWidget {
  const Separator({Key? key, required this.direction}) : super(key: key);
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    Widget divider = direction == Axis.horizontal
        ? Divider(color: kSupportBlue.withOpacity(0.1), height: 1, indent: 16, endIndent: 16, thickness: 1)
        : VerticalDivider(color: kSupportBlue.withOpacity(0.1), width: 1, indent: 16, endIndent: 16, thickness: 1);

    return Flex(
      direction: direction,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: divider),
        SizedBox(width: 16),
        Text("OR", style: TextStyles.h6.copyWith(color: kBlackVariant.withOpacity(0.7))),
        SizedBox(width: 16),
        Flexible(child: divider),
      ],
    );
  }
}
