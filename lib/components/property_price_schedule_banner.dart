import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';

import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/dialogs/decline_offer_dialog.dart';
import 'package:real_estate_portal/components/snack_bar/custom_snack_bar.dart';
import 'package:real_estate_portal/models/property_details_models/property_model.dart';

import 'package:real_estate_portal/models/response_models/book_status_response_models/book_status_response_model.dart';

import 'package:real_estate_portal/routes/routes.dart';
import 'package:real_estate_portal/screens/project_detail/components/available_time_slot_dialog.dart';
import 'package:real_estate_portal/screens/property_detail/components/available_payments_plans.dart';
import 'package:real_estate_portal/screens/property_detail/components/payment_history_dialog.dart';
import 'package:real_estate_portal/screens/property_detail/components/place_offer_dialog.dart';
import 'package:real_estate_portal/screens/property_detail/cubit/offer_cubit.dart';

import 'package:vrouter/vrouter.dart';
import '../core/utils/constants.dart';
import '../core/utils/responsive.dart';
import '../core/utils/styles.dart';
import '../injection_container.dart';

class PropertyPriceScheduleBanner
    extends StatefulWidget {
  PropertyPriceScheduleBanner(
      {Key? key,
      required this.propertyRentOrBuyPlans,
      required this.propertyPrice,
      required this.propertyId,
      this.bookStatusResponseModel})
      : super(key: key);
  final String propertyPrice;
  final int propertyId;

  final BookStatusResponseModel?
      bookStatusResponseModel;
  final List<PropertyRentOrBuyPlan>
      propertyRentOrBuyPlans;

  @override
  State<PropertyPriceScheduleBanner>
      createState() =>
          _PropertyPriceScheduleBannerState();
}

