import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/skeleton_image_loader.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

class MobileCard extends StatefulWidget {
  final String? image;
  final String? name;
  final String? address;
  final int? bedrooms;
  final int? bathroom;
  final double? sqft;
  final double? price;
  final String? tenure;
  final Widget? priceWidget;
  final Widget? extensionWidget;
  final double height;
  final VoidCallback? onTap;

  const MobileCard({
    Key? key,
    this.image,
    this.name,
    this.address,
    this.bedrooms,
    this.bathroom,
    this.sqft,
    this.price,
    this.tenure,
    this.priceWidget,
    this.extensionWidget,
    this.height = 180,
    this.onTap,
  }) : super(key: key);

  @override
  _MobileCardState createState() => _MobileCardState();
}

class _MobileCardState extends State<MobileCard> {
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

    Widget _quatifiedDetails = Row(
      children: [
        Text(
          "${widget.bedrooms} Bedrooms",
          style: TextStyles.body12.copyWith(color: kAccentColor[80]),
        ),
        Spacer(),
        Text(
          "${widget.bathroom} Bathrooms",
          style: TextStyles.body12.copyWith(color: kAccentColor[80]),
        ),
        Spacer(),
        Text(
          "${widget.sqft} Sqft",
          style: TextStyles.body12.copyWith(color: kAccentColor[80]),
        ),
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints.expand(height: widget.height),
      child: GestureDetector(
        onTap: widget.onTap,
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
                              if (widget.bedrooms != null && widget.bathroom != null) _quatifiedDetails,
                              Spacer(flex: 3),
                              widget.priceWidget ??
                                  Text(
                                    widget.price != null ? "AED ${widget.price}/${widget.tenure}" : "TBD",
                                    style: TextStyles.h3,
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.extensionWidget != null) ...[
                    SizedBox(height: 10),
                    widget.extensionWidget!,
                  ],
                ],
              ),
            ),
            // Positioned(
            //   top: Insets.sm,
            //   right: Insets.sm,
            //   child: Material(
            //     color: Colors.transparent,
            //     child: IconButton(
            //       onPressed: () {},
            //       icon: Icon(Icons.bookmark_outline, color: kSupportBlue),
            //       visualDensity: VisualDensity.compact,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
