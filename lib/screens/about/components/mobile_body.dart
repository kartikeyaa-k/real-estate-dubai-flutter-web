import 'package:flutter/material.dart';

import '../../../components/listing_cards/mobile_card.dart';

class MobileBody extends StatelessWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF3F3F3),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsetsDirectional.only(bottom: 2),
          child: MobileCard(),
        ),
      ),
    );
  }
}
