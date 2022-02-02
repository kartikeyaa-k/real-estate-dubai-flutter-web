import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/dialogs/redirect_confirmation.dart';
import 'package:real_estate_portal/components/mobile_banner_image.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:real_estate_portal/screens/service_providers/components/benefits_grid_model.dart';
import 'package:vrouter/src/core/extended_context.dart';

mobileStackBannerImage({required String imageLocation, required String header, required String subHeader}) {
  return MobileBannerWithText(
    imageLocation: imageLocation,
    header: 'Service Provider',
    subHeader: 'Offer Services to Property Owners With Eases',
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
              'assets/service/service-providers.jpg',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 200),
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

Widget mobileGridItem({required Color cicleColor, required String title, required String description}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 170,
        height: 125,
        padding: EdgeInsets.only(
          left: mobileLeftRightPadding,
          right: mobileLeftRightPadding,
          top: mobileLeftRightPadding,
        ),
        decoration: BoxDecoration(color: kBackgroundColor, borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(shape: BoxShape.circle, color: cicleColor),
                child: Icon(
                  Icons.library_books_rounded,
                  color: kPlainWhite,
                  size: 15,
                )),
            mobileVerticalSizedBox,
            Text(
              title,
              textAlign: TextAlign.center,
              style: MS.miniHeaderBlack,
            ),
            mobileVerticalSizedBox,
            Text(
              description,
              textAlign: TextAlign.center,
              style: MS.bodyBlack,
            ),
          ],
        ),
      ),
    ],
  );
}

//  CupertinoStepper _buildStepper(StepperType type) {
//     final canCancel = currentStep > 0;
//     final canContinue = currentStep < 3;
//     return CupertinoStepper(
//       type: type,
//       currentStep: currentStep,
//       onStepTapped: (step) => setState(() => currentStep = step),
//       onStepCancel: canCancel ? () => setState(() => --currentStep) : null,
//       onStepContinue: canContinue ? () => setState(() => ++currentStep) : null,
//       steps: [
//         for (var i = 0; i < 3; ++i)
//           _buildStep(
//             title: Text('Step ${i + 1}'),
//             isActive: i == currentStep,
//             state: i == currentStep
//                 ? StepState.editing
//                 : i < currentStep ? StepState.complete : StepState.indexed,
//           ),
//         _buildStep(
//           title: Text('Error'),
//           state: StepState.error,
//         ),
//         _buildStep(
//           title: Text('Disabled'),
//           state: StepState.disabled,
//         )
//       ],
//     );
//   }

