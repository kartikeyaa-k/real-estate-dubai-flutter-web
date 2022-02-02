import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_dropdown_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_text_field.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

class PaymentPlansDialog extends StatefulWidget {
  const PaymentPlansDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentPlansDialog> createState() => _PaymentPlansDialogState();
}

class _PaymentPlansDialogState extends State<PaymentPlansDialog> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get id from url and load data
    // if id is missing redirect to [PropertyListingScreen]
    if (!context.vRouter.queryParameters.keys.contains("property_id")) {
    } else {
      int propertyId = int.parse(context.vRouter.queryParameters["property_id"] as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
    Widget _header = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Payment Plans", textAlign: TextAlign.left, style: TextStyles.h2),
      ],
    );

    Widget _buyPlanRow = Container(
      decoration: BoxDecoration(
        color: kDisableColor.withOpacity(0.3),
      ),
      padding: EdgeInsets.all(2),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(flex: 2, child: Text('\$1200', style: TS.miniestHeaderBlack)),
        Expanded(flex: 3, child: Text('Tag Name', style: TS.miniestHeaderBlack)),
        Expanded(flex: 5, child: Text('30%', style: TS.miniestHeaderBlack)),
      ]),
    );
    Widget _rentPlanRow = Container(
      decoration: BoxDecoration(
        color: kDisableColor.withOpacity(0.3),
      ),
      padding: EdgeInsets.all(2),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Expanded(flex: 1, child: Text('\$1200', style: TS.miniestHeaderBlack)),
        Expanded(flex: 4, child: Text('Tag Name', style: TS.miniestHeaderBlack)),
      ]),
    );

    Widget _body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(flex: 4, child: Text('Buy Plan', style: TS.miniHeaderBlack)),
        ]),
        SizedBox(
          height: Insets.med,
        ),
        _buyPlanRow,
        SizedBox(
          height: Insets.med,
        ),
        _rentPlanRow,
      ],
    );

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
                            _body
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
                            context.vRouter.to(ProjectDetailScreenPath,
                                queryParameters: {"id": context.vRouter.queryParameters["property_id"] as String});
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
  }
}
