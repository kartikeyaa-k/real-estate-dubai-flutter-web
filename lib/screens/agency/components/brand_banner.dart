import 'package:flutter/material.dart';

import '../../../components/buttons/custom_icon_button.dart';
import '../../../components/skeleton_image_loader.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class BrandBanner extends StatelessWidget {
  const BrandBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: Responsive.isDesktop(context),
      replacement: Container(
        // height: 250,
        constraints: BoxConstraints(minHeight: 202),
        child: AspectRatio(
          aspectRatio: Responsive.isMobile(context) ? 180 / 101 : 417 / 125,
          child: Stack(
            children: [
              SkeletonImageLoader(
                  borderRadius: BorderRadius.circular(0),
                  image: "https://i.pinimg.com/736x/93/c7/72/93c7726d3418c6de38f223fa4c02484d.jpg"),
              Positioned(
                top: 20,
                left: 20,
                child: CustomIconButton(
                  child: Icon(Icons.arrow_back_outlined, color: kSupportBlue),
                  backgroundColor: Colors.white,
                  size: 40,
                  showBorder: false,
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: CustomIconButton(
                  child: Icon(Icons.share_outlined, color: kSupportAccent),
                  backgroundColor: Colors.white,
                  size: 40,
                  showBorder: false,
                ),
              )
            ],
          ),
        ),
      ),
      child: Container(
        height: 228,
        child: AspectRatio(
          aspectRatio: 1,
          child: SkeletonImageLoader(
              borderRadius: Corners.lgBorder,
              image: "https://i.pinimg.com/736x/93/c7/72/93c7726d3418c6de38f223fa4c02484d.jpg"),
        ),
      ),
    );
  }
}
