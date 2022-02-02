import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/buttons/primary_button.dart';
import '../../components/buttons/primary_flat_button.dart';
import '../../components/carousel/carousel.dart';
import '../../components/company_banner.dart';
import '../../components/footer.dart';
import '../../components/input_fields/primary_text_field.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import '../../models/amenity_model.dart';
import '../../models/project_model/project_model.dart';
import '../../models/property_details_models/property_location_detail_model.dart';
import '../../models/property_media.dart';
import '../../models/response_models/cover_page_models/cover_page_model.dart';
import '../../routes/routes.dart';
import 'components/cover_app_bar_mobile.dart';
import 'components/cover_banner_image.dart';
import 'components/cover_toolbar.dart';
import 'components/floor_plan.dart';
// import 'components/maxmized_carousel.dart';
import 'components/payment_plan.dart';
import 'cubit/cover_page_cubit.dart';

class CoverPageScreen extends StatelessWidget {
  const CoverPageScreen({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CoverPageView();
  }
}

class CoverPageView extends StatefulWidget {
  const CoverPageView({Key? key})
      : super(key: key);

  @override
  State<CoverPageView> createState() =>
      _CoverPageViewState();
}

class _CoverPageViewState
    extends State<CoverPageView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>();
  final _cubit = sl<CoverPageCubit>();
  CoverPageModel? coverProjectDetails;
  ProjectModel? otherDetails;
  PropertyLocationDetailModel?
      propertyLocationDetailModel;
  final GlobalKey floorPlanKey = GlobalKey();
  final GlobalKey paymentPlanKey = GlobalKey();
  final GlobalKey gallaryKey = GlobalKey();
  String mainThumbnail = '';
  String smallThumbnail = '';
  List<AmenityModel> amenties = [];
  List<AmenityModel> features = [];
  List<FloorPlanModel> floorPlan = [];
  List<ProjectPlanModel> projectPlanModel = [];
  ScrollController _scrollController =
      ScrollController();
  String projectName = '';
  String address = '';
  String description = '';
  String agencyName = '';
  String agentName = '';
  String agencycoverImage = '';
  String agencyPhone = '';
  List<PropertyMedia> urlList = [];
  List<PropertyMedia> videoList = [];

