import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_portal/components/buttons/custom_icon_button.dart';
import 'package:real_estate_portal/screens/property_detail/cubit/verification_hack_cubit.dart';
import 'package:real_estate_portal/screens/services/cubit/service_cubit.dart';
import '../../components/mobile_app_bar.dart';
import 'constants/property_detail_constants.dart';
import '../service_providers/cubit/service_provider_cubit.dart';
import '../services/cubit/service_main_cubit.dart';
import '../../services/book_status_services/book_status_services.dart';
import '../../services/service_provider_service/service_provider_services.dart';
import '../../services/services_main_services/services_main_service.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/carousel/carousel.dart';
import '../../components/carousel/compact_carousel.dart';
import '../../components/toolbar.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import '../../routes/routes.dart';
import '../project_detail/cubit/book_status_cubit.dart';
import '../property_listing/components/app_bar_bottom.dart';
import 'components/custom_bottom_sheet.dart';
import 'components/primary_detail.dart';
import 'components/property_tab.dart';
import 'components/reviews.dart';
import 'components/secondary_detail_card.dart';
import 'components/service_tab.dart';
import 'components/side_cards.dart';
import 'cubit/property_cubit.dart';

/// ## Components Used
/// - [PrimaryCarousel] - tablet landscape, webview
/// - [PrimaryCompactCarousel] - mobile, tablet portrait
/// - [CustomBottomSheet] - mobile, tablet portrait
/// - [PropertyDetailPrimaryDetailCard] - all view
/// - [PropertyTab] - all view
/// - [PropertyDetailReviews] - all view
/// - [PropertyDetailSecondaryDetailCard] - all view
/// - [ServiceTab] - all view
/// - [PropertyCostCard] - all view
///
/// ## Component References
/// - [PrimaryCarousel] => [PropertyDetailScreen]
/// - [PrimaryCompactCarousel] => [PropertyDetailScreen]
/// - [CustomBottomSheet] => NA
/// - [PropertyDetailPrimaryDetailCard] => [PropertyTab]
/// - [PropertyTab] => [PropertyDetailScreen]
/// - [PropertyDetailReviews] => [PropertyTab]
/// - [PropertyDetailSecondaryDetailCard] => [PropertyTab]
/// - [ServiceTab] => [PropertyDetailScreen]
/// - [PropertyCostCard] => [PropertyTab]
///
class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({Key? key}) : super(key: key);

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late BookStatusCubit bookStatusCubit;

  @override
  void initState() {
    super.initState();
    bookStatusCubit = BookStatusCubit(bookStatusServices: sl<BookStatusServices>());
  }

  @override
  void dispose() {
    bookStatusCubit.close();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bookStatusCubit.getBookStatus(context.vRouter.queryParameters['id'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(create: (context) => PropertyDetailCubit(sl())),
        BlocProvider(create: (context) => bookStatusCubit),
        BlocProvider(create: (context) => ServiceCubit(myServicesService: sl(), servicesMainService: sl())),
        BlocProvider(create: (context) => VerificationHackCubit(sl())),
      ],
      child: Builder(builder: (context) {
        return BlocBuilder<BookStatusCubit, BookStatusState>(
          builder: (context, state) {
            if (state is LBookStatus) return _PropertyDetailLoading();

            bool showService = false;
            if (state is SBookStatus) showService = state.result.status?.trim() == "BOOKED";

            return PropertyDetailView(showService: showService);
          },
        );
      }),
    );
  }
}

class PropertyDetailView extends StatefulWidget {
  const PropertyDetailView({Key? key, required this.showService}) : super(key: key);
  final bool showService;

  @override
  _PropertyDetailViewState createState() => _PropertyDetailViewState();
}

