import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/carousel/carousel.dart';
import '../../components/carousel/compact_carousel.dart';
import '../../components/company_banner.dart';
import '../../components/footer.dart';
import '../../components/listing_cards/featured_card.dart';
import '../../components/mobile_app_bar.dart';
import '../../components/toolbar.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import '../../models/agency_model.dart';
import '../../models/amenity_model.dart';
import '../../models/property_details_models/property_location_detail_model.dart';
import '../../models/property_media.dart';
import '../../routes/routes.dart';
import '../property_detail/components/primary_detail.dart';
import '../property_listing/components/app_bar_bottom.dart';
import 'components/floor_plan.dart';
import 'components/payment_plan.dart';
import 'components/primary_detail_card.dart';
import 'components/project_detail_secondary_detail_card.dart';
import 'components/project_detail_tab_bar.dart';
import 'cubit/book_status_cubit.dart';
import 'cubit/project_cubit.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => sl<ProjectDetailCubit>()),
      BlocProvider(create: (context) => BookStatusCubit(bookStatusServices: sl())),
    ], child: ProjectDetailView());
  }
}

class ProjectDetailView extends StatefulWidget {
  ProjectDetailView({
    Key? key,
  }) : super(key: key);

  @override
  _ProjectDetailViewState createState() => _ProjectDetailViewState();
}

class _ProjectDetailViewState extends State<ProjectDetailView> with TickerProviderStateMixin {
  late TabController _tabController;
  late VoidCallback _tabControllerListener;