  @override
  void initState() {
    cubitEvents();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void cubitEvents() {
    _cubit.getCoverPage();
  }

  void _launchURL(String _url) async =>
      await canLaunch(_url)
          ? await launch(_url)
          : throw 'Could not launch $_url';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Function hp =
        ScreenUtils(MediaQuery.of(context)).hp;
    final Function wp =
        ScreenUtils(MediaQuery.of(context)).wp;
    Widget _vSpace = Responsive(
        mobile: SizedBox(height: Insets.med),
        tablet: SizedBox(height: Insets.xl),
        desktop: SizedBox(height: Insets.sm));
    double _offset = Responsive.isDesktop(context)
        ? Insets.offset
        : 0;
    double leftRightPadding = Insets.xxl;
    double topBottomPadding = Insets.xl;
    double mobileLeftRightPadding = Insets.med;
    double mobileTopBottomPadding = Insets.med;
    Widget _lgVSpace =
        Responsive.isMobile(context)
            ? Container(height: Insets.med)
            : SizedBox(height: Insets.xxl);

    List<Widget> _mobileMapView = [
      Text(
        "Location:",
        style: MS.lableBlack,
      ),
      SizedBox(
        height: mobileLeftRightPadding,
      ),
      // map view
      Container(
        width: wp(100),
        child: AspectRatio(
          aspectRatio:
              Responsive.isDesktop(context)
                  ? 1
                  : Responsive.isMobile(context)
                      ? 1
                      : 794 / 250,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(
                        target: otherDetails
                                ?.location ??
                            LatLng(
                                15.3982, 73.8113),
                        zoom: 14),
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
              ),
              Padding(
                padding:
                    const EdgeInsets.all(5.0),
                child: Align(
                    alignment:
                        Alignment.bottomLeft,
                    child: SizedBox(
                      width: 150,
                      child: PrimaryFlatButton(
                        text: Text(
                            "Get Directions"
                                .toUpperCase(),
                            textAlign:
                                TextAlign.center,
                            style: MS.bodyBlack),
                        onTap: () {
                          context.vRouter.toExternal(
                              "https://maps.google.com?q=${otherDetails?.location.latitude ?? 15.3982},${otherDetails?.location.longitude ?? 73.8113}",
                              openNewTab: true);
                        },
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    ];

    Widget _mobileLocationDetails = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: mobileLeftRightPadding,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_hospital_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest Hospital (${propertyLocationDetailModel?.distanceHospital})",
                      style: MS.bodyGray))
            ],
          ),
        ),
        SizedBox(
          height: mobileLeftRightPadding,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_bus_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest Bus Station (${propertyLocationDetailModel?.distanceBusStation})",
                      style: MS.bodyGray))
            ],
          ),
        ),
        SizedBox(
          height: mobileLeftRightPadding,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest School (${propertyLocationDetailModel?.distanceSchool})",
                      style: MS.bodyGray))
            ],
          ),
        ),
        SizedBox(
          height: mobileLeftRightPadding,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flight_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest Airport (${propertyLocationDetailModel?.distanceAirport})",
                      style: MS.bodyGray))
            ],
          ),
        ),
        SizedBox(
          height: mobileLeftRightPadding,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  Icons
                      .directions_transit_filled_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest Train Station (${propertyLocationDetailModel?.distanceTrainStation})",
                      style: MS.bodyGray))
            ],
          ),
        ),
      ],
    );

    Widget _mobilePropertyDetailTitle = Text(
      "Project Detail : ",
      style: MS.lableBlack,
    );

    Widget _mobilePropertyDetailRow(
        {required String title,
        required String value}) {
      return SizedBox(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: Insets.xl),
          child: Row(
            children: [
              Expanded(
                  child: Text(title,
                      style: MS.bodyGray)),
              Expanded(
                child: Text(value,
                    style: MS.bodyGray),
              )
            ],
          ),
        ),
      );
    }

    Widget _mobileAmenitiesRow(
        {required String title,
        String? iconUrl}) {
      return ConstrainedBox(
        constraints: BoxConstraints.expand(
            width: 250, height: 35),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(50),
              ),
              child: Image.network(iconUrl ?? ""),
            ),
            SizedBox(
                width: mobileLeftRightPadding),
            Flexible(
              child: Text(
                title,
                style: MS.bodyGray,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> _mobileDetails = [
      _mobilePropertyDetailRow(
          title: "Price From :",
          value: (otherDetails?.startingPrice ==
                      0 ||
                  otherDetails?.startingPrice ==
                      null)
              ? "TBD"
              : "AED ${otherDetails?.startingPrice}"),
      _mobilePropertyDetailRow(
          title: "Total Units :",
          value: otherDetails?.totalUnits
                  .toString() ??
              ""),
      if (otherDetails?.deliveryDate != null)
        _mobilePropertyDetailRow(
            title: "Delivery Date : ",
            value: DateFormat("yMMM").format(
                otherDetails!.deliveryDate!)),
    ];

    List<Widget> _mobilePropertyDetail = [
      _mobilePropertyDetailTitle,
      SizedBox(
        height: mobileTopBottomPadding,
      ),
      Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                ..._mobileDetails.sublist(0, 2)
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                ..._mobileDetails.sublist(2)
              ],
            ),
          )
        ],
      )
    ];
    List<Widget> _mobileAmenities = [
      amenties.isNotEmpty
          ? Text(
              "Amenities : ",
              style: MS.lableBlack,
            )
          : Container(),
      amenties.isNotEmpty
          ? Wrap(
              children: amenties
                  .map((e) => _mobileAmenitiesRow(
                      title: e.name.en,
                      iconUrl: e.logo))
                  .toList())
          : Container(),
    ];

    List<Widget> _mobileAdditionalFeatures = [
      features.isNotEmpty
          ? Text("Additional features",
              style: MS.lableBlack)
          : Container(),
      features.isNotEmpty ? _vSpace : Container(),
      features.isNotEmpty
          ? Wrap(
              children: features
                  .map((e) => _mobileAmenitiesRow(
                      title: e.name.en))
                  .toList())
          : Container(),
    ];
    Widget _mobileCarousel = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          height: 200,
          padding: EdgeInsets.only(
              left: mobileLeftRightPadding,
              right: mobileLeftRightPadding,
              bottom: mobileTopBottomPadding,
              top: mobileTopBottomPadding),
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                barrierColor: Colors.black,
                barrierDismissible: false,
                useSafeArea: true,
                builder: (_) {
                  return MaximizedImageCarousel(
                      urlList: urlList,
                      carouselType:
                          CarouselType.image);
                },
              );
            },
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Container(
                  height: hp(40),
                  width: wp(100),
                  // padding: EdgeInsets.only(left: mobileLeftRightPadding, right: mobileLeftRightPadding),
                  child: Image.network(
                    mainThumbnail,
                    fit: BoxFit.fitWidth,
                  ),
                )),
              ],
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(
                  right: mobileLeftRightPadding,
                  left: mobileLeftRightPadding,
                  bottom: mobileTopBottomPadding),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  PrimaryFlatButton(
                    icon: Icon(Icons
                        .camera_alt_outlined),
                    text: Text(
                        "Show ${urlList.length} photos"
                            .toUpperCase(),
                        textAlign:
                            TextAlign.center,
                        style: MS.bodyBlack),
                    onTap: () => showDialog(
                      context: context,
                      barrierColor: Colors.black,
                      barrierDismissible: false,
                      useSafeArea: true,
                      builder: (_) {
                        return MaximizedImageCarousel(
                            urlList: urlList,
                            carouselType:
                                CarouselType
                                    .image);
                      },
                    ),
                  ),
                  SizedBox(
                    height:
                        mobileTopBottomPadding,
                  ),
                  PrimaryFlatButton(
                    icon: Icon(
                        Icons.videocam_outlined),
                    text: Text(
                        "Watch video tour"
                            .toUpperCase(),
                        textAlign:
                            TextAlign.center,
                        style: MS.bodyBlack),
                    onTap: () => showDialog(
                      context: context,
                      barrierColor: Colors.black,
                      barrierDismissible: false,
                      useSafeArea: true,
                      builder: (_) {
                        return MaximizedImageCarousel(
                            urlList: videoList,
                            carouselType:
                                CarouselType
                                    .video);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    mobileStackBannerImage() {
      return CoverBannerImage(
        isNetworkImage: true,
        imageLocation:
            coverProjectDetails!.heroImageUrl,
      );
    }

    mobileDescription() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kPlainWhite,
            ),
            padding: EdgeInsets.only(
                top: mobileTopBottomPadding,
                right: mobileLeftRightPadding,
                left: mobileLeftRightPadding,
                bottom: mobileTopBottomPadding),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description : ',
                    textAlign: TextAlign.left,
                    style: MS.lableBlack,
                  ),
                  SizedBox(
                    height: Insets.med,
                  ),
                  Container(
                      child: SingleChildScrollView(
                          child: Text(description,
                              overflow:
                                  TextOverflow
                                      .fade,
                              textAlign:
                                  TextAlign.left,
                              style:
                                  MS.bodyGray))),
                ],
              ),
            ),
          ),
        ],
      );
    }

    mobileCompany() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kPlainWhite,
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: CompanyBanner(
              customPadding:
                  mobileLeftRightPadding,
              // agencyName: agencyName,
              agencyName:
                  "Abu Dhabi United Real Estate Company LLC",
              // agentName: agentName,
              agentName: "Ahmad Kurnful",
              coverImage: agencycoverImage,
              agentPhone: agencyPhone,
            ),
          ),
        ],
      );
    }

    mobileLocation() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kPlainWhite,
            ),
            padding: EdgeInsets.only(
                left: mobileLeftRightPadding,
                top: mobileTopBottomPadding,
                bottom: mobileTopBottomPadding,
                right: mobileLeftRightPadding),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                ..._mobileMapView,
                Container(
                    padding: EdgeInsets.only(
                        left:
                            mobileLeftRightPadding,
                        bottom:
                            mobileTopBottomPadding,
                        right:
                            mobileLeftRightPadding),
                    child: _mobileLocationDetails)
              ],
            ),
          ),
        ],
      );
    }

    mobilePropertyDetails() {
      return otherDetails != null
          ? Container(
              decoration: BoxDecoration(
                color: kPlainWhite,
              ),
              width: wp(100),
              padding: EdgeInsets.only(
                  left: mobileLeftRightPadding,
                  top: mobileTopBottomPadding,
                  bottom: mobileTopBottomPadding,
                  right: mobileLeftRightPadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    ..._mobilePropertyDetail,
                    _lgVSpace,
                    ..._mobileAmenities,
                    _lgVSpace,
                    ..._mobileAdditionalFeatures
                  ],
                ),
              ))
          : Container();
    }

    mobileGallary() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: kBlackVariant,
            ),
            child: _mobileCarousel,
          )
        ],
      );
    }

