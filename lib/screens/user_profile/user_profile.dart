import 'package:flutter/material.dart';

import '../../components/breadcrumb/primary_breadcrumb.dart';
import '../../components/mobile_app_bar.dart';
import '../../components/primary_tab_bar.dart';
import '../../components/toolbar.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../property_listing/components/app_bar_bottom.dart';
import '../property_listing/components/banner_image.dart';
import 'components/basic_information.dart';
import 'components/company_information.dart';
import 'components/contact_information.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Widget> _tabList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabList = [
      _tabViewChild("Basic Information"),
      _tabViewChild("Contact Information"),
      _tabViewChild("Company Information")
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);

    // App banner with tab bar
    Widget _tabBarWithImageBanner = Stack(
      children: [
        // Column(
        //   children: _toolBarSwitchCondition
        //       ? [if (Responsive.isDesktop(context)) PrimaryBreadCrumb(), BannerImage(), SizedBox(height: 40)]
        //       : [],
        // ),
        Positioned(
          bottom: 0,
          left: Insets.offset,
          right: Insets.offset,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My Profile", style: TextStyles.h2.copyWith(color: Colors.white)),
              SizedBox(height: _toolBarSwitchCondition ? 30 : 18),
              if (_toolBarSwitchCondition) ...[
                PrimaryTabBar(
                  tabController: _tabController,
                  children: _tabList,
                )
              ],
            ],
          ),
        )
      ],
    );

    return Scaffold(
      appBar: Responsive.isDesktop(context) ? ToolBar() : MobileAppBar(),
      backgroundColor: Colors.white,
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
                          labelStyle: TextStyles.h4.copyWith(color: kBlackVariant),
                          indicatorWeight: 4,
                          tabs: _tabList,
                        ),
                      ),
                      minExtent: 62,
                      maxExtent: 62),
                  pinned: true)
            else
              SliverToBoxAdapter(child: _tabBarWithImageBanner)
          ];
        },
        body: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Responsive.isMobile(context) ? Insets.lg : Insets.offset, vertical: 48),
          child: TabBarView(
            controller: _tabController,
            children: [
              SingleChildScrollView(child: BasicInformationTab()),
              SingleChildScrollView(child: ContactInformation()),
              SingleChildScrollView(child: CompanyInformation()),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _tabViewChild(String e) {
    return SizedBox(
      child: Row(
        children: [
          Center(
            child: Text(e),
          )
        ],
      ),
      height: 80,
    );
  }
}
