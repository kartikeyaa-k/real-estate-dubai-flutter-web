import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/skeleton_image_loader.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({Key? key, required this.image, required this.text, required this.id}) : super(key: key);
  final String image;
  final String text;
  final int id;

  @override
  Widget build(BuildContext context) {
    final Widget cardImage = Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 187 / 105,
          child: Container(
            height: 210,
            child: SkeletonImageLoader(image: image),
          ),
        ),

        // Positioned(
        //   bottom: 10,
        //   right: 10,
        //   child: Container(
        //     alignment: Alignment.center,
        //     width: 20,
        //     height: 20,
        //     decoration: BoxDecoration(color: kAccentColor[100], borderRadius: BorderRadius.circular(4)),
        //     child: Text("12", style: TextStyles.body14.copyWith(color: Colors.white)),
        //   ),
        // )
      ],
    );

    return AspectRatio(
      aspectRatio: 197 / 162,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: Insets.med),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.1)),
          borderRadius: Corners.xlBorder,
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            cardImage,
            Text(text, style: TextStyles.h3),
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
    );
  }
}
