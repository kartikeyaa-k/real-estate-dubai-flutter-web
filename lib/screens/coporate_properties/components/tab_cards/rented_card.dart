import 'package:flutter/material.dart';

import '../../../../components/buttons/primary_button.dart';
import '../../../../components/listing_cards/flexible_card.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/styles.dart';
import '../payment_detail_dialog.dart';
import 'corporate_common_card_mixin.dart';

class RentedCard extends StatelessWidget with CorporateCommonCardMixin {
  const RentedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleCard(
      lineThreeWidget: Row(
        children: [
          Flexible(flex: 8, child: Text("AED 130000/year", style: TextStyles.h4.copyWith(color: kBlackVariant))),
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
                    showDialog(
                      context: context,
                      builder: (context) {
                        return PaymentDetailDialog();
                      },
                    );
                  },
                  text: "Payment Details",
                  fontSize: 12,
                  width: 113,
                  height: null,
                ),
                PrimaryButton(onTap: () {}, text: "View Details", fontSize: 12, width: 98, height: null)
              ],
            ),
          ),
        ],
      ),
      lineFourWidget: employeeCard(),
    );
  }
}
