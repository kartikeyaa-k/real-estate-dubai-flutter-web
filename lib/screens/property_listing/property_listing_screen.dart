import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constants/property_listing_const.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/scaffold/sliver_scaffold.dart';
import '../../components/toolbar.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../models/home_page_model/suggest_places_model.dart';
import '../../models/property_details_models/property_model.dart';
import 'components/app_bar_bottom.dart';
import 'components/banner_image.dart';
import 'components/property_filter_app_bar.dart';
import 'components/tab_bar.dart';
import 'components/tab_view.dart';
import 'cubit/property_listing_cubit.dart';

class PropertyListingScreen extends StatelessWidget {
  const PropertyListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyListingView();
  }
}

class PropertyListingView extends StatefulWidget {
  const PropertyListingView({Key? key}) : super(key: key);

  @override
  _PropertyListingViewState createState() => _PropertyListingViewState();
}

class _PropertyListingViewState extends State<PropertyListingView> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;

  static const String title = "Explore Properties";

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List searchKeywords = jsonDecode(context.vRouter.queryParameters['searchKeywordList'] ?? "[]");
    List<PlacesResultModel> placesSearch =
        searchKeywords.map((json) => PlacesResultModel.fromJson(jsonDecode(jsonEncode(json)))).toList();
    final PlanType planType =
        PropertyModelEnumConverter.planTypeValues.map[context.vRouter.queryParameters["planType"]] ?? PlanType.RENT;
    final int? propertyTypeId = int.tryParse(context.vRouter.queryParameters['propertyType'] ?? "");
    final int? minPrice = int.tryParse(context.vRouter.queryParameters[kMinPriceKey] ?? "");
    final int? maxPrice = int.tryParse(context.vRouter.queryParameters[kMaxPriceKey] ?? "");
    final PaymentType? paymentType = PropertyModelEnumConverter.paymentTypeValues.map[kPaymentType];
    final FurnishedType? furnishedType =
        PropertyModelEnumConverter.furnishedStatusValues.map[context.vRouter.queryParameters["furnishing"] ?? "ANY"];
    final double? minArea = double.tryParse(context.vRouter.queryParameters['minArea'] ?? "");
    final double? maxArea = double.tryParse(context.vRouter.queryParameters['maxArea'] ?? "");
    final keywords = context.vRouter.queryParameters['keywords']?.split(",");
    keywords?.removeWhere((keyword) => keyword.isEmpty);
    final String? sort = context.vRouter.queryParameters[kSortingKey];
    final int? minBathroom = int.tryParse(context.vRouter.queryParameters[kMinBathKey] ?? "");
    final int? maxBathroom = int.tryParse(context.vRouter.queryParameters[kMaxBathKey] ?? "");
    final int? minBedroom = int.tryParse(context.vRouter.queryParameters[kMinBedroomKey] ?? "");
    final int? maxBedroom = int.tryParse(context.vRouter.queryParameters[kMaxBedroomKey] ?? "");
    final int? currentPage = int.tryParse(context.vRouter.queryParameters[kPageNumberKey] ?? "1");
    final int limit = kPropertyPerPage;
    final int offset = ((currentPage ?? 1) - 1) * kPropertyPerPage;

    _tabController.index = context.vRouter.queryParameters["type"] == "c" ? 1 : 0;

    // load data for the given url
    context.read<PropertyListingCubit>().initPropertyListing(
          placesSearch: placesSearch,
          keywords: keywords,
          furnishedType: furnishedType,
          planType: planType,
          propertyTypeId: propertyTypeId,
          maxArea: maxArea,
          minArea: minArea,
          paymentType: paymentType,
          maxPrice: maxPrice,
          minPrice: minPrice,
          sort: sort,
          minBedroom: minBedroom,
          maxBedroom: maxBedroom,
          minBathroom: minBathroom,
          maxBathroom: maxBathroom,
          limit: limit,
          offset: offset,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);

    Widget stack = Stack(
      children: [
        Column(
          children: _toolBarSwitchCondition ? [BannerImage(), SizedBox(height: 40)] : [],
        ),
        Positioned(
          bottom: 0,
          left: Insets.offset,
          right: Insets.offset,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyles.h2.copyWith(color: Colors.white)),
              SizedBox(height: _toolBarSwitchCondition ? 30 : 18),
              if (_toolBarSwitchCondition) ...[PropertyListingTabBar(tabController: _tabController)],
            ],
          ),
        )
      ],
    );

    return Title(
      title: "Explore Properties",
      color: Colors.black,
      child: Visibility(
        visible: Responsive.isMobile(context),

        // when mobile view
        child: SliverScaffold(
          isSearch: false,
          child: TabView(
              key: ValueKey('for-rent'),
              propertyType:
                  context.vRouter.queryParameters['type'] == "c" ? PropertyType.COMMERCIAL : PropertyType.RESIDENTIAL),
          title: title,
          appBarExtension: [
            SliverPersistentHeader(
                delegate: SliverAppBarDelegate(child: AppBarBottom(), minExtent: 54, maxExtent: 54), pinned: true),
          ],
        ),

        //  web and tablet landscape
        replacement: Scaffold(
          appBar: Responsive.isDesktop(context) ? ToolBar() : PropertyFilterAppBar(),
          body: ListView(
            shrinkWrap: true,
            children: [
              stack,
              AnimatedSwitcher(
                  duration: Times.fastest,
                  child: context.vRouter.queryParameters["type"] == "c"
                      ? TabView(key: ValueKey('commericial'), propertyType: PropertyType.COMMERCIAL)
                      : TabView(key: ValueKey('for-rent'), propertyType: PropertyType.RESIDENTIAL))
            ],
          ),
        ),
      ),
    );
  }
}
