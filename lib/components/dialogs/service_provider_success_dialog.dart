import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

Widget _headerSubheader = Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text("Request Submitted successfully",
        textAlign: TextAlign.center,
        style: TextStyles.h2),
    SizedBox(height: Insets.xs),
    Text(
      "Our team will get back to you after processing your request.",
      textAlign: TextAlign.center,
      style: TextStyles.body16.copyWith(
          color: kBlackVariant.withOpacity(0.7)),
    ),
    SizedBox(height: Insets.sm),

    // calendar and time slot row
  ],
);
Widget body(BuildContext context) {
  final Function wp =
      ScreenUtils(MediaQuery.of(context)).wp;
  final Function hp =
      ScreenUtils(MediaQuery.of(context)).hp;
  return SizedBox(
    height: Responsive.isDesktop(context)
        ? hp(30)
        : hp(24),
    width: Responsive.isDesktop(context)
        ? wp(20)
        : wp(35),
    child: Image.asset(
      'assets/gifs/success.gif',
      fit: BoxFit.cover,
    ),
  );
}

serviceProviderSuccessDialog(
    BuildContext context) {
  final Function wp =
      ScreenUtils(MediaQuery.of(context)).wp;
  final Function hp =
      ScreenUtils(MediaQuery.of(context)).hp;
  return showDialog(
      context: context,
      useSafeArea: false,
      barrierLabel: "asd",
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (context, setState) {
          return Scaffold(
            backgroundColor:
                Colors.black.withOpacity(0.7),
            body: Dialog(
              child: Container(
                height:
                    Responsive.isDesktop(context)
                        ? hp(50)
                        : hp(50),
                width:
                    Responsive.isDesktop(context)
                        ? wp(32)
                        : wp(60),
                alignment: Alignment.center,
                padding:
                    EdgeInsets.all(Insets.xl),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: Responsive
                                  .isDesktop(
                                      context)
                              ? 5
                              : 20),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .start,
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .center,
                        children: [
                          body(context),
                          SizedBox(
                              height: Insets.sm),
                          _headerSubheader,
                        ],
                      ),
                    ),
                    Align(
                      alignment:
                          Alignment.topRight,
                      child: InkWell(
                          onTap: () {
                            context.vRouter.to(
                              HomePath,
                            );
                          },
                          child: Icon(Icons.close,
                              size: 20)),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      });
}
