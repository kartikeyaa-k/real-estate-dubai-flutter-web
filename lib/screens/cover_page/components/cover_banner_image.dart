import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/skeleton_image_loader.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';

class CoverBannerImage extends StatelessWidget {
  const CoverBannerImage(
      {Key? key,
      this.keepAspectRatio = true,
      this.isNetworkImage = false,
      this.imageLocation = 'assets/app/banner-property-listing.png'})
      : super(key: key);
  final bool keepAspectRatio;
  final String imageLocation;
  final bool isNetworkImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: keepAspectRatio,
          replacement: Image.asset("assets/cover/cover_bg.png",
              width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          child: AspectRatio(
            aspectRatio: Responsive.isMobile(context) ? 2.55 : 4.55,
            child: Image.asset("assets/cover/cover_bg.png",
                width: double.infinity, height: double.infinity, fit: BoxFit.fitWidth),
          ),
        ),
        Positioned.fill(
          left: 50,
          right: 50,
          top: 12,
          bottom: 12,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 50),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: AssetImage('assets/cover/cover_ot.png'), fit: BoxFit.contain)),
          ),
        )
      ],
    );
  }
}
