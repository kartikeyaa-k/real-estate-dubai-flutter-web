import 'package:flutter/material.dart';

import '../../../components/listing_cards/card_mixin.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class ServiceDetailPrimaryDetailCard extends StatefulWidget {
  const ServiceDetailPrimaryDetailCard({Key? key}) : super(key: key);

  @override
  _ServiceDetailPrimaryDetailCardState createState() => _ServiceDetailPrimaryDetailCardState();
}

class _ServiceDetailPrimaryDetailCardState extends State<ServiceDetailPrimaryDetailCard> with CommonCardMixin {
  @override
  Widget build(BuildContext context) {
    Widget _scheduleRow = Row(
      children: [
        Icon(Icons.schedule_outlined, color: kSupportBlue),
        SizedBox(width: Insets.sm),
        Text.rich(TextSpan(
            text: "10:30 - 18:30 ",
            style: TextStyles.h3,
            children: [TextSpan(text: "(Open Now)", style: TextStyles.h3.copyWith(color: kSupportGreen))]))
      ],
    );

    Widget _textSpan = Row(
      children: [
        Icon(Icons.star, color: kSupportAccent),
        SizedBox(width: Insets.sm),
        Text.rich(
          TextSpan(
            text: "4.6",
            style: TextStyles.h3.copyWith(color: kSupportAccent),
            children: [TextSpan(text: "(300)", style: TextStyles.body18.copyWith(color: kSupportAccent))],
          ),
        )
      ],
    );

    return Container(
      height: 195,
      padding: EdgeInsets.all(Insets.xl),
      decoration: BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Chip(
                label: Text("Verified Service", style: TextStyles.body16.copyWith(color: Colors.white)),
                backgroundColor: kSupportGreen,
                visualDensity: VisualDensity.compact,
              ),
              Text("Home Decor", style: TextStyles.h2),
              _scheduleRow,
              _textSpan
            ],
          ),
          if (Responsive.isDesktop(context)) Positioned(bottom: 0, right: 0, child: socialSharingRow)
        ],
      ),
    );
  }
}