  final GlobalKey detailsKey = GlobalKey();
  final GlobalKey floorPlanKey = GlobalKey();
  final GlobalKey paymentPlanKey = GlobalKey();
  final GlobalKey availableUnitKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabControllerListener = () {
      if (_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            Scrollable.ensureVisible(detailsKey.currentContext!, duration: Times.slower, alignment: 0.05);
            break;
          case 1:
            Scrollable.ensureVisible(floorPlanKey.currentContext!, duration: Times.slower, alignment: 0.05);
            break;
          case 2:
            Scrollable.ensureVisible(paymentPlanKey.currentContext!, duration: Times.slower, alignment: 0.05);
            break;
          case 3:
            Scrollable.ensureVisible(availableUnitKey.currentContext!, duration: Times.slower, alignment: 0.05);
            break;
          default:
            Scrollable.ensureVisible(detailsKey.currentContext!, duration: Times.slower, alignment: 0.02);
        }
      }
    };

    // FIXME: make it change as per section visibility
    _tabController = TabController(length: 1, vsync: this);
    _tabController.addListener(_tabControllerListener);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get id from url and load data
    // if id is missing redirect to [PropertyListingScreen]
    if (!context.vRouter.queryParameters.keys.contains("id")) {
      context.vRouter.to(ProjectListingScreenPath);
    } else {
      String propertyId = context.vRouter.queryParameters["id"]!;
      context.read<ProjectDetailCubit>().initPropertyPage(propertyId);
      // context.read<BookStatusCubit>().getBookStatus(propertyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    double _offset = Responsive.isDesktop(context) ? Insets.offset : 0;
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
    // carousel

    Widget _carousel({
      required String bannerUrl,
      required String sideImageUrl1,
      required String sideImageUrl2,
      required List<PropertyMedia> urlList,
      required List<PropertyMedia>? videoList,
    }) {
      return Responsive.isDesktop(context)
          ? PrimaryCarousel(
              bannerUrl: bannerUrl,
              sideImageUrl1: sideImageUrl1,
              sideImageUrl2: sideImageUrl2,
              urlList: urlList,
              videoList: videoList)
          : PrimaryCompactCarousel(urlList: urlList, videoList: videoList);
    }

    Widget _vSpace = Responsive.isDesktop(context) ? SizedBox(height: Insets.xxl) : SizedBox(height: Insets.med);

    Widget _secondaryAndSideCard({
      List<AmenityModel>? amenities,
      List<AmenityModel>? features,
      required String? startingPrice,
      required String totalUnits,
      DateTime? deliveryDate,
      required String description,
      LatLng? position,
      required PropertyLocationDetailModel locationDetails,
      required AgencyDetailsModel agencyDetailsModel,
      required int propertyPrice,
    }) {
      Widget projectDetailSecondaryDetailCard = ProjectDetailSecondaryDetailCard(
        globalKey: detailsKey,
        additionalFeatures: features,
        amenities: amenities,
        deliveryDate: deliveryDate,
        startingPrice: startingPrice,
        totalUnits: totalUnits,
        description: description,
        position: position,
        locationDetails: locationDetails,
      );

      Widget companyBanner = CompanyBanner(
          agencyName: agencyDetailsModel.agencyName,
          agentName: agencyDetailsModel.agentName,
          coverImage: agencyDetailsModel.coverImage,
          agentPhone: agencyDetailsModel.agentPhone);

      Widget propertyPriceScheduleBanner = BlocBuilder<BookStatusCubit, BookStatusState>(builder: (context, state) {
        if (state is LBookStatus) {
          return _PropertyDetailLoading();
        }
        // else if (state is FBookStatus) {
        //   return Container(
        //     child: Text('FAILED'),
        //   );
        // }
        else if (state is SBookStatus) {
          // return PropertyPriceScheduleBanner(
          //     propertyPrice: propertyPrice,
          //     propertyId: int.parse(context.vRouter.queryParameters["id"] as String),
          //     bookStatusResponseModel: state.result);
        }
        return Container();
      });

      return Flex(
        direction: Responsive.isDesktop(context) ? Axis.horizontal : Axis.vertical,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Responsive.isDesktop(context)
              ? Expanded(flex: 2, child: projectDetailSecondaryDetailCard)
              : projectDetailSecondaryDetailCard,
          Responsive.isDesktop(context) ? SizedBox(width: Insets.xl) : _vSpace,
          Responsive.isDesktop(context)
              ? Expanded(
                  child: Column(
                  children: [
                    // propertyPriceScheduleBanner,
                    // _vSpace,
                    companyBanner,
                  ],
                ))
              : Column(
                  children: [
                    // propertyPriceScheduleBanner,
                    // _vSpace,
                    companyBanner,
                  ],
                ),
        ],
      );
    }

    Widget _featuredList = Padding(
      padding: Responsive.isDesktop(context) ? EdgeInsets.symmetric(vertical: Insets.xl) : EdgeInsets.all(Insets.lg),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  "Available Units In This Property",
                  style: TextStyles.h2,
                  key: availableUnitKey,
                ),
              ),
              Spacer(),
              if (!Responsive.isMobile(context)) ...[
                InkWell(
                  child: Text(
                    "See All(200)",
                    style: TextStyles.body12.copyWith(color: kSupportBlue),
                  ),
                ),
                SizedBox(width: 20),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_back_ios_sharp, size: 18),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward_ios_sharp, size: 18),
                ),
              ] else
                InkWell(
                  child: Text(
                    "See All(200)",
                    style: TextStyles.body12.copyWith(color: kSupportBlue),
                  ),
                ),
            ],
          ),
          SizedBox(height: Insets.lg),
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsetsDirectional.only(end: Insets.xl),
                child: FeaturedCard(),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: Responsive.isDesktop(context) ? ToolBar() : MobileAppBar(),
      body: SafeArea(
        child: BlocBuilder<ProjectDetailCubit, ProjectDetailState>(
          buildWhen: (previous, current) =>
              previous.projectData != current.projectData ||
              previous.propertyLocationDetail != current.propertyLocationDetail,
          builder: (context, state) {
            Widget _body = CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: _offset),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // PrimaryBreadCrumb(),

                      // _vSpace,
                      _carousel(
                        bannerUrl: state.coverImage,
                        sideImageUrl1: state.sideImageUrl1,
                        sideImageUrl2: state.sideImageUrl2,
                        urlList: state.projectData.projectImages,
                        videoList: state.projectData.projectVideos,
                      ),
                      _vSpace,
                      PrimaryDetailCard(
                          name: state.projectData.projectName.en,
                          address: state.projectData.areaCommunityDetails.communityName.en),
                      _vSpace,
                    ]),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: SliverAppBarDelegate(
                    maxExtent: 62,
                    minExtent: 62,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: _offset),
                      child: ProjectDetailTabBar(
                        tabController: _tabController,
                        showSorting: Responsive.isDesktop(context),
                      ),
                    ),
                  ),
                  pinned: false,
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: _offset),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      ...[
                        _vSpace,
                        _secondaryAndSideCard(
                          amenities: state.projectData.amenities == null
                              ? [] as List<AmenityModel>
                              : state.projectData.amenities,
                          features: state.projectData.features == null
                              ? [] as List<AmenityModel>
                              : state.projectData.features,
                          deliveryDate: state.projectData.deliveryDate,
                          startingPrice:
                              state.projectData.startingPrice != 0 ? state.projectData.startingPrice.toString() : null,
                          totalUnits: state.projectData.totalUnits.toString(),
                          description: state.projectData.projectDescription.en,
                          locationDetails: state.propertyLocationDetail,
                          position: state.projectData.location,
                          agencyDetailsModel: state.projectData.agencyDetails,
                          propertyPrice: state.projectData.pricePerSqFeet ?? 0,
                        ),
                        if (state.projectData.floorPlans != null && state.projectData.floorPlans!.isNotEmpty) ...[
                          _vSpace,
                          FloorPlan(globalKey: floorPlanKey, floorPlans: state.projectData.floorPlans),
                        ],
                        if (state.projectData.projectPlans != null && state.projectData.projectPlans!.isNotEmpty) ...[
                          _vSpace,
                          PaymentPlan(globalKey: paymentPlanKey, projectPlanList: state.projectData.projectPlans),
                        ],

                        _vSpace,
                        // _featuredList
                      ],
                    ]),
                  ),
                ),
                if (Responsive.isDesktop(context)) SliverToBoxAdapter(child: Footer())
              ],
            );

            return Title(
              title: state.projectData.projectName.en,
              color: Colors.black,
              child: Visibility(
                visible: !state.projectDetailStatus.isSubmissionInProgress ||
                    !state.locationDetailStatus.isSubmissionInProgress ||
                    !state.bookStatus.isSubmissionInProgress,
                replacement: _PropertyDetailLoading(),
                child: _body,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_tabControllerListener);
    _tabController.dispose();
    super.dispose();
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