class _PropertyPriceScheduleBannerState
    extends State<PropertyPriceScheduleBanner> {
  late OfferCubit _offerCubit;
  void initState() {
    _offerCubit = sl<OfferCubit>();

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
            // context.vRouter
            //     .to(AvailableTimeSlotDialogPath, queryParameters: {'property_id': widget.propertyId.toString()});

            if (FirebaseAuth
                    .instance.currentUser ==
                null) {
              return context.vRouter.to(LoginPath,
                  queryParameters: {
                    "redirect":
                        AvailableTimeSlotDialogPath,
                    "property_id": widget
                        .propertyId
                        .toString()
                  });
            }

            showDialog(
              context: context,
              builder: (_) {
                return AvailableTimeSlotDialog(
                    propertyId: widget.propertyId
                        .toString());
              },
            );
          },
          text: "Book a Viewing",
          height: 45,
          width: 110,
          fontSize: 12,
        ),
      ],
    );

    Widget _btnReschedule = PrimaryButton(
      onTap: () {
        // print('#log : Property Id => ${widget.propertyId}');
        // context.vRouter.to(AvailableTimeSlotDialogPath, queryParameters: {'property_id': widget.propertyId.toString()});
        if (FirebaseAuth.instance.currentUser ==
            null) {
          return context.vRouter
              .to(LoginPath, queryParameters: {
            "redirect":
                AvailableTimeSlotDialogPath,
            "property_id":
                widget.propertyId.toString()
          });
        }

        showDialog(
          context: context,
          builder: (_) {
            return AvailableTimeSlotDialog(
                propertyId:
                    widget.propertyId.toString());
          },
        );
      },
      text: "Reschedule",
      height: 45,
      width: 110,
      fontSize: 12,
    );

    Widget _btnDecline = PrimaryButton(
      onTap: () async {
        print(
            '#log : Property Id => ${widget.propertyId}');
        // context.vRouter.to(DeclineOfferDialogPath, queryParameters: {'property_id': widget.propertyId.toString()});
        await showDialog(
          context: context,
          builder: (_) {
            return DeclineOfferDialog(
                propertyId:
                    widget.propertyId.toString());
          },
        );
      },
      text: "Not Interested",
      backgroundColor: kBackgroundColor,
      color: kSupportBlue,
      height: 45,
      width: 110,
      fontSize: 12,
    );

    Widget _btnAcceptOffer = Row(
      children: [
        // ignore: deprecated_member_use_from_same_package
        PrimaryButton(
          onTap: () {
            context
                .read<OfferCubit>()
                .acceptOffer(context
                    .vRouter
                    .queryParameters[
                        "property_id"]
                    .toString());
          },
          text: "Accept Offer",
          height: 45,
          width: 110,
          fontSize: 12,
        ),
      ],
    );

    Widget _btnViewPaymentDetails = Row(
      children: [
        // ignore: deprecated_member_use_from_same_package
        PrimaryButton(
          onTap: () {
            _offerCubit.getPaymentHistory(
                widget.propertyId.toString());
          },
          text: "View Payment Details",
          height: 45,
          width: 136,
          fontSize: 12,
        ),
      ],
    );

    Widget _btnPlaceOffer = Row(
      children: [
        // ignore: deprecated_member_use_from_same_package
        PrimaryButton(
          onTap: () {
            final PropertyRentOrBuyPlan
                firstSellingPrice = widget
                    .propertyRentOrBuyPlans
                    .firstWhere(
              (element) =>
                  element.planType ==
                  PlanType.BUY,
              orElse: () =>
                  PropertyRentOrBuyPlan.empty,
            );

            final String sellingPrice =
                firstSellingPrice ==
                        PropertyRentOrBuyPlan
                            .empty
                    ? ""
                    : firstSellingPrice.price
                        .toString();

            placeOfferDialog(
                sellingPrice: sellingPrice,
                propertyRentOrBuyPlans:
                    widget.propertyRentOrBuyPlans,
                context: context,
                onPlace: (id, offer) {
                  print(
                      '#log ============> placing offer : $id , $offer');
                  _offerCubit.placeOffer(
                      id, offer);
                },
                onCancel: () {
                  Navigator.pop(context);
                });
            print(
                '#log : Property Id => ${widget.propertyId}');
            // context.vRouter.to(PlaceOfferDialogPath, queryParameters: {'property_id': propertyId.toString()});
          },
          text: "Place Offer",
          height: 45,
          width: 110,
          fontSize: 12,
        ),
      ],
    );

    Widget _btnDownloadContract = PrimaryButton(
      onTap: () {
        context.vRouter.toExternal(
            widget.bookStatusResponseModel
                    ?.contract_link ??
                "",
            openNewTab: true);
      },
      text: "Download Contract",
      height: 45,
      width: 120,
      fontSize: 12,
    );

    Widget _btnHistory = PrimaryButton(
      onTap: () {},
      text: "History",
      height: 45,
      width: 110,
      fontSize: 12,
      backgroundColor: kBackgroundColor,
      color: kSupportBlue,
    );

    Widget _btnDownloadInvoice = PrimaryButton(
      onTap: () {
        context.vRouter.toExternal(
            widget.bookStatusResponseModel
                    ?.contract_link ??
                "",
            openNewTab: true);
      },
      text: "Download Invoice",
      height: 45,
      width: 110,
      fontSize: 12,
    );

    Widget _btnPayRent = PrimaryButton(
      onTap: () {},
      text: "Pay Rent",
      height: 45,
      width: 110,
      fontSize: 12,
    );

    Widget _propertyPrice(BuildContext context) {
      return Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text('Property Price',
                  style: TextStyles.h3),
              SizedBox(height: Insets.xs),
              Text("Starting From",
                  style: TextStyles.body12
                      .copyWith(
                          color: kBlackVariant
                              .withOpacity(0.7))),
            ],
          ),
          SizedBox(width: Insets.offset),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(widget.propertyPrice),
              SizedBox(height: Insets.sm),
              InkWell(
                  onTap: () {
                    availablePaymentPlans(
                      context: context,
                      propertyRentOrBuyPlans: widget
                          .propertyRentOrBuyPlans,
                      price: widget.propertyPrice,
                    );
                  },
                  child: Text(
                      "Other pricing options",
                      style: TextStyles.body30
                          .copyWith(
                              color:
                                  kSupportBlue))),
            ],
          )
        ],
      );
    }

