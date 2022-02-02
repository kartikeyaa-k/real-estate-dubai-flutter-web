import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/listing_cards/featured_card.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/components/scaffold/primary_scaffold.dart';
import 'package:real_estate_portal/components/scaffold/sliver_scaffold.dart';
import 'package:real_estate_portal/components/snack_bar/custom_snack_bar.dart';
import 'package:real_estate_portal/components/toolbar.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/models/response_models/community_guideline_response_models/popular_building_location_response_model.dart';
import 'package:real_estate_portal/screens/agency/components/location.dart';

import 'package:real_estate_portal/screens/community_detail/components/popular_building_card.dart';
import 'package:real_estate_portal/screens/community_detail/components/primary_detail_card.dart';
import 'package:real_estate_portal/screens/community_detail/components/secondary_detail_card.dart';
import 'package:real_estate_portal/screens/company_guidlines/cubit/community_cubit.dart';
import 'package:real_estate_portal/screens/service_providers/components/property_filter_app_bar.dart';
import 'package:real_estate_portal/screens/services/components/banner_image.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../injection_container.dart';
import 'cubit/community_building_cubit.dart';
import 'cubit/feautred_property_cubit.dart';
import 'cubit/popular_building_location_cubit.dart';

class CommunityDetailScreen extends StatefulWidget {
  CommunityDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen> {
  final _cubit = sl<CommunityCubit>();
  final _cubitBuilding = sl<CommunityBuildingCubit>();
  final _cubitProperty = sl<FeaturedPropertyCubit>();
  final _cubitLocationCubit = sl<PopularBuildingLocationCubit>();
  ScrollController _scrollController = ScrollController();
  ScrollController _pageScrollController = ScrollController();
  int scrollPoint = 0;
  int singleBuildingCardWidth = 350;
  int maxScrollTimes = 0;
  int limit = 10;
  int offset = 0;
  int totalPaging = 0;
  late LatLng position;

  List<Marker> list = [];

  Set<Marker> _markers = {};
  List<Locations> listLocation = [];

  @override
  void initState() {
    _markers.addAll(list);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Set<Marker> createMarker() {
    return <Marker>{
      Marker(
          onDragEnd: ((newPosition) async {}),
          draggable: false,
          markerId: const MarkerId(''),
          position: position,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'Car Location')),
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    int? community_id = context.vRouter.queryParameters['community_id'] == null
        ? null
        : int.parse(context.vRouter.queryParameters['community_id']!);

    if (community_id != null) {
      _cubit.getCommunityDetails(community_id: community_id);
      _cubitBuilding.getCommunityBuildings(community_id: community_id, limit: limit, offset: offset);
      // _cubitProperty.getFeaturedProperty(community_id: community_id);
      _cubitLocationCubit.getPopularBuildingLocation(community_id: community_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    double _offset = Responsive.isDesktop(context) ? Insets.offset : 0;
    Widget _vSpace = Responsive.isDesktop(context) ? SizedBox(height: Insets.xxl) : SizedBox(height: Insets.med);
    Widget _carousel(String image) {
      print('#loog image bbanne: $image');
      return Responsive.isDesktop(context)
          ? BannerImage(
              imageLocation: image,
            )
          : BannerImage(imageLocation: image);
    }

    Widget _popularBuilding() {
      return BlocBuilder<CommunityBuildingCubit, CommunityBuildingState>(
          bloc: _cubitBuilding,
          builder: (_, state) {
            if (state is LCommunityBuildings) {
              return Center(child: SpinKitThreeBounce(color: kSupportBlue));
            } else if (state is FCommunityBuildings) {
              SnackBar snackBar = CustomSnackBar.errorSnackBar(state.failure.errorMessage.isEmpty
                  ? state.failure.errorMessage
                  : "Unexpected failure occured at login. Please try again after sometime.");
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
              return Center(
                child: Column(
                  children: [
                    Text(
                        state.failure.errorMessage.isEmpty
                            ? state.failure.errorMessage
                            : "Unexpected failure occured at login. Please try again after sometime.",
                        style: TextStyles.h4),
                    SizedBox(height: Insets.med),
                  ],
                ),
              );
            } else if (state is SCommunityBuildings) {
              return Container(
                padding: EdgeInsets.all(Insets.xl),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Popular Buildings",
                          style: Responsive.isDesktop(context) ? TextStyles.h2 : MS.lableBlack,
                        ),
                        Spacer(),
                        if (Responsive.isDesktop(context)) ...[
                          IconButton(
                            onPressed: () {
                              setState(() {
                                scrollPoint -= 350;
                              });
                              _scrollController.animateTo(scrollPoint.toDouble(),
                                  duration: Duration(milliseconds: 500), curve: Curves.linear);
                            },
                            icon: Icon(Icons.keyboard_arrow_left_outlined),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                scrollPoint += 350;
                              });
                              _scrollController.animateTo(scrollPoint.toDouble(),
                                  duration: Duration(milliseconds: 500), curve: Curves.linear);
                            },
                            icon: Icon(Icons.keyboard_arrow_right_outlined),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: Insets.lg),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.result.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsetsDirectional.only(end: Insets.xl),
                          child: PopularBuildingCard(
                              onTap: () {
                                listLocation.forEach((element) {
                                  if (element.buildingName == state.result[index].buildingName) {
                                    context.vRouter.toExternal(
                                        "https://maps.google.com?q=${element.latlng.split(',').first},${element.latlng.split(',').last}",
                                        openNewTab: true);
                                  }
                                });
                              },
                              image: state.result[index].image,
                              text: state.result[index].buildingName,
                              averageRating: state.result[index].averageRating,
                              totalReviewCount: state.result[index].totalReviewCount),
                        ),
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          });
    }

    Widget _mapView(double lat, double lon) {
      return AspectRatio(
        aspectRatio: Responsive.isDesktop(context) ? 1126 / 604 : 1,
        child: BlocListener<PopularBuildingLocationCubit, PopularBuildingLocationState>(
            bloc: _cubitLocationCubit,
            listener: (_, state) {
              if (state is LPopularBuildingLocations) {
              } else if (state is FPopularBuildingLocations) {
              } else if (state is SPopularBuildingLocations) {
                List<Marker> list = [];

                if (state.result!.locations!.isEmpty) {
                } else {
                  setState(() {
                    listLocation.addAll(state.result!.locations!);
                  });

                  state.result!.locations!.forEach((e) {
                    list.add(Marker(
                      markerId: MarkerId(e.buildingName),
                      position: LatLng(
                        double.parse(e.latlng.split(',').first),
                        double.parse(e.latlng.split(',').last),
                      ),
                      infoWindow: InfoWindow(title: 'Business 2'),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                    ));
                  });
                }
                setState(() {
                  _markers.addAll(list);
                });
              }
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(target: LatLng(25.2048, 55.2708), zoom: 14),
                  myLocationButtonEnabled: false,
                  myLocationEnabled: true,
                  markers: _markers,
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: PrimaryButton(
                      onTap: () {
                        //_pageScrollController.animateTo(1000, duration: Duration(milliseconds: 300), curve: Curves.linear);
                        context.vRouter.toExternal("https://maps.google.com?q=${lat},${lon}", openNewTab: true);
                      },
                      text: "Get Directions".toUpperCase(),
                      width: 140,
                    ),
                  ),
                ),
              ],
            )),
      );
    }

