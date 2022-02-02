import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import 'book_slot.dart';

class ServiceCostCard extends StatelessWidget {
  const ServiceCostCard({Key? key, this.isFixed = false}) : super(key: key);
  final bool isFixed;

  @override
  Widget build(BuildContext context) {
    Widget _serviceCostRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Service Cost", style: TextStyles.h3),
              SizedBox(height: 4),
              Text("Service charge may vary from time", style: TextStyles.body12)
            ],
          ),
        ),
        Text("AED 120/Hr", style: Responsive.isDesktop(context) ? TextStyles.h2 : TextStyles.h3)
      ],
    );

    return Container(
      padding: EdgeInsets.all(Insets.xl),
      height: isFixed ? 150 : null,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isFixed ? null : Corners.lgBorder,
          boxShadow: isFixed ? Shadows.smallReverse : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _serviceCostRow,
          SizedBox(height: Insets.xl),
          PrimaryButton(
              onTap: () {
                showDialog(
                  context: context,
                  useSafeArea: false,
                  builder: (context) {
                    return BookSlot();
                  },
                );
              },
              text: "Book Service",
              width: isFixed ? double.infinity : 125)
        ],
      ),
    );
  }
}

class ReviewServiceCard extends StatelessWidget {
  const ReviewServiceCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Insets.xl),
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: Responsive.isMobile(context) ? null : Corners.lgBorder),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Service Cost", style: TextStyles.h3),
          SizedBox(height: 4),
          Text("Service charge may vary from time", style: TextStyles.body12),
          SizedBox(height: Insets.xl),
          PrimaryButton(
            onTap: () {},
            text: "Book Service",
            backgroundColor: kAccentColor[100]!,
            onHoverColor: kAccentColor,
          )
        ],
      ),
    );
  }
}
