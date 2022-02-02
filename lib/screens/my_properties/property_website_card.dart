import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/listing_cards/bookmark_card_mixin.dart';
import 'package:real_estate_portal/components/listing_cards/card_mixin.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';

class PropertyWebsiteCard extends StatefulWidget {
  PropertyWebsiteCard(
      {Key? key,
      this.name,
      this.address,
      this.price,
      this.image,
      this.onViewDetails})
      : super(key: key);

  final String? name;
  final String? address;
  final String? price;
  final String? image;
  final VoidCallback? onViewDetails;

  @override
  _PropertyWebsiteCardState createState() => _PropertyWebsiteCardState();
}

class _PropertyWebsiteCardState extends State<PropertyWebsiteCard>
    with BookmarkCardMixin {
  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsetsDirectional.only(
                        start: 10, end: 10, bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title text
                        Text(widget.name ?? "", style: TextStyles.h3),

                        // Location row
                        Spacer(flex: 1),
                        locationRow(location: widget.address),

                        // Bedroom, bathroom, area chart
                        Spacer(flex: 3),

                        // Price and details
                        Spacer(flex: 4),
                        priceRow(
                          onTap: widget.onViewDetails,
                          price:
                              widget.price != null ? "${widget.price}" : "TBD",
                        ),

                        // extension
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
}
