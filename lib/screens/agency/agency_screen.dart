import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/toolbar.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../property_listing/components/app_bar_bottom.dart';
import '../property_listing/components/tab_bar.dart';
import 'components/agency_cover_detail.dart';
import 'components/agency_tab_view.dart';
import 'components/brand_banner.dart';
import 'components/description.dart';
import 'components/location.dart';

class AgencyScreen extends StatefulWidget {
  const AgencyScreen({Key? key}) : super(key: key);

  @override
  _AgencyScreenState createState() => _AgencyScreenState();
}

class _AgencyScreenState extends State<AgencyScreen> with TickerProviderStateMixin {
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
    bool switchViewCondition = Responsive.isDesktop(context);

    Widget child = Container(
      padding:
          switchViewCondition ? EdgeInsets.symmetric(horizontal: Insets.xxl, vertical: Insets.offset) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: switchViewCondition ? EdgeInsets.all(Insets.xl) : EdgeInsets.zero,
            child: Flex(
              direction: switchViewCondition ? Axis.horizontal : Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BrandBanner(),
                SizedBox(width: Insets.xl),
                if (!switchViewCondition) AgencyCoverDetails() else Flexible(child: AgencyCoverDetails()),
              ],
            ),
          ),
          SizedBox(height: Insets.xl),
          Container(
            width: switchViewCondition ? 710 : double.infinity,
            color: switchViewCondition ? Colors.white : Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Description(), SizedBox(height: Insets.xl), Location()],
            ),
          ),
          SizedBox(height: Insets.xl),
        ],
      ),
    );

    return Scaffold(
      appBar: Responsive.isDesktop(context) ? ToolBar() : null,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(child: child),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: switchViewCondition
                        ? EdgeInsets.symmetric(horizontal: Insets.xxl, vertical: Insets.xs)
                        : EdgeInsets.symmetric(horizontal: Insets.xl),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Properties Owned By Dyson Projects Ltd.",
                            style: TextStyles.h2.copyWith(color: kBlackVariant),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
                        if (!switchViewCondition)
                          InkWell(
                            onTap: () {},
                            child: Text("See All(200)", style: TextStyles.body12.copyWith(color: kSupportBlue)),
                          )
                      ],
                    ),
                  ),
                  SizedBox(height: Insets.xl),
                ],
              ),
            ),
            SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
                child: Padding(
                  padding: switchViewCondition
                      ? EdgeInsets.symmetric(horizontal: Insets.xxl, vertical: Insets.xs)
                      : EdgeInsets.zero,
                  child: PropertyListingTabBar(tabController: _tabController, showSorting: switchViewCondition),
                ),
                maxExtent: 80,
                minExtent: 80,
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // TAB For Rent
            AgencyTabView(key: ValueKey('for-rent-of-agency')),
            // TAB Commercial Rent
            AgencyTabView(key: ValueKey('commericial-of-agency'))
          ],
        ),
      ),
    );
  }
}
