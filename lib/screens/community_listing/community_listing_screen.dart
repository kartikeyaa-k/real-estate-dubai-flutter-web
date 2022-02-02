import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/toolbar.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/community_model.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:real_estate_portal/screens/company_guidlines/cubit/community_cubit.dart';
import 'package:real_estate_portal/screens/property_owners/components/property_filter_app_bar.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../components/footer.dart';
import '../../components/scaffold/sliver_scaffold.dart';
import '../../components/sliver_grid_delegate.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import 'components/community_card.dart';
import 'components/location_detail_card.dart';
import 'components/mobile_community_card.dart';
import 'components/page_header.dart';

class CommunityListingScreen extends StatefulWidget {
  const CommunityListingScreen(
      {Key? key, required this.communities, required this.id, required this.description, required this.text})
      : super(key: key);

  final List<CommunityModel> communities;
  final int id;
  final String description;
  final String text;

  @override
  _CommunityListingScreenState createState() => _CommunityListingScreenState();
}

class _CommunityListingScreenState extends State<CommunityListingScreen> with TickerProviderStateMixin {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // int? community_id = context.vRouter.queryParameters['community_id'] == null
    //     ? null
    //     : int.parse(context.vRouter.queryParameters['community_id']!);

    // if (community_id != null) {}
  }

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);
    final double offset = Responsive.isMobile(context) ? 0 : Insets.offset;
    final double cardSpacing = Responsive.isMobile(context) ? Insets.xl : Insets.xxl;

    Widget _tabBarWithImageBanner =
        PageHeader(toolBarSwitchCondition: _toolBarSwitchCondition, searchController: _searchController);

    Widget gridView = GridView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.communities.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtentAndMinHeight(
          maxCrossAxisExtent: 394,
          mainAxisMinExtent: 200,
          mainAxisSpacing: cardSpacing,
          crossAxisSpacing: cardSpacing,
          childAspectRatio: Responsive.isMobile(context) ? 328 / 193 : 197 / 162,
        ),
        itemBuilder: (context, index) {
          return Responsive.isMobile(context)
              ? MobileCommunityCard(
                  imageUrl: widget.communities[index].communityImage,
                  text: widget.communities[index].communityName,
                  subText: "Malls - Parks - Restaurant - Spas",
                  id: widget.communities[index].communityId)
              : CommunityCard(
                  image: widget.communities[index].communityImage,
                  text: widget.communities[index].communityName,
                  id: widget.communities[index].communityId);
        });

    Widget body = Padding(
      padding: EdgeInsets.all(offset),
      child: Flex(
        mainAxisSize: MainAxisSize.min,
        direction: Responsive.isDesktop(context) ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            Flexible(child: gridView)
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: gridView,
            ),
          SizedBox(width: cardSpacing, height: cardSpacing),
          LocationDetail(
            text: widget.text,
            description: widget.description,
          ),
        ],
      ),
    );

    Widget mobileView = SliverScaffold(
      hideBottomNav: false,
      child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: EdgeInsetsDirectional.only(top: Insets.med),
            child: body,
          ),
        ),
      ),
      title: "Communities In Dubai",
    );

    Widget webView = Scaffold(
      appBar: Responsive.isDesktop(context) ? ToolBar() : PropertyFilterAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [_tabBarWithImageBanner, body, if (Responsive.isDesktop(context)) Footer()],
        ),
      ),
    );

    return _toolBarSwitchCondition
        ? WillPopScope(
            onWillPop: () async {
              print('#log oon wi poop');
              context.vRouter.to(CommunityGuidlinePath);
              return true;
            },
            child: webView)
        : mobileView;
  }
}
