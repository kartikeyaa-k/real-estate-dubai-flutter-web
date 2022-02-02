import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import '../../property_listing/components/banner_image.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
    required bool toolBarSwitchCondition,
    required TextEditingController searchController,
  })  : _toolBarSwitchCondition = toolBarSwitchCondition,
        _searchController = searchController,
        super(key: key);

  final bool _toolBarSwitchCondition;
  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(children: [BannerImage(), if (_toolBarSwitchCondition) SizedBox(height: 40)]),
        if (_toolBarSwitchCondition)
          Positioned(
            bottom: 0,
            left: Insets.offset,
            right: Insets.offset,
            child: Container(
              height: 80,
              decoration: BoxDecoration(color: Colors.white, borderRadius: Corners.lgBorder, boxShadow: Shadows.universal),
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: Row(
                children: [
                  Text("Emirates", style: TextStyles.h3.copyWith(color: kBlackVariant)),
                  Spacer(flex: 4),
                  // Flexible(
                  //   flex: 4,
                  //   child: Align(
                  //     alignment: Alignment.centerRight,
                  //     child: ConstrainedBox(
                  //         constraints: BoxConstraints(maxWidth: 200),
                  //         child: PrimaryTextField(controller: _searchController, text: "Search Community")),
                  //   ),
                  // ),
                  // SizedBox(width: Insets.med),
                  // PrimaryButton(onTap: () {}, icon: Icons.search_outlined, text: "Search", width: 116),
                ],
              ),
            ),
          )
      ],
    );
  }
}
