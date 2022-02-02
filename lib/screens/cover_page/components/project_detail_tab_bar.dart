import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class ProjectDetailTabBar extends StatefulWidget {
  ProjectDetailTabBar({Key? key, required TabController tabController, this.showSorting = true})
      : _tabController = tabController,
        super(key: key);

  final TabController _tabController;
  final bool showSorting;

  @override
  _ProjectDetailTabBarState createState() => _ProjectDetailTabBarState();
}

class _ProjectDetailTabBarState extends State<ProjectDetailTabBar> {
  @override
  Widget build(BuildContext context) {
    final bool adjustmentCondition = MediaQuery.of(context).size.width > 665;
    final double padding = adjustmentCondition ? Insets.xl : Insets.lg;
    final double comboBoxMaxWidth = adjustmentCondition ? 200 : 180;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: Shadows.universal,
        borderRadius: widget.showSorting ? Corners.lgBorder : null,
      ),
      constraints: BoxConstraints(maxWidth: Insets.maxWidth),
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: Insets.xl),
      width: double.infinity,
      child: TabBar(
        controller: widget._tabController,
        labelPadding: EdgeInsets.symmetric(horizontal: padding),
        isScrollable: true,
        indicatorColor: kSupportBlue,
        labelColor: Colors.black,
        unselectedLabelColor: kBlackVariant,
        labelStyle: TextStyles.h4.copyWith(color: kBlackVariant),
        indicatorWeight: 4,
        tabs: [
          ...['Details', 'Floor Plan', 'Payment Plan', 'Available Units'].map(
            (e) => SizedBox(
                child: Center(
                  child: Text(e),
                ),
                height: 80),
          )
        ],
      ),
    );
  }
}
