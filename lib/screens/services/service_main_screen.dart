import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hovering/hovering.dart';
import 'package:real_estate_portal/components/bottom_navbar.dart';
import 'package:real_estate_portal/components/dialogs/redirect_confirmation.dart';
import 'package:real_estate_portal/components/mobile_app_bar.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/components/scaffold/sliver_scaffold.dart';
import 'package:real_estate_portal/components/skeleton_image_loader.dart';
import 'package:real_estate_portal/models/response_models/services_main_response_models/get_services_main_response_model.dart';
import 'package:real_estate_portal/screens/cover_page/components/cover_app_bar_mobile.dart';
import 'package:real_estate_portal/screens/service_providers/service_provider_screen.dart';
import 'package:real_estate_portal/screens/service_providers/service_registration_screen.dart';
import 'package:real_estate_portal/screens/services/models/interested_in_model.dart';
import 'package:real_estate_portal/screens/services/models/property_type_model.dart';
import 'package:real_estate_portal/screens/services/services_show_more_screen.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/buttons/primary_button.dart';
import '../../components/footer.dart';
import '../../components/toolbar.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import '../../routes/routes.dart';
import 'components/banner_image.dart';
import 'components/benefits_grid_model.dart';
import 'components/enquire_dialog.dart';
import 'components/mobile_body.dart';
import 'components/property_filter_app_bar.dart';
import 'cubit/service_main_cubit.dart';
import 'models/select_services_model.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final searchKeywords = jsonDecode(context.vRouter.queryParameters['searchKeywordList'] ?? "");
    // searchKeywords?.removeWhere((keyword) => keyword.isEmpty);

    return ServicesView();
  }
}

class ServicesView extends StatefulWidget {
  const ServicesView({Key? key})
      : super(key: key);

  @override
  _ServicesViewState createState() =>
      _ServicesViewState();
}