class _PropertyDetailViewState extends State<PropertyDetailView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Widget> _tabList;

  @override
  void initState() {
    super.initState();
    if (widget.showService) {
      _tabController = TabController(length: 2, vsync: this);
      _tabList = ["Property", "Services"].map((e) => _tabViewChild(e)).toList();
    } else {
      _tabController = TabController(length: 1, vsync: this);
      _tabList = ["Property"].map((e) => _tabViewChild(e)).toList();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get id from url and load data
    // if id is missing redirect to [PropertyListingScreen]

    _tabController.index = context.vRouter.queryParameters[kPDselectedTabKey] == kPDServiceTabValue ? 1 : 0;

    // if data is already loaded avoid reloading the data
    if (context.read<PropertyDetailCubit>().state.propertyDetailStatus.isSubmissionSuccess) return;

    if (!context.vRouter.queryParameters.keys.contains("id")) {
      context.vRouter.to(PropertyListingScreenPath);
    } else {
      String propertyId = context.vRouter.queryParameters["id"]!;
      context.read<PropertyDetailCubit>().initPropertyPage(propertyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    var throttler = Throttler(throttleGapInMillis: 1000);
    double _offset = Responsive.isDesktop(context) ? Insets.offset : 0;
    Widget _vSpace = Responsive.isDesktop(context) ? SizedBox(height: Insets.xxl) : SizedBox(height: Insets.med);

    return BlocBuilder<PropertyDetailCubit, PropertyDetailState>(
      buildWhen: (previous, current) => previous.propertyDetailStatus != current.propertyDetailStatus,
      builder: (context, state) {
        // check if loading is completed [state.locationDetailStatus]
        print('#log :other plans =========>${state.propertyData.propertyRentOrBuyPlans.length} ');
        Widget _body = CustomScrollView(
          shrinkWrap: true,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: _offset),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // breadcrumbs
                  // if (Responsive.isDesktop(context)) PrimaryBreadCrumb(keepPadding: false),
                  if (!Responsive.isMobile(context)) _vSpace,

                  // carousel handled for both mobile and web
                  BlocBuilder<PropertyDetailCubit, PropertyDetailState>(
                    buildWhen: (previous, current) =>
                        previous.propertyData.propertyImages != current.propertyData.propertyImages,
                    builder: (context, state) {
                      return Responsive.isDesktop(context)
                          ? PrimaryCarousel(
                              urlList: state.propertyData.propertyImages,
                              bannerUrl: state.coverImage,
                              sideImageUrl1: state.sideImageUrl1,
                              sideImageUrl2: state.sideImageUrl2,
                              videoList: state.propertyData.propertyVideos,
                            )
                          : PrimaryCompactCarousel(
                              urlList: state.propertyData.propertyImages,
                              videoList: state.propertyData.propertyVideos,
                              additionalWidget: [
                                SizedBox(height: 8),
                                BlocBuilder<PropertyDetailCubit, PropertyDetailState>(
                                  builder: (context, state) {
                                    return CustomIconButton(
                                      backgroundColor: state.isBookmarked ? kSupportBlue : Colors.white,
                                      child: Icon(
                                        Icons.bookmark_outline_outlined,
                                        color: state.isBookmarked ? Colors.white : kSupportBlue,
                                      ),
                                      borderRadius: Corners.smBorder,
                                      onTap: () {
                                        if (FirebaseAuth.instance.currentUser == null) {
                                          context.vRouter.to(
                                            LoginPath,
                                            queryParameters: {"redirect": "${context.vRouter.url}"},
                                          );
                                        }

                                        throttler.run(() {
                                          context.read<PropertyDetailCubit>().bookmarkProperty();
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            );
                    },
                  ),
                  _vSpace,
                ]),
              ),
            ),

            // sticky toolbar showing services and property and tab view
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: _offset),
              sliver: SliverPersistentHeader(
                delegate: SliverAppBarDelegate(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: Insets.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            Responsive.isDesktop(context) ? BorderRadius.vertical(top: Corners.lgRadius) : null,
                      ),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicatorColor: kSupportBlue,
                        labelColor: Colors.black,
                        unselectedLabelColor: kBlackVariant,
                        labelStyle: TextStyles.h4.copyWith(color: kBlackVariant),
                        indicatorWeight: 4,
                        tabs: _tabList,
                        onTap: (index) {
                          Map<String, String> queryParameters = {...context.vRouter.queryParameters};
                          String selectedTabValue = index == 0 ? kPDPropertyTabValue : kPDServiceTabValue;
                          if (queryParameters.containsKey(kPDselectedTabKey)) {
                            queryParameters.update(kPDselectedTabKey, (value) => selectedTabValue);
                          } else {
                            queryParameters[kPDselectedTabKey] = selectedTabValue;
                          }
                          context.vRouter
                              .to(context.vRouter.path, isReplacement: true, queryParameters: queryParameters);
                        },
                      ),
                    ),
                    minExtent: 62,
                    maxExtent: 62),
                // pinned: true,
              ),
            ),

            SliverToBoxAdapter(
              // animated switcher is used for reacting to tab bar in future
              child: AnimatedSwitcher(
                duration: Times.fastest,
                child: context.vRouter.queryParameters[kPDselectedTabKey] == kPDServiceTabValue
                    ? ServiceTab()
                    : PropertyTab(
                        propertyRentOrBuyPlans: state.propertyData.propertyRentOrBuyPlans,
                        id: state.propertyData.propertyDetails.id,
                        properyPrice: state.propertyData.propertyDetails.propertySellingPrice,
                      ),
              ),
            )
          ],
        );

        return Title(
          title: state.propertyData.propertyDetails.propertyName.en,
          color: Colors.black,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              appBar: Responsive.isMobile(context) ? MobileAppBar() : ToolBar(),
              body: Visibility(
                visible: !state.propertyDetailStatus.isSubmissionInProgress,
                replacement: _PropertyDetailLoading(),
                child: _body,
              ),
            ),
          ),
        );
      },
    );
  }

  SizedBox _tabViewChild(String e) {
    return SizedBox(
      child: Row(
        children: [
          Center(
            child: Text(e),
          ),
        ],
      ),
      height: 80,
    );
  }
}

// skeleton laoding
class _PropertyDetailLoading extends StatelessWidget {
  const _PropertyDetailLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Responsive.isMobile(context)
        ? Padding(
            padding: const EdgeInsets.all(16),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(width: double.infinity, height: 300, color: Colors.white),
                  SizedBox(height: 10),
                  CarouselSkeleton(),
                  SizedBox(height: 30),
                  PropertyDetailPrimaryDetailCardSkeleton(),
                  SizedBox(height: 30),
                  Container(height: 200, width: double.infinity, color: Colors.white)
                ],
              ),
            ),
          )
        : Padding(
            padding: EdgeInsets.all(Insets.offset),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(width: double.infinity, height: 64, color: Colors.white),
                  SizedBox(height: 10),
                  CarouselSkeleton(),
                  SizedBox(height: 30),
                  PropertyDetailPrimaryDetailCardSkeleton(),
                  SizedBox(height: 30),
                  Container(height: 200, width: double.infinity, color: Colors.white)
                ],
              ),
            ),
          );
  }
}
