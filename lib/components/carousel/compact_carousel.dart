import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:scrolling_page_indicator/scrolling_page_indicator.dart';
import 'package:vrouter/vrouter.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../models/property_media.dart';
import '../buttons/custom_icon_button.dart';
import '../skeleton_image_loader.dart';
import 'carousel.dart';

class PrimaryCompactCarousel extends StatefulWidget {
  const PrimaryCompactCarousel({Key? key, required this.urlList, this.videoList, this.additionalWidget = const []})
      : super(key: key);
  final List<PropertyMedia> urlList;
  final List<PropertyMedia>? videoList;
  final List<Widget> additionalWidget;

  @override
  _PrimaryCompactCarouselState createState() => _PrimaryCompactCarouselState();
}

class _PrimaryCompactCarouselState extends State<PrimaryCompactCarousel> {
  int imageIndex = 0;
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
    widget.videoList?.removeWhere((element) => element.link.isEmpty);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _carouselPosition = Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black.withOpacity(0)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: ScrollingPageIndicator(
            itemCount: widget.urlList.length,
            controller: controller,
            dotColor: Colors.white,
            dotSelectedColor: kSupportBlue,
            visibleDotCount: 7,
            visibleDotThreshold: 7,
            orientation: Axis.horizontal,
            dotSize: 6,
            dotSelectedSize: 8,
            dotSpacing: 12,
          ),
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
                controller: controller,
                itemCount: widget.urlList.length,
                itemBuilder: (context, index) {
                  return SkeletonImageLoader(borderRadius: BorderRadius.circular(0), image: widget.urlList[index].link);
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
                  onTap: () {
                    if (context.vRouter.historyCanBack()) {
                      context.vRouter.historyBack();
                    }
                  },
                  child: Icon(Icons.arrow_back_outlined, color: kSupportBlue),
                  backgroundColor: Colors.white,
                  size: 40,
                  showBorder: false,
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: Column(
                  children: [
                    if (widget.videoList != null && widget.videoList!.isNotEmpty) ...[
                      CustomIconButton(
                        child: Icon(FeatherIcons.video, color: kSupportBlue),
                        backgroundColor: Colors.white,
                        size: 40,
                        showBorder: false,
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierColor: Colors.black,
                            barrierDismissible: false,
                            useSafeArea: true,
                            builder: (_) {
                              return MaximizedImageCarousel(
                                  urlList: widget.videoList!, carouselType: CarouselType.video);
                            },
                          );
                        },
                      ),
                      SizedBox(height: Insets.lg),
                    ],
                    CustomIconButton(
                      child: Icon(Icons.camera_alt_outlined, color: kSupportAccent),
                      backgroundColor: Colors.white,
                      size: 40,
                      showBorder: false,
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black,
                          barrierDismissible: false,
                          useSafeArea: true,
                          builder: (_) {
                            return MaximizedImageCarousel(urlList: widget.urlList, carouselType: CarouselType.image);
                          },
                        );
                      },
                    ),
                    ...widget.additionalWidget,
                  ],
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
