import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/property_price_schedule_banner.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class PropertyCostCard extends StatelessWidget {
  const PropertyCostCard({Key? key, this.isFixed = false, required this.price}) : super(key: key);
  final bool isFixed;
  final String price;

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
              Text("Property Price", style: TextStyles.h3),
              SizedBox(height: 4),
              Text("Starting From", style: TextStyles.body12)
            ],
          ),
        ),
        Text("AED $price/Year", style: Responsive.isDesktop(context) ? TextStyles.h2 : TextStyles.h3)
      ],
    );

    return Container(
      padding: EdgeInsets.all(Insets.xl),
      height: isFixed ? 150 : null,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: isFixed ? null : Corners.lgBorder, boxShadow: isFixed ? Shadows.smallReverse : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _serviceCostRow,
          SizedBox(height: Insets.xl),
          PrimaryButton(onTap: () {}, text: "Book a Viewing", width: isFixed ? double.infinity : 142)
        ],
      ),
    );
  }
}
