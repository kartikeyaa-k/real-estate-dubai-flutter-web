import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/components/skeleton_image_loader.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

class MobileBannerWithText extends StatelessWidget {
  const MobileBannerWithText(
      {Key? key,
      this.keepAspectRatio = true,
      this.isNetworkImage = false,
      required this.imageLocation,
      this.header = '',
      this.subHeader = ''})
      : super(key: key);
  final bool keepAspectRatio;
  final String imageLocation;
  final bool isNetworkImage;
  final String header;
  final String subHeader;

  @override
  Widget build(BuildContext context) {
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;

    return Stack(
      alignment: Alignment.center,
      children: [
        Visibility(
          visible: keepAspectRatio,
          replacement: Image.asset(imageLocation, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          child: AspectRatio(
            aspectRatio: 2.55,
            child: Image.asset(imageLocation, width: double.infinity, height: double.infinity, fit: BoxFit.fitWidth),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(header, style: MS.headerWhite),
              mobileVerticalSizedBox,
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: mobileLeftRightPadding, right: mobileLeftRightPadding),
                child: Text(
                  subHeader,
                  textAlign: TextAlign.center,
                  style: TS.bodyWhite,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Icon(Icons.arrow_back),
        )
      ],
    );
  }
}
