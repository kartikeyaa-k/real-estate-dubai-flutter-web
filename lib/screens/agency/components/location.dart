import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class Location extends StatelessWidget {
  const Location({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget stack = Stack(
      children: [
        Image.asset(
          "assets/temp/map.png",
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned.fill(
          child: Center(
            child: PrimaryButton(
              onTap: () {},
              text: "View in Map",
            ),
          ),
        ),
      ],
    );

    return Container(
      padding: EdgeInsets.all(Responsive.isMobile(context) ? Insets.lg : Insets.xl),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Location:", style: TextStyles.h2.copyWith(color: kBlackVariant)),
          SizedBox(height: Insets.lg),
          if (Responsive.isDesktop(context))
            stack
          else
            AspectRatio(
              aspectRatio: Responsive.isMobile(context) ? 165 / 101 : 397 / 125,
              child: stack,
            )
        ],
      ),
    );
  }
}