//* MOBILE WIDGETS ABOVE *//

    stackBannerImage() {
      final bool _toolBarSwitchCondition =
          !Responsive.isMobile(context);
      return Stack(
        alignment: Alignment.center,
        children: [
          Column(children: [
            _toolBarSwitchCondition
                ? CoverBannerImage(
                    isNetworkImage: true,
                    imageLocation:
                        coverProjectDetails!
                            .heroImageUrl,
                  )
                : CoverBannerImage(
                    isNetworkImage: true,
                    imageLocation:
                        coverProjectDetails!
                            .heroImageUrl,
                  )
          ]),
          // Align(
          //   alignment: Alignment.center,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Text(
          //         projectName,
          //         style: TS.headerWhite,
          //         textAlign: TextAlign.center,
          //       ),
          //       SizedBox(height: Insets.med),
          //       Text(coverProjectDetails!.heroText!.en, style: TS.miniHeaderWhite),
          //       SizedBox(height: Insets.xxl),
          //       // SizedBox(
          //       //   width: wp(50),
          //       //   child: Text(coverProjectDetails!.descriptionText!.en,
          //       //       maxLines: 3,
          //       //       overflow: TextOverflow.fade,
          //       //       textAlign: TextAlign.center,
          //       //       style: TextStyles.body14.copyWith(color: Colors.white)),
          //       // ),

          //       coverProjectDetails?.brochureUrl == null || coverProjectDetails?.brochureUrl == ''
          //           ? Container()
          //           : PrimaryButton(
          //               onTap: () {
          //                 print('#log : brochure : ${coverProjectDetails?.brochureUrl} ');
          //                 _launchURL(coverProjectDetails?.brochureUrl ?? "");
          //               },
          //               text: "Download Brochure",
          //               fontSize: 14,
          //               backgroundColor: Colors.transparent,
          //               color: kPlainWhite,
          //               isBorder: true,
          //               onHoverColor: Colors.transparent,
          //             ),
          //       // Container(
          //       //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.white)),
          //       //     padding: EdgeInsets.all(10),
          //       //     child: Text(
          //       //       'Download Brochure',
          //       //       style: TextStyles.h2.copyWith(fontSize: 12, color: kPlainWhite),
          //       //     ))
          //     ],
          //   ),
          // ),
        ],
      );
    }

    List<Widget> _mapView = [
      Text(
        "Location:",
        style: TextStyles.h2
            .copyWith(color: kBlackVariant),
      ),
      _vSpace,
      _vSpace,
      // map view
      Container(
        height: 400,
        width: wp(60),
        child: AspectRatio(
          aspectRatio:
              Responsive.isDesktop(context)
                  ? 1
                  : 794 / 250,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(
                        target: otherDetails
                                ?.location ??
                            LatLng(
                                15.3982, 73.8113),
                        zoom: 14),
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                markers: {
                  Marker(
                    markerId:
                        MarkerId("my-marker"),
                    position:
                        LatLng(15.3982, 73.8113),
                  )
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: PrimaryButton(
                    onTap: () {
                      context.vRouter.toExternal(
                          "https://maps.google.com?q=${otherDetails?.location.latitude ?? 15.3982},${otherDetails?.location.longitude ?? 73.8113}",
                          openNewTab: true);
                    },
                    text: "Get Directions"
                        .toUpperCase(),
                    width: 140,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    Widget _locationDetails = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "",
          style: TextStyles.h2
              .copyWith(color: kBlackVariant),
        ),
        _vSpace,
        _vSpace,
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_hospital_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest Hospital (${propertyLocationDetailModel?.distanceHospital})",
                      style: TS.bodyGray))
            ],
          ),
        ),
        SizedBox(
          height: leftRightPadding,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_bus_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest Bus Station (${propertyLocationDetailModel?.distanceBusStation})",
                      style: TS.bodyGray))
            ],
          ),
        ),
        SizedBox(
          height: leftRightPadding,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest School (${propertyLocationDetailModel?.distanceSchool})",
                      style: TS.bodyGray))
            ],
          ),
        ),
        SizedBox(
          height: leftRightPadding,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.flight_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest Airport (${propertyLocationDetailModel?.distanceAirport})",
                      style: TS.bodyGray))
            ],
          ),
        ),
        SizedBox(
          height: leftRightPadding,
        ),
        SizedBox(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                  Icons
                      .directions_transit_filled_outlined,
                  color: kSupportBlue),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                      "Closest Train Station (${propertyLocationDetailModel?.distanceTrainStation})",
                      style: TS.bodyGray))
            ],
          ),
        ),
      ],
    );
    Widget _firstHorizontalView = Container(
      height: 220,
      padding: EdgeInsets.only(
          left: leftRightPadding,
          right: leftRightPadding),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.start,
        children: [
          // Description
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: kPlainWhite,
                borderRadius:
                    BorderRadius.circular(8),
              ),
              padding: EdgeInsets.only(
                  top: topBottomPadding,
                  right: leftRightPadding,
                  left: leftRightPadding,
                  bottom: topBottomPadding),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Description : ',
                      textAlign: TextAlign.left,
                      style: TS.lableBlack,
                    ),
                    SizedBox(
                      height: Insets.med,
                    ),
                    Container(
                        height: 150,
                        child: SingleChildScrollView(
                            child: Text(
                                description,
                                overflow:
                                    TextOverflow
                                        .fade,
                                textAlign:
                                    TextAlign
                                        .left,
                                style: TS
                                    .bodyGray))),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: leftRightPadding,
          ),
          Container(
            width: wp(30),
            decoration: BoxDecoration(
              color: kPlainWhite,
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: CompanyBanner(
              customPadding: leftRightPadding,
              // agencyName: agencyName,
              agencyName:
                  "Abu Dhabi United Real Estate Company LLC",
              // agentName: agentName,
              agentName: "Ahmad Kurnful",
              coverImage: agencycoverImage,
              agentPhone: agencyPhone,
            ),
          )
        ],
      ),
    );
    Widget _locationView = Container(
      decoration: BoxDecoration(
        color: kPlainWhite,
      ),
      padding: EdgeInsets.only(
          left: leftRightPadding,
          top: topBottomPadding,
          bottom: leftRightPadding,
          right: leftRightPadding),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [..._mapView],
          ),
          Container(
              padding: EdgeInsets.only(
                  left: leftRightPadding,
                  bottom: leftRightPadding,
                  right: leftRightPadding),
              child: _locationDetails)
        ],
      ),
    );
    Widget _propertyDetailTitle = Text(
      "Project Detail : ",
      style: TS.lableBlack,
    );

    Widget _propertyDetailRow(
        {required String title,
        required String value}) {
      return SizedBox(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: Insets.xl),
          child: Row(
            children: [
              Expanded(
                  child: Text(title,
                      style: TS.bodyGray)),
              Expanded(
                child: Text(value,
                    style: TS.bodyGray),
              )
            ],
          ),
        ),
      );
    }

    Widget _amenitiesRow(
        {required String title,
        String? iconUrl}) {
      return ConstrainedBox(
        constraints: BoxConstraints.expand(
            width: 250, height: 35),
        child: Row(
          children: [
            Container(
              height: 24,
              width: 24,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(50),
              ),
              child: Image.network(iconUrl ?? ""),
            ),
            SizedBox(width: Insets.lg),
            Flexible(
              child: Text(
                title,
                style: TS.bodyGray,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    List<Widget> _details = [
      _propertyDetailRow(
          title: "Price From :",
          value: (otherDetails?.startingPrice ==
                      0 ||
                  otherDetails?.startingPrice ==
                      null)
              ? "TBD"
              : "AED ${otherDetails?.startingPrice}"),
      _propertyDetailRow(
          title: "Total Units :",
          value: otherDetails?.totalUnits
                  .toString() ??
              ""),
      if (otherDetails?.deliveryDate != null)
        _propertyDetailRow(
            title: "Delivery Date : ",
            value: DateFormat("yMMM").format(
                otherDetails!.deliveryDate!)),
    ];
    List<Widget> _propertyDetail = [
      _propertyDetailTitle,
      _vSpace,
      _vSpace,
      Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                ..._details.sublist(0, 2)
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [..._details.sublist(2)],
            ),
          )
        ],
      )
    ];
    List<Widget> _amenities = [
      amenties.isNotEmpty
          ? Text(
              "Amenities : ",
              style: TS.lableBlack,
            )
          : Container(),
      amenties.isNotEmpty ? _vSpace : Container(),
      amenties.isNotEmpty
          ? Wrap(
              children: amenties
                  .map((e) => _amenitiesRow(
                      title: e.name.en,
                      iconUrl: e.logo))
                  .toList())
          : Container(),
    ];
    // additional features
    List<Widget> _additionalFeatures = [
      features.isNotEmpty
          ? Text("Additional features",
              style: TS.miniHeaderBlack)
          : Container(),
      features.isNotEmpty ? _vSpace : Container(),
      features.isNotEmpty
          ? Wrap(
              children: features
                  .map((e) => _amenitiesRow(
                      title: e.name.en))
                  .toList())
          : Container(),
    ];
    Widget _carousel = Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
                left: leftRightPadding,
                right: leftRightPadding,
                bottom: leftRightPadding,
                top: leftRightPadding),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black,
                  barrierDismissible: false,
                  useSafeArea: true,
                  builder: (_) {
                    return MaximizedImageCarousel(
                        urlList: urlList,
                        carouselType:
                            CarouselType.image);
                  },
                );
              },
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Expanded(
                      flex: 6,
                      child: SizedBox(
                        height: hp(40),
                        child: Image.network(
                          mainThumbnail,
                          fit: BoxFit.fitHeight,
                        ),
                      )),
                  SizedBox(
                      width: leftRightPadding),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: hp(40),
                      child: Image.network(
                        smallThumbnail,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
              right: leftRightPadding,
              left: leftRightPadding,
              bottom: leftRightPadding),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              PrimaryFlatButton(
                icon: Icon(
                    Icons.camera_alt_outlined),
                text: Text(
                    "Show ${urlList.length} photos"
                        .toUpperCase(),
                    style: TS.bodyBlack),
                onTap: () => showDialog(
                  context: context,
                  barrierColor: Colors.black,
                  barrierDismissible: false,
                  useSafeArea: true,
                  builder: (_) {
                    return MaximizedImageCarousel(
                        urlList: urlList,
                        carouselType:
                            CarouselType.image);
                  },
                ),
              ),
              SizedBox(
                width: Insets.xl,
              ),
              // PrimaryFlatButton(
              //   icon: Icon(Icons.videocam_outlined),
              //   text: Text("View 360 tour", style: TextStyles.body16),
              //   onTap: () => showDialog(
              //     context: context,
              //     barrierColor: Colors.black,
              //     barrierDismissible: false,
              //     useSafeArea: true,
              //     builder: (_) {
              //       return MaximizedImageCarousel(urlList: urlList, carouselType: CarouselType.video);
              //     },
              //   ),
              // ),
              PrimaryFlatButton(
                icon:
                    Icon(Icons.videocam_outlined),
                text: Text(
                    "Watch video tour"
                        .toUpperCase(),
                    style: TS.bodyBlack),
                onTap: () => showDialog(
                  context: context,
                  barrierColor: Colors.black,
                  barrierDismissible: false,
                  useSafeArea: true,
                  builder: (_) {
                    return MaximizedImageCarousel(
                        urlList: videoList,
                        carouselType:
                            CarouselType.video);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );

    Widget _secondHorizontalView = Container(
      key: gallaryKey,
      margin: EdgeInsets.only(
          left: leftRightPadding,
          right: leftRightPadding),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          otherDetails != null
              ? Container(
                  decoration: BoxDecoration(
                    color: kPlainWhite,
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  width: wp(50),
                  padding: EdgeInsets.only(
                      left: leftRightPadding,
                      top: topBottomPadding,
                      bottom: topBottomPadding,
                      right: leftRightPadding),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                      children: [
                        ..._propertyDetail,
                        _lgVSpace,
                        ..._amenities,
                        _lgVSpace,
                        ..._additionalFeatures
                      ],
                    ),
                  ))
              : Container(),
          Expanded(
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: kBlackVariant,
                borderRadius:
                    BorderRadius.circular(8),
              ),
              child: _carousel,
            ),
          ),
        ],
      ),
    );

