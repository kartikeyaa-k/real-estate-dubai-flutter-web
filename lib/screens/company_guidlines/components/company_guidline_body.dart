import 'package:flutter/material.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/emirates_model.dart';
import 'package:real_estate_portal/screens/community_listing/community_listing_screen.dart';

import '../../../components/listing_cards/image_card.dart';
import '../../../core/utils/styles.dart';

class CompanyGuidlinesBody extends StatelessWidget {
  const CompanyGuidlinesBody({
    Key? key,
    required bool toolBarSwitchCondition,
    required this.result,
  })  : _toolBarSwitchCondition = toolBarSwitchCondition,
        super(key: key);

  final bool _toolBarSwitchCondition;
  final List<EmiratesModel> result;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(_toolBarSwitchCondition ? Insets.offset : Insets.lg),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: result.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 370, mainAxisSpacing: 30, crossAxisSpacing: 30, childAspectRatio: 370 / 208),
          itemBuilder: (context, index) {
            return ImageCard(
              imageUrl: result[index].image,
              text: result[index].emirateName,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CommunityListingScreen(
                        communities: result[index].communities,
                        id: result[index].id,
                        description: result[index].description,
                        text: result[index].emirateName),
                  ),
                );
              },
            );
          }),
    );
  }
}
