import 'package:flutter/material.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../../core/utils/app_responsive.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../routes/routes.dart';

class EnquirySubmittedSuccessDialog extends StatelessWidget {
  const EnquirySubmittedSuccessDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
    Widget _headerSubheader = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Request Submitted successfully", textAlign: TextAlign.center, style: TextStyles.h2),
        SizedBox(height: Insets.xs),
        Text(
          "Our team will get back to you after processing your request.",
          textAlign: TextAlign.center,
          style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
        ),
        SizedBox(height: Insets.sm),

        // calendar and time slot row
      ],
    );
    Widget body = SizedBox(
      height: Responsive.isDesktop(context) ? hp(30) : hp(24),
      width: Responsive.isDesktop(context) ? wp(20) : wp(35),
      child: Image.asset(
        'assets/gifs/success.gif',
        fit: BoxFit.cover,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Dialog(
        child: Container(
          height: Responsive.isDesktop(context) ? hp(50) : hp(50),
          width: Responsive.isDesktop(context) ? wp(32) : wp(60),
          alignment: Alignment.center,
          padding: EdgeInsets.all(Insets.xl),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: Responsive.isDesktop(context) ? 5 : 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    body,
                    SizedBox(height: Insets.sm),
                    _headerSubheader,
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {
                      context.vRouter.to(
                        HomePath,
                      );
                    },
                    child: Icon(Icons.close, size: 20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