//FIXME
//_leadClient widget below should be renamed to _leadLeasing
    Widget _leadClientApprovedPropertyPrice = Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text('Property Price',
                style: TextStyles.h3),
            SizedBox(height: Insets.xs),
            Text("Negotiable",
                style: TextStyles.body12.copyWith(
                    color: kBlackVariant
                        .withOpacity(0.7))),
          ],
        ),
        SizedBox(width: Insets.offset),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(widget.propertyPrice,
                style: TextStyles.h3),
          ],
        )
      ],
    );

    Widget _leadLeasingApprovedPropertyPrice =
        Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text('Property Price',
                    style: TextStyles.h3),
                SizedBox(height: Insets.xs),
                Text("Under negotiation",
                    style: TextStyles.body12
                        .copyWith(
                            color: kBlackVariant
                                .withOpacity(
                                    0.7))),
              ],
            ),
            SizedBox(width: Insets.offset),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                    '${widget.bookStatusResponseModel?.actual_price}',
                    style: TextStyles.h3),
              ],
            )
          ],
        ),
        SizedBox(
          height: Insets.med,
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "You placed a new offer for ${widget.bookStatusResponseModel?.offered_price}.",
                style: TextStyles.body12.copyWith(
                    color: kBlackVariant
                        .withOpacity(0.7))),
          ],
        )
      ],
    );

    Widget _contractDrawn = Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text('Property Price',
                    style: TextStyles.h3),
                SizedBox(height: Insets.xs),
                Text("Offer accepted",
                    style: TextStyles.body12
                        .copyWith(
                            color: kBlackVariant
                                .withOpacity(
                                    0.7))),
              ],
            ),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                    '${widget.bookStatusResponseModel?.actual_price}',
                    style: TextStyles.h3),
              ],
            )
          ],
        ),
        SizedBox(
          height: Insets.med,
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text("Contract is being prepared.",
                style: TextStyles.body12.copyWith(
                    color: kBlackVariant
                        .withOpacity(0.7))),
          ],
        )
      ],
    );

    Widget _firstPartySignatrure = Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text('Property Price',
                    style: TextStyles.h3),
                SizedBox(height: Insets.xs),
                Text("Contract has been prepared",
                    style: TextStyles.body12
                        .copyWith(
                            color: kBlackVariant
                                .withOpacity(
                                    0.7))),
              ],
            ),
            SizedBox(width: Insets.offset),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                    '${widget.bookStatusResponseModel?.actual_price}',
                    style: TextStyles.h3),
              ],
            )
          ],
        ),
        SizedBox(
          height: Insets.med,
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.end,
          children: [_btnDownloadContract],
        )
      ],
    );

    Widget _secondPartySignatrure = Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text('Property Price',
                    style: TextStyles.h3),
                SizedBox(height: Insets.xs),
                Text("Contract has been prepared",
                    style: TextStyles.body12
                        .copyWith(
                            color: kBlackVariant
                                .withOpacity(
                                    0.7))),
              ],
            ),
            SizedBox(height: Insets.xs),
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                    '${widget.bookStatusResponseModel?.actual_price}',
                    style: TextStyles.h3),
              ],
            )
          ],
        ),
        SizedBox(
          height: Insets.med,
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.end,
          children: [_btnDownloadContract],
        )
      ],
    );

    Widget _bookedPaid = Column(children: [
      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text('Paid Property Price',
                  style: TextStyles.h3),
            ],
          ),
          SizedBox(width: Insets.offset),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                  '${widget.bookStatusResponseModel?.offered_price}',
                  style: TextStyles.h3),
            ],
          )
        ],
      ),
      SizedBox(
        height: Insets.med,
      ),
      Row(
        mainAxisAlignment:
            MainAxisAlignment.start,
        children: [_btnViewPaymentDetails],
      )
    ]);

    Widget _bookedNotPaid = Column(children: [
      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text('Rent Due',
                  style: TextStyles.h3),
              SizedBox(height: Insets.xs),
              Text(
                  "Due date: ${widget.bookStatusResponseModel?.due_date}",
                  style: TextStyles.body12
                      .copyWith(
                          color: kBlackVariant
                              .withOpacity(0.7))),
            ],
          ),
          SizedBox(width: Insets.offset),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                  '${widget.bookStatusResponseModel?.offered_price}',
                  style: TextStyles.h3),
            ],
          )
        ],
      ),
      SizedBox(
        height: Insets.med,
      ),
      Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [_btnViewPaymentDetails],
      )
    ]);

    Widget _scheduledBody = Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text('Your Viewing Is Scheduled',
            style: TextStyles.h3),
        SizedBox(height: Insets.xs),
        Text(
            "Your agent will reach at the selected time",
            style: TextStyles.body12.copyWith(
                color: kBlackVariant
                    .withOpacity(0.7))),
        SizedBox(
          height: Insets.med,
        ),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer,
                        color: kSupportBlue),
                    SizedBox(
                      width: Insets.sm,
                    ),
                    Text(
                      '${widget.bookStatusResponseModel?.visit_details?.from_time} - ${widget.bookStatusResponseModel?.visit_details?.to_time}',
                      style: TextStyles.h4,
                    ),
                  ],
                ),
                SizedBox(
                  height: Insets.med,
                ),
                Row(
                  children: [
                    Icon(
                      Icons
                          .calendar_today_rounded,
                      color: kSupportBlue,
                    ),
                    SizedBox(
                      width: Insets.sm,
                    ),
                    Text(
                      '${widget.bookStatusResponseModel?.visit_details?.scheduled_date}',
                      style: TextStyles.h4,
                    ),
                  ],
                )
              ],
            ),
            _btnReschedule,
          ],
        )
      ],
    );

    print(
        '#log ===================>> bookStatusResponseModel.status -- > ${widget.bookStatusResponseModel?.status}');
    print(
        '#log ===================>> bookStatusResponseModel.substatus -- > ${widget.bookStatusResponseModel?.sub_status}');

    switch (
        widget.bookStatusResponseModel?.status ??
            "") {
      case "":
        return Container(
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
                          _propertyPrice(context),
                          SizedBox(
                            height: Insets.med,
                          ),
                          _btnBookViewing
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _propertyPrice(context),
                    SizedBox(
                      height: Insets.med,
                    ),
                    _btnBookViewing
                  ],
                ),
        );

      case "REJECTED":
        return Container(
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
                          _propertyPrice(context),
                          SizedBox(
                            height: Insets.med,
                          ),
                          _btnBookViewing
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    _propertyPrice(context),
                    SizedBox(
                      height: Insets.med,
                    ),
                    _btnBookViewing
                  ],
                ),
        );

      case "VISIT_SCHEDULED":
        if (widget.bookStatusResponseModel
                ?.sub_status ==
            'COMPLETE') {
//*********************** THREE BUTTONS UI ***********************//
          return BlocListener<OfferCubit,
              OfferState>(
            bloc: _offerCubit,
            listener: (context, state) {
              if (state is LPlaceOffer) {
              } else if (state is FPlaceOffer) {
                SnackBar snackBar = CustomSnackBar
                    .errorSnackBar(state.failure
                            .errorMessage.isEmpty
                        ? state
                            .failure.errorMessage
                        : "Unexpected failure occured at login. Please try again after sometime.");
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else if (state is SPlaceOffer) {
                // Navigator.pop(context);
                context.vRouter.to(
                    ProjectDetailScreenPath,
                    queryParameters: {
                      "id": widget.propertyId
                          as String
                    });
              }
            },
            child: Container(
              padding: EdgeInsets.all(_padding),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      Responsive.isDesktop(
                              context)
                          ? Corners.lgBorder
                          : null),
              child: Responsive.isTablet(context)
                  ? Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _leadClientApprovedPropertyPrice,
                              SizedBox(
                                height:
                                    Insets.med,
                              ),
                              Row(
                                children: [
                                  _btnDecline,
                                  // _btnAcceptOffer,
                                  _btnPlaceOffer,
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        _leadClientApprovedPropertyPrice,
                        SizedBox(
                          height: Insets.med,
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            _btnDecline,
                            // _btnAcceptOffer,
                            _btnPlaceOffer,
                          ],
                        )
                      ],
                    ),
            ),
          );
        } else {
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(_padding),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        Responsive.isDesktop(
                                context)
                            ? Corners.lgBorder
                            : null),
                child: Responsive.isTablet(
                        context)
                    ? Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                _propertyPrice(
                                    context),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .center,
                        children: [
                          _propertyPrice(context),
                        ],
                      ),
              ),
              _vSpace,
              Container(
                padding: EdgeInsets.all(_padding),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        Responsive.isDesktop(
                                context)
                            ? Corners.lgBorder
                            : null),
                child:
                    Responsive.isTablet(context)
                        ? Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    _scheduledBody,
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              _scheduledBody
                            ],
                          ),
              ),
            ],
          );
        }
      case "LEAD":
        if (widget.bookStatusResponseModel
                ?.sub_status ==
            'LEASING_APPROVED') {
//*********************** THREE BUTTONS UI ***********************//
          return BlocListener<OfferCubit,
              OfferState>(
            bloc: _offerCubit,
            listener: (context, state) {
              if (state is LPlaceOffer) {
              } else if (state is FPlaceOffer) {
                SnackBar snackBar = CustomSnackBar
                    .errorSnackBar(state.failure
                            .errorMessage.isEmpty
                        ? state
                            .failure.errorMessage
                        : "Unexpected failure occured at login. Please try again after sometime.");
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else if (state is SPlaceOffer) {
                context.vRouter.to(
                    ProjectDetailScreenPath,
                    queryParameters: {
                      "id": context.vRouter
                              .queryParameters[
                          "property_id"] as String
                    });
              }
            },
            child: Container(
              padding: EdgeInsets.all(_padding),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      Responsive.isDesktop(
                              context)
                          ? Corners.lgBorder
                          : null),
              child: Responsive.isTablet(context)
                  ? Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _leadClientApprovedPropertyPrice,
                              SizedBox(
                                height:
                                    Insets.med,
                              ),
                              Row(
                                children: [
                                  _btnDecline,
                                  // _btnAcceptOffer,
                                  _btnPlaceOffer,
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        _leadClientApprovedPropertyPrice,
                        SizedBox(
                          height: Insets.med,
                        ),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            _btnDecline,
                            // _btnAcceptOffer,
                            _btnPlaceOffer,
                          ],
                        )
                      ],
                    ),
            ),
          );
        } else {
// ************ not three button ui **************//
          return Container(
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
                            _leadLeasingApprovedPropertyPrice
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _leadLeasingApprovedPropertyPrice
                    ],
                  ),
          );
        }

      case "CONTRACT":
        if (widget.bookStatusResponseModel
                ?.sub_status ==
            'CONTRACT_BEING_PREPARED') {
          return Container(
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
                            _contractDrawn
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [_contractDrawn],
                  ),
          );
        } else if (widget.bookStatusResponseModel
                    ?.sub_status ==
                'CONTRACT_DRAWN' ||
            widget.bookStatusResponseModel
                    ?.sub_status ==
                'FIST_PARTY_SIGNATURE' ||
            widget.bookStatusResponseModel
                    ?.sub_status ==
                'SECOND_PARTY_SIGNATURE') {
          return Container(
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
                            _firstPartySignatrure
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _firstPartySignatrure
                    ],
                  ),
          );
        }

        // else if (widget.bookStatusResponseModel?.sub_status == 'SECOND_PARTY_SIGNATURE') {
        //   return Container(
        //     padding: EdgeInsets.all(_padding),
        //     decoration: BoxDecoration(color: Colors.white, borderRadius: Responsive.isDesktop(context) ? Corners.lgBorder : null),
        //     child: Responsive.isTablet(context)
        //         ? Row(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Expanded(
        //                 child: Column(
        //                   children: [_secondPartySignatrure],
        //                 ),
        //               ),
        //             ],
        //           )
        //         : Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [_secondPartySignatrure],
        //           ),
        //   );
        // }

        else {
          return Container();
        }

      case "BOOKED":
        if (widget.bookStatusResponseModel
                ?.sub_status ==
            'PAID,RENT') {
          return BlocListener<OfferCubit,
              OfferState>(
            bloc: _offerCubit,
            listener: (context, state) {
              if (state is LPaymentHistory) {
              } else if (state
                  is FPaymentHistory) {
                SnackBar snackBar = CustomSnackBar
                    .errorSnackBar(state.failure
                            .errorMessage.isEmpty
                        ? state
                            .failure.errorMessage
                        : "Unexpected failure occured at login. Please try again after sometime.");
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else if (state
                  is SPaymentHistory) {
                showPaymentHistoryDialg(
                    context: context,
                    paymentHistoryModelResponseModel:
                        state.result);
                // context.vRouter.to(ProjectDetailScreenPath,
                //    queryParameters: {"id": context.vRouter.queryParameters["property_id"] as String});
              }
            },
            child: Container(
              padding: EdgeInsets.all(_padding),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      Responsive.isDesktop(
                              context)
                          ? Corners.lgBorder
                          : null),
              child: Responsive.isTablet(context)
                  ? Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _bookedPaid
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [_bookedPaid],
                    ),
            ),
          );
        } else if (widget.bookStatusResponseModel
                ?.sub_status ==
            'NOT_PAID,RENT') {
          return BlocListener<OfferCubit,
              OfferState>(
            bloc: _offerCubit,
            listener: (context, state) {
              if (state is LPaymentHistory) {
              } else if (state
                  is FPaymentHistory) {
                SnackBar snackBar = CustomSnackBar
                    .errorSnackBar(state.failure
                            .errorMessage.isEmpty
                        ? state
                            .failure.errorMessage
                        : "Unexpected failure occured at login. Please try again after sometime.");
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(snackBar);
              } else if (state
                  is SPaymentHistory) {
                showPaymentHistoryDialg(
                    context: context,
                    paymentHistoryModelResponseModel:
                        state.result);
                // context.vRouter.to(ProjectDetailScreenPath,
                //    queryParameters: {"id": context.vRouter.queryParameters["property_id"] as String});
              }
            },
            child: Container(
              padding: EdgeInsets.all(_padding),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      Responsive.isDesktop(
                              context)
                          ? Corners.lgBorder
                          : null),
              child: Responsive.isTablet(context)
                  ? Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              _bookedNotPaid
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [_bookedNotPaid],
                    ),
            ),
          );
        } else {
          return Container();
        }
      default:
        return Container();
    }
  }
}
