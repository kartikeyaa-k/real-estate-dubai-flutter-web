import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:video_player/video_player.dart';

import '../buttons/primary_flat_button.dart';
import '../skeleton_image_loader.dart';
import '../../core/utils/styles.dart';
import '../../models/property_media.dart';

class PrimaryCarousel extends StatelessWidget {
  const PrimaryCarousel({
    Key? key,
    required this.urlList,
    required this.videoList,
    required this.bannerUrl,
    required this.sideImageUrl1,
    required this.sideImageUrl2,
  }) : super(key: key);
  final List<PropertyMedia> urlList;
  final List<PropertyMedia>? videoList;
  final String bannerUrl;
  final String sideImageUrl1;
  final String sideImageUrl2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 462,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.only(end: 4),
                  child: SkeletonImageLoader(image: bannerUrl, borderRadius: BorderRadius.circular(0)),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: PrimaryFlatButton(
                    icon: Icon(Icons.camera_alt_outlined),
                    text: Text("Show ${urlList.length} photos", style: TextStyles.body16),
                    onTap: () => showDialog(
                      context: context,
                      barrierColor: Colors.black,
                      barrierDismissible: false,
                      useSafeArea: true,
                      builder: (_) {
                        return MaximizedImageCarousel(urlList: urlList, carouselType: CarouselType.image);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _SideImages(imageUrl: sideImageUrl1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // PrimaryFlatButton(
                          //   icon: Icon(Icons.videocam_outlined),
                          //   text: Text("View 360 tour", style: TextStyles.body16),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _SideImages(imageUrl: sideImageUrl2),
                      if (videoList != null && videoList!.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryFlatButton(
                              icon: Icon(Icons.videocam_outlined),
                              text: Text("Watch video tour", style: TextStyles.body16),
                              onTap: () => showDialog(
                                context: context,
                                barrierColor: Colors.black,
                                barrierDismissible: false,
                                useSafeArea: true,
                                builder: (_) {
                                  return MaximizedImageCarousel(urlList: videoList!, carouselType: CarouselType.video);
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

enum CarouselType { video, image }

class MaximizedImageCarousel extends StatefulWidget {
  const MaximizedImageCarousel({
    Key? key,
    required this.urlList,
    required this.carouselType,
  }) : super(key: key);

  final List<PropertyMedia> urlList;
  final CarouselType carouselType;

  @override
  State<MaximizedImageCarousel> createState() => _MaximizedImageCarouselState();
}

class _MaximizedImageCarouselState extends State<MaximizedImageCarousel> {
  late PageController _pageController;
  int _selectedImageIndex = 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      if (_pageController.page! < widget.urlList.length) {
        setState(() => _selectedImageIndex = (_pageController.page?.toInt() ?? 0) + 1);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Padding(
        padding: Responsive.isMobile(context) ? const EdgeInsets.all(15.0) : const EdgeInsets.all(64.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!Responsive.isMobile(context)) ...[
                  Visibility(
                    visible: _selectedImageIndex > 1,
                    replacement: SizedBox(),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      child: IconButton(
                        iconSize: 40,
                        onPressed: () {
                          _pageController.previousPage(duration: Times.fast, curve: Curves.easeIn);
                          // if (_selectedImageIndex > 1) {
                          //   setState(() => _selectedImageIndex -= 1);
                          // }
                        },
                        icon: Icon(Icons.keyboard_arrow_left_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
                Expanded(
                    flex: 4,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.urlList.length,
                      itemBuilder: (context, index) {
                        if (widget.carouselType == CarouselType.image)
                          return Image.network(widget.urlList[index].link, height: 100, width: 200);
                        else
                          return AspectRatio(
                              aspectRatio: 800 / 450, child: _VideoPlayer(url: widget.urlList[index].link));
                      },
                    )),
                if (!Responsive.isMobile(context)) ...[
                  Spacer(),
                  Visibility(
                    visible: _selectedImageIndex < widget.urlList.length,
                    replacement: SizedBox(),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      child: IconButton(
                        iconSize: 40,
                        onPressed: () {
                          _pageController.nextPage(duration: Times.fast, curve: Curves.easeIn);
                          // if (_selectedImageIndex < widget.urlList.length) {
                          //   setState(() => _selectedImageIndex += 1);
                          // }
                        },
                        icon: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 24),
                      ),
                    ),
                  ),
                ]
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.close, color: Colors.white),
                        SizedBox(width: Insets.sm),
                        Text("Close", style: TextStyles.body24.copyWith(color: Colors.white))
                      ],
                    ),
                  ),
                  Spacer(),
                  Text("$_selectedImageIndex/${widget.urlList.length}",
                      style: TextStyles.body24.copyWith(color: Colors.white))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoPlayer extends StatefulWidget {
  _VideoPlayer({Key? key, required this.url}) : super(key: key);
  final String url;

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<_VideoPlayer> {
  late VideoPlayerController _controller;
  IconData _activeIcon = Icons.play_arrow;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(_controller),
                  Positioned.fill(
                    child: Center(
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            _controller.value.isPlaying ? _controller.pause() : _controller.play();
                            _activeIcon = _controller.value.isPlaying ? Icons.pause : Icons.play_arrow;
                          });
                        },
                        icon: Icon(_activeIcon, size: 32, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            )
          : SpinKitThreeBounce(
              color: Colors.white,
              duration: Times.slower,
              size: 12,
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class _SideImages extends StatelessWidget {
  const _SideImages({
    Key? key,
    required String imageUrl,
  })  : _imageUrl = imageUrl,
        super(key: key);

  final String _imageUrl;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcOver,
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [Color.fromRGBO(0, 0, 0, 0.5), Color.fromRGBO(0, 0, 0, 0.51)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(bounds);
      },
      child: SkeletonImageLoader(
        image: _imageUrl,
        borderRadius: BorderRadius.circular(0),
      ),
    );
  }
}

class CarouselSkeleton extends StatelessWidget {
  const CarouselSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 462,
      child: Row(
        children: [
          Expanded(flex: 8, child: Container(color: Colors.white)),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Expanded(child: Container(color: Colors.white)),
                SizedBox(
                  height: 10,
                ),
                Expanded(child: Container(color: Colors.white)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
