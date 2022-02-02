import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_portal/components/mobile_app_bar.dart';
import 'package:real_estate_portal/components/primary_tab_bar.dart';
import 'package:real_estate_portal/components/toolbar.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/screens/coporate_properties/components/corporate_properties_tab_view.dart';
import 'package:real_estate_portal/screens/property_listing/components/app_bar_bottom.dart';
import 'package:real_estate_portal/screens/property_listing/components/banner_image.dart';

class CorporatePropertiesScreen extends StatefulWidget {
  const CorporatePropertiesScreen({
    Key? key,
  }) : super(key: key);

  @override
  _CorporatePropertiesScreenState createState() => _CorporatePropertiesScreenState();
}

enum CorporatePropertiesTabs {
  RentedProperties,
  InProcess,
  RequestedProperties,
  RejectedProperties,
}

class _CorporatePropertiesScreenState extends State<CorporatePropertiesScreen> with TickerProviderStateMixin {
  /// content padding for dektop and tablets for My properties
  EdgeInsets desktopContentPadding = EdgeInsets.symmetric(
    vertical: Insets.xxl / 2,
    horizontal: Insets.offset,
  );

  late TabController _tabController;
  late List<Widget> _tabList;

  final List<String> _tabString = CorporatePropertiesTabs.values.map((e) {
    String name = e.toString().substring(e.toString().indexOf(".") + 1);
    return name.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}');
  }).toList();

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);

    // App banner with tab bar
    Widget _tabBarWithImageBanner = Stack(
      children: [
        Column(
          children: _toolBarSwitchCondition
              ? [if (Responsive.isDesktop(context)) _breadCrumbs(), BannerImage(), SizedBox(height: 40)]
              : [],
        ),
        Positioned(
          bottom: 0,
          left: Insets.offset,
          right: Insets.offset,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Search result",
                style: TextStyles.h2.copyWith(color: Colors.white),
              ),
              SizedBox(height: _toolBarSwitchCondition ? 30 : 18),
              if (_toolBarSwitchCondition) ...[
                PrimaryTabBar(
                  tabController: _tabController,
                  children: _tabList,
                ),
              ],
            ],
          ),
        ),
      ],
    );

    List<Widget> _mobileAppBarActions = [
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.search),
      ),
      IconButton(
        onPressed: () {},
        icon: Icon(Icons.filter_list),
      )
    ];

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: Responsive.isDesktop(context) ? ToolBar() : MobileAppBar(actions: _mobileAppBarActions),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            if (Responsive.isMobile(context))
              SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                  child: Container(
                    color: Colors.white,
                    child: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      indicatorColor: kSupportBlue,
                      labelColor: Colors.black,
                      unselectedLabelColor: kBlackVariant,
                      labelStyle: TextStyles.h4.copyWith(
                        color: kBlackVariant,
                      ),
                      indicatorWeight: 4,
                      tabs: _tabList,
                    ),
                  ),
                  minExtent: 62,
                  maxExtent: 62,
                ),
                pinned: true,
              )
            else
              SliverToBoxAdapter(child: _tabBarWithImageBanner)
          ];
        },
        body: Container(
          padding: Responsive.isMobile(context) ? EdgeInsets.only(top: Insets.sm) : null,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Rented Properties
              CorporatePropertiesTabView(
                key: ValueKey('rented-properties'),
                tabType: CorporatePropertiesTabs.RentedProperties,
              ),
              // InProcess
              CorporatePropertiesTabView(
                key: ValueKey('in-process'),
                tabType: CorporatePropertiesTabs.InProcess,
              ),
              // Saved Properties
              CorporatePropertiesTabView(
                key: ValueKey('requested-properties'),
                tabType: CorporatePropertiesTabs.RequestedProperties,
              ),
              // Rejected Properties
              CorporatePropertiesTabView(
                key: ValueKey('rejected-properties'),
                tabType: CorporatePropertiesTabs.RejectedProperties,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabList = _tabString.map((e) => _tabViewChild(e)).toList();
  }

  // TODO: Make bread crumbs global component, after routing is configured
  Container _breadCrumbs() {
    return Container(
      padding: desktopContentPadding,
      alignment: Alignment.centerLeft,
      height: 90,
      child: Row(
        children: [
          Icon(Icons.keyboard_arrow_left_outlined),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.xl),
              child: Text(
                "Back to Home",
                style: TextStyles.body18.copyWith(color: kSupportBlue),
              ),
            ),
          ),
          VerticalDivider(
            width: 1,
            color: Colors.black,
            endIndent: 16,
            indent: 16,
          ),
          BreadCrumb(
            items: [
              BreadCrumbItem(
                content: Text(
                  "Dubai",
                  style: TextStyles.body18.copyWith(
                    color: kSupportBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {},
                splashColor: kBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: Insets.xl),
              ),
              BreadCrumbItem(
                content: Text(
                  "Green Community",
                  style: TextStyles.body18.copyWith(
                    color: kSupportBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {},
                splashColor: kBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: Insets.xl),
              ),
              BreadCrumbItem(
                content: Text(
                  "Green Park",
                  style: TextStyles.body18.copyWith(
                    color: kSupportBlue,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {},
                splashColor: kBackgroundColor,
                padding: EdgeInsets.symmetric(horizontal: Insets.xl),
              ),
            ],
            divider: Icon(Icons.chevron_right, size: 15),
          ),
        ],
      ),
    );
  }

  SizedBox _tabViewChild(String e) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          Center(
            child: Text(e),
          ),
          SizedBox(width: 6),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              borderRadius: Corners.lgBorder,
              color: kSupportAccent,
            ),
          ),
        ],
      ),
    );
  }
}
