import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class LocationDetail extends StatelessWidget {
  const LocationDetail({Key? key, required this.description, required this.text}) : super(key: key);
  final String description;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: Insets.xl, vertical: Insets.xxl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: Responsive.isMobile(context) ? null : Corners.xlBorder,
        border: Responsive.isMobile(context) ? null : Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      width: Responsive.isDesktop(context) ? 320 : null,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("About $text", style: TextStyles.h2),
            SizedBox(height: 30),
            Flexible(
              child: Text(
                description,
                textAlign: TextAlign.left,
                style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
              ),
            ),
            // SizedBox(height: 30),
            // Text("Rent villa in Dubai",
            //     style: TextStyles.body18.copyWith(decoration: TextDecoration.underline, color: kSupportBlue)),
            // SizedBox(height: 15),
            // Text("Rent appartment in Dubai",
            //     style: TextStyles.body18.copyWith(decoration: TextDecoration.underline, color: kSupportBlue)),

            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