mobileHorizontalList(List<BenefitsModel> gridItemList) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        color: kBlackVariant,
        height: 150,
        child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsetsDirectional.all(mobileLeftRightPadding),
          scrollDirection: Axis.horizontal,
          itemCount: gridItemList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: index == gridItemList.length - 1 ? 0 : mobileLeftRightPadding),
              child: mobileGridItem(
                  cicleColor: gridItemList[index].iconColor,
                  title: gridItemList[index].header,
                  description: gridItemList[index].subHeader),
            );
          },
        ),
      ),
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
                    context.vRouter.to(ServiceRegistrationScreenPath, queryParameters: {'isLogin': 'true'});
                  },
                  onSignUp: () {
                    context.vRouter.to(ServiceRegistrationScreenPath, queryParameters: {'isLogin': 'false'});
                  });
            } else {
              context.vRouter.to(ServiceRegistrationScreenPath);
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

circleFirst(String number) {
  return Container(
    width: 20.0,
    height: 20.0,
    decoration: new BoxDecoration(
      color: number != '1' ? kPlainWhite : kSupportBlue,
      shape: BoxShape.circle,
      border: number != '1' ? Border.all(color: kSupportBlue) : null,
    ),
    alignment: Alignment.center,
    child: Text(
      number,
      textAlign: TextAlign.center,
      style: TextStyles.h5.copyWith(color: number != '1' ? kSupportBlue : kPlainWhite),
    ),
  );
}

circleTwo(String number) {
  return Container(
    width: 20.0,
    height: 20.0,
    decoration: new BoxDecoration(
      color: number != '2'
          ? number == '1'
              ? kSupportBlue
              : kPlainWhite
          : kSupportBlue,
      shape: BoxShape.circle,
      border: number != '2' ? Border.all(color: kSupportBlue) : null,
    ),
    alignment: Alignment.center,
    child: number == '1'
        ? Icon(
            Icons.check,
            color: kPlainWhite,
            size: 12,
          )
        : Text(
            number,
            textAlign: TextAlign.center,
            style: TextStyles.h5.copyWith(color: number != '2' ? kSupportBlue : kPlainWhite),
          ),
  );
}

circleThree(String number) {
  return Container(
    width: 20.0,
    height: 20.0,
    decoration: new BoxDecoration(
      color: kSupportBlue,
      shape: BoxShape.circle,
      border: number != '3' ? Border.all(color: kSupportBlue) : null,
    ),
    alignment: Alignment.center,
    child: number != '3'
        ? Icon(
            Icons.check,
            color: kPlainWhite,
            size: 12,
          )
        : Text(
            number,
            textAlign: TextAlign.center,
            style: TextStyles.h5.copyWith(color: kPlainWhite),
          ),
  );
}

circleTitleFirst(String title, String number) {
  return Container(
    decoration: new BoxDecoration(),
    alignment: Alignment.center,
    child: Text(title,
        textAlign: TextAlign.center,
        style: number == '1' ? TextStyles.h5.copyWith(color: kSupportBlue) : TextStyles.body14.copyWith(color: kBlackVariant)),
  );
}

circleTitleTwo(String title, String number) {
  return Container(
    decoration: new BoxDecoration(),
    alignment: Alignment.center,
    child: Text(title,
        textAlign: TextAlign.center,
        style: number == '2' ? TextStyles.h5.copyWith(color: kSupportBlue) : TextStyles.body14.copyWith(color: kBlackVariant)),
  );
}

circleTitleThree(String title, String number) {
  return Container(
    decoration: new BoxDecoration(),
    alignment: Alignment.center,
    child: Text(title,
        textAlign: TextAlign.center,
        style: number == '3' ? TextStyles.h5.copyWith(color: kSupportBlue) : TextStyles.body14.copyWith(color: kBlackVariant)),
  );
}

Widget circleVerticalDivider(BuildContext context) {
  final Function hp = ScreenUtils(MediaQuery.of(context)).hp;

  return Container(
    height: hp(10),
    width: 1,
    decoration: BoxDecoration(border: Border.all(color: kSupportBlue, width: 2)),
  );
}

Widget verticalDividerSpacing(BuildContext context) {
  final Function hp = ScreenUtils(MediaQuery.of(context)).hp;

  return Container(
    height: hp(10.6),
  );
}

Column singleBlock({required String text, required Widget child, double width = double.infinity, double height = 48}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(text, style: TextStyles.body14.copyWith(color: kLightBlue)),
      SizedBox(height: 4),
      Container(width: width, height: height, child: child),
    ],
  );
}

mobileLeftFormStatusDisplay(BuildContext context, int _formIndex) {
  switch (_formIndex) {
    case 0:
      return Container(
        width: 50,
        padding: EdgeInsets.only(top: mobileLeftRightPadding, bottom: mobileLeftRightPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: kBlackVariant.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            circleFirst('1'),
            circleVerticalDivider(context),
            circleFirst('2'),
            circleVerticalDivider(context),
            circleFirst('3'),
          ],
        ),
      );

    case 1:
      return Container(
        width: 50,
        padding: EdgeInsets.only(top: mobileLeftRightPadding, bottom: mobileLeftRightPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: kBlackVariant.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            circleTwo('1'),
            circleVerticalDivider(context),
            circleTwo('2'),
            circleVerticalDivider(context),
            circleTwo('3'),
          ],
        ),
      );

    case 2:
      return Container(
        width: 50,
        padding: EdgeInsets.only(top: mobileLeftRightPadding, bottom: mobileLeftRightPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: kBlackVariant.withOpacity(0.1),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            circleThree('1'),
            circleVerticalDivider(context),
            circleThree('2'),
            circleVerticalDivider(context),
            circleThree('3'),
          ],
        ),
      );

    default:
      return Container();
  }
}
