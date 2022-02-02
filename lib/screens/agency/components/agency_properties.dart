import 'package:flutter/material.dart';
import 'package:real_estate_portal/models/property_details_models/property_model.dart';

import '../../../components/scaffold/sliver_scaffold.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../property_listing/components/app_bar_bottom.dart';
import '../../property_listing/components/mobile_body.dart';
import '../../property_listing/components/tab_bar.dart';
import '../../property_listing/components/tab_view.dart';

class AgencyProperties extends StatefulWidget {
  const AgencyProperties({Key? key}) : super(key: key);

  @override
  _AgencyPropertiesState createState() => _AgencyPropertiesState();
}

class _AgencyPropertiesState extends State<AgencyProperties> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);

    return Responsive.isMobile(context)
        ? SliverScaffold(
            child: Container(
              child: Padding(
                padding: EdgeInsetsDirectional.only(top: Insets.med),
                child: MobileBody(),
              ),
            ),
            title: "Rent Properties",
            appBarExtension: [
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(child: AppBarBottom(), maxExtent: 54, minExtent: 54),
                pinned: true,
              ),
            ],
          )
        : NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [SliverToBoxAdapter(child: PropertyListingTabBar(tabController: _tabController))];
            },
            body: Container(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // TAB For Rent
                  TabView(key: ValueKey('for-rent'), propertyType: PropertyType.RESIDENTIAL),
                  // TAB Commercial Rent
                  TabView(key: ValueKey('commericial'), propertyType: PropertyType.COMMERCIAL)
                ],
              ),
            ),
          );
  }
}