//* REGISTER INTEREST WIIDGETS
//* NEED TO MOVE THEM
    Widget _header = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Registration Form",
            textAlign: TextAlign.left,
            style: TextStyles.h2),
      ],
    );
    Widget _body = Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 4,
                child: _FieldLayout(
                  caption: "First Name",
                  child: PrimaryTextField(
                    text: '',
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 4,
                child: _FieldLayout(
                  caption: "Last Name",
                  child: PrimaryTextField(
                    text: '',
                  ),
                ),
              ),
            ]),
        SizedBox(
          height: Insets.med,
        ),
        Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 4,
                child: _FieldLayout(
                  caption: "Email",
                  child: PrimaryTextField(
                    text: '',
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 4,
                child: _FieldLayout(
                  caption: "Phone Number",
                  child: PrimaryTextField(
                    text: '',
                  ),
                ),
              ),
            ]),
      ],
    );
    Widget _btns = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrimaryButton(
          onTap: () {
            context.vRouter.to(CoverPath);
          },
          text: "Cancel",
          backgroundColor: kBackgroundColor,
          color: kSupportBlue,
          height: 45,
          width: 110,
          fontSize: 12,
        ),
        SizedBox(
          width: Insets.med,
        ),
        PrimaryButton(
          onTap: () {
            context.vRouter.to(CoverPath);
          },
          text: "Submit",
          height: 45,
          width: 110,
          fontSize: 12,
        )
      ],
    );

    return BlocProvider(
      create: (_) => _cubit,
      child: Responsive.isMobile(context)
          ? SafeArea(
              child: Scaffold(
                  key: _scaffoldKey,
                  appBar: mobileAppBar(context),
                  body: BlocListener<
                          CoverPageCubit,
                          CoverPageState>(
                      bloc: _cubit,
                      listener: (_, state) {
                        if (state is LCoverPage) {
                        } else if (state
                            is FCoverPage) {
                          context.vRouter
                              .to(HomePath);
                        } else if (state
                            is SCoverPage) {
                          if (state.otherDetails
                              .isEmpty) {
                            context.vRouter
                                .to(HomePath);
                          } else {
                            String firstImage =
                                '';
                            String secondImage =
                                '';
                            state.otherDetails
                                .projectImages
                                .forEach(
                                    (element) {
                              if (element
                                  .isCover) {
                                firstImage =
                                    element.link;
                              } else {
                                secondImage =
                                    element.link;
                              }
                            });
                            setState(() {
                              coverProjectDetails =
                                  state
                                      .coverProjectDetails;
                              otherDetails = state
                                  .otherDetails;
                              mainThumbnail =
                                  firstImage;
                              smallThumbnail =
                                  secondImage;
                              if (state
                                      .otherDetails
                                      .amenities ==
                                  null) {
                              } else {
                                amenties.addAll(state
                                    .otherDetails
                                    .amenities!);
                              }
                              if (state
                                      .otherDetails
                                      .features ==
                                  null) {
                                features.addAll(state
                                    .otherDetails
                                    .features!);
                              }

                              if (state
                                      .otherDetails
                                      .floorPlans ==
                                  null) {
                              } else {
                                floorPlan.addAll(state
                                    .otherDetails
                                    .floorPlans!);
                              }
                              if (state
                                      .otherDetails
                                      .projectPlans !=
                                  null) {
                                projectPlanModel
                                    .addAll(state
                                        .otherDetails
                                        .projectPlans!);
                              }
                              String type = '';
                              if (state.otherDetails
                                          .projectType !=
                                      null &&
                                  state
                                          .otherDetails
                                          .projectType!
                                          .name !=
                                      null) {
                                type = ' | ' +
                                    state
                                        .otherDetails
                                        .projectType!
                                        .name!
                                        .en;
                              }
                              projectName = state
                                      .otherDetails
                                      .projectName
                                      .en +
                                  type;
                              if (state
                                      .otherDetails
                                      .address !=
                                  null) {
                                address = state
                                    .otherDetails
                                    .address!
                                    .en;
                              }

                              description = state
                                  .otherDetails
                                  .projectDescription
                                  .en;
                              agencyName = state
                                  .otherDetails
                                  .agencyDetails
                                  .agencyName;
                              agentName = state
                                  .otherDetails
                                  .agencyDetails
                                  .agentName;
                              agencyPhone = state
                                  .otherDetails
                                  .agencyDetails
                                  .agentPhone;

                              agencycoverImage =
                                  state
                                      .otherDetails
                                      .agencyDetails
                                      .coverImage;

                              urlList.addAll(state
                                  .otherDetails
                                  .projectImages);
                              videoList.addAll(state
                                      .otherDetails
                                      .projectVideos ??
                                  []);
                              if (state
                                      .otherDetails
                                      .projectVideos !=
                                  null) {
                                urlList.addAll(state
                                    .otherDetails
                                    .projectVideos!);
                              }
                            });

                            _cubit.getLocationDetails(
                                state.otherDetails
                                    .location);
                          }
                        } else if (state
                            is LLocationDetail) {
                        } else if (state
                            is FLocationDetail) {
                          context.vRouter
                              .to(HomePath);
                        } else if (state
                            is SLocationDetail) {
                          setState(() {
                            propertyLocationDetailModel =
                                state
                                    .propertyLocationDetailModel;
                          });
                        }
                      },
                      child: Container(
                          constraints:
                              BoxConstraints(
                            maxHeight:
                                MediaQuery.of(
                                        context)
                                    .size
                                    .height,
                            maxWidth:
                                MediaQuery.of(
                                        context)
                                    .size
                                    .width,
                          ),
                          color: kBackgroundColor,
                          child:
                              SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                coverProjectDetails == null ||
                                        otherDetails ==
                                            null ||
                                        propertyLocationDetailModel ==
                                            null
                                    ? SizedBox(
                                        height: MediaQuery.of(
                                                context)
                                            .size
                                            .height,
                                        child: Center(
                                            child: SpinKitThreeBounce(
                                                color:
                                                    kSupportBlue)))
                                    : ListView(
                                        controller:
                                            _scrollController,
                                        shrinkWrap:
                                            true,
                                        children: [
                                            mobileStackBannerImage(),
                                            SizedBox(
                                                height: mobileTopBottomPadding),
                                            mobileDescription(),
                                            SizedBox(
                                                height: mobileTopBottomPadding),
                                            mobileCompany(),
                                            SizedBox(
                                                height: mobileTopBottomPadding),
                                            mobileLocation(),
                                            SizedBox(
                                                height: mobileTopBottomPadding),
                                            mobilePropertyDetails(),
                                            SizedBox(
                                                height: mobileTopBottomPadding),
                                            mobileGallary(),
                                            SizedBox(
                                                height: mobileTopBottomPadding),
                                            floorPlan.isNotEmpty
                                                ? Container(child: FloorPlan(customPadding: mobileTopBottomPadding, globalKey: floorPlanKey, floorPlans: floorPlan))
                                                : Container(),
                                            projectPlanModel.isNotEmpty
                                                ? Container(child: PaymentPlan(customPadding: leftRightPadding, globalKey: paymentPlanKey, projectPlanList: projectPlanModel))
                                                : Container(),
                                            SizedBox(
                                                height: mobileTopBottomPadding),
                                          ])
                              ]))))))
          : Scaffold(
              backgroundColor: kBackgroundColor,
              appBar: CoverToolBar(
                isFloorPlan: floorPlan.isNotEmpty,
                isPaymentPlan:
                    projectPlanModel.isNotEmpty,
                onOverview: () {
                  _scrollController.animateTo(
                      hp(0.3),
                      duration: Duration(
                          milliseconds: 190),
                      curve: Curves.slowMiddle);
                },
                onGallery: () {
                  _scrollController.animateTo(
                      floorPlan.isEmpty
                          ? 1000
                          : hp(175),
                      duration: Duration(
                          milliseconds: 190),
                      curve: Curves.slowMiddle);
                },
                onFloorPlan: () {
                  _scrollController.animateTo(
                      hp(230),
                      duration: Duration(
                          milliseconds: 190),
                      curve: Curves.slowMiddle);
                },
                onPaymentPlan: () {
                  _scrollController.animateTo(
                      _scrollController.position
                          .maxScrollExtent,
                      duration: Duration(
                          milliseconds: 190),
                      curve: Curves.slowMiddle);
                },
                onLocation: () {
                  _scrollController.animateTo(500,
                      duration: Duration(
                          milliseconds: 190),
                      curve: Curves.slowMiddle);
                },
              ),
              body: BlocListener<CoverPageCubit,
                  CoverPageState>(
                bloc: _cubit,
                listener: (_, state) {
                  if (state is LCoverPage) {
                  } else if (state
                      is FCoverPage) {
                    context.vRouter.to(HomePath);
                  } else if (state
                      is SCoverPage) {
                    if (state
                        .otherDetails.isEmpty) {
                      context.vRouter
                          .to(HomePath);
                    } else {
                      String firstImage = '';
                      String secondImage = '';
                      state.otherDetails
                          .projectImages
                          .forEach((element) {
                        if (element.isCover) {
                          firstImage =
                              element.link;
                        } else {
                          secondImage =
                              element.link;
                        }
                      });
                      setState(() {
                        coverProjectDetails = state
                            .coverProjectDetails;
                        otherDetails =
                            state.otherDetails;
                        mainThumbnail =
                            firstImage;
                        smallThumbnail =
                            secondImage;
                        if (state.otherDetails
                                .amenities ==
                            null) {
                        } else {
                          amenties.addAll(state
                              .otherDetails
                              .amenities!);
                        }
                        if (state.otherDetails
                                .features ==
                            null) {
                          features.addAll(state
                              .otherDetails
                              .features!);
                        }

                        if (state.otherDetails
                                .floorPlans ==
                            null) {
                        } else {
                          floorPlan.addAll(state
                              .otherDetails
                              .floorPlans!);
                        }
                        if (state.otherDetails
                                .projectPlans !=
                            null) {
                          projectPlanModel.addAll(
                              state.otherDetails
                                  .projectPlans!);
                        }
                        String type = '';
                        if (state.otherDetails
                                    .projectType !=
                                null &&
                            state
                                    .otherDetails
                                    .projectType!
                                    .name !=
                                null) {
                          type = ' | ' +
                              state
                                  .otherDetails
                                  .projectType!
                                  .name!
                                  .en;
                        }
                        projectName = state
                                .otherDetails
                                .projectName
                                .en +
                            type;
                        if (state.otherDetails
                                .address !=
                            null) {
                          address = state
                              .otherDetails
                              .address!
                              .en;
                        }

                        description = state
                            .otherDetails
                            .projectDescription
                            .en;
                        agencyName = state
                            .otherDetails
                            .agencyDetails
                            .agencyName;
                        agentName = state
                            .otherDetails
                            .agencyDetails
                            .agentName;
                        agencyPhone = state
                            .otherDetails
                            .agencyDetails
                            .agentPhone;

                        agencycoverImage = state
                            .otherDetails
                            .agencyDetails
                            .coverImage;

                        urlList.addAll(state
                            .otherDetails
                            .projectImages);
                        videoList.addAll(state
                                .otherDetails
                                .projectVideos ??
                            []);
                        if (state.otherDetails
                                .projectVideos !=
                            null) {
                          urlList.addAll(state
                              .otherDetails
                              .projectVideos!);
                        }
                      });

                      _cubit.getLocationDetails(
                          state.otherDetails
                              .location);
                    }
                  } else if (state
                      is LLocationDetail) {
                  } else if (state
                      is FLocationDetail) {
                    context.vRouter.to(HomePath);
                  } else if (state
                      is SLocationDetail) {
                    setState(() {
                      propertyLocationDetailModel =
                          state
                              .propertyLocationDetailModel;
                    });
                  }
                },
                child: coverProjectDetails ==
                            null ||
                        otherDetails == null ||
                        propertyLocationDetailModel ==
                            null
                    ? Column(
                        children: [
                          SizedBox(
                              height: hp(60.4),
                              child: Center(
                                  child: SpinKitThreeBounce(
                                      color:
                                          kSupportBlue))),
                          SizedBox(
                            height: Insets.offset,
                          ),
                        ],
                      )
                    : Container(
                        height: double.infinity,
                        child:
                            SingleChildScrollView(
                          child: ListView(
                            controller:
                                _scrollController,
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(),
                            children: [
                              stackBannerImage(),
                              SizedBox(
                                  height:
                                      leftRightPadding),
                              _firstHorizontalView,
                              SizedBox(
                                  height:
                                      leftRightPadding),
                              _locationView,
                              SizedBox(
                                  height:
                                      leftRightPadding),
                              _secondHorizontalView,
                              SizedBox(
                                  height:
                                      leftRightPadding),
                              floorPlan.isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          left:
                                              leftRightPadding,
                                          right:
                                              leftRightPadding),
                                      child: FloorPlan(
                                          customPadding:
                                              leftRightPadding,
                                          globalKey:
                                              floorPlanKey,
                                          floorPlans:
                                              floorPlan))
                                  : Container(),

                              SizedBox(
                                  height:
                                      leftRightPadding),
                              projectPlanModel
                                      .isNotEmpty
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          left:
                                              leftRightPadding,
                                          right:
                                              leftRightPadding),
                                      child: PaymentPlan(
                                          customPadding:
                                              leftRightPadding,
                                          globalKey:
                                              paymentPlanKey,
                                          projectPlanList:
                                              projectPlanModel))
                                  : Container(),
                              SizedBox(
                                  height:
                                      leftRightPadding),
                              // _vSpace,
                              if (Responsive
                                  .isDesktop(
                                      context))
                                Footer(),
                            ],
                          ),
                        ),
                      ),
              ),
              floatingActionButton:
                  FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                      context: context,
                      useSafeArea: false,
                      barrierLabel: "asd",
                      barrierDismissible: true,
                      builder:
                          (BuildContext context) {
                        return StatefulBuilder(
                            builder: (context,
                                setState) {
                          return Scaffold(
                            backgroundColor:
                                Colors.black
                                    .withOpacity(
                                        0.7),
                            body: Center(
                              child: Container(
                                color:
                                    kPlainWhite,
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min,
                                  children: [
                                    SizedBox(
                                      width:
                                          wp(50),
                                      child:
                                          Stack(
                                        children: [
                                          Container(
                                            alignment:
                                                Alignment.center,
                                            padding:
                                                EdgeInsets.all(Insets.xl),
                                            child:
                                                Column(
                                              children: [
                                                Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    _header,
                                                    SizedBox(
                                                      height: Insets.med,
                                                    ),
                                                    _body
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: Insets.xl,
                                                ),
                                                _btns,
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(8.0),
                                            child:
                                                Align(
                                              alignment:
                                                  Alignment.topRight,
                                              child: GestureDetector(
                                                  onTap: () {
                                                    context.vRouter.to(CoverPath);
                                                  },
                                                  child: Icon(Icons.close, size: 20)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      });
                },
                icon: null,
                heroTag: "Interested?",
                label: Text(
                    'Register your interest'
                        .toUpperCase()),
              ),
            ),
    );
  }
}

class _FieldLayout extends StatelessWidget {
  const _FieldLayout({
    Key? key,
    required String caption,
    required Widget child,
  })  : _caption = caption,
        _child = child,
        super(key: key);

  final String _caption;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(_caption,
            style: TextStyles.body12.copyWith(
                color: Color(0xFF99C9E7))),
        SizedBox(height: 4),
        _child
      ],
    );
  }
}
