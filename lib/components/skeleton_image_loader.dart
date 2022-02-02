import 'package:flutter/material.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:transparent_image/transparent_image.dart';

class SkeletonImageLoader extends StatelessWidget {
  final String image;
  final BorderRadius? borderRadius;
  const SkeletonImageLoader({
    Key? key,
    required this.image,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: SkeletonAnimation(
            shimmerColor: Colors.grey[200]!,
            borderRadius: BorderRadius.circular(20),
            shimmerDuration: 1500,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: borderRadius ?? BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        Positioned.fill(
          bottom: 0,
          top: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
            child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, fit: BoxFit.cover, image: image),
          ),
        ),
      ],
    );
  }
}
