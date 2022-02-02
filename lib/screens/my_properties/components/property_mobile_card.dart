import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/skeleton_image_loader.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

class PropertyMobileCard extends StatefulWidget {
  final String? image;
  final String? name;
  final String? address;
  final String? price;
  final double height;

  const PropertyMobileCard({
    Key? key,
    this.image,
    this.name,
    this.address,
    this.price,

    this.height = 180,
  }) : super(key: key);

  @override
  _PropertyMobileCardState createState() => _PropertyMobileCardState();
}

class _PropertyMobileCardState extends State<PropertyMobileCard> {
  @override
  Widget build(BuildContext context) {
    Widget _image = AspectRatio(
      aspectRatio: 10 / 13,
      child: Container(
        height: 130,
        child: SkeletonImageLoader(
          borderRadius: Corners.lgBorder,
          image: (widget.image).toString(),
        ),
      ),
    );

   

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: widget.height),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Colors.white),
            padding: EdgeInsets.all(Insets.sm),
            child: Column(
              children: [
                Flexible(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 180,
                          minHeight: 180,
                        ),
                        child: _image,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Chip(
                            //   label: Text(
                            //     "Verified",
                            //     style: TextStyles.body10.copyWith(
                            //       color: Colors.white,
                            //     ),
                            //   ),
                            //   backgroundColor: kSupportGreen,
                            //   visualDensity: VisualDensity.compact,
                            // ),
                            // Spacer(flex: 2),
                            Text(
                              (widget.name).toString(),
                              style: TextStyles.h3,
                              maxLines: 2,
                            ),
                            Spacer(),
                            Text(
                              (widget.address).toString(),
                              style: TextStyles.body14.copyWith(
                                color: kBlackVariant.withOpacity(0.7),
                              ),
                              maxLines: 2,
                            ),
                            Spacer(flex: 2),
                           
                            Spacer(flex: 3),
                           
                                Text(
                                  widget.price != null
                                      ? "${widget.price}"
                                      : "TBD",
                                  style: TextStyles.h3,
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
          Positioned(
            top: Insets.sm,
            right: Insets.sm,
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.bookmark_outline, color: kSupportBlue),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
