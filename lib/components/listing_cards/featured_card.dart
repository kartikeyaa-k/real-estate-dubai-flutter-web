import 'package:flutter/material.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';
import 'card_mixin.dart';

class FeaturedCard extends StatefulWidget {
  FeaturedCard({
    Key? key,
    this.cardExtension,
    this.onViewDetails,
    this.title,
    this.address,
    this.price,
    this.tenure,
    this.bedroomCount,
    this.bathroomCount,
    this.area,
    this.image,
  }) : super(key: key);

  final Widget? cardExtension;
  final VoidCallback? onViewDetails;
  final String? title;
  final String? address;
  final double? price;
  final String? tenure;
  final int? bedroomCount;
  final int? bathroomCount;
  final double? area;
  final String? image;

  @override
  _FeaturedCardState createState() => _FeaturedCardState();
}

class _FeaturedCardState extends State<FeaturedCard> with CommonCardMixin {
  @override
  Widget build(BuildContext context) {
    Widget areaChart = Stack(
      children: [
        Container(
          padding: EdgeInsets.all(2),
          alignment: Alignment.center,
          height: 30,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: kAccentColor[80],
              border: Border.all(color: kSupportAccent, style: BorderStyle.solid),
            ),
          ),
        ),
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              chartButton(context,
                  top: -10,
                  left: 35,
                  text:
                      "${widget.bedroomCount != null && widget.bedroomCount != 0 ? widget.bedroomCount : '--'} Bedrooms",
                  icon: Icons.hotel_outlined),
              chartButton(context,
                  bottom: -20,
                  text:
                      "${widget.bathroomCount != null && widget.bathroomCount != 0 ? widget.bathroomCount : '--'} Bathrooms",
                  icon: Icons.bathtub_outlined),
              chartButton(context,
                  top: -10,
                  right: 35,
                  text: "${widget.area != null && widget.area != 0 ? widget.area?.toInt() : '--'} Sqft",
                  icon: Icons.pie_chart_outline_outlined)
            ],
          ),
        ),
      ],
    );

    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 1, color: kBlackVariant.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 459, minHeight: 394),
            child: Column(
              children: [
                cardImage(image: widget.image),
                SizedBox(height: 20),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 10, end: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title text
                        Text(widget.title ?? "", style: TextStyles.h3),

                        // Location row
                        Spacer(flex: 1),
                        locationRow(location: widget.address),

                        // Bedroom, bathroom, area chart
                        Spacer(flex: 3),
                        areaChart,

                        // Price and details
                        Spacer(flex: 4),
                        priceRow(
                          onTap: widget.onViewDetails,
                          price: widget.price != null
                              ? "${widget.price?.toInt()}${RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(widget.tenure!) ? "" : "/${widget.tenure}"}"
                              : null,
                        ),

                        // extension
                        if (widget.cardExtension != null) ...[
                          Spacer(flex: 2),
                          widget.cardExtension!,
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Stack chartButton(BuildContext context,
      {double? right, double? top, double? left, double? bottom, required String text, required IconData icon}) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: kSupportAccent,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(icon, size: 20, color: Colors.white),
        ),
        Positioned(
          top: top,
          left: left,
          bottom: bottom,
          right: right,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyles.body14.copyWith(color: Color(0xFFB4667C)),
              ),
            ],
          ),
        )
      ],
    );
  }
}
