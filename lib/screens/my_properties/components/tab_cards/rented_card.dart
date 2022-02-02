import 'package:flutter/material.dart';
import 'package:real_estate_portal/models/response_models/my_properties/booked_properties_response_model.dart';

import '../../../../components/buttons/primary_button.dart';
import '../../../../components/listing_cards/flexible_card.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/styles.dart';
import '../payment_detail_dialog.dart';

class RentedCard extends StatelessWidget {
  const RentedCard({Key? key, required this.bookedPropertiesModel}) : super(key: key);
 final BookedPropertiesModel bookedPropertiesModel;
  @override
  Widget build(BuildContext context) {
    return FlexibleCard(
      lineThreeWidget: Row(
        children: [
          Flexible(flex: 8, child: Text(bookedPropertiesModel.price, style: TextStyles.h4.copyWith(color: kBlackVariant))),
          Spacer(),
          Expanded(
            flex: 14,
            child: Wrap(
              alignment: WrapAlignment.end,
              runSpacing: 10,
              spacing: 4,
              children: [
                PrimaryButton(
                  onTap: () {
                   
                  },
                  text: "Payment Details",
                  fontSize: 12,
                  width: 113,
                  height: null,
                ),
                PrimaryButton(onTap: () {}, text: "0000000000", fontSize: 12, width: 98, height: null)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
