import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/screens/property_detail/cubit/verification_hack_cubit.dart';
import 'package:real_estate_portal/screens/services/components/success_dialog.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../models/response_models/verification_status_response_models/verification_status_response_model.dart';
import '../../../routes/routes.dart';

class VerificationStatusBanner
    extends StatefulWidget {
  VerificationStatusBanner(
      {Key? key,
      required this.propertyId,
      required this.verificationStatusResponseModel})
      : super(key: key);

  final int propertyId;
  final VerificationStatusResponseModel
      verificationStatusResponseModel;

  @override
  State<VerificationStatusBanner> createState() =>
      _VerificationStatusBannerState();
}

class _VerificationStatusBannerState
    extends State<VerificationStatusBanner> {
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _padding = Responsive.isMobile(context)
        ? Insets.lg
        : Insets.xl;
    Widget _vSpace = Responsive.isDesktop(context)
        ? SizedBox(height: Insets.xxl)
        : SizedBox(height: Insets.med);

    Widget _btnBookViewing = Row(
      children: [
        // ignore: deprecated_member_use_from_same_package
        PrimaryButton(
          onTap: () {
            print(
                '#log : Property Id => ${widget.propertyId}');
            context.vRouter.to(
                AvailableTimeSlotDialogPath,
                queryParameters: {
                  'property_id':
                      widget.propertyId.toString()
                });
          },
          text: "Book a Viewing",
          height: 45,
          width: 110,
          fontSize: 12,
        ),
      ],
    );

    Widget clientConfirmed(BuildContext context) {
      return Row(
        children: [
          Column(
            mainAxisAlignment:
                MainAxisAlignment.start,
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Verification Pending',
                  style: TextStyles.h3),
              SizedBox(height: Insets.med),
              Flexible(
                  child: Text(
                      "Verification is under process from the Adure Team",
                      style: TextStyles.body12
                          .copyWith(
                              color: kBlackVariant
                                  .withOpacity(
                                      0.7)))),
            ],
          ),
        ],
      );
    }

    Widget pendingVerification(
        BuildContext context) {
      return Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text('Verification Note!',
                        style: TextStyles.h3),
                    SizedBox(height: Insets.med),
                    Flexible(
                        child: Text(
                            "Complete the verification by following the steps :",
                            style: TextStyles
                                .body12
                                .copyWith(
                                    color: kBlackVariant
                                        .withOpacity(
                                            0.7)))),
                    SizedBox(height: Insets.xs),
                    Flexible(
                        child: Text(
                            "1. Click the “Go to link” button.",
                            style: TextStyles
                                .body12
                                .copyWith(
                                    color: kBlackVariant
                                        .withOpacity(
                                            0.7)))),
                    Flexible(
                        child: Text(
                            "2. Complete the process which will be opened in the new tab.",
                            style: TextStyles
                                .body12
                                .copyWith(
                                    color: kBlackVariant
                                        .withOpacity(
                                            0.7)))),
                    Flexible(
                        child: Text(
                            "3. After completing the above process, click the 'Complete Verification' button.",
                            style: TextStyles
                                .body12
                                .copyWith(
                                    color: kBlackVariant
                                        .withOpacity(
                                            0.7)))),
                    SizedBox(height: Insets.med),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .center,
                      children: [
                        PrimaryButton(
                          onTap: () {
                            context.vRouter.toExternal(
                                widget.verificationStatusResponseModel
                                        .verificationUrl ??
                                    "",
                                openNewTab: true);
                          },
                          text: "Go To Link",
                          backgroundColor:
                              kSupportBlue,
                          color: kPlainWhite,
                          fontSize: 12,
                        ),
                        SizedBox(
                            height: Insets.xs),
                        PrimaryButton(
                          onTap: () async {
                            bool? isConfirmed =
                                await showDialog<
                                    bool>(
                              context: context,
                              builder: (_) {
                                return _ConfirmationDialog();
                              },
                            );

                            if (isConfirmed ??
                                false)
                              context
                                  .read<
                                      VerificationHackCubit>()
                                  .completeVerification(widget
                                      .propertyId
                                      .toString());
                          },
                          text:
                              "Complete Verification",
                          backgroundColor:
                              kSupportBlue,
                          color: kPlainWhite,
                          fontSize: 12,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(),
            ],
          ),
        ],
      );
    }

    print(
        '#log ===================>> bookStatusResponseModel.url -- > ${widget.verificationStatusResponseModel.verificationUrl}');
    print(
        '#log ===================>> bookStatusResponseModel.status -- > ${widget.verificationStatusResponseModel.verificationStatus}');

    if (widget.verificationStatusResponseModel
            .verificationStatus ==
        'CLIENT_CONFIRMED') {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(_padding),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    Responsive.isDesktop(context)
                        ? Corners.lgBorder
                        : null),
            child: Responsive.isTablet(context)
                ? Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            clientConfirmed(
                                context),
                            SizedBox(
                              height: Insets.med,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      clientConfirmed(context),
                      SizedBox(
                        height: Insets.med,
                      ),
                    ],
                  ),
          ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(_padding),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    Responsive.isDesktop(context)
                        ? Corners.lgBorder
                        : null),
            child: Responsive.isTablet(context)
                ? Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            pendingVerification(
                                context),
                            SizedBox(
                              height: Insets.med,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      pendingVerification(
                          context),
                      SizedBox(
                        height: Insets.med,
                      ),
                    ],
                  ),
          ),
        ],
      );
    }
  }
}

class _ConfirmationDialog extends StatefulWidget {
  const _ConfirmationDialog({Key? key})
      : super(key: key);

  @override
  State<_ConfirmationDialog> createState() =>
      _ConfirmationDialogState();
}

class _ConfirmationDialogState
    extends State<_ConfirmationDialog> {
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // get id from url and load data
  //   // if id is missing redirect to [PropertyListingScreen]
  //   if (!context.vRouter.queryParameters.keys.contains("property_id")) {
  //   } else {
  //     int propertyId = int.parse(context.vRouter.queryParameters["property_id"] as String);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final Function wp =
        ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp =
        ScreenUtils(MediaQuery.of(context)).hp;
    Widget _header = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Confirmation",
            textAlign: TextAlign.left,
            style: TextStyles.h2),
      ],
    );
    Widget _body = Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // Row(
        //   children: [
        //     Text(
        //       "Do you want to decline the offer?",
        //       textAlign: TextAlign.center,
        //       style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: Insets.med,
        // ),
        Row(
          children: [
            Flexible(
              child: Text(
                "Please make sure you have filled all the required documents in the provided link.",
                style: TextStyles.body16.copyWith(
                    color: kBlackVariant
                        .withOpacity(0.7)),
              ),
            ),
          ],
        ),
      ],
    );

    Widget _btns = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrimaryButton(
          onTap: () {
            Navigator.pop<bool>(context, false);
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
            Navigator.pop<bool>(context, true);
          },
          text: "Confirm",
          height: 45,
          width: 110,
          fontSize: 12,
        )
      ],
    );

    return Scaffold(
      backgroundColor:
          Colors.black.withOpacity(0.7),
      body: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: wp(50),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.all(Insets.xl),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .start,
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
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
                    child: Align(
                      alignment:
                          Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(
                                context);
                            // context.vRouter.to(ProjectDetailScreenPath, queryParameters: {"id": widget.propertyId});
                          },
                          child: Icon(Icons.close,
                              size: 20)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
