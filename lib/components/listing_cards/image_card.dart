import 'package:flutter/material.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';
import '../skeleton_image_loader.dart';

class ImageCard extends StatelessWidget {
  final String imageUrl;
  final String text;
  final VoidCallback? onTap;
  const ImageCard({Key? key, required this.imageUrl, required this.text, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              // width: 394,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: SkeletonImageLoader(image: imageUrl),
            ),
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
              child: Text(text, style: TextStyles.h3.copyWith(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
