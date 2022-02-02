import 'package:flutter/material.dart';
import '../../../../components/listing_cards/featured_card.dart';
import 'corporate_common_card_mixin.dart';

class SavedPropertyCard extends StatelessWidget with CorporateCommonCardMixin {
  const SavedPropertyCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FeaturedCard(cardExtension: employeeCard());
  }
}
