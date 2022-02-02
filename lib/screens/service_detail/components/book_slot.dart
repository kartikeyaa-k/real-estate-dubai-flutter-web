import 'package:flutter/material.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

class BookSlot extends StatelessWidget {
  const BookSlot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(Insets.xl),
        child: Column(
          children: [
            Text("Book Your Service", style: TextStyles.h2),
            Text(
              "Your service will be booked according to the selected time slot",
              style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
            ),
          ],
        ),
      ),
    );
  }
}
