import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../models/project_model/project_model.dart';

class PaymentPlan extends StatelessWidget {
  const PaymentPlan({Key? key, required this.globalKey, required this.projectPlanList, this.customPadding}) : super(key: key);
  final GlobalKey globalKey;
  final List<ProjectPlanModel> projectPlanList;
  final double? customPadding;

  @override
  Widget build(BuildContext context) {
    double mobileLeftRightPadding = Insets.med;
    double mobileTopBottomPadding = Insets.med;
    double _padding = customPadding != null
        ? Insets.xxl
        : Responsive.isMobile(context)
            ? Insets.lg
            : Insets.xl;

    return Responsive.isMobile(context)
        ? Container(
            padding: EdgeInsets.all(mobileLeftRightPadding),
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Payment Plans : ", style: MS.lableBlack, key: globalKey),
                SizedBox(height: mobileTopBottomPadding),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: Insets.xxl,
                        runSpacing: Insets.xxl,
                        children: projectPlanList
                            .map((e) => _mobilePercentPayment(e.planName.en.split(" ").first,
                                e.planName.en.replaceAll(e.planName.en.split(" ").first, "").trim()))
                            .toList(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(_padding),
            decoration: BoxDecoration(color: Colors.white, borderRadius: Responsive.isDesktop(context) ? Corners.lgBorder : null),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Payment Plans:", style: TextStyles.h3, key: globalKey),
                SizedBox(height: Insets.xxl),
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: Insets.xxl,
                        runSpacing: Insets.xxl,
                        children: projectPlanList
                            .map((e) => _percentPayment(e.planName.en.split(" ").first,
                                e.planName.en.replaceAll(e.planName.en.split(" ").first, "").trim()))
                            .toList(),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }

  Column _mobilePercentPayment(String percent, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(percent, style: MS.bodyGray),
        SizedBox(height: Insets.sm),
        Text(text, style: MS.bodyGray.copyWith(color: kSupportBlue))
      ],
    );
  }

  Column _percentPayment(String percent, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(percent, style: TextStyles.h2),
        SizedBox(height: Insets.sm),
        Text(text, style: TextStyles.body18.copyWith(color: kSupportBlue))
      ],
    );
  }
}
