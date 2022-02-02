import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/breadcrumb/primary_breadcrumb.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

import 'banner_image.dart';

class FormComponents {
  static stackBannerImage(BuildContext context) {
    final bool _toolBarSwitchCondition =
        !Responsive.isMobile(context);
    final Function wp =
        ScreenUtils(MediaQuery.of(context)).wp;

    final _vSpace = SizedBox(
      height: Insets.xl,
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: _toolBarSwitchCondition
              ? [
                  // if (Responsive.isDesktop(context)) PrimaryBreadCrumb(),
                  BannerImage(
                    imageLocation:
                        'assets/service/service_provider_banner.png',
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
              _vSpace,
              _vSpace,
              _vSpace,
              Text(
                  "Service Provider Registration",
                  style: TS.headerWhite),
              // _vSpace,
              // SizedBox(
              //   width: wp(40),
              //   child: Text(
              //     'Offer service to property owners with ease',
              //     textAlign: TextAlign.center,
              //     style: TS.bodyWhite,
              //     maxLines: 3,
              //     overflow: TextOverflow.ellipsis,
              //   ),
              // ),
            ],
          ),
        )
      ],
    );
  }

  static Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Let’s Work Together!',
          style: TextStyles.h1,
        ),
      ],
    );
  }

  static Widget circleVerticalDivider(
      BuildContext context) {
    final Function hp =
        ScreenUtils(MediaQuery.of(context)).hp;

    return Container(
      height: hp(10),
      decoration: BoxDecoration(
          border: Border.all(
              color: kSupportBlue, width: 1)),
    );
  }

  static Widget verticalDividerSpacing(
      BuildContext context) {
    final Function hp =
        ScreenUtils(MediaQuery.of(context)).hp;

    return Container(
      height: hp(10.6),
    );
  }

  static Widget adBanner(BuildContext context) {
    final Function wp =
        ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp =
        ScreenUtils(MediaQuery.of(context)).hp;
    return Container(
        height: hp(44.3),
        width: wp(100),
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: kDisableColor),
        child: Text(
          'AD  - IMAGE',
          textAlign: TextAlign.center,
        ));
  }

  static circleFirst(String number) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: new BoxDecoration(
        color: number != '1'
            ? kPlainWhite
            : kSupportBlue,
        shape: BoxShape.circle,
        border: number != '1'
            ? Border.all(color: kSupportBlue)
            : null,
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        textAlign: TextAlign.center,
        style: TextStyles.h5.copyWith(
            color: number != '1'
                ? kSupportBlue
                : kPlainWhite),
      ),
    );
  }

  static circleTwo(String number) {
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
        border: number != '2'
            ? Border.all(color: kSupportBlue)
            : null,
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
              style: TextStyles.h5.copyWith(
                  color: number != '2'
                      ? kSupportBlue
                      : kPlainWhite),
            ),
    );
  }

  static circleThree(String number) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: new BoxDecoration(
        color: kSupportBlue,
        shape: BoxShape.circle,
        border: number != '3'
            ? Border.all(color: kSupportBlue)
            : null,
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
              style: TextStyles.h5
                  .copyWith(color: kPlainWhite),
            ),
    );
  }

  static circleTitleFirst(
      String title, String number) {
    return Container(
      decoration: new BoxDecoration(),
      alignment: Alignment.center,
      child: Text(title,
          textAlign: TextAlign.center,
          style: number == '1'
              ? TextStyles.h5
                  .copyWith(color: kSupportBlue)
              : TextStyles.body14.copyWith(
                  color: kBlackVariant)),
    );
  }

  static circleTitleTwo(
      String title, String number) {
    return Container(
      decoration: new BoxDecoration(),
      alignment: Alignment.center,
      child: Text(title,
          textAlign: TextAlign.center,
          style: number == '2'
              ? TextStyles.h5
                  .copyWith(color: kSupportBlue)
              : TextStyles.body14.copyWith(
                  color: kBlackVariant)),
    );
  }

  static circleTitleThree(
      String title, String number) {
    return Container(
      decoration: new BoxDecoration(),
      alignment: Alignment.center,
      child: Text(title,
          textAlign: TextAlign.center,
          style: number == '3'
              ? TextStyles.h5
                  .copyWith(color: kSupportBlue)
              : TextStyles.body14.copyWith(
                  color: kBlackVariant)),
    );
  }

  static leftFormStatusDisplay(
      BuildContext context, int _formIndex) {
    final Function wp =
        ScreenUtils(MediaQuery.of(context)).wp;

    switch (_formIndex) {
      case 0:
        return Container(
          width: Responsive.isDesktop(context)
              ? wp(20)
              : 110,
          padding: EdgeInsets.only(
            left: Insets.oldOffset,
            top: Insets.xxl,
            bottom: Insets.xxl,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color:
                  kBlackVariant.withOpacity(0.1),
            ),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  FormComponents.circleFirst('1'),
                  circleVerticalDivider(context),
                  circleFirst('2'),
                  circleVerticalDivider(context),
                  circleFirst('3'),
                ],
              ),
              Responsive.isDesktop(context)
                  ? SizedBox(
                      width: Insets.oldOffset,
                    )
                  : Container(),
              Responsive.isDesktop(context)
                  ? Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        circleTitleFirst(
                            'Basic Information',
                            '1'),
                        verticalDividerSpacing(
                            context),
                        circleTitleFirst(
                            'Company Information',
                            '2'),
                        verticalDividerSpacing(
                            context),
                        circleTitleFirst(
                            'Select Services',
                            '3'),
                      ],
                    )
                  : Container()
            ],
          ),
        );

      case 1:
        return Container(
          width: Responsive.isDesktop(context)
              ? wp(20)
              : 110,
          padding: EdgeInsets.only(
            left: Insets.oldOffset,
            top: Insets.xxl,
            bottom: Insets.xxl,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color:
                  kBlackVariant.withOpacity(0.1),
            ),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  circleTwo('1'),
                  circleVerticalDivider(context),
                  circleTwo('2'),
                  circleVerticalDivider(context),
                  circleTwo('3'),
                ],
              ),
              Responsive.isDesktop(context)
                  ? SizedBox(
                      width: Insets.oldOffset,
                    )
                  : Container(),
              Responsive.isDesktop(context)
                  ? Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        circleTitleTwo(
                            'Basic Information',
                            '1'),
                        verticalDividerSpacing(
                            context),
                        circleTitleTwo(
                            'Company Information',
                            '2'),
                        verticalDividerSpacing(
                            context),
                        circleTitleTwo(
                            'Select Services',
                            '3'),
                      ],
                    )
                  : Container()
            ],
          ),
        );

      case 2:
        return Container(
          width: Responsive.isDesktop(context)
              ? wp(20)
              : 110,
          padding: EdgeInsets.only(
            left: Insets.oldOffset,
            top: Insets.xxl,
            bottom: Insets.xxl,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1,
              color:
                  kBlackVariant.withOpacity(0.1),
            ),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center,
                children: [
                  circleThree('1'),
                  circleVerticalDivider(context),
                  circleThree('2'),
                  circleVerticalDivider(context),
                  circleThree('3'),
                ],
              ),
              Responsive.isDesktop(context)
                  ? SizedBox(
                      width: Insets.oldOffset,
                    )
                  : Container(),
              Responsive.isDesktop(context)
                  ? Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        circleTitleThree(
                            'Basic Information',
                            '1'),
                        verticalDividerSpacing(
                            context),
                        circleTitleThree(
                            'Company Information',
                            '2'),
                        verticalDividerSpacing(
                            context),
                        circleTitleThree(
                            'Select Services',
                            '3'),
                      ],
                    )
                  : Container(),
            ],
          ),
        );

      default:
        return Container();
    }
  }
}
