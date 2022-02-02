import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_text_field.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/components/snack_bar/custom_snack_bar.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/models/property_details_models/property_model.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:real_estate_portal/screens/property_detail/cubit/offer_cubit.dart';
import 'package:vrouter/src/core/extended_context.dart';

Widget _header = Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text("Place Offer Confirmation", textAlign: TextAlign.left, style: TextStyles.h2),
  ],
);

placeOfferDialog(
    {required BuildContext context,
    required List<PropertyRentOrBuyPlan> propertyRentOrBuyPlans,
    required String sellingPrice,
    Function(String offer, String plan_id)? onPlace,
    Function()? onCancel}) {
  TextEditingController offer = TextEditingController();
  String planID = '';
  bool isBuySelected = false;
  String firstBuyingId = '';
  String rentDuration = 'Year ';
  propertyRentOrBuyPlans.forEach((element) {
    if (element.planType == PlanType.BUY) {
      firstBuyingId = element.planId.toString();
    }
  });

  return showDialog(
      context: context,
      useSafeArea: false,
      barrierLabel: "asd",
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.7),
            body: Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 500,
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(Insets.xl),
                          child: Column(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // PLANS HEADER
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Payment Plans", textAlign: TextAlign.left, style: TextStyles.h2),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Insets.med,
                                  ),
                                  // BUY RENT Body
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //************************** Buy Plan Header
                                      if (propertyRentOrBuyPlans
                                              .where((element) => element.planType == PlanType.BUY)
                                              .toList()
                                              .length !=
                                          0) ...[
                                        Padding(
                                          padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                            Expanded(
                                                flex: 2,
                                                child: Text('Buy Plan',
                                                    style: Responsive.isDesktop(context)
                                                        ? TS.miniestHeaderBlack
                                                        : MS.lableBlack)),
                                            Expanded(
                                                flex: 4,
                                                child: Text("AED $sellingPrice",
                                                    style: Responsive.isDesktop(context)
                                                        ? TS.miniestHeaderBlack
                                                        : MS.lableBlack)),
                                            Spacer(
                                              flex: 2,
                                            ),
                                            Expanded(
                                              child: Icon(
                                                Icons.check,
                                                color: isBuySelected ? kSupportBlue : kDisableColor,
                                              ),
                                            )
                                          ]),
                                        ),
                                        SizedBox(
                                          height: Insets.med,
                                        ),
                                      ],
                                      //************************** Buy Plan Body
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: propertyRentOrBuyPlans.length,
                                              itemBuilder: (context, index) {
                                                if (propertyRentOrBuyPlans[index].planType == PlanType.BUY) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        planID = propertyRentOrBuyPlans[index].planId.toString();
                                                        isBuySelected = true;
                                                      });
                                                      print('#log =========> Plan Id : $planID');
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: kDisableColor.withOpacity(0.3),
                                                      ),
                                                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                        Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                                propertyRentOrBuyPlans[index]
                                                                        .planName
                                                                        .en
                                                                        .split('%')
                                                                        .first +
                                                                    '%',
                                                                style: Responsive.isDesktop(context)
                                                                    ? TS.miniestHeaderBlack
                                                                    : MS.lableBlack)),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                                propertyRentOrBuyPlans[index]
                                                                    .planName
                                                                    .en
                                                                    .split('-')
                                                                    .last
                                                                    .trim(),
                                                                style: Responsive.isDesktop(context)
                                                                    ? TS.miniestHeaderBlack
                                                                    : MS.lableBlack)),
                                                        Spacer(
                                                          flex: 2,
                                                        ),
                                                        Expanded(child: Container())
                                                      ]),
                                                    ),
                                                  );
                                                } else
                                                  return Container();
                                              }),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Insets.med,
                                      ),

                                      //*************************** Rent Plan

                                      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                              child: Text('Rent Plan',
                                                  style: Responsive.isDesktop(context)
                                                      ? TS.miniestHeaderBlack
                                                      : MS.lableBlack),
                                            )),
                                      ]),
                                      SizedBox(
                                        height: Insets.med,
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: propertyRentOrBuyPlans.length,
                                              itemBuilder: (context, index) {
                                                if (propertyRentOrBuyPlans[index].planType == PlanType.RENT) {
                                                  return InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        planID = propertyRentOrBuyPlans[index].planId.toString();
                                                        isBuySelected = false;
                                                        rentDuration =
                                                            propertyRentOrBuyPlans[index].planName.en.split('%').last;
                                                      });
                                                      print('#log =========> Plan Id : $planID');
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: kDisableColor.withOpacity(0.3),
                                                      ),
                                                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                                                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                        Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                                "AED ${propertyRentOrBuyPlans[index].price.toString()}",
                                                                style: Responsive.isDesktop(context)
                                                                    ? TS.miniestHeaderBlack
                                                                    : MS.lableBlack)),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                                propertyRentOrBuyPlans[index]
                                                                    .planName
                                                                    .en
                                                                    .split('%')
                                                                    .last,
                                                                style: Responsive.isDesktop(context)
                                                                    ? TS.miniestHeaderBlack
                                                                    : MS.lableBlack)),
                                                        Spacer(
                                                          flex: 2,
                                                        ),
                                                        Expanded(
                                                          child: Icon(
                                                            Icons.check,
                                                            color: planID ==
                                                                    propertyRentOrBuyPlans[index].planId.toString()
                                                                ? kSupportBlue
                                                                : kDisableColor,
                                                          ),
                                                        )
                                                      ]),
                                                    ),
                                                  );
                                                } else
                                                  return Container();
                                              }),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Insets.med,
                                  ),

                                  //********************** Place Offer Section
                                  _header,
                                  SizedBox(
                                    height: Insets.med,
                                  ),
                                  //  OFFER BODY
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Enter your counter offer.",
                                            textAlign: TextAlign.center,
                                            style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: Insets.med,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Offer Price", style: TextStyles.body14.copyWith(color: kLightBlue)),
                                          SizedBox(height: 4),
                                          PrimaryTextField(
                                              suffixIcon: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    isBuySelected ? '' : "/$rentDuration   ",
                                                    style: Responsive.isDesktop(context) ? TS.bodyBlack : MS.bodyBlack,
                                                  ),
                                                ],
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter.deny(RegExp('[a-zA-Z]')),
                                              ],
                                              text: "",
                                              controller: offer,
                                              onChanged: (email) {}),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),

                              //********************** Buttons
                              SizedBox(
                                height: Insets.xl,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  PrimaryButton(
                                    onTap: () {
                                      onCancel!();
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
                                      if (isBuySelected) {
                                        if (offer.text != "") {
                                          onPlace!(firstBuyingId, offer.text);
                                        }
                                      } else {
                                        if (planID != '' && offer.text != '') {
                                          onPlace!(planID, offer.text);
                                        }
                                      }
                                    },
                                    text: "Place Offer",
                                    height: 45,
                                    width: 110,
                                    fontSize: 12,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                                onTap: () {
                                  onCancel!();
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
          );
        });
      });
}
