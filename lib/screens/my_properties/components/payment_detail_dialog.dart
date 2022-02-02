import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/primary_outlined_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class PaymentDetailDialog extends StatelessWidget {
  const PaymentDetailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _paymentDetailRow = Row(
      children: [
        Text("AED 1200", style: TextStyles.h4),
        Spacer(flex: 4),
        Text("01/01/2021- 02/02/2021", style: TextStyles.h4),
        Spacer(flex: 4),
        Text("Paid", style: TextStyles.h4.copyWith(color: kSupportGreen)),
        Spacer(flex: 4),
        PrimaryOutlinedButton(
          onTap: () {},
          text: "Download Invoice",
          icon: Icons.file_download_outlined,
        ),
        Spacer(),
        PrimaryButton(onTap: () {}, text: "Pay Rent", icon: Icons.attach_money_outlined, width: null)
      ],
    );

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: Corners.xlBorder),
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(maxWidth: 834),
        decoration: BoxDecoration(borderRadius: Corners.xlBorder, color: Colors.white),
        padding: EdgeInsets.all(Insets.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(child: Text("Payment Details", style: TextStyles.h2)),
            SizedBox(height: Insets.xxl),

            // Rent Due
            Text("Rent Due", style: TextStyles.h3),
            Padding(
              padding: EdgeInsetsDirectional.only(start: Insets.sm),
              child: _paymentDetailRow,
            ),

            // payment history
            SizedBox(height: 26),
            Text("Payment History", style: TextStyles.h3),
            Padding(
              padding: EdgeInsetsDirectional.only(start: Insets.sm),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: _paymentDetailRow,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
