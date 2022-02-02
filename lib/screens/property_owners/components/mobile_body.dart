import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/dialogs/redirect_confirmation.dart';
import 'package:real_estate_portal/components/mobile_banner_image.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

CarouselController buttonCarouselController = CarouselController();
Widget mobileDescription(String description) {
  return Padding(
    padding: EdgeInsets.only(left: mobileLeftRightPadding, right: mobileLeftRightPadding),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: MS.bodyGray,
          ),
        ),
      ],
    ),
  );
}

mobileStackImageBannerCard(
    {required BuildContext ctx,
    required String imageLocation,
    required String cardHeader,
    required String cardSubHeader,
    String buttonTitle = '',
    Function()? onTap}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Stack(children: [
        Container(
          width: double.infinity,
          child: ClipRRect(
            child: Image.asset(
              imageLocation,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: cardSubHeader.characters.length < 100 ? 230 : 210),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(ctx).size.width - 150,
                      padding: EdgeInsets.all(mobileLeftRightPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cardHeader,
                            style: MS.miniHeaderBlack,
                          ),
                          mobileVerticalSizedBox,
                          Text(
                            cardSubHeader,
                            textAlign: TextAlign.center,
                            style: MS.bodyBlack,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    ],
  );
}

Widget pricingPlanOne(BuildContext c) {
  return Container(
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kSupportBlue),
    alignment: Alignment.topCenter,
    padding: EdgeInsets.only(top: mobileLeftRightPadding, bottom: mobileLeftRightPadding),
    margin: EdgeInsets.only(left: 2, right: 2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Free', style: MS.miniestHeaderWhite),
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
            if (FirebaseAuth.instance.currentUser == null) {
              redirectConfimationDialog(
                  context: c,
                  onLogin: () {
                    c.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'true', 'amcType': 'free'});
                  },
                  onSignUp: () {
                    c.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'false', 'amcType': 'free'});
                  });
            } else {
              c.vRouter.to(FacilityManagementPath, queryParameters: {'amcType': 'free'});
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
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kSupportBlue),
    alignment: Alignment.topCenter,
    padding: EdgeInsets.only(top: mobileLeftRightPadding, bottom: mobileLeftRightPadding),
    margin: EdgeInsets.only(left: 2, right: 2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Basic', style: MS.miniestHeaderWhite),
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
            if (FirebaseAuth.instance.currentUser == null) {
              redirectConfimationDialog(
                  context: c,
                  onLogin: () {
                    c.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'true', 'amcType': 'basic'});
                  },
                  onSignUp: () {
                    c.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'false', 'amcType': 'basic'});
                  });
            } else {
              c.vRouter.to(FacilityManagementPath, queryParameters: {'amcType': 'basic'});
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
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kSupportBlue),
    alignment: Alignment.topCenter,
    padding: EdgeInsets.only(top: mobileLeftRightPadding, bottom: mobileLeftRightPadding),
    margin: EdgeInsets.only(left: 2, right: 2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Standard', style: MS.miniestHeaderWhite),
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
            if (FirebaseAuth.instance.currentUser == null) {
              redirectConfimationDialog(
                  context: c,
                  onLogin: () {
                    c.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'true', 'amcType': 'standard'});
                  },
                  onSignUp: () {
                    c.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'false', 'amcType': 'standard'});
                  });
            } else {
              c.vRouter.to(FacilityManagementPath, queryParameters: {'amcType': 'standard'});
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
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: kSupportBlue),
    alignment: Alignment.topCenter,
    padding: EdgeInsets.only(top: mobileLeftRightPadding, bottom: mobileLeftRightPadding),
    margin: EdgeInsets.only(left: 2, right: 2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Premium', style: MS.miniestHeaderWhite),
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
            if (FirebaseAuth.instance.currentUser == null) {
              redirectConfimationDialog(
                  context: c,
                  onLogin: () {
                    c.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'true', 'amcType': 'premium'});
                  },
                  onSignUp: () {
                    c.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'false', 'amcType': 'premium'});
                  });
            } else {
              c.vRouter.to(FacilityManagementPath, queryParameters: {'amcType': 'premium'});
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

List<Widget> listPricePlan(BuildContext context) {
  return [pricingPlanOne(context), pricingPlanTwo(context), pricingPlanThree(context), pricingPlanFour(context)];
}

mobilePricingPlan(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.max,
    children: [
      Container(
        padding: EdgeInsets.all(mobileLeftRightPadding),
        decoration: BoxDecoration(
          color: kBlackVariant,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.only(top: mobileLeftRightPadding, bottom: mobileLeftRightPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '',
                          style: MS.miniestHeaderWhite,
                        ),
                        mobileVerticalLargerSizedBox,
                        Text(
                          'Self Managed Listing & Marketing',
                          style: MS.miniestHeaderWhite,
                        ),
                        mobileVerticalLargerSizedBox,
                        Text(
                          'Professionally Managed Listing & Marketing',
                          style: MS.miniestHeaderWhite,
                        ),
                        mobileVerticalLargerSizedBox,
                        Text(
                          'Lease Administration',
                          style: MS.miniestHeaderWhite,
                        ),
                        mobileVerticalLargerSizedBox,
                        Text(
                          'Maintenance',
                          style: MS.miniestHeaderWhite,
                        ),
                        mobileVerticalLargerSizedBox,
                        Text(
                          'Integrated Facility Management',
                          style: MS.miniestHeaderWhite,
                        ),
                        mobileVerticalLargerSizedBox,
                        mobileVerticalLargerSizedBox,
                        mobileVerticalLargerSizedBox,
                        Text(
                          ' ',
                          style: MS.miniestHeaderWhite,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: CarouselSlider(
                    items: listPricePlan(context),
                    carouselController: buttonCarouselController,
                    options: CarouselOptions(
                      height: 280,
                      autoPlay: false,
                      enlargeCenterPage: false,
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

mobileAnyHeader({required String header, String? subHeader}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        alignment: Alignment.center,
        child: Text(
          header,
          textAlign: TextAlign.center,
          style: MS.miniHeaderBlack,
        ),
      ),
    ],
  );
}

customVerticalStepper() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: kSupportBlue),
              child: Text(
                '1',
                textAlign: TextAlign.center,
                style: MS.miniestHeaderWhite,
              )),
          Container(
            height: 50,
            width: 2,
            decoration: BoxDecoration(border: Border(left: BorderSide(color: kSupportBlue, width: 2))),
          ),
          Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: kSupportBlue),
              child: Text(
                '2',
                textAlign: TextAlign.center,
                style: MS.miniestHeaderWhite,
              )),
          Container(
            height: 50,
            width: 2,
            decoration: BoxDecoration(border: Border(left: BorderSide(color: kSupportBlue, width: 2))),
          ),
          Container(
              height: 35,
              width: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(shape: BoxShape.circle, color: kSupportBlue),
              child: Text(
                '3',
                textAlign: TextAlign.center,
                style: MS.miniestHeaderWhite,
              )),
        ],
      ),
      mobileHorizontalSizedBox,
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 35,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login & Apply',
                  textAlign: TextAlign.left,
                  style: MS.miniHeaderBlack,
                ),
                mobileVerticalMiniSizedBox,
                Text(
                  'Register with us',
                  textAlign: TextAlign.left,
                  style: MS.bodyGray,
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 0,
            decoration: BoxDecoration(border: Border(left: BorderSide(color: kPlainWhite, width: 0))),
          ),
          Container(
            height: 35,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Approval',
                  textAlign: TextAlign.left,
                  style: MS.miniHeaderBlack,
                ),
                mobileVerticalMiniSizedBox,
                Text(
                  'Our team will verify your account',
                  textAlign: TextAlign.left,
                  style: MS.bodyGray,
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            width: 0,
            decoration: BoxDecoration(border: Border(left: BorderSide(color: kPlainWhite, width: 0))),
          ),
          Container(
            height: 35,
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get Listed',
                  textAlign: TextAlign.left,
                  style: MS.miniHeaderBlack,
                ),
                mobileVerticalMiniSizedBox,
                Text(
                  'List your services',
                  textAlign: TextAlign.left,
                  style: MS.bodyGray,
                ),
              ],
            ),
          ),
        ],
      ),
    ],
  );
}

