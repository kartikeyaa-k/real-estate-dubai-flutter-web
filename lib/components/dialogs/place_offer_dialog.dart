import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_text_field.dart';
import 'package:real_estate_portal/components/snack_bar/custom_snack_bar.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/injection_container.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:real_estate_portal/screens/property_detail/cubit/offer_cubit.dart';
import 'package:vrouter/src/core/extended_context.dart';

class AcceptOfferDialog extends StatelessWidget {
  const AcceptOfferDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OfferCubit>(create: (context) => sl<OfferCubit>(), child: AcceptOfferView());
  }
}

class AcceptOfferView extends StatefulWidget {
  const AcceptOfferView({
    Key? key,
  }) : super(key: key);

  @override
  State<AcceptOfferView> createState() => _AcceptOfferViewState();
}

class _AcceptOfferViewState extends State<AcceptOfferView> {
  TextEditingController offer = TextEditingController();
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
        Text("Confirmation", textAlign: TextAlign.left, style: TextStyles.h2),
      ],
    );
    Widget _body = Column(
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
                      '/year  ',
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
    );

    Widget _btns = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrimaryButton(
          onTap: () {
            context.vRouter
                .to(ProjectDetailScreenPath, queryParameters: {"id": context.vRouter.queryParameters["property_id"] as String});
         
         
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
            context.read<OfferCubit>().placeOffer(context.vRouter.queryParameters["property_id"] as String, offer.text);
          },
          text: "Place Offer",
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
                if (state is LPlaceOffer) {
                } else if (state is FPlaceOffer) {
                  SnackBar snackBar = CustomSnackBar.errorSnackBar(state.failure.errorMessage.isEmpty
                  ? state.failure.errorMessage
                  : "Unexpected failure occured at login. Please try again after sometime.");
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
                } else if (state is SPlaceOffer) {
         context.vRouter
                .to(ProjectDetailScreenPath, queryParameters: {"id": context.vRouter.queryParameters["property_id"] as String});
         
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
                              context.vRouter.to(ProjectDetailScreenPath,
                                  queryParameters: {"id": context.vRouter.queryParameters["property_id"] as String});
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
