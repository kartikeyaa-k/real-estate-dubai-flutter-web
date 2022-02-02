import 'package:flutter/material.dart';

import '../../../components/buttons/custom_icon_button.dart';
import '../../../components/skeleton_image_loader.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';

class ServiceDetailBanner extends StatelessWidget {
  const ServiceDetailBanner({
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
          aspectRatio: Responsive.isMobile(context) ? 360 / 240 : 834 / 404,
          child: Stack(
            children: [
              SkeletonImageLoader(
                  borderRadius: BorderRadius.circular(0),
                  image: "https://www.kdps.com.au/wp-content/uploads/2018/12/apartment-or-townhouse.jpg"),
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
        child: AspectRatio(
          aspectRatio: 1166 / 462,
          child: SkeletonImageLoader(
              borderRadius: BorderRadius.circular(0),
              image: "https://www.kdps.com.au/wp-content/uploads/2018/12/apartment-or-townhouse.jpg"),
        ),
      ),
    );
  }
}
