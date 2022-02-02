import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';

import '../../../components/skeleton_image_loader.dart';
import '../../../components/ui_text.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class PopularBuildingCard extends StatelessWidget {
  const PopularBuildingCard(
      {Key? key,
      required this.image,
      required this.text,
      required this.onTap,
      required this.averageRating,
      required this.totalReviewCount})
      : super(key: key);
  final String image;
  final String text;
  final String averageRating;
  final int totalReviewCount;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 112,
              width: 200,
              child: SkeletonImageLoader(
                image: image,
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            SizedBox(height: Insets.lg),
            SizedBox(
                width: 200, height: 45, child: Text(text, style: Responsive.isMobile(context) ? MS.lableBlack : TextStyles.h3)),
            Row(
              children: [
                Icon(Icons.star_rate_rounded, color: kAccentColor),
                SizedBox(width: Insets.sm),
                Text("$averageRating ($totalReviewCount)", style: TextStyles.body14.copyWith(color: kAccentColor)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
