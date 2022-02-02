import 'package:flutter/material.dart';

import '../../../components/skeleton_image_loader.dart';
import '../../../core/utils/styles.dart';

class MyServicesMobileCard extends StatelessWidget {
  const MyServicesMobileCard({Key? key, required this.imageUrl, required this.text, this.subHeading, this.cost = ""})
      : super(key: key);
  final String imageUrl;
  final String text;
  final Widget? subHeading;
  final String cost;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          height: 192,
          child: SkeletonImageLoader(image: imageUrl),
        ),
        Positioned.fill(
          child: Container(
            padding: EdgeInsets.all(Insets.lg),
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0)],
                  begin: Alignment.bottomCenter,
                  end: Alignment(0, -0.7)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(flex: 8, child: Text(text, style: TextStyles.h4.copyWith(color: Colors.white))),
                    Spacer(),
                    Text(cost, style: TextStyles.body14.copyWith(color: Colors.white))
                  ],
                ),
                if (subHeading != null) ...[SizedBox(height: Insets.med), subHeading!]
              ],
            ),
          ),
        ),
      ],
    );
  }
}
