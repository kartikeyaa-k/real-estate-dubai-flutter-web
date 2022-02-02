import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/dialogs/redirect_confirmation.dart';
import '../../components/footer.dart';
import '../../components/mobile_padding.dart';
import '../../components/scaffold/sliver_scaffold.dart';
import '../../components/skeleton_image_loader.dart';
import '../../components/toolbar.dart';
import '../../core/utils/app_responsive.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../models/response_models/services_main_response_models/get_services_main_response_model.dart';
import '../../routes/routes.dart';
import 'components/banner_image.dart';
import 'components/enquire_dialog.dart';
import 'components/property_filter_app_bar.dart';
import 'cubit/service_main_cubit.dart';
import 'models/interested_in_model.dart';
import 'models/property_type_model.dart';
import 'models/select_services_model.dart';

class ServiceShowMoreScreen extends StatelessWidget {
  ServiceShowMoreScreen(
      {Key? key,
      required this.serviceList,
      required this.interestedIn,
      required this.propertyType,
      required this.cubit,
      required this.selectServiceType})
      : super(key: key);
  final List<ServiceMainModel> serviceList;
  final ServiceMainCubit cubit;
  final List<DropdownMenuItem<InterestedInModel>> interestedIn;
  final List<DropdownMenuItem<PropertyTypeModel>> propertyType;
  final List<DropdownMenuItem<SelectServicesModel>> selectServiceType;

  @override
  Widget build(BuildContext context) {
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);
    final _vMinSpace = SizedBox(
      height: Insets.sm,
    );
    final _vSpace = SizedBox(
      height: Insets.xl,
    );

    final _vExtraSpace = SizedBox(
      height: Insets.offset,
    );
    final _hSpace = SizedBox(
      width: Insets.xl,
    );
    final _hPadding = Insets.offset;
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
                      imageLocation: 'assets/services_new/service-banner.png',
                    )
                  ]
                : [],
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Get the service you need", style: TS.headerWhite),
                _vSpace,
                SizedBox(
                  width: wp(40),
                  child: Text(
                    'Our turn-key Facility Management solutions are brought to you by qualified professionals whom are well experienced in delivering such services. By using our services you will recieve a high level of services which are aligned to international best practices; where we strive to meet your expectations provided at competitive rates.',
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
    }

    gridItem({String image = "", required String name, String dec = ""}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (FirebaseAuth.instance.currentUser == null) {
                redirectConfimationDialog(
                    context: context,
                    onLogin: () {
                      context.vRouter.to(LoginPath, queryParameters: {
                        "redirect": ServiceMainScreenPath,
                      });
                    },
                    onSignUp: () {
                      context.vRouter.to(SignupPath, queryParameters: {
                        "redirect": ServiceMainScreenPath,
                      });
                    });
              } else {
                serviceEnquiryDialog(
                    context: context,
                    type: 3,
                    interestedIn: interestedIn,
                    propertyType: propertyType,
                    selectServiceType: selectServiceType,
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onSubmit: (requestParams) {
                      //bloc call to add enquiry
                      cubit.submitEnquiry(requestParams: requestParams);
                    });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    // width: 394,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: SkeletonImageLoader(image: image),
                  ),
                ),
                mobileVerticalSizedBox,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(name, textAlign: TextAlign.center, style: TS.lableWhite),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(dec,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TS.bodyWhite),
                        )
                      ],
                    ),
                  ],
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
          left: Insets.offset,
          right: Insets.offset,
        ),
        child: Container(
          padding: EdgeInsets.only(
            left: Insets.offset,
            right: Insets.offset,
          ),
          color: kBlackVariant,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Insets.med,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Individual Maintenance Services',
                    style: TS.lableWhite,
                  ),
                ],
              ),
              SizedBox(
                height: Insets.xl,
              ),
              GridView.builder(
                  shrinkWrap: true,
                  itemCount: serviceList.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 370, mainAxisSpacing: 30, crossAxisSpacing: 30, childAspectRatio: 370 / 300),
                  itemBuilder: (context, index) {
                    return gridItem(
                      name: serviceList[index].serviceName,
                      image: serviceList[index].images.isEmpty ? "" : serviceList[index].images.first,
                      dec: serviceList[index].serviceDescription ?? "",
                    );
                  }),
              SizedBox(
                height: Insets.med,
              ),
            ],
          ),
        ),
      );
    }

// ********************************** Mobile **********************************

    mobileGridItem({String image = "", required String name, String dec = ""}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              if (FirebaseAuth.instance.currentUser == null) {
                redirectConfimationDialog(
                    context: context,
                    onLogin: () {
                      context.vRouter.to(LoginPath, queryParameters: {
                        "redirect": ServiceMainScreenPath,
                      });
                    },
                    onSignUp: () {
                      context.vRouter.to(SignupPath, queryParameters: {
                        "redirect": ServiceMainScreenPath,
                      });
                    });
              } else {
                serviceEnquiryDialog(
                    context: context,
                    type: 3,
                    interestedIn: interestedIn,
                    propertyType: propertyType,
                    selectServiceType: selectServiceType,
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onSubmit: (requestParams) {
                      //bloc call to add enquiry
                      cubit.submitEnquiry(requestParams: requestParams);
                    });
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    // width: 394,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                    child: SkeletonImageLoader(image: image),
                  ),
                ),
                mobileVerticalSizedBox,
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(name, textAlign: TextAlign.center, style: MS.lableWhite),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(dec, textAlign: TextAlign.center, style: MS.bodyWhite),
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      );
    }

    mobileServicesView() {
      return Padding(
        padding: EdgeInsets.only(
          left: Insets.offset,
          right: Insets.offset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            mobileVerticalSizedBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: serviceList.length,
                itemBuilder: (context, index) {
                  return mobileGridItem(
                    name: serviceList[index].serviceName,
                    image: serviceList[index].images.isEmpty ? "" : serviceList[index].images.first,
                    dec: serviceList[index].serviceDescription ?? "",
                  );
                }),
            SizedBox(
              height: Insets.med,
            ),
          ],
        ),
      );
    }

    Widget _mobileContent() {
      return SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        mobileVerticalSizedBox,
        mobileServicesView(),
      ]));
    }

    return Responsive.isMobile(context)
        ? SafeArea(
            child: SliverScaffold(
                title: 'Get the service you need',
                imageLocation: 'assets/services_new/service-banner.png',
                isSearch: false,
                child: Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    color: kBlackVariant,
                    child: _mobileContent())))
        : Scaffold(
            appBar: Responsive.isDesktop(context) ? ToolBar() : PropertyFilterAppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  stack(),
                  SizedBox(
                    height: Insets.xxl,
                  ),
                  servicesView(),
                  SizedBox(
                    height: Insets.xxl,
                  ),
                  Footer()
                ],
              ),
            ),
          );
  }
}