    Widget _featuredList() {
      return BlocBuilder<FeaturedPropertyCubit, FeaturedPropertyState>(
        bloc: _cubitProperty,
        builder: (_, state) {
          if (state is LFeaturedProperties) {
            return Center(child: SpinKitThreeBounce(color: kSupportBlue));
          } else if (state is FFeaturedProperties) {
            return Center(
              child: Column(
                children: [
                  Text(
                      state.failure.errorMessage.isEmpty
                          ? state.failure.errorMessage
                          : "Unexpected failure occured at login. Please try again after sometime.",
                      style: TextStyles.h4),
                  SizedBox(height: Insets.med),
                ],
              ),
            );
          } else if (state is SFeaturedProperties) {
            return Padding(
              padding: Responsive.isDesktop(context) ? EdgeInsets.symmetric(vertical: Insets.xl) : EdgeInsets.all(Insets.lg),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Featured Properties",
                        style: TextStyles.h2,
                      ),
                      Spacer(),
                      if (Responsive.isDesktop(context)) ...[
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
                      ],
                    ],
                  ),
                  SizedBox(height: Insets.lg),
                  Container(
                    height: 400,
                    child: ListView.builder(
                      itemCount: state.propertyListingListModel.result.list.length,
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
          }
          return Container();
        },
      );
    }

//*** Mobile Widget *****************************************//
    Widget mobileStack = Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            BannerImage(
              imageLocation: 'assets/service/services-banner.jpg',
            )
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Service Providers", style: TS.headerWhite),
              _vSpace,
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Offer Services to Property Owners With Ease',
                  textAlign: TextAlign.center,
                  style: TS.bodyWhite,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        )
      ],
    );

    return Responsive.isMobile(context)
        ? SafeArea(
            child: BlocBuilder<CommunityCubit, CommunityState>(
            bloc: _cubit,
            builder: (_, state) {
              if (state is LCommunityDetails) {
                return SliverScaffold(
                    title: 'Community Details',
                    imageLocation: "",
                    isSearch: false,
                    child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        color: kBackgroundColor,
                        child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [Center(child: SpinKitThreeBounce(color: kSupportBlue))]))));
              } else if (state is FCommunityDetails) {
                return SliverScaffold(
                    title: 'Community Details',
                    imageLocation: "",
                    isSearch: false,
                    child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        color: kBackgroundColor,
                        child: SingleChildScrollView(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Center(
                            child: Column(
                              children: [
                                Text(
                                    state.failure.errorMessage.isEmpty
                                        ? state.failure.errorMessage
                                        : "Unexpected failure occured at login. Please try again after sometime.",
                                    style: TextStyles.h4),
                                SizedBox(height: Insets.med),
                              ],
                            ),
                          )
                        ]))));
              } else if (state is SCommunityDetails) {
                return SliverScaffold(
                    title: 'Community Details',
                    imageLocation: state.result.image,
                    isSearch: false,
                    child: Container(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height,
                          maxWidth: MediaQuery.of(context).size.width,
                        ),
                        color: kBackgroundColor,
                        child: SingleChildScrollView(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          PrimaryDetailCard(
                            text: state.result.communityName,
                            emirate: state.result.emirateName,
                            reviewModel: state.result.reviewData,
                          ),
                          mobileVerticalSizedBox,
                          SecondaryDetailCard(
                            description: state.result.description,
                          ),
                          mobileVerticalSizedBox,
                          _popularBuilding(),
                          mobileVerticalSizedBox,
                          Container(
                            padding: EdgeInsets.all(Insets.xl),
                            color: Colors.white,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Popular Buildings",
                                  style: !Responsive.isMobile(context) ? TextStyles.h2 : MS.lableBlack,
                                ),
                                SizedBox(height: Insets.lg),
                                _mapView(state.result.latitude, state.result.longitude)
                              ],
                            ),
                          ),
                          mobileVerticalSizedBox,
                        ]))));
              }

              return Container();
            },
          ))
        : PrimaryScaffold(
            appBar: Responsive.isDesktop(context) ? ToolBar() : PropertyFilterAppBar(),
            bodyPadding: EdgeInsets.symmetric(horizontal: _offset),
            children: [
                BlocBuilder<CommunityCubit, CommunityState>(
                  bloc: _cubit,
                  builder: (_, state) {
                    if (state is LCommunityDetails) {
                      return Center(child: SpinKitThreeBounce(color: kSupportBlue));
                    } else if (state is FCommunityDetails) {
                      return Center(
                        child: Column(
                          children: [
                            Text(
                                state.failure.errorMessage.isEmpty
                                    ? state.failure.errorMessage
                                    : "Unexpected failure occured at login. Please try again after sometime.",
                                style: TextStyles.h4),
                            SizedBox(height: Insets.med),
                          ],
                        ),
                      );
                    } else if (state is SCommunityDetails) {
                      return Container(
                        child: Center(
                          child: SingleChildScrollView(
                            controller: _pageScrollController,
                            child: Column(
                              children: [
                                _carousel(state.result.image),
                                _vSpace,
                                PrimaryDetailCard(
                                  text: state.result.communityName,
                                  emirate: state.result.emirateName,
                                  reviewModel: state.result.reviewData,
                                ),
                                _vSpace,
                                SecondaryDetailCard(
                                  description: state.result.description,
                                ),
                                _vSpace,
                                _popularBuilding(),
                                _vSpace,

                                // Map View
                                Container(
                                  padding: EdgeInsets.all(Insets.xl),
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Popular Buildings",
                                        style: TextStyles.h2,
                                      ),
                                      SizedBox(height: Insets.lg),
                                      _mapView(state.result.latitude, state.result.longitude)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    return Container();
                  },
                ),
              ]);
    // return Scaffold(
    //   backgroundColor: kBackgroundColor,
    //   appBar: Responsive.isDesktop(context) ? ToolBar() : null,
    //   body: ConstrainedBox(
    //     constraints: BoxConstraints(maxWidth: 1920),
    //     child: SingleChildScrollView(
    //       child: Padding(
    //         padding: EdgeInsets.symmetric(horizontal: _offset),
    //         child: Column(
    //           children: [
    //             _carousel,
    //             _vSpace,
    //             PrimaryDetailCard(),
    //             _vSpace,
    //             SecondaryDetailCard(),
    //             _vSpace,
    //             _popularBuilding,
    //             _vSpace,

    //             // Map View
    //             Container(
    //               padding: EdgeInsets.all(Insets.xl),
    //               color: Colors.white,
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [Text("Popular Buildings", style: TextStyles.h2), SizedBox(height: Insets.lg), _mapView],
    //               ),
    //             ),

    //             // Featured list
    //             _featuredList,
    //             if (Responsive.isDesktop(context)) Footer()
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
