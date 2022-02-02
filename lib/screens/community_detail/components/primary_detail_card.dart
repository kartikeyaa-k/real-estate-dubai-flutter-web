import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/listing_cards/card_mixin.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/review_model.dart';

class PrimaryDetailCard extends StatefulWidget {
  PrimaryDetailCard({Key? key, required this.text, required this.emirate, required this.reviewModel}) : super(key: key);

  final String text;
  final String emirate;
  final ReviewModel reviewModel;

  @override
  _PrimaryDetailCardState createState() => _PrimaryDetailCardState();
}

class _PrimaryDetailCardState extends State<PrimaryDetailCard> with CommonCardMixin {
  @override
  Widget build(BuildContext context) {
    Widget _agencyName = Text(
      widget.text,
      style: Responsive.isDesktop(context) ? TextStyles.h3.copyWith(color: kBlackVariant) : MS.lableBlack,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    Widget _locationRow = locationRow(
      location: widget.emirate,
      textStyle: Responsive.isDesktop(context) ? TextStyles.h3.copyWith(color: kSupportBlue) : MS.miniHeaderBlack,
      textMaxWidth: 422,
    );

    Widget _rating = Row(
      children: [
        Icon(
          Icons.star_rate_rounded,
          color: kAccentColor,
        ),
        SizedBox(width: Insets.sm),
        Text(
          "${widget.reviewModel.averageRating} (${widget.reviewModel.totalReviewCount})",
          style: TextStyles.body14.copyWith(color: kAccentColor),
        ),
      ],
    );

    Widget _nearby = Text(
      "",
      // "Malls - Parks - Restaurants - Spas",
      style: TextStyles.body14.copyWith(
        color: kBlackVariant.withOpacity(0.7),
      ),
    );

    return Container(
      height: 155,
      padding: EdgeInsets.all(Insets.xl),
      color: Colors.white,
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _agencyName,
              _locationRow,
              _rating,
              _nearby,
            ],
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: socialSharingRow,
          ),
        ],
      ),
    );
  }
}
