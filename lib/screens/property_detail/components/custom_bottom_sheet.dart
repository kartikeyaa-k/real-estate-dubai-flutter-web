import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/primary_outlined_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _currentRentDueRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Rent Due", style: TextStyles.h4.copyWith(color: kBlackVariant)),
            SizedBox(height: 6),
            Text(
              "12/02/2020  - 12/03/2020",
              style: TextStyles.body10.copyWith(color: kBlackVariant.withOpacity(0.7)),
            ),
          ],
        ),
        Spacer(),
        Text("AED 1200/Month")
      ],
    );

    Widget _actionButtonsRow = Row(
      children: [
        PrimaryOutlinedButton(onTap: () {}, text: "Download Invoices", width: null),
        Spacer(),
        PrimaryButton(
          onTap: () {},
          text: "Pay Rent",
          width: null,
          backgroundColor: kSupportGreen,
          onHoverColor: kSupportGreen.withOpacity(0.9),
        )
      ],
    );

    var _singlePaymentHistoryRow = Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("AED 1200", style: TextStyles.h4),
            SizedBox(height: 6),
            Text(
              "12/02/2020",
              style: TextStyles.body10.copyWith(color: kBlackVariant.withOpacity(0.7)),
            ),
          ],
        ),
        Spacer(),
        Text("Paid", style: TextStyles.h4.copyWith(color: kSupportGreen)),
        Spacer(),
        PrimaryOutlinedButton(onTap: () {}, text: "Download Invoices", width: null)
      ],
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 1, maxWidth: MediaQuery.of(context).size.width),
      child: DraggableScrollableSheet(
        maxChildSize: 0.8,
        // the minimum height should be 168px, hence calculate the percent accordingly
        initialChildSize: (168 / MediaQuery.of(context).size.height),
        minChildSize: (168 / MediaQuery.of(context).size.height),
        builder: (context, controller) {
          return Container(
              padding: EdgeInsets.all(Insets.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Corners.xlRadius),
                color: Colors.white,
                boxShadow: Shadows.smallReverse,
              ),
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: [
                    Icon(Icons.keyboard_arrow_down_outlined),

                    // Row Rent due
                    _currentRentDueRow,

                    // Buttons download and invoice
                    SizedBox(height: 20),
                    _actionButtonsRow,

                    // Payment history
                    SizedBox(height: 26),
                    Align(alignment: Alignment.centerLeft, child: Text("Payment history", style: TextStyles.h4)),
                    SizedBox(height: 15),
                    ListView.builder(
                        controller: controller,
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _singlePaymentHistoryRow,
                          );
                        })
                  ],
                ),
              ));
        },
      ),
    );
  }
}
