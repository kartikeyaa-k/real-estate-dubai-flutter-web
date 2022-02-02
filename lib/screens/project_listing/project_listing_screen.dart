import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/scaffold/sliver_scaffold.dart';
import '../../components/toolbar.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../models/home_page_model/suggest_places_model.dart';
import 'components/app_bar_bottom.dart';
import 'components/banner_image.dart';
import 'components/project_filter_app_bar.dart';
import 'components/project_list.dart';
import 'components/sorting_bar.dart';
import 'constants/project_list_contants.dart';
import 'cubit/project_listing_cubit.dart';

class ProjectListingScreen extends StatelessWidget {
  const ProjectListingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProjectListingView();
  }
}

class ProjectListingView extends StatefulWidget {
  const ProjectListingView({Key? key}) : super(key: key);

  @override
  _ProjectListingViewState createState() => _ProjectListingViewState();
}

class _ProjectListingViewState extends State<ProjectListingView> with TickerProviderStateMixin {
  late ScrollController _scrollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    List searchKeywords = jsonDecode(context.vRouter.queryParameters[kProjSearchKeywordKey] ?? "[]");
    List<PlacesResultModel> placesSearch =
        searchKeywords.map((json) => PlacesResultModel.fromJson(jsonDecode(jsonEncode(json)))).toList();
    final int? minPrice = int.tryParse(context.vRouter.queryParameters[kProjMinPriceKey] ?? "");
    final int? maxPrice = int.tryParse(context.vRouter.queryParameters[kProjMaxPriceKey] ?? "");
    final keywords = context.vRouter.queryParameters[kProjKeywordsKey]?.split(",");
    keywords?.removeWhere((keyword) => keyword.isEmpty);
    final List<int>? amenityIds =
        context.vRouter.queryParameters[kProjAmenities]?.split(",").map((e) => int.parse(e)).toList();
    final int? deliveryYear = int.tryParse(context.vRouter.queryParameters[kProjDeliveryDateKey] ?? "");
    final int? currentPage = int.tryParse(context.vRouter.queryParameters[kProjPageNumberKey] ?? "1");
    final int limit = kProjPerPage;
    final int offset = ((currentPage ?? 1) - 1) * kProjPerPage;
    final String? sort = context.vRouter.queryParameters[kProjSortingKey];

    // load data for the given url
    context.read<ProjectListingCubit>().initProjectListing(
          placesSearch: placesSearch,
          keywords: keywords,
          maxPrice: maxPrice,
          minPrice: minPrice,
          amenityIds: amenityIds,
          deliveryYear: deliveryYear,
          limit: limit,
          offset: offset,
          sort: sort,
        );
  }

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              Text("Explore Projects", style: TextStyles.h2.copyWith(color: Colors.white)),
              SizedBox(height: _toolBarSwitchCondition ? 30 : 18),
              if (_toolBarSwitchCondition) ...[SortingBar()],
            ],
          ),
        )
      ],
    );

    return Title(
      title: "Explore Projects",
      color: Colors.black,
      child: Visibility(
        visible: Responsive.isMobile(context),
        child: SliverScaffold(
          child: ProjectList(),
          title: "Explore Projects",
          appBarExtension: [
            SliverPersistentHeader(
                delegate: SliverAppBarDelegate(child: ProjectAppBarBottom(), minExtent: 54, maxExtent: 54),
                pinned: true),
          ],
        ),
        replacement: Scaffold(
          appBar: Responsive.isDesktop(context) ? ToolBar() : ProjectFilterAppBar(),
          body: ListView(
            shrinkWrap: true,
            children: [
              stack,
              ProjectList(),
            ],
          ),
        ),
      ),
    );
  }
}
