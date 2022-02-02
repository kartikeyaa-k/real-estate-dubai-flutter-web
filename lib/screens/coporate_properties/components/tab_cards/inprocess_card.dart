import 'package:flutter/material.dart';

import '../../../../components/buttons/primary_button.dart';
import '../../../../components/listing_cards/flexible_card.dart';
import '../../../../components/ui_text.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/styles.dart';
import 'corporate_common_card_mixin.dart';

class InProcessCard extends StatelessWidget with CorporateCommonCardMixin {
  const InProcessCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleCard(
      lineThreeWidget: Row(
        children: [
          Expanded(flex: 4, child: Text("AED 130000/year", style: TextStyles.h4.copyWith(color: kBlackVariant))),
          Spacer(),
          PrimaryButton(onTap: () {}, text: "View Details", fontSize: 12, width: null, height: null)
        ],
      ),
      lineFourWidget: Row(
        children: [
          Icon(Icons.access_time_rounded, color: kSupportBlue),
          SizedBox(width: 5),
          Expanded(
            flex: 10,
            child: UiText(
              text: "10:00 - 11:00 12/11/2020",
              style: TextStyles.h4.copyWith(color: kSupportBlue),
            ),
          ),
          Spacer(),
          PrimaryButton(onTap: () {}, text: "Reschedule", fontSize: 12, width: null, height: null)
        ],
      ),
      lineFiveWidget: employeeCard(),
    );
  }
}