class _ServicesViewState
    extends State<ServicesView>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  String demoString =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Eu dui arcu nisl nunc bibendum in.Venenatis, sit lobortis ";

  String bannerImage = "";
  List<ServiceMainModel> serviceList = [];
  bool isServicesLoading = true;

  List<BenefitsModel> gridItemList = [];
  final _cubit = sl<ServiceMainCubit>();

  //* Dropdown Values for enquire box
  List<DropdownMenuItem<InterestedInModel>>
      interestedIn = [];
  List<DropdownMenuItem<PropertyTypeModel>>
      propertyType = [];
  List<DropdownMenuItem<SelectServicesModel>>
      selectServiceType = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(
        "----------------------------------- Depencdency changes ------------------------------------");

    // load data for the given url
  }

  @override
  void initState() {
    super.initState();
    _cubit.getFacilityMngServices();

    setupEnuireNowDropdownValues();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  setupEnuireNowDropdownValues() {
    interestedIn.addAll([
      DropdownMenuItem(
          value: InterestedInModel(
              name:
                  'Maintenance Contract Packages',
              type: 1),
          child: Text(
            'Maintenance Contract Packages',
          )),
      DropdownMenuItem(
          value: InterestedInModel(
              name:
                  'Integrated Facility Management Service',
              type: 2),
          child: Text(
            'Integrated Facility Management Service',
          )),
      DropdownMenuItem(
          value: InterestedInModel(
              name:
                  'Individual Maintenance Service',
              type: 3),
          child: Text(
            'Individual Maintenance Service',
          ))
    ]);

    propertyType.addAll([
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Apartment', type: 1),
          child: Text(
            'Apartment',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Villa', type: 1),
          child: Text(
            'Villa',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Townhouse', type: 1),
          child: Text(
            'Townhouse',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Penthouse', type: 1),
          child: Text(
            'Penthouse',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Full Floor Service',
              type: 2),
          child: Text(
            'Full Floor Service',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Full Building Services',
              type: 2),
          child: Text(
            'Full Building Services',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name:
                  'Community Management Service',
              type: 2),
          child: Text(
            'Community Management Service',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Apartment', type: 3),
          child: Text(
            'Apartment',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Villa', type: 3),
          child: Text(
            'Villa',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Townhouse', type: 3),
          child: Text(
            'Townhouse',
          )),
      DropdownMenuItem(
          value: PropertyTypeModel(
              name: 'Penthouse', type: 3),
          child: Text(
            'Penthouse',
          )),
    ]);

    selectServiceType.addAll([
      DropdownMenuItem(
          value: SelectServicesModel(
              name: 'Bronze', type: 1),
          child: Text(
            'Bronze',
          )),
      DropdownMenuItem(
          value: SelectServicesModel(
              name: 'Silver', type: 1),
          child: Text(
            'Silver',
          )),
      DropdownMenuItem(
          value: SelectServicesModel(
              name: 'Gold', type: 1),
          child: Text(
            'Gold',
          )),
      DropdownMenuItem(
          value: SelectServicesModel(
              name: 'Platinum', type: 1),
          child: Text(
            'Platinum',
          )),
      DropdownMenuItem(
          value: SelectServicesModel(
              name:
                  'Integrated Facility Management',
              type: 2),
          child: Text(
            'Integrated Facility Management',
          )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final Function wp =
        ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp =
        ScreenUtils(MediaQuery.of(context)).hp;
    final bool _toolBarSwitchCondition =
        !Responsive.isMobile(context);

    final _vMinSpace = SizedBox(
      height: Insets.sm,
    );
    final _vSpace = SizedBox(
      height: Insets.xl,
    );
    final _vExtraSpace = SizedBox(
      height: Insets.oldOffset,
    );
    final _hSpace = SizedBox(
      width: Insets.xl,
    );
    final _hPadding = Insets.oldOffset;
    final _hSmallPadding = Insets.xl;
    final _vPadding = Insets.xl;

    Widget stack() {
      return Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: _toolBarSwitchCondition
                ? [
                    BannerImage(
                      imageLocation:
                          'assets/services_new/service-banner.png',
                    )
                  ]
                : [],
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                    "Integrated Turn-key Facility Management Solutions",
                    style: TS.headerWhite),
                _vSpace,
                SizedBox(
                  width: wp(40),
                  child: Text(
                    'Our turn-key Facility Management solutions are brought to you by qualified professionals whom are well experienced in delivering such services. By using our services you will recieve a high level of services which are aligned to international best practices; where we strive to meet your expectations provided at competitive rates.',
                    textAlign: TextAlign.center,
                    style: TS.bodyWhite,
                    maxLines: 3,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        ],
      );
    }

    Widget bannerOverImageLeftBody = Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _vExtraSpace,
        Text(
          'Integrated Turn-key Facility Management Solutions ',
          style: TS.miniHeaderBlack,
        ),
        _vExtraSpace,
        Text(
          "Our turn-key Facility Management solutions are brought to you by qualified professionals whom are well experienced in delivering such services. By using our services you will recieve a high level of services which are aligned to international best practices; where we strive to meet your expectations provided at competitive rates. ",
          textAlign: TextAlign.start,
          style: TS.bodyBlack,
        ),
        _vSpace,
        PrimaryButton(
          onTap: () {
            if (FirebaseAuth
                    .instance.currentUser ==
                null) {
              redirectConfimationDialog(
                  context: context,
                  onLogin: () {
                    context.vRouter.to(LoginPath,
                        queryParameters: {
                          "redirect":
                              ServiceMainScreenPath,
                        });
                  },
                  onSignUp: () {
                    context.vRouter.to(SignupPath,
                        queryParameters: {
                          "redirect":
                              ServiceMainScreenPath,
                        });
                  });
            } else {
              serviceEnquiryDialog(
                  context: context,
                  type: 2,
                  interestedIn: interestedIn,
                  propertyType: propertyType,
                  selectServiceType:
                      selectServiceType,
                  onCancel: () {
                    Navigator.pop(context);
                  },
                  onSubmit: (requestParams) {
                    //bloc call to add enquiry
                    _cubit.submitEnquiry(
                        requestParams:
                            requestParams);
                  });
            }
          },
          backgroundColor: kSupportBlue,
          color: kPlainWhite,
          text: 'Register',
        ),
        _vExtraSpace,
      ],
    );

    Widget bannerContentRightStack = Stack(
      alignment: Alignment.center,
      children: [
        Container(
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.end,
            children: [
              Container(
                  width: wp(75),
                  height: hp(67.2),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft:
                          Radius.circular(8),
                    ),
                    child: Image.asset(
                      'assets/services_new/service-stack.png',
                      fit: BoxFit.fitWidth,
                    ),
                  )),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: Insets.oldOffset),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.start,
            crossAxisAlignment:
                CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8.0),
                ),
                child: Container(
                  height: 340,
                  width: wp(40),
                  decoration: BoxDecoration(
                      color: kPlainWhite,
                      borderRadius:
                          Corners.lgBorder),
                  padding: EdgeInsets.only(
                    left: _hPadding,
                    right: _hPadding,
                  ),
                  child: bannerOverImageLeftBody,
                ),
              )
            ],
          ),
        ),
      ],
    );

    Widget pricingPlans = Container(
      height: 600,
      padding: EdgeInsets.only(
        bottom: Insets.xxl,
      ),
      decoration: BoxDecoration(
        color: kBlackVariant,
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              left: Insets.oldOffset,
              right: Insets.oldOffset,
              top: Insets.xl,
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Online Maintenance Contract Package',
                  style: TS.miniHeaderWhite,
                ),
                Text(
                  'No contracts. No surprise fees.',
                  style: TS.bodyWhite,
                ),
              ],
            ),
          ),
          SizedBox(
            height: Insets.xl,
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.only(
                  left: Insets.oldOffset * 2,
                  right: Insets.oldOffset * 2,
                ),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: Insets.xl,
                            left:
                                Insets.oldOffset),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              '',
                              style: TS
                                  .miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets
                                  .oldOffset,
                            ),
                            Text(
                              'Air Conditioning Maintenance & Servicing',
                              style: TS
                                  .miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Electrical Systems Maintenance & Servicing',
                              style: TS
                                  .miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Plumbing System Maintenance & Servicing',
                              style: TS
                                  .miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Pest Control Service',
                              style: TS
                                  .miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Handyman Services',
                              style: TS
                                  .miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Emergency Call-outs',
                              style: TS
                                  .miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            Text(
                              'Value of Materials Provided per year',
                              style: TS
                                  .miniestHeaderWhite,
                            ),
                            SizedBox(
                              height: Insets.xl,
                            ),
                            SizedBox(
                              height: Insets
                                  .oldOffset,
                            ),
                            Text(
                              ' ',
                              style: TS
                                  .miniestHeaderWhite,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          HoverAnimatedContainer(
                        // hoverColor: kSupportBlue,
                        hoverDecoration:
                            BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            8),
                                color:
                                    kSupportBlue),
                        child: Container(
                          padding:
                              EdgeInsets.only(
                                  top: Insets.xl),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
                            children: [
                              Text('Bronze',
                                  style: TS
                                      .miniestHeaderWhite),
                              SizedBox(
                                height: Insets
                                    .oldOffset,
                              ),
                              Text(
                                '2',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '2',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '2',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '1',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '2',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                'Unlimited',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '-',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              SizedBox(
                                height: Insets
                                    .oldOffset,
                              ),
                              PrimaryButton(
                                onTap: () {
                                  if (FirebaseAuth
                                          .instance
                                          .currentUser ==
                                      null) {
                                    redirectConfimationDialog(
                                        context:
                                            context,
                                        onLogin:
                                            () {
                                          context.vRouter.to(
                                              LoginPath,
                                              queryParameters: {
                                                "redirect": ServiceMainScreenPath,
                                              });
                                        },
                                        onSignUp:
                                            () {
                                          context.vRouter.to(
                                              SignupPath,
                                              queryParameters: {
                                                "redirect": ServiceMainScreenPath,
                                              });
                                        });
                                  } else {
                                    serviceEnquiryDialog(
                                        context:
                                            context,
                                        type: 1,
                                        interestedIn:
                                            interestedIn,
                                        propertyType:
                                            propertyType,
                                        selectServiceType:
                                            selectServiceType,
                                        selectedService:
                                            'Bronze',
                                        onCancel:
                                            () {
                                          Navigator.pop(
                                              context);
                                        },
                                        onSubmit:
                                            (requestParams) {
                                          //bloc call to add enquiry
                                          _cubit.submitEnquiry(
                                              requestParams:
                                                  requestParams);
                                        });
                                  }
                                },
                                backgroundColor:
                                    kPlainWhite,
                                color:
                                    kSupportBlue,
                                onHoverColor:
                                    kPlainWhite,
                                text: 'Register',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          HoverAnimatedContainer(
                        // hoverColor: kSupportBlue,
                        hoverDecoration:
                            BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            8),
                                color:
                                    kSupportBlue),
                        child: Container(
                          padding:
                              EdgeInsets.only(
                                  top: Insets.xl),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
                            children: [
                              Text('Silver',
                                  style: TS
                                      .miniestHeaderWhite),
                              SizedBox(
                                height: Insets
                                    .oldOffset,
                              ),
                              Text(
                                '3',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '3',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '3',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '2',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '4',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                'Unlimited',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '500 AED',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              SizedBox(
                                height: Insets
                                    .oldOffset,
                              ),
                              PrimaryButton(
                                onTap: () {
                                  if (FirebaseAuth
                                          .instance
                                          .currentUser ==
                                      null) {
                                    redirectConfimationDialog(
                                        context:
                                            context,
                                        onLogin:
                                            () {
                                          context.vRouter.to(
                                              LoginPath,
                                              queryParameters: {
                                                "redirect": ServiceMainScreenPath,
                                              });
                                        },
                                        onSignUp:
                                            () {
                                          context.vRouter.to(
                                              SignupPath,
                                              queryParameters: {
                                                "redirect": ServiceMainScreenPath,
                                              });
                                        });
                                  } else {
                                    serviceEnquiryDialog(
                                        context:
                                            context,
                                        type: 1,
                                        selectedService:
                                            'Silver',
                                        interestedIn:
                                            interestedIn,
                                        propertyType:
                                            propertyType,
                                        selectServiceType:
                                            selectServiceType,
                                        onCancel:
                                            () {
                                          Navigator.pop(
                                              context);
                                        },
                                        onSubmit:
                                            (requestParams) {
                                          //bloc call to add enquiry
                                          _cubit.submitEnquiry(
                                              requestParams:
                                                  requestParams);
                                        });
                                  }
                                },
                                backgroundColor:
                                    kPlainWhite,
                                color:
                                    kSupportBlue,
                                onHoverColor:
                                    kPlainWhite,
                                text: 'Register',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child:
                          HoverAnimatedContainer(
                        // hoverColor: kSupportBlue,
                        hoverDecoration:
                            BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            8),
                                color:
                                    kSupportBlue),
                        child: Container(
                          padding:
                              EdgeInsets.only(
                                  top: Insets.xl),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
                            children: [
                              Text('Gold',
                                  style: TS
                                      .miniestHeaderWhite),
                              SizedBox(
                                height: Insets
                                    .oldOffset,
                              ),
                              Text(
                                '4',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '4',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '4',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '3',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '6',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                'Unlimited',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '750 AED',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              SizedBox(
                                height: Insets
                                    .oldOffset,
                              ),
                              PrimaryButton(
                                onTap: () {
                                  if (FirebaseAuth
                                          .instance
                                          .currentUser ==
                                      null) {
                                    redirectConfimationDialog(
                                        context:
                                            context,
                                        onLogin:
                                            () {
                                          context.vRouter.to(
                                              LoginPath,
                                              queryParameters: {
                                                "redirect": ServiceMainScreenPath,
                                              });
                                        },
                                        onSignUp:
                                            () {
                                          context.vRouter.to(
                                              SignupPath,
                                              queryParameters: {
                                                "redirect": ServiceMainScreenPath,
                                              });
                                        });
                                  } else {
                                    serviceEnquiryDialog(
                                        context:
                                            context,
                                        type: 1,
                                        selectedService:
                                            'Gold',
                                        interestedIn:
                                            interestedIn,
                                        propertyType:
                                            propertyType,
                                        selectServiceType:
                                            selectServiceType,
                                        onCancel:
                                            () {
                                          Navigator.pop(
                                              context);
                                        },
                                        onSubmit:
                                            (requestParams) {
                                          //bloc call to add enquiry
                                          _cubit.submitEnquiry(
                                              requestParams:
                                                  requestParams);
                                        });
                                  }
                                },
                                backgroundColor:
                                    kPlainWhite,
                                color:
                                    kSupportBlue,
                                onHoverColor:
                                    kPlainWhite,
                                text: 'Register',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child:
                          HoverAnimatedContainer(
                        // hoverColor: kSupportBlue,
                        hoverDecoration:
                            BoxDecoration(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                            8),
                                color:
                                    kSupportBlue),
                        child: Container(
                          padding:
                              EdgeInsets.only(
                                  top: Insets.xl),
                          child: Column(
                            mainAxisAlignment:
                                MainAxisAlignment
                                    .start,
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .center,
                            children: [
                              Text('Platinum',
                                  style: TS
                                      .miniestHeaderWhite),
                              SizedBox(
                                height: Insets
                                    .oldOffset,
                              ),
                              Text(
                                '5',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '5',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '5',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '4',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '8',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                'Unlimited',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              Text(
                                '1000 AED',
                                style: TS
                                    .bodyWhite
                                    .copyWith(
                                  fontSize:
                                      FontSizes
                                          .s18,
                                ),
                              ),
                              SizedBox(
                                height:
                                    Insets.xl - 2,
                              ),
                              SizedBox(
                                height: Insets
                                    .oldOffset,
                              ),
                              PrimaryButton(
                                onTap: () {
                                  if (FirebaseAuth
                                          .instance
                                          .currentUser ==
                                      null) {
                                    redirectConfimationDialog(
                                        context:
                                            context,
                                        onLogin:
                                            () {
                                          context.vRouter.to(
                                              LoginPath,
                                              queryParameters: {
                                                "redirect": ServiceMainScreenPath,
                                              });
                                        },
                                        onSignUp:
                                            () {
                                          context.vRouter.to(
                                              SignupPath,
                                              queryParameters: {
                                                "redirect": ServiceMainScreenPath,
                                              });
                                        });
                                  } else {
                                    serviceEnquiryDialog(
                                        context:
                                            context,
                                        type: 1,
                                        selectedService:
                                            'Platinum',
                                        interestedIn:
                                            interestedIn,
                                        propertyType:
                                            propertyType,
                                        selectServiceType:
                                            selectServiceType,
                                        onCancel:
                                            () {
                                          Navigator.pop(
                                              context);
                                        },
                                        onSubmit:
                                            (requestParams) {
                                          //bloc call to add enquiry
                                          _cubit.submitEnquiry(
                                              requestParams:
                                                  requestParams);
                                        });
                                  }
                                },
                                backgroundColor:
                                    kPlainWhite,
                                color:
                                    kSupportBlue,
                                onHoverColor:
                                    kPlainWhite,
                                text: 'Register',
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          )
        ],
      ),
    );

    Widget servicesStatusBar = Container(
      decoration: BoxDecoration(
        color: kAccentColor[100],
      ),
      padding: EdgeInsets.only(
        top: _hPadding,
        bottom: _hPadding,
      ),
      alignment: Alignment.center,
      child: Container(
          padding: EdgeInsets.only(
              left: _hPadding * 2,
              right: _hPadding * 2),
          child: Responsive.isDesktop(context)
              ? Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Flexible(
                        child: Text(
                            'Services at your finger tips and a click away; with consistent market prices ',
                            style: TS.bodyWhite)),
                    PrimaryButton(
                      onTap: () {
                        if (FirebaseAuth.instance
                                .currentUser ==
                            null) {
                          redirectConfimationDialog(
                              context: context,
                              onLogin: () {
                                context.vRouter.to(
                                    LoginPath,
                                    queryParameters: {
                                      "redirect":
                                          ServiceMainScreenPath,
                                    });
                              },
                              onSignUp: () {
                                context.vRouter.to(
                                    SignupPath,
                                    queryParameters: {
                                      "redirect":
                                          ServiceMainScreenPath,
                                    });
                              });
                        } else {
                          serviceEnquiryDialog(
                              context: context,
                              type: 4,
                              interestedIn:
                                  interestedIn,
                              propertyType:
                                  propertyType,
                              selectServiceType:
                                  selectServiceType,
                              onCancel: () {
                                Navigator.pop(
                                    context);
                              },
                              onSubmit:
                                  (requestParams) {
                                //bloc call to add enquiry
                                _cubit.submitEnquiry(
                                    requestParams:
                                        requestParams);
                              });
                        }
                      },
                      text: "Enquire",
                      width: 140,
                    ),
                  ],
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment:
                      MainAxisAlignment.start,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                            'Services at your finger tips and a click away; with consistent market prices ',
                            textAlign:
                                TextAlign.center,
                            style: TS.bodyWhite)),
                    mobileVerticalSizedBox,
                    PrimaryButton(
                      onTap: () {
                        if (FirebaseAuth.instance
                                .currentUser ==
                            null) {
                          redirectConfimationDialog(
                              context: context,
                              onLogin: () {
                                context.vRouter.to(
                                    LoginPath,
                                    queryParameters: {
                                      "redirect":
                                          ServiceMainScreenPath,
                                    });
                              },
                              onSignUp: () {
                                context.vRouter.to(
                                    SignupPath,
                                    queryParameters: {
                                      "redirect":
                                          ServiceMainScreenPath,
                                    });
                              });
                        } else {
                          serviceEnquiryDialog(
                              context: context,
                              type: 4,
                              interestedIn:
                                  interestedIn,
                              propertyType:
                                  propertyType,
                              selectServiceType:
                                  selectServiceType,
                              onCancel: () {
                                Navigator.pop(
                                    context);
                              },
                              onSubmit:
                                  (requestParams) {
                                //bloc call to add enquiry
                                _cubit.submitEnquiry(
                                    requestParams:
                                        requestParams);
                              });
                        }
                      },
                      text: "Enquire",
                      width: 140,
                    ),
                  ],
                )),
    );

    gridItem(
        {String image = "",
        required String name,
        String dec = ""}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (FirebaseAuth
                      .instance.currentUser ==
                  null) {
                redirectConfimationDialog(
                    context: context,
                    onLogin: () {
                      context.vRouter.to(
                          LoginPath,
                          queryParameters: {
                            "redirect":
                                ServiceMainScreenPath,
                          });
                    },
                    onSignUp: () {
                      context.vRouter.to(
                          SignupPath,
                          queryParameters: {
                            "redirect":
                                ServiceMainScreenPath,
                          });
                    });
              } else {
                serviceEnquiryDialog(
                    context: context,
                    type: 3,
                    interestedIn: interestedIn,
                    propertyType: propertyType,
                    selectServiceType:
                        selectServiceType,
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onSubmit: (requestParams) {
                      //bloc call to add enquiry
                      _cubit.submitEnquiry(
                          requestParams:
                              requestParams);
                    });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  MainAxisAlignment.start,
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    // width: 394,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(
                                12)),
                    child: SkeletonImageLoader(
                        image: image),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(
                      mobileLeftRightPadding),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Text(name,
                              textAlign: TextAlign
                                  .center,
                              style:
                                  TS.lableBlack),
                        ],
                      ),
                      mobileVerticalMiniSizedBox,
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Flexible(
                            child: Text(dec,
                                textAlign:
                                    TextAlign
                                        .center,
                                style:
                                    TS.bodyGray),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      );
    }

    servicesView() {
      return Padding(
        padding: EdgeInsets.only(
          left: Insets.oldOffset,
          right: Insets.oldOffset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  'Individual Maintenance Services',
                  style: TS.lableBlack,
                ),
              ],
            ),
            serviceList.length == 0
                ? Container(
                    height: 10,
                  )
                : SizedBox(
                    height: Insets.med,
                  ),
            serviceList.length == 0
                ? Container(
                    child: Text(
                    'No Services Added',
                    style: TS.bodyBlack,
                  ))
                : GridView.builder(
                    shrinkWrap: true,
                    itemCount:
                        serviceList.length > 6
                            ? 6
                            : serviceList.length,
                    gridDelegate:
                        SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent:
                                370,
                            mainAxisSpacing: 30,
                            crossAxisSpacing: 30,
                            childAspectRatio:
                                370 / 300),
                    itemBuilder:
                        (context, index) {
                      return gridItem(
                        name: serviceList[index]
                            .serviceName,
                        image: serviceList[index]
                                .images
                                .isEmpty
                            ? ""
                            : serviceList[index]
                                .images
                                .first,
                        dec: serviceList[index]
                                .serviceDescription ??
                            "",
                      );
                    }),
            serviceList.length == 0
                ? Container(
                    height: 10,
                  )
                : SizedBox(
                    height: Insets.med,
                  ),
            serviceList.length == 0
                ? Container(
                    height: 10,
                  )
                : PrimaryButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BlocProvider<
                                  ServiceMainCubit>(
                            create: (context) =>
                                _cubit,
                            child: ServiceShowMoreScreen(
                                cubit: _cubit,
                                interestedIn:
                                    interestedIn,
                                propertyType:
                                    propertyType,
                                selectServiceType:
                                    selectServiceType,
                                serviceList:
                                    serviceList),
                          ),
                        ),
                      );
                    },
                    text: 'View More Services',
                  )
          ],
        ),
      );
    }

