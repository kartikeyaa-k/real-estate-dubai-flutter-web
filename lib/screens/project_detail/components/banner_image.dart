import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/skeleton_image_loader.dart';

class BannerImage extends StatelessWidget {
  const BannerImage(
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
          replacement: Image.asset(imageLocation, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
          child: AspectRatio(
            aspectRatio: 4.55,
            child: isNetworkImage
                ? ShaderMask(
                    blendMode: BlendMode.srcOver,
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [Color.fromRGBO(0, 0, 0, 0.5), Color.fromRGBO(0, 0, 0, 0.51)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds);
                    },
                    child: SkeletonImageLoader(
                      image: imageLocation,
                      borderRadius: BorderRadius.circular(0),
                    ),
                  )
                : Image.asset(imageLocation, width: double.infinity, height: double.infinity, fit: BoxFit.fitWidth),
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
