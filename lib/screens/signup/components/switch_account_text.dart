import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/vrouter.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';

class SwitchAccountText extends StatelessWidget {
  const SwitchAccountText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text.rich(
        TextSpan(
          text: "Already have an Account? ",
          style: TextStyles.body14.copyWith(color: kLightBlue),
          children: [
            TextSpan(
              text: "Sign in",
              style: TextStyles.h5.copyWith(color: kSupportBlue),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  context.vRouter.to(LoginPath);
                },
            )
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