// ********************************** Mobile **********************************

    mobileGridItem(
        {String image = "",
        required String name,
        String dec = ""}) {
      print('#log : imagge : $image');
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (FirebaseAuth
                      .instance.currentUser ==
                  null) {
                redirectConfimationDialog(
                    context: context,
                    onLogin: () {
                      context.vRouter.to(
                          LoginPath,
                          queryParameters: {
                            "redirect":
                                ServiceMainScreenPath,
                          });
                    },
                    onSignUp: () {
                      context.vRouter.to(
                          SignupPath,
                          queryParameters: {
                            "redirect":
                                ServiceMainScreenPath,
                          });
                    });
              } else {
                serviceEnquiryDialog(
                    context: context,
                    type: 3,
                    interestedIn: interestedIn,
                    propertyType: propertyType,
                    selectServiceType:
                        selectServiceType,
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onSubmit: (requestParams) {
                      //bloc call to add enquiry
                      _cubit.submitEnquiry(
                          requestParams:
                              requestParams);
                    });
              }
            },
            child: Container(
              margin: EdgeInsets.only(
                bottom: mobileLeftRightPadding,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    MainAxisAlignment.start,
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      // width: 394,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius
                                  .circular(12)),
                      child: SkeletonImageLoader(
                          image: image),
                    ),
                  ),
                  mobileVerticalSizedBox,
                  Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Text(name,
                              textAlign: TextAlign
                                  .center,
                              style:
                                  MS.lableBlack),
                        ],
                      ),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Flexible(
                            child: Text(dec,
                                textAlign:
                                    TextAlign
                                        .center,
                                style:
                                    MS.bodyGray),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }

    mobileServicesView() {
      return Padding(
        padding: EdgeInsets.only(
          left: Insets.oldOffset,
          right: Insets.oldOffset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'Individual Maintenance Services',
                    textAlign: TextAlign.center,
                    style: MS.lableBlack,
                  ),
                ),
              ],
            ),
            mobileVerticalSizedBox,
            serviceList.length == 0
                ? Container(
                    child: Text(
                    'No Services Added',
                    style: TS.bodyBlack,
                  ))
                : ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(),
                    itemCount:
                        serviceList.length > 3
                            ? 3
                            : serviceList.length,
                    itemBuilder:
                        (context, index) {
                      return mobileGridItem(
                        name: serviceList[index]
                            .serviceName,
                        image: serviceList[index]
                                .images
                                .isEmpty
                            ? "assets/services_new/service-banner.png"
                            : serviceList[index]
                                .images
                                .first,
                        dec: serviceList[index]
                                .serviceDescription ??
                            "",
                      );
                    }),
            serviceList.length == 0
                ? Container()
                : SizedBox(
                    height: Insets.med,
                  ),
            serviceList.length == 0
                ? Container()
                : PrimaryButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BlocProvider<
                                  ServiceMainCubit>(
                            create: (context) =>
                                _cubit,
                            child: ServiceShowMoreScreen(
                                cubit: _cubit,
                                interestedIn:
                                    interestedIn,
                                propertyType:
                                    propertyType,
                                selectServiceType:
                                    selectServiceType,
                                serviceList:
                                    serviceList),
                          ),
                        ),
                      );
                    },
                    text: 'View More Services')
          ],
        ),
      );
    }

    Widget pricingPlanOne(BuildContext c) {
      return Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8),
            color: kSupportBlue),
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
            top: mobileLeftRightPadding,
            bottom: mobileLeftRightPadding),
        margin:
            EdgeInsets.only(left: 2, right: 2),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            Text('Free',
                style: MS.miniestHeaderWhite),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.close,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.close,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.close,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.close,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            PrimaryButton(
              onTap: () {
                if (FirebaseAuth
                        .instance.currentUser ==
                    null) {
                  redirectConfimationDialog(
                      context: context,
                      onLogin: () {
                        context.vRouter.to(
                            LoginPath,
                            queryParameters: {
                              "redirect":
                                  ServiceMainScreenPath,
                            });
                      },
                      onSignUp: () {
                        context.vRouter.to(
                            SignupPath,
                            queryParameters: {
                              "redirect":
                                  ServiceMainScreenPath,
                            });
                      });
                } else {
                  serviceEnquiryDialog(
                      context: context,
                      type: 1,
                      selectedService: 'Bronze',
                      interestedIn: interestedIn,
                      propertyType: propertyType,
                      selectServiceType:
                          selectServiceType,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (requestParams) {
                        //bloc call to add enquiry
                        _cubit.submitEnquiry(
                            requestParams:
                                requestParams);
                      });
                }
              },
              backgroundColor: kPlainWhite,
              color: kSupportBlue,
              text: 'Register',
              onHoverColor: kPlainWhite,
              fontSize: 12,
              height: 30,
            )
          ],
        ),
      );
    }

    Widget pricingPlanTwo(BuildContext c) {
      return Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8),
            color: kSupportBlue),
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
            top: mobileLeftRightPadding,
            bottom: mobileLeftRightPadding),
        margin:
            EdgeInsets.only(left: 2, right: 2),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            Text('Basic',
                style: MS.miniestHeaderWhite),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.close,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.close,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.close,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            PrimaryButton(
              onTap: () {
                if (FirebaseAuth
                        .instance.currentUser ==
                    null) {
                  redirectConfimationDialog(
                      context: context,
                      onLogin: () {
                        context.vRouter.to(
                            LoginPath,
                            queryParameters: {
                              "redirect":
                                  ServiceMainScreenPath,
                            });
                      },
                      onSignUp: () {
                        context.vRouter.to(
                            SignupPath,
                            queryParameters: {
                              "redirect":
                                  ServiceMainScreenPath,
                            });
                      });
                } else {
                  serviceEnquiryDialog(
                      context: context,
                      type: 1,
                      selectedService: 'Silver',
                      interestedIn: interestedIn,
                      propertyType: propertyType,
                      selectServiceType:
                          selectServiceType,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (requestParams) {
                        //bloc call to add enquiry
                        _cubit.submitEnquiry(
                            requestParams:
                                requestParams);
                      });
                }
              },
              backgroundColor: kPlainWhite,
              color: kSupportBlue,
              text: 'Register',
              onHoverColor: kPlainWhite,
              fontSize: 12,
              height: 30,
            )
          ],
        ),
      );
    }

    Widget pricingPlanThree(BuildContext c) {
      return Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8),
            color: kSupportBlue),
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
            top: mobileLeftRightPadding,
            bottom: mobileLeftRightPadding),
        margin:
            EdgeInsets.only(left: 2, right: 2),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            Text('Standard',
                style: MS.miniestHeaderWhite),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.close,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            PrimaryButton(
              onTap: () {
                if (FirebaseAuth
                        .instance.currentUser ==
                    null) {
                  redirectConfimationDialog(
                      context: context,
                      onLogin: () {
                        context.vRouter.to(
                            LoginPath,
                            queryParameters: {
                              "redirect":
                                  ServiceMainScreenPath,
                            });
                      },
                      onSignUp: () {
                        context.vRouter.to(
                            SignupPath,
                            queryParameters: {
                              "redirect":
                                  ServiceMainScreenPath,
                            });
                      });
                } else {
                  serviceEnquiryDialog(
                      context: context,
                      type: 1,
                      selectedService: 'Gold',
                      interestedIn: interestedIn,
                      propertyType: propertyType,
                      selectServiceType:
                          selectServiceType,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (requestParams) {
                        //bloc call to add enquiry
                        _cubit.submitEnquiry(
                            requestParams:
                                requestParams);
                      });
                }
              },
              backgroundColor: kPlainWhite,
              color: kSupportBlue,
              text: 'Register',
              onHoverColor: kPlainWhite,
              fontSize: 12,
              height: 30,
            )
          ],
        ),
      );
    }

    Widget pricingPlanFour(BuildContext c) {
      return Container(
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(8),
            color: kSupportBlue),
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
            top: mobileLeftRightPadding,
            bottom: mobileLeftRightPadding),
        margin:
            EdgeInsets.only(left: 2, right: 2),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.center,
          children: [
            Text('Premium',
                style: MS.miniestHeaderWhite),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            Icon(
              Icons.check,
              color: kPlainWhite,
              size: FontSizes.s14,
            ),
            mobileVerticalLargerSizedBox,
            mobileVerticalLargerSizedBox,
            PrimaryButton(
              onTap: () {
                if (FirebaseAuth
                        .instance.currentUser ==
                    null) {
                  redirectConfimationDialog(
                      context: context,
                      onLogin: () {
                        context.vRouter.to(
                            LoginPath,
                            queryParameters: {
                              "redirect":
                                  ServiceMainScreenPath,
                            });
                      },
                      onSignUp: () {
                        context.vRouter.to(
                            SignupPath,
                            queryParameters: {
                              "redirect":
                                  ServiceMainScreenPath,
                            });
                      });
                } else {
                  serviceEnquiryDialog(
                      context: context,
                      type: 1,
                      selectedService: 'Platinum',
                      interestedIn: interestedIn,
                      propertyType: propertyType,
                      selectServiceType:
                          selectServiceType,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (requestParams) {
                        //bloc call to add enquiry
                        _cubit.submitEnquiry(
                            requestParams:
                                requestParams);
                      });
                }
              },
              backgroundColor: kPlainWhite,
              color: kSupportBlue,
              text: 'Register',
              onHoverColor: kPlainWhite,
              fontSize: 12,
              height: 30,
            )
          ],
        ),
      );
    }

    List<Widget> listPricePlan(
        BuildContext context) {
      return [
        pricingPlanOne(context),
        pricingPlanTwo(context),
        pricingPlanThree(context),
        pricingPlanFour(context)
      ];
    }

    mobilePricingPlan(BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.all(
                mobileLeftRightPadding),
            decoration: BoxDecoration(
              color: kBlackVariant,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Packages',
                      style: MS.lableWhite,
                    ),
                  ],
                ),
                mobileVerticalSizedBox,
                Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: EdgeInsets.only(
                            top:
                                mobileLeftRightPadding,
                            bottom:
                                mobileLeftRightPadding),
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              '',
                              style: MS
                                  .miniestHeaderWhite,
                            ),
                            mobileVerticalLargerSizedBox,
                            Text(
                              'Self Managed Listing & Marketing',
                              style: MS
                                  .miniestHeaderWhite,
                            ),
                            mobileVerticalLargerSizedBox,
                            Text(
                              'Professionally Managed Listing & Marketing',
                              style: MS
                                  .miniestHeaderWhite,
                            ),
                            mobileVerticalLargerSizedBox,
                            Text(
                              'Lease Administration',
                              style: MS
                                  .miniestHeaderWhite,
                            ),
                            mobileVerticalLargerSizedBox,
                            Text(
                              'Maintenance',
                              style: MS
                                  .miniestHeaderWhite,
                            ),
                            mobileVerticalLargerSizedBox,
                            Text(
                              'Integrated Facility Management',
                              style: MS
                                  .miniestHeaderWhite,
                            ),
                            mobileVerticalLargerSizedBox,
                            mobileVerticalLargerSizedBox,
                            mobileVerticalLargerSizedBox,
                            Text(
                              ' ',
                              style: MS
                                  .miniestHeaderWhite,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: CarouselSlider(
                        items: listPricePlan(
                            context),
                        carouselController:
                            buttonCarouselController,
                        options: CarouselOptions(
                          height: 280,
                          autoPlay: false,
                          enlargeCenterPage:
                              false,
                          viewportFraction: 0.9,
                          aspectRatio: 2.0,
                          initialPage: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    }

    Widget _mobileContent() {
      return SingleChildScrollView(
          child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
            mobileVerticalSizedBox,
            description(),
            mobileVerticalSizedBox,
            mobilePricingPlan(context),
            mobileVerticalSizedBox,
            mobileStackImageBannerCard(
                ctx: context,
                imageLocation:
                    'assets/services_new/service-stack.png',
                cardHeader:
                    'Integrated Turn-key Facility Management Solutions ',
                cardSubHeader:
                    "Our turn-key Facility Management solutions are brought to you by qualified professionals whom are well experienced in delivering such services. By using our services you will recieve a high level of services which are aligned to international best practices; where we strive to meet your expectations provided at competitive rates. ",
                onTap: () {
                  if (FirebaseAuth
                          .instance.currentUser ==
                      null) {
                    redirectConfimationDialog(
                        context: context,
                        onLogin: () {
                          context.vRouter.to(
                              LoginPath,
                              queryParameters: {
                                "redirect":
                                    ServiceMainScreenPath,
                              });
                        },
                        onSignUp: () {
                          context.vRouter.to(
                              SignupPath,
                              queryParameters: {
                                "redirect":
                                    ServiceMainScreenPath,
                              });
                        });
                  } else {
                    serviceEnquiryDialog(
                        context: context,
                        type: 2,
                        interestedIn:
                            interestedIn,
                        propertyType:
                            propertyType,
                        selectServiceType:
                            selectServiceType,
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onSubmit:
                            (requestParams) {
                          //bloc call to add enquiry
                          _cubit.submitEnquiry(
                              requestParams:
                                  requestParams);
                        });
                  }
                }),
            mobileVerticalSizedBox,
            mobileVerticalSizedBox,
            mobileServicesView(),
            mobileVerticalSizedBox,
            servicesStatusBar,
            mobileVerticalSizedBox,
          ]));
    }

    return Responsive.isMobile(context)
        ? SafeArea(
            child: SliverScaffold(
                title: 'Get the service you need',
                imageLocation:
                    'assets/services_new/service-banner.png',
                isSearch: false,
                child: BlocListener<
                    ServiceMainCubit,
                    ServiceMainState>(
                  bloc: _cubit,
                  listener: (_, state) {
                    if (state
                        is LOtherServicesMain) {
                    } else if (state
                        is FOtherServicesMain) {
                    } else if (state
                        is SOtherServicesMain) {
                      List<
                              DropdownMenuItem<
                                  SelectServicesModel>>
                          selectService = [];
                      state.result
                          .forEach((element) {
                        selectService.add(
                          DropdownMenuItem(
                              value: SelectServicesModel(
                                  name: element
                                      .serviceName,
                                  type: 3),
                              child: Text(
                                element
                                    .serviceName,
                              )),
                        );
                      });
                      setState(() {
                        serviceList
                            .addAll(state.result);
                        selectServiceType.addAll(
                            selectService);
                      });
                    } else if (state
                        is LSubmitServiceEnquiry) {
                    } else if (state
                        is FSubmitServiceEnquiry) {
                    } else if (state
                        is SSubmitServiceEnquiry) {
                      context.vRouter.to(
                          ServiceEnquirySubmitSuccessDialogPath);
                    }
                  },
                  child: Container(
                      constraints: BoxConstraints(
                        maxHeight:
                            MediaQuery.of(context)
                                .size
                                .height,
                        maxWidth:
                            MediaQuery.of(context)
                                .size
                                .width,
                      ),
                      color: kBackgroundColor,
                      child: _mobileContent()),
                )))
        : Scaffold(
            appBar: Responsive.isDesktop(context)
                ? ToolBar()
                : PropertyFilterAppBar(),
            body: BlocListener<ServiceMainCubit,
                ServiceMainState>(
              bloc: _cubit,
              listener: (_, state) {
                if (state is LOtherServicesMain) {
                } else if (state
                    is FOtherServicesMain) {
                } else if (state
                    is SOtherServicesMain) {
                  List<
                          DropdownMenuItem<
                              SelectServicesModel>>
                      selectService = [];
                  state.result.forEach((element) {
                    selectService.add(
                      DropdownMenuItem(
                          value:
                              SelectServicesModel(
                                  name: element
                                      .serviceName,
                                  type: 3),
                          child: Text(
                            element.serviceName,
                          )),
                    );
                  });
                  setState(() {
                    serviceList
                        .addAll(state.result);
                    selectServiceType
                        .addAll(selectService);
                  });
                } else if (state
                    is LSubmitServiceEnquiry) {
                } else if (state
                    is FSubmitServiceEnquiry) {
                } else if (state
                    is SSubmitServiceEnquiry) {
                  context.vRouter.to(
                      ServiceEnquirySubmitSuccessDialogPath);
                }
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    stack(),
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: wp(20),
                          right: wp(20)),
                      child: Text(
                          'Our turn-key Facility Management solutions are brought to you by qualified professionals whom are well experienced in delivering such services. By using our services you will recieve a high level of services which are aligned to international best practices; where we strive to meet your expectations provided at competitive rates.',
                          textAlign:
                              TextAlign.center,
                          maxLines: 3,
                          style: TS.bodyGray),
                    ),
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    pricingPlans,
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    bannerContentRightStack,
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    servicesView(),
                    SizedBox(
                      height: Insets.xxl,
                    ),
                    servicesStatusBar,
                    Footer()
                  ],
                ),
              ),
            ),
          );
  }
}
