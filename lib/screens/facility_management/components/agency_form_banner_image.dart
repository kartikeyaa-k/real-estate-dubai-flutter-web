import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

class AgencyFormBannerImage extends StatelessWidget {
  const AgencyFormBannerImage(
      {Key? key, this.keepAspectRatio = true, this.imageLocation = 'assets/app/banner-property-listing.png'})
      : super(key: key);
  final bool keepAspectRatio;
  final String imageLocation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: keepAspectRatio,
          replacement: Image.asset(imageLocation, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          child: AspectRatio(
            aspectRatio: 1366 / 300,
            child: Image.asset(imageLocation, width: double.infinity, height: double.infinity, fit: BoxFit.fitWidth),
          ),
        ),
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [Colors.black, Colors.black.withOpacity(0)],
                begin: Alignment.bottomCenter,
                end: Alignment.center,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 54,
          left: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Agency Registration", style: TextStyles.h2.copyWith(color: Colors.white)),
              SizedBox(height: 16),
              Text("In fermentum posuere urna nec", style: TextStyles.body18.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }
}
