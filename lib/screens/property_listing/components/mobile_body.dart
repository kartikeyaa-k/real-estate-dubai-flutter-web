import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/listing_cards/mobile_card.dart';
import '../cubit/property_listing_cubit.dart';

class MobileBody extends StatelessWidget {
  const MobileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF3F3F3),
      child: BlocBuilder<PropertyListingCubit, PropertyListingState>(
        builder: (context, state) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsetsDirectional.only(bottom: 2),
              child: MobileCard(),
            ),
          );
        },
      ),
    );
  }
}
