import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../../components/skeleton_image_loader.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class MobileCommunityCard extends StatelessWidget {
  final String imageUrl;
  final String text;
  final String subText;
  final int id;
  const MobileCommunityCard({Key? key, required this.id, required this.imageUrl, required this.text, required this.subText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          height: double.infinity,
          child: SkeletonImageLoader(image: imageUrl),
        ),
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [kBlackVariant, kBlackVariant.withOpacity(0)],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: TextStyles.h3.copyWith(color: Colors.white)),
                SizedBox(height: Insets.med),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "",
                        // "Malls - Parks - Restaurants - Spas ",
                        style: TextStyles.body14.copyWith(color: kBlackVariant.withOpacity(0.7)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    PrimaryButton(
                        onTap: () {
                          context.vRouter.to(CommunityDetailsPath, queryParameters: {"community_id": id.toString()});
                        },
                        text: "View Details",
                        width: null,
                        height: null)
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
