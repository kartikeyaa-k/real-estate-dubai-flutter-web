import 'package:flutter/material.dart';

import '../../../components/ui_text.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class SecondaryDetailCard extends StatelessWidget {
  const SecondaryDetailCard({Key? key, required this.description}) : super(key: key);
  final String description;

  @override
  Widget build(BuildContext context) {
    TextStyle adaptiveTextStyle = Responsive.isMobile(context) ? TextStyles.body14 : TextStyles.body18;
    Widget lgVSpace = Responsive(
      mobile: SizedBox(height: Insets.xxl),
      tablet: SizedBox(height: Insets.lg),
      desktop: SizedBox(height: Insets.lg),
    );

    Widget vSpace = Responsive(
      mobile: SizedBox(height: Insets.lg),
      tablet: SizedBox(height: Insets.lg),
      desktop: SizedBox(height: Insets.sm),
    );

    return Container(
      padding: EdgeInsets.all(Insets.xl),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Description:", style: !Responsive.isMobile(context) ? TextStyles.h2 : MS.lableBlack),
          vSpace,
          UiText(
            text: description,
            style: Responsive.isMobile(context)
                ? TextStyles.body14.copyWith(color: kBlackVariant.withOpacity(0.7))
                : TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
          ),
          lgVSpace,
          // Text("House Prices", style: TextStyles.h2),
          // vSpace,
          // UiText(
          //   span: TextSpan(
          //     text: "Avg. 1 Bedroom Appartment Asking Price: ",
          //     style: adaptiveTextStyle,
          //     children: [
          //       TextSpan(
          //         text: "649,996 AED",
          //         style: adaptiveTextStyle.copyWith(color: kSupportBlue),
          //       )
          //     ],
          //   ),
          // ),
          // vSpace,
          // UiText(
          //   span: TextSpan(
          //     text: "Avg. 1 Bedroom Appartment Asking Price: ",
          //     style: adaptiveTextStyle,
          //     children: [
          //       TextSpan(
          //         text: "649,996 AED",
          //         style: adaptiveTextStyle.copyWith(color: kSupportBlue),
          //       )
          //     ],
          //   ),
          // ),
          // vSpace,
          // UiText(
          //   span: TextSpan(
          //     text: "Avg. 1 Bedroom Appartment Asking Price: ",
          //     style: adaptiveTextStyle,
          //     children: [
          //       TextSpan(
          //         text: "649,996 AED",
          //         style: adaptiveTextStyle.copyWith(color: kSupportBlue),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