Widget mobileHeader() {
  return Padding(
    padding: EdgeInsets.only(top: mobileLeftRightPadding, left: mobileLeftRightPadding, right: mobileLeftRightPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Let’s Work Together!',
          style: MS.lableBlack,
        ),
      ],
    ),
  );
}

getRegisteredBody({
  required String header,
  required BuildContext context,
}) {
  return Container(
    padding: EdgeInsets.only(left: mobileLeftRightPadding, right: mobileLeftRightPadding),
    child: Column(
      children: [
        mobileAnyHeader(header: header),
        mobileVerticalSizedBox,
        mobileVerticalSizedBox,
        customVerticalStepper(),
        mobileVerticalSizedBox,
        mobileVerticalSizedBox,
        PrimaryButton(
          onTap: () {
            if (FirebaseAuth.instance.currentUser == null) {
              redirectConfimationDialog(
                  context: context,
                  onLogin: () {
                    context.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'true', 'amcType': ''});
                  },
                  onSignUp: () {
                    context.vRouter.to(FacilityManagementPath, queryParameters: {'isLogin': 'false', 'amcType': ''});
                  });
            } else {
              context.vRouter.to(FacilityManagementPath, queryParameters: {'amcType': ''});
            }
          },
          text: "Register",
          backgroundColor: kSupportBlue,
          color: kPlainWhite,
          height: 34,
          width: 150,
          fontSize: 12,
        ),
        mobileVerticalSizedBox,
        serviceStatusBar()
      ],
    ),
  );
}

