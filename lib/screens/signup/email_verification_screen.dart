import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/mobile_app_bar.dart';
import 'package:real_estate_portal/components/toolbar.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../components/buttons/primary_button.dart';
import '../../components/scaffold/primary_scaffold.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../routes/routes.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _shouldCenter = !Responsive.isDesktop(context);
    final double _desktopHeight = MediaQuery.of(context).size.height - Insets.footerSize;
    final double _otherHeight = MediaQuery.of(context).size.height - kToolbarHeight - kBottomNavigationBarHeight;

    var _welcomeCol = Column(
      crossAxisAlignment: _shouldCenter ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Welcome!',
          style: TextStyles.h3.copyWith(color: kBlackVariant),
        ),
        SizedBox(height: 20),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 425),
          child: Text(
            "Thanks for signing up! We just need you to verify your email address to complete setting up your account.",
            maxLines: 3,
            textAlign: _shouldCenter ? TextAlign.center : null,
            style: TextStyles.body18.copyWith(color: kBlackVariant),
          ),
        ),
        SizedBox(height: 20),
        PrimaryElevatedButton(
          text: "Continue",
          onTap: () {
            final redirectPath = context.vRouter.queryParameters['redirect'];

            if (redirectPath == null || redirectPath.isEmpty) {
              context.vRouter.to(HomePath);
            } else {
              // Taking id from property listing screen and passing it to Property details
              context.vRouter.to(redirectPath);
            }
          },
        ),
      ],
    );

    return PrimaryScaffold(
      appBar: Responsive.isMobile(context) ? MobileAppBar() : ToolBar(),
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: MediaQuery.of(context).size.width,
            height: Responsive.isDesktop(context) ? _desktopHeight : _otherHeight,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Flex(
                direction: _shouldCenter ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/app/email.png'),
                  SizedBox(width: 50, height: 20),
                  _welcomeCol,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
