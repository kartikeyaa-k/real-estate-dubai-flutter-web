import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/listing_cards/card_mixin.dart';
import 'package:real_estate_portal/core/localization/app_localizations.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/models/home_page_model/project_list_model.dart';

class LatestCard extends StatefulWidget {
  final VoidCallback? onViewDetail;
  final String? name;
  final ConstructionStatus? status;
  final int? totalUnits;
  final String? address;
  final bool? isVerified;
  final int? pricePerSqFeet;
  final String? imageLink;

  LatestCard({
    Key? key,
    this.name,
    this.status,
    this.totalUnits,
    this.address,
    this.isVerified,
    this.pricePerSqFeet,
    this.imageLink,
    this.onViewDetail,
  }) : super(key: key);

  @override
  _LatestCardState createState() => _LatestCardState();
}

class _LatestCardState extends State<LatestCard> with CommonCardMixin {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.95,
      child: Container(
        // width: 394,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: kBlackVariant.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              cardImage(
                isVerified: widget.isVerified,
                underConstruction: ProjectListModelEnumConverter.statusValues.reverse![widget.status],
                image: widget.imageLink,
              ),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 10,
                    end: 10,
                    bottom: 10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title text
                      Text(widget.name.toString(), style: TextStyles.h3),
                      // Location row
                      Spacer(flex: 1),
                      locationRow(location: widget.address),
                      // units count
                      Spacer(flex: 2),
                      Row(
                        children: [
                          Text(
                            (widget.totalUnits == null)
                                ? "0 ${(AppLocalizations.of(context)!.translate("Units")).toString()}"
                                : "${widget.totalUnits} ${(AppLocalizations.of(context)!.translate("Units")).toString()}",
                            style: TextStyles.body14.copyWith(
                              color: kSupportBlue,
                            ),
                          ),
                          // SizedBox(width: 10),
                          // Text(
                          //   "1 - 5 Bedroom",
                          //   style: TextStyles.h5.copyWith(
                          //     color: kBlackVariant,
                          //   ),
                          // ),
                        ],
                      ),
                      // Price and details
                      Spacer(flex: 2),
                      priceRow(
                        ctx: context,
                        price: widget.pricePerSqFeet != null ? "${widget.pricePerSqFeet}" : null,
                        onTap: widget.onViewDetail,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
