import 'package:flutter/material.dart';

import '../../../components/buttons/custom_icon_button.dart';
import '../../../components/skeleton_image_loader.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class CompactCarousel extends StatefulWidget {
  const CompactCarousel({Key? key, required this.urlList}) : super(key: key);
  final List<String> urlList;

  @override
  _CompactCarouselState createState() => _CompactCarouselState();
}

class _CompactCarouselState extends State<CompactCarousel> {
  int imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget _carouselPosition = Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black.withOpacity(0)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
              widget.urlList.length,
              (index) => Padding(
                padding: EdgeInsetsDirectional.only(end: Insets.med, bottom: Insets.sm),
                child: AnimatedContainer(
                  height: Insets.med,
                  width: Insets.med,
                  duration: Times.fast,
                  decoration: BoxDecoration(
                    color: imageIndex == index ? kSupportBlue : Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Visibility(
      visible: !Responsive.isDesktop(context),
      child: Container(
        constraints: BoxConstraints(minHeight: 202),
        child: AspectRatio(
          aspectRatio: Responsive.isMobile(context) ? 180 / 101 : 417 / 202,
          child: Stack(
            children: [
              PageView.builder(
                itemCount: widget.urlList.length,
                itemBuilder: (context, index) {
                  return SkeletonImageLoader(borderRadius: BorderRadius.circular(0), image: widget.urlList[index]);
                },
                onPageChanged: (index) {
                  setState(() {
                    imageIndex = index;
                  });
                },
              ),
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
              ),
              _carouselPosition
            ],
          ),
        ),
      ),
    );
  }
}
