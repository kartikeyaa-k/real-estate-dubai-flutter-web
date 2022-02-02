import 'package:flutter/material.dart';

import '../../../components/listing_cards/image_card.dart';
import '../../../core/utils/styles.dart';

class CompanyGuidlinesBody extends StatelessWidget {
  const CompanyGuidlinesBody({
    Key? key,
    required bool toolBarSwitchCondition,
  })  : _toolBarSwitchCondition = toolBarSwitchCondition,
        super(key: key);

  final bool _toolBarSwitchCondition;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_toolBarSwitchCondition ? Insets.offset : Insets.lg),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: 10,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 370, mainAxisSpacing: 30, crossAxisSpacing: 30, childAspectRatio: 370 / 208),
          itemBuilder: (context, index) {
            return ImageCard(
              imageUrl: "https://www.kdps.com.au/wp-content/uploads/2018/12/apartment-or-townhouse.jpg",
              text: "Dubai",
            );
          }),
    );
  }
}
