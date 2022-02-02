import 'package:flutter/material.dart';

class BannerImage extends StatelessWidget {
  const BannerImage({Key? key, this.keepAspectRatio = true, this.imageLocation = 'assets/app/banner-property-listing.png'})
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
            aspectRatio: 4.55,
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
        )
      ],
    );
  }
}
