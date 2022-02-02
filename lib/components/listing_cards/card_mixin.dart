import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';
import '../buttons/custom_icon_button.dart';
import '../buttons/primary_button.dart';
import '../buttons/text_tag_button.dart';
import '../skeleton_image_loader.dart';

mixin CommonCardMixin {
  /// Social sharing contains icon button for facebook, twitter and share
  Widget socialSharingRow = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "Share:",
        style: TextStyles.body18
            .copyWith(color: kSupportBlue),
      ),
      // SizedBox(width: 20),
      // CustomIconButton(
      //   child: SvgPicture.asset('assets/icon/facebook.svg'),
      //   borderRadius: Corners.smBorder,
      //   onTap: () {
      //     Share.share('check out my website https://example.com', subject: 'Look what I made!');
      //   },
      // ),
      // SizedBox(width: 20),
      // CustomIconButton(
      //   child: SvgPicture.asset('assets/icon/twitter.svg'),
      //   borderRadius: Corners.smBorder,
      // ),
      SizedBox(width: 20),
      CustomIconButton(
        child: SvgPicture.asset(
            'assets/icon/share.svg'),
        borderRadius: Corners.smBorder,
        onTap: () {
          Share.share(
            'Property Just For You | Search For Your Dream Property on http://adu-re.com',
          );
        },
      ),
    ],
  );

  /// card Image following aspect 17/9
  /// contains 3 positioned widgets tags, bookmark button, image count meter
  Widget cardImage({
    bool? isVerified,
    String? underConstruction,
    String? image,
  }) =>
      Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 17 / 9,
            child: Container(
              height: 210,
              child: SkeletonImageLoader(
                  image: image ??
                      'https://www.rocketmortgage.com/resources-cmsassets/RocketMortgage.com/Article_Images/Large_Images/TypesOfHomes/contemporary-house-style-9.jpg'),
            ),
          ),
          // Positioned(
          //   top: 10,
          //   right: 10,
          //   child: CustomIconButton(
          //     child: Icon(Icons.bookmark_outline),
          //     backgroundColor: Colors.white,
          //     size: 40,
          //     showBorder: false,
          //   ),
          // ),
          Positioned(
            top: 10,
            left: 10,
            child: Wrap(
              direction: Axis.vertical,
              runSpacing: 10,
              spacing: 10,
              children: [
                if (isVerified ?? false)
                  TextTagButton(
                      text: "Verified",
                      backgroundColor:
                          kSupportGreen),
                (underConstruction == null)
                    ? Container()
                    : TextTagButton(
                        text:
                            "Under Construction",
                        backgroundColor:
                            kAccentColor,
                      ),
              ],
            ),
          ),
          /*Positioned(
            bottom: 10,
            right: 10,
            child: Container(
              alignment: Alignment.center,
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: kAccentColor[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "12",
                style: TextStyles.body14.copyWith(color: Colors.white),
              ),
            ),
          ),*/
        ],
      );

  /// Location row contains location icon and text location
  /// text location is Box contrained with maxWidth 268
  Widget locationRow({
    String? location,
    TextStyle? textStyle,
    double textMaxWidth = 268,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 20,
          color: kSupportBlue,
        ),
        // Flexible helps text to wrap in next line if space available is less than maxWidth
        Flexible(
          child: Container(
            padding: EdgeInsetsDirectional.only(
                start: 10),
            constraints: BoxConstraints(
                maxWidth: textMaxWidth),
            child: Text(
              (location == null)
                  ? "Soon"
                  : location.toString(),
              style: textStyle ??
                  TextStyles.body14.copyWith(
                    color: kBlackVariant
                        .withOpacity(0.7),
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  /// Price row contains price and duration till property is available
  Widget priceRow({
    BuildContext? ctx,
    VoidCallback? onTap,
    String? price,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 15,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                price != null
                    ? "\AED $price"
                    : "TBD",
                style: TextStyles.h4.copyWith(
                    color: kBlackVariant),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(height: 5),
              // Text(
              //   "*Available for 2 months only",
              //   style: TextStyle(
              //     fontWeight: FontWeight.w500,
              //     fontSize: 12,
              //     color: Color(0xFF6C6C6C),
              //   ),
              // ),
            ],
          ),
        ),
        Spacer(flex: 1),
        PrimaryButton(
          text: "View Details",
          onTap: onTap ?? () {},
          height: 30,
          width: 98,
          fontSize: 12,
        ),
      ],
    );
  }
}
