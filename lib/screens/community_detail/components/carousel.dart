import 'package:flutter/material.dart';

import '../../../components/buttons/custom_icon_button.dart';
import '../../../components/skeleton_image_loader.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class Carousel extends StatelessWidget {
  const Carousel({Key? key, required this.urlList}) : super(key: key);
  final List<String> urlList;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 462,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Stack(children: [
              Padding(
                padding: EdgeInsetsDirectional.only(end: 4),
                child: SkeletonImageLoader(
                  image: urlList[0],
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.xl),
                  child: Row(
                    children: [
                      CustomIconButton(
                        size: 40,
                        child: Icon(Icons.keyboard_arrow_left_outlined, color: kSupportBlue),
                        borderRadius: BorderRadius.circular(100),
                        backgroundColor: Colors.white,
                        showBorder: false,
                      ),
                      Spacer(),
                      CustomIconButton(
                        size: 40,
                        child: Icon(Icons.keyboard_arrow_right_outlined, color: kSupportBlue),
                        borderRadius: BorderRadius.circular(100),
                        backgroundColor: Colors.white,
                        showBorder: false,
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
          SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...urlList.sublist(1).map(
                        (e) => Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: AspectRatio(
                            aspectRatio: 336 / 189,
                            child: Container(
                              // height: 200,
                              child: SkeletonImageLoader(
                                image: e,
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
