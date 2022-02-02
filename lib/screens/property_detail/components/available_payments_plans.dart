import 'package:flutter/material.dart';

import '../../../core/utils/app_responsive.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../models/property_details_models/property_model.dart';

Widget _header = Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text("Payment Plans", textAlign: TextAlign.left, style: TextStyles.h2),
  ],
);

Widget _buyPlanRow(BuildContext context, String percentage, String name) {
  return Container(
    decoration: BoxDecoration(
      color: kDisableColor.withOpacity(0.3),
    ),
    padding: EdgeInsets.all(2),
    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          flex: 2,
          child: Text(percentage, style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
    ]),
  );
}

Widget _rentPlanRow(BuildContext context, String price, String name) {
  return Container(
    decoration: BoxDecoration(
      color: kDisableColor.withOpacity(0.3),
    ),
    padding: EdgeInsets.all(2),
    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(
          flex: 2,
          child:
              Text("AED $price/$name", style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
    ]),
  );
}

Widget _body(context, List<PropertyRentOrBuyPlan> propertyRentOrBuyPlans, String price) {
  print('#log : plans ==========>> ${propertyRentOrBuyPlans.toString()})');

  int rentPlanLen = 0;
  int buyPlanLen = 0;
  propertyRentOrBuyPlans.forEach((element) {
    if (element.planType == PlanType.BUY) {
      price = element.price.toString();
    }
  });
  if (propertyRentOrBuyPlans.isEmpty) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          flex: 2,
          child: Text('No Other Plans Found', style: TS.bodyBlack.copyWith(color: kSupportBlue)),
        )
      ]),
    ]);
  } else {
    propertyRentOrBuyPlans.forEach((element) {
      if (element.planType == PlanType.RENT) {
        rentPlanLen++;
      } else {
        buyPlanLen++;
      }
    });
  }
  print('#log : Buy Price =====> $price');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buyPlanLen != 0
          ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  flex: 2,
                  child:
                      Text('Buy Plan', style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
              Expanded(
                  flex: 4,
                  child:
                      Text("AED $price", style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
            ])
          : Container(),
      SizedBox(
        height: Insets.med,
      ),
      SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: propertyRentOrBuyPlans.length,
                itemBuilder: (context, index) {
                  if (propertyRentOrBuyPlans[index].planType == PlanType.BUY) {
                    return _buyPlanRow(context, propertyRentOrBuyPlans[index].planName.en, ""
                        // propertyRentOrBuyPlans[index].planName.en.split('-').last,
                        );
                  } else
                    return Container();
                }),
          ],
        ),
      ),
      SizedBox(
        height: Insets.med,
      ),
      rentPlanLen != 0
          ? Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Expanded(
                  flex: 2,
                  child:
                      Text('Rent Plan', style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
            ])
          : Container(),

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
                  return _rentPlanRow(
                    context,
                    propertyRentOrBuyPlans[index].price.toString(),
                    propertyRentOrBuyPlans[index].planName.en,
                  );
                } else
                  return Container();
              }),
        ],
      ),
      // _rentPlanRow,
    ],
  );
}

availablePaymentPlans(
    {required BuildContext context,
    required String price,
    required List<PropertyRentOrBuyPlan> propertyRentOrBuyPlans}) {
  final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
  double hp = MediaQuery.of(context).size.height;
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
                    width: wp(50),
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
                                  _header,
                                  SizedBox(
                                    height: Insets.med,
                                  ),
                                  _body(context, propertyRentOrBuyPlans, price)
                                ],
                              ),
                              SizedBox(
                                height: Insets.xl,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
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
