import 'package:flutter/material.dart';

import '../../../../components/listing_cards/featured_card.dart';
import '../../../../components/ui_text.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/styles.dart';
import 'corporate_common_card_mixin.dart';

class RequestedPropertyCard extends StatelessWidget with CorporateCommonCardMixin {
  const RequestedPropertyCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FeaturedCard(
      cardExtension: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          employeeCard(),
          SizedBox(height: 15),
          Row(
            children: [
              Icon(Icons.info_outline, color: kSupportRed),
              SizedBox(width: 5),
              Expanded(
                child: UiText(
                  text: "Rejected at negotiation",
                  style: TextStyles.h4.copyWith(color: kSupportRed),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
