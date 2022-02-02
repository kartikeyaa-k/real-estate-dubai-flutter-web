import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

import '../../../components/buttons/custom_icon_button.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../login/cubit/login_cubit.dart';

class SocailComponent extends StatelessWidget {
  const SocailComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool layoutChangeCondition = Responsive.isTablet(context) && !Responsive.isLandscape(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (layoutChangeCondition) ...[
          // Center(child: Text("With Your Social Accounts", style: TextStyles.body12.copyWith(color: kLightBlue))),
          // SizedBox(height: 5),
        ],
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
        if (layoutChangeCondition)
          FittedBox(
            child: Text.rich(
              TextSpan(
                text: "Already Have an Account? ",
                style: TextStyles.body12.copyWith(color: kLightBlue),
                children: [
                  if (Responsive.isTablet(context))
                    TextSpan(
                      text: "Sign in",
                      style: TextStyles.h6.copyWith(color: kSupportBlue),
                      recognizer: TapGestureRecognizer()..onTap = () => context.vRouter.to(LoginPath),
                    )
                ],
              ),
              textAlign: TextAlign.center,
            ),
          )
        else
          Text.rich(
            TextSpan(
              text: "By clicking on register, you agree to the ",
              style: TextStyles.body12.copyWith(color: kBlackVariant),
              children: [
                TextSpan(
                  text: "Terms and Conditions",
                  style: TextStyles.body12.copyWith(color: kSupportBlue),
                  recognizer: TapGestureRecognizer()..onTap = () => context.vRouter.to(LoginPath),
                ),
                TextSpan(
                  text: " , ",
                  style: TextStyles.body12.copyWith(color: kBlackVariant),
                ),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyles.body12.copyWith(color: kSupportBlue),
                  recognizer: TapGestureRecognizer()..onTap = () => context.vRouter.to(LoginPath),
                ),
                TextSpan(
                  text: " , ",
                  style: TextStyles.body12.copyWith(color: kBlackVariant),
                ),
                TextSpan(
                  text: "Acceptable user policy",
                  style: TextStyles.body12.copyWith(color: kSupportBlue),
                  recognizer: TapGestureRecognizer()..onTap = () => context.vRouter.to(LoginPath),
                ),
                TextSpan(
                  text: " , ",
                  style: TextStyles.body12.copyWith(color: kBlackVariant),
                ),
                TextSpan(
                  text: "Cookie policy",
                  style: TextStyles.body12.copyWith(color: kSupportBlue),
                  recognizer: TapGestureRecognizer()..onTap = () => context.vRouter.to(LoginPath),
                ),
                TextSpan(
                  text: " , ",
                  style: TextStyles.body12.copyWith(color: kBlackVariant),
                ),
                TextSpan(
                  text: "Disclaimer",
                  style: TextStyles.body12.copyWith(color: kSupportBlue),
                  recognizer: TapGestureRecognizer()..onTap = () => context.vRouter.to(LoginPath),
                ),
                TextSpan(
                  text: " , ",
                  style: TextStyles.body12.copyWith(color: kBlackVariant),
                ),
                TextSpan(
                  text: "Refund policy",
                  style: TextStyles.body12.copyWith(color: kSupportBlue),
                  recognizer: TapGestureRecognizer()..onTap = () => context.vRouter.to(LoginPath),
                ),
                TextSpan(
                  text: " and ",
                  style: TextStyles.body12.copyWith(color: kBlackVariant),
                ),
                TextSpan(
                  text: "DCMA Policy",
                  style: TextStyles.body12.copyWith(color: kSupportBlue),
                  recognizer: TapGestureRecognizer()..onTap = () => context.vRouter.to(LoginPath),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
      ],
    );
  }
}
