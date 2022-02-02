import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/snack_bar/custom_snack_bar.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:real_estate_portal/screens/property_detail/cubit/offer_cubit.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../injection_container.dart';

class DeclineOfferDialog extends StatelessWidget {
  const DeclineOfferDialog({Key? key, required this.propertyId}) : super(key: key);
  final String propertyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OfferCubit>(
        create: (context) => sl<OfferCubit>(), child: DeclineOfferView(propertyId: propertyId));
  }
}

class DeclineOfferView extends StatefulWidget {
  const DeclineOfferView({
    Key? key,
    required this.propertyId,
  }) : super(key: key);
  final String propertyId;

  @override
  State<DeclineOfferView> createState() => _DeclineOfferViewState();
}

class _DeclineOfferViewState extends State<DeclineOfferView> {
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
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
    Widget _header = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Confirmation", textAlign: TextAlign.left, style: TextStyles.h2),
      ],
    );
    Widget _body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                "Do you want to proceed. Instead try negotiating by placing a counter offer.",
                style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
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
            Navigator.pop(context);
            //   context.vRouter
            //       .to(ProjectDetailScreenPath, queryParameters: {"id": context.vRouter.queryParameters["property_id"] as String});
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
            context.read<OfferCubit>().declineOffer(widget.propertyId);
          },
          text: "Confirm",
          height: 45,
          width: 110,
          fontSize: 12,
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocListener<OfferCubit, OfferState>(
              listener: (context, state) {
                if (state is LDeclineOffer) {
                } else if (state is FDeclineOffer) {
                  SnackBar snackBar = CustomSnackBar.errorSnackBar(state.failure.errorMessage.isEmpty
                      ? state.failure.errorMessage
                      : "Unexpected failure occured at login. Please try again after sometime.");
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                } else if (state is SDeclineOffer) {
                  SnackBar snackBar = CustomSnackBar.errorSnackBar("Declined Offer.");
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(snackBar);
                  Navigator.pop(context);
                  // context.vRouter.to(ProjectDetailScreenPath,
                  //   queryParameters: {"id": context.vRouter.queryParameters["property_id"] as String});
                }
              },
              child: SizedBox(
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
                          _btns,
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
                              // context.vRouter.to(ProjectDetailScreenPath, queryParameters: {"id": widget.propertyId});
                            },
                            child: Icon(Icons.close, size: 20)),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
