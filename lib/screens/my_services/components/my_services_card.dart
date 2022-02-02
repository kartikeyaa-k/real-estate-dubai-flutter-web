import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/skeleton_image_loader.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class MyServicesCard extends StatelessWidget {
  const MyServicesCard({
    Key? key,
    this.cost,
    this.image,
    this.title = "Home Decor",
    this.description = "",
    this.buttonText = "Reschedule",
    this.topButtonText = "View Details",
    this.showBottom = false,
    this.chips,
    this.onViewDetails,
  }) : super(key: key);

  final String? cost;
  final String? image;
  final String title;
  final String description;
  final String topButtonText;
  final String buttonText;
  final bool showBottom;
  final List<Widget>? chips;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: Corners.xlBorder, color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 370 / 200,
            child: Stack(
              children: [
                SkeletonImageLoader(
                  image: image ??
                      "https://www.rocketmortgage.com/resources-cmsassets/RocketMortgage.com/Article_Images/Large_Images/TypesOfHomes/contemporary-house-style-9.jpg",
                  borderRadius: BorderRadius.vertical(top: Corners.xlRadius),
                ),
                Positioned(
                  top: Insets.xl,
                  left: Insets.xl,
                  child: Wrap(children: chips ?? []),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(Insets.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.h3, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Spacer(),
                  Text(
                    description,
                    style: TextStyles.body12.copyWith(color: kBlackVariant.withOpacity(0.7)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Spacer(flex: 3),
                  Row(
                    children: [
                      if (cost != null) Expanded(flex: 8, child: Text("AED $cost/Service", style: TextStyles.h4)),
                      Spacer(),
                      PrimaryButton(
                          onTap: onViewDetails ?? () {}, text: topButtonText, fontSize: 12, height: null, width: null)
                    ],
                  ),
                  Spacer(flex: 2),
                  if (showBottom)
                    Row(
                      children: [
                        Icon(Icons.schedule_outlined, color: kSupportBlue),
                        SizedBox(width: Insets.sm),
                        Expanded(
                          flex: 8,
                          child: Text.rich(
                            TextSpan(
                              text: "13:00 - 13:30 ",
                              style: TextStyles.body16.copyWith(color: Color(0xFF3E3F5E)),
                              children: [
                                TextSpan(
                                    text: "12/12/2020", style: TextStyles.body14.copyWith(color: Color(0xFF3E3F5E)))
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        PrimaryButton(onTap: () {}, text: buttonText, fontSize: 12, height: null, width: null)
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
