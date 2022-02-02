import 'package:flutter/material.dart';

import '../core/utils/constants.dart';
import '../core/utils/responsive.dart';
import '../core/utils/styles.dart';

// TODO: replace in other places too
class PrimaryTabBar extends StatelessWidget {
  PrimaryTabBar(
      {Key? key, required TabController tabController, this.showSorting = true, required this.children, this.action})
      : _tabController = tabController,
        super(key: key);

  final TabController _tabController;
  final bool showSorting;
  final List<Widget> children;
  final List<Widget>? action;

  @override
  Widget build(BuildContext context) {
    final bool adjustmentCondition = MediaQuery.of(context).size.width > 665;
    final double padding = adjustmentCondition ? Insets.xl : Insets.lg;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: Shadows.universal, borderRadius: showSorting ? Corners.lgBorder : null),
      constraints: BoxConstraints(maxWidth: Insets.maxWidth),
      height: 82,
      child: Row(
        children: [
          Flexible(
            flex: 4,
            // TODO: Snap tab to screen when clicked in scrollview
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsetsDirectional.only(start: padding, end: padding),
                child: TabBar(
                  controller: _tabController,
                  labelPadding: EdgeInsets.symmetric(horizontal: padding),
                  isScrollable: !Responsive.isMobile(context),
                  indicatorColor: kSupportBlue,
                  labelColor: Colors.black,
                  unselectedLabelColor: kBlackVariant,
                  labelStyle: TextStyles.h4.copyWith(color: kBlackVariant),
                  indicatorWeight: 4,
                  tabs: children,
                ),
              ),
            ),
          ),
          if (action != null && action!.isNotEmpty) ...[Spacer(), ...action ?? []]
        ],
      ),
    );
  }
}