serviceStatusBar() {
  return Container(
    decoration: BoxDecoration(
      color: kAccentColor[100],
    ),
    padding: EdgeInsets.only(
      top: mobileLeftRightPadding,
      bottom: mobileLeftRightPadding,
    ),
    alignment: Alignment.center,
    child: Container(
        padding: EdgeInsets.only(
          left: mobileLeftRightPadding,
          right: mobileLeftRightPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '25+',
                        textAlign: TextAlign.center,
                        style: MS.lableWhite,
                      ),
                      mobileVerticalMiniSizedBox,
                      Text(
                        'Communities Managed',
                        textAlign: TextAlign.center,
                        style: MS.miniestHeaderWhite,
                      ),
                    ],
                  ),
                  mobileVerticalSizedBox,
                  mobileVerticalSizedBox,
                  mobileVerticalSizedBox,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '10000+',
                        textAlign: TextAlign.center,
                        style: MS.lableWhite,
                      ),
                      mobileVerticalMiniSizedBox,
                      Text(
                        'No. of Tenants',
                        textAlign: TextAlign.center,
                        style: MS.miniestHeaderWhite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '2500+',
                        textAlign: TextAlign.center,
                        style: MS.lableWhite,
                      ),
                      mobileVerticalMiniSizedBox,
                      Text(
                        'Properties Managed',
                        textAlign: TextAlign.center,
                        style: MS.miniestHeaderWhite,
                      ),
                    ],
                  ),
                  mobileVerticalSizedBox,
                  mobileVerticalSizedBox,
                  mobileVerticalSizedBox,
                  Column(
                    children: [
                      Text(
                        '100000+',
                        textAlign: TextAlign.center,
                        style: MS.lableWhite,
                      ),
                      mobileVerticalMiniSizedBox,
                      Text(
                        'No. of Maintenance\ntasks completed',
                        textAlign: TextAlign.center,
                        style: MS.miniestHeaderWhite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        '150+',
                        textAlign: TextAlign.center,
                        style: MS.lableWhite,
                      ),
                      mobileVerticalMiniSizedBox,
                      Text(
                        'No. of owners served',
                        textAlign: TextAlign.center,
                        style: MS.miniestHeaderWhite,
                      ),
                    ],
                  ),
                  mobileVerticalSizedBox,
                  mobileVerticalSizedBox,
                  mobileVerticalSizedBox,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '50000+',
                        textAlign: TextAlign.center,
                        style: MS.lableWhite,
                      ),
                      mobileVerticalMiniSizedBox,
                      Text(
                        'Properties Managed',
                        textAlign: TextAlign.center,
                        style: MS.miniestHeaderWhite,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )),
  );
}
