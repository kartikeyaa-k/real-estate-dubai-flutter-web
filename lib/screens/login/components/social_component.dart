import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/custom_icon_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../routes/routes.dart';
import '../../signup/signup_screen.dart';
import '../cubit/login_cubit.dart';

class SocailComponent extends StatelessWidget {
  const SocailComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Center(child: Text("With Your Social Accounts", style: TextStyles.body12.copyWith(color: kLightBlue))),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CustomIconButton(child: Image.asset('assets/app/facebook.png')),
            // SizedBox(width: 20),
            CustomIconButton(
              child: Image.asset('assets/app/google.png'),
              onTap: () => context.read<LoginCubit>().logInWithGoogle(),
            ),
          ],
        ),
        SizedBox(height: 20),
        InkWell(
          onTap: () {
            context.vRouter.to(SignupPath);
          },
          child: FittedBox(
            child: Text.rich(
              TextSpan(
                text: "Don't Have an Account? ",
                style: TextStyles.body12.copyWith(color: kLightBlue),
                children: [
                  if (Responsive.isTablet(context))
                    TextSpan(
                      text: "Create account",
                      style: TextStyles.h6.copyWith(color: kSupportBlue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.vRouter.to(SignupPath);
                        },
                    )
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
