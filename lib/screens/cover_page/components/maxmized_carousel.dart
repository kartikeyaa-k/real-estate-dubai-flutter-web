// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:real_estate_portal/core/utils/responsive.dart';
// import 'package:video_player/video_player.dart';

// import '../../../components/carousel/carousel.dart';
// import '../../../core/utils/styles.dart';
// import '../../../models/property_media.dart';

// class MaximizedImageCarousel extends StatefulWidget {
//   const MaximizedImageCarousel({
//     Key? key,
//     required this.urlList,
//     required this.carouselType,
//   }) : super(key: key);

//   final List<PropertyMedia> urlList;
//   final CarouselType carouselType;

//   @override
//   State<MaximizedImageCarousel> createState() => _MaximizedImageCarouselState();
// }

// class _MaximizedImageCarouselState extends State<MaximizedImageCarousel> {
//   late PageController _pageController;
//   int _selectedImageIndex = 1;

//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Responsive.isMobile(context)
//         ? Material(
//             color: Colors.black,
//             child: Padding(
//               padding: Responsive.isMobile(context) ? const EdgeInsets.all(15.0) : const EdgeInsets.all(64.0),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                           child: PageView.builder(
//                         controller: _pageController,
//                         itemCount: widget.urlList.length,
//                         itemBuilder: (context, index) {
//                           if (widget.carouselType == CarouselType.image)
//                             return Image.network(widget.urlList[index].link, height: 100, width: 200);
//                           else
//                             return AspectRatio(
//                               aspectRatio: 800 / 450,
//                               child: _VideoPlayer(
//                                 url: widget.urlList[index].link,
//                               ),
//                             );
//                         },
//                       )),
//                     ],
//                   ),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: GestureDetector(
//                       onTap: () {
//                         print('#log : closing');
//                         Navigator.pop(context);
//                       },
//                       child: Row(
//                         children: [
//                           Icon(Icons.close, color: Colors.white),
//                           SizedBox(width: Insets.sm),
//                           Text("Close", style: MS.miniHeaderWhite)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         : Material(
//             color: Colors.black,
//             child: Padding(
//               padding: Responsive.isMobile(context) ? const EdgeInsets.all(8.0) : const EdgeInsets.all(64.0),
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Row(
//                       children: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: Row(
//                             children: [
//                               Icon(Icons.close, color: Colors.white),
//                               SizedBox(width: Insets.sm),
//                               Text("Close", style: TextStyles.body24.copyWith(color: Colors.white))
//                             ],
//                           ),
//                         ),
//                         Spacer(),
//                         Text("$_selectedImageIndex/${widget.urlList.length}",
//                             style: TextStyles.body24.copyWith(color: Colors.white))
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Visibility(
//                         visible: _selectedImageIndex > 1,
//                         replacement: SizedBox(),
//                         child: DecoratedBox(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white),
//                           ),
//                           child: IconButton(
//                             iconSize: 40,
//                             onPressed: () {
//                               _pageController.previousPage(duration: Times.fast, curve: Curves.easeIn);
//                               if (_selectedImageIndex > 1) {
//                                 setState(() => _selectedImageIndex -= 1);
//                               }
//                             },
//                             icon: Icon(Icons.keyboard_arrow_left_rounded, color: Colors.white, size: 24),
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Expanded(
//                           flex: 4,
//                           child: PageView.builder(
//                             controller: _pageController,
//                             itemCount: widget.urlList.length,
//                             itemBuilder: (context, index) {
//                               if (widget.carouselType == CarouselType.image)
//                                 return Image.network(widget.urlList[index].link, height: 100, width: 200);
//                               else
//                                 return AspectRatio(
//                                   aspectRatio: 800 / 450,
//                                   child: _VideoPlayer(
//                                     url: widget.urlList[index].link,
//                                   ),
//                                 );
//                             },
//                           )),
//                       Spacer(),
//                       Visibility(
//                         visible: _selectedImageIndex < widget.urlList.length,
//                         replacement: SizedBox(),
//                         child: DecoratedBox(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(color: Colors.white),
//                           ),
//                           child: IconButton(
//                             iconSize: 40,
//                             onPressed: () {
//                               _pageController.nextPage(duration: Times.fast, curve: Curves.easeIn);
//                               if (_selectedImageIndex < widget.urlList.length) {
//                                 setState(() => _selectedImageIndex += 1);
//                               }
//                             },
//                             icon: Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 24),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }
// }

// class _VideoPlayer extends StatefulWidget {
//   _VideoPlayer({Key? key, required this.url}) : super(key: key);
//   final String url;

//   @override
//   _VideoPlayerState createState() => _VideoPlayerState();
// }

// class _VideoPlayerState extends State<_VideoPlayer> {
//   late VideoPlayerController _controller;
//   IconData _activeIcon = Icons.play_arrow;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.url)
//       ..initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
//         setState(() {});
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: _controller.value.isInitialized
//           ? AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: Stack(
//                 children: [
//                   VideoPlayer(_controller),
//                   Positioned.fill(
//                     child: Center(
//                       child: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             _controller.value.isPlaying ? _controller.pause() : _controller.play();
//                             _activeIcon = _controller.value.isPlaying ? Icons.pause : Icons.play_arrow;
//                           });
//                         },
//                         icon: Icon(_activeIcon, size: 32, color: Colors.white),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )
//           : SpinKitThreeBounce(
//               color: Colors.white,
//               duration: Times.slower,
//               size: 12,
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }
