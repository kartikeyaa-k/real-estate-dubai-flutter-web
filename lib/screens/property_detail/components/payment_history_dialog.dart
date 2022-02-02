import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/models/response_models/payment_history_response_models/payment_history_response_model.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../../core/utils/app_responsive.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../models/property_details_models/property_model.dart';
import '../../../routes/routes.dart';

Widget _header = Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    Text("Payment Details", textAlign: TextAlign.left, style: TextStyles.h2),
  ],
);

Widget _buyPaidRow(BuildContext context, String price, String date, String receipt) {
  return Container(
    decoration: BoxDecoration(
      color: kDisableColor.withOpacity(0.3),
    ),
    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(flex: 2, child: Text(price, style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
      Expanded(flex: 2, child: Text(date, style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
      Expanded(
          flex: 2,
          child: Text('Paid' + '%',
              style: Responsive.isDesktop(context)
                  ? TS.miniestHeaderBlack.copyWith(color: kSupportGreen)
                  : MS.lableBlack.copyWith(color: kSupportGreen))),
      Expanded(
          flex: 2,
          child: PrimaryButton(
            onTap: () {
              context.vRouter.toExternal(receipt, openNewTab: true);
            },
            text: 'Download Invoice',
            backgroundColor: kSupportBlue,
            color: kPlainWhite,
          )),
    ]),
  );
}

Widget _rentDueRow(BuildContext context, String price, String date) {
  return Container(
    decoration: BoxDecoration(
      color: kDisableColor.withOpacity(0.3),
    ),
    padding: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
    child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Expanded(flex: 2, child: Text(price, style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
      Expanded(flex: 2, child: Text(date, style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
      Expanded(
          flex: 2,
          child: Text('Due',
              style: Responsive.isDesktop(context)
                  ? TS.miniestHeaderBlack.copyWith(color: kErrorColor)
                  : MS.lableBlack.copyWith(color: kErrorColor))),
      Expanded(
          flex: 2,
          child: Text('',
              style: Responsive.isDesktop(context)
                  ? TS.miniestHeaderBlack.copyWith(color: kErrorColor)
                  : MS.lableBlack.copyWith(color: kErrorColor))),
    ]),
  );
}

Widget _body(context, PaymentHistoryModelResponseModel paymentHistoryModelResponseModel) {
  print('#log : payment history ==========>> ${paymentHistoryModelResponseModel.paymentHistoryModel})');
  String price = '123';

  List<PaymentHistoryModel> notPaid = [];
  List<PaymentHistoryModel> paid = [];

  paymentHistoryModelResponseModel.paymentHistoryModel.forEach((element) {
    if (element.receipt == null) {
      notPaid.add(element);
    }
  });
  paymentHistoryModelResponseModel.paymentHistoryModel.forEach((element) {
    if (element.receipt != null) {
      paid.add(element);
    }
  });

  if (paymentHistoryModelResponseModel.paymentHistoryModel.isEmpty) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
          flex: 2,
          child: Text('No Payment Details Found', style: TS.bodyBlack.copyWith(color: kSupportBlue)),
        )
      ]),
    ]);
  }
  print('#log : Buy Price =====> $price');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(flex: 2, child: Text('Rent Due', style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
      ]),
      SizedBox(
        height: Insets.med,
      ),
      SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: notPaid.length,
                itemBuilder: (context, index) {
                  return _rentDueRow(
                    context,
                    notPaid[index].amountPayable.toString(),
                    notPaid[index].period,
                  );
                }),
          ],
        ),
      ),
      SizedBox(
        height: Insets.med,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(
            flex: 2,
            child: Text('Payment History', style: Responsive.isDesktop(context) ? TS.miniestHeaderBlack : MS.lableBlack)),
      ]),
      SizedBox(
        height: Insets.med,
      ),
      SizedBox(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: paid.length,
                  itemBuilder: (context, index) {
                    return _buyPaidRow(
                        context, paid[index].amountPayable.toString(), paid[index].period, paid[index].receipt.toString());
                  }),
            ],
          ),
        ),
      ),
      // _rentPlanRow,
    ],
  );
}

showPaymentHistoryDialg(
    {required BuildContext context, required PaymentHistoryModelResponseModel paymentHistoryModelResponseModel}) {
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
                    width: wp(80),
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
                                  _body(context, paymentHistoryModelResponseModel)
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
                            child: GestureDetector(
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
