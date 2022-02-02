import 'package:flutter/material.dart';

import '../../components/buttons/primary_button.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';
import 'components/corporate_property_filter.dart';

class CorporatePropertyFilterScreen extends StatelessWidget {
  const CorporatePropertyFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _bottomNavigation = Container(
      height: 62,
      decoration: BoxDecoration(boxShadow: Shadows.smallReverse),
      padding: EdgeInsets.symmetric(horizontal: 20.5, vertical: 10.5),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("200", style: TextStyles.h3.copyWith(color: kBlackVariant)),
              Text(
                "Properties Found",
                style: TextStyles.body10.copyWith(color: kBlackVariant.withOpacity(0.7)),
              )
            ],
          ),
          Spacer(),
          PrimaryButton(
            onTap: () {},
            text: "Apply Filter",
            height: 41,
            width: 110,
          )
        ],
      ),
    );

    var _appBar = AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: kSupportBlue),
      title: Text("Filter Properties", style: TextStyles.h3.copyWith(color: kBlackVariant)),
      actions: [
        TextButton(
          onPressed: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Insets.sm),
            child: Text("Clear Filters"),
          ),
        )
      ],
    );

    return Scaffold(
      appBar: _appBar,
      bottomNavigationBar: _bottomNavigation,
      body: SingleChildScrollView(
        child: Container(
          child: MyPropertyFilter(isFullPageView: true),
        ),
      ),
    );
  }
}
