import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../components/snack_bar/custom_snack_bar.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import '../../../routes/routes.dart';
import '../cubit/phone_login_cubit.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({
    Key? key,
  }) : super(key: key);

  @override
  _MobileLoginState createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  late Widget _switchableWidget;

  @override
  void initState() {
    super.initState();
    _switchableWidget = _PhoneColumn();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneLoginCubit, PhoneLoginState>(
      listener: (context, state) {
        switch (state.status) {
          case PhoneAuthStatus.phoneSubmissionFailure:
            SnackBar snackBar =
                CustomSnackBar.errorSnackBar("Unexpected failure occured at login. Please try again after sometime.");

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
            break;
          case PhoneAuthStatus.phoneSubmissionSuccess:
            setState(() {
              _switchableWidget = _OTPLogin();
            });
            break;
          case PhoneAuthStatus.otpSubmissionFailure:
            SnackBar snackBar =
                CustomSnackBar.errorSnackBar("Unexpected failure occured at login. Please try again after sometime.");

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
            break;
          case PhoneAuthStatus.otpSubmissionSuccess:
            if (state.userCredential != null && state.userCredential!.additionalUserInfo!.isNewUser) {
              context.vRouter.to(SignupFormPath);
            } else {
              final redirectPath = context.vRouter.queryParameters['redirect'];
              if (redirectPath == null || redirectPath.isEmpty) {
                context.vRouter.to(HomePath);
              } else {
                if (redirectPath == AvailableTimeSlotDialogPath) {
                  String? property_id;
                  property_id = context.vRouter.queryParameters['property_id'];
                  context.vRouter.to(redirectPath, queryParameters: {"property_id": property_id ?? ""});
                } else if (redirectPath == FacilityManagementPath) {
                  context.vRouter
                      .to(redirectPath, queryParameters: {"amcType": context.vRouter.queryParameters['amcType'] ?? ""});
                } else {
                  context.vRouter.to(redirectPath);
                }
              }
            }
            break;
          default:
            break;
        }
      },
      child: AnimatedSwitcher(
        duration: Times.fast,
        child: _switchableWidget,
      ),
    );
  }
}

// ======================================================================
// Phone number section
// ======================================================================

// Phone number and submission button
class _PhoneColumn extends StatelessWidget {
  const _PhoneColumn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Mobile", style: TextStyles.body14.copyWith(color: kLightBlue)),
        SizedBox(height: 4),
        _PhoneNumberField(),
        SizedBox(height: 20),
        _SubmitPhoneNumberButton(),
      ],
    );
  }
}

class _PhoneNumberField extends StatelessWidget {
  const _PhoneNumberField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initialCountry = 'AE';
    PhoneNumber number = PhoneNumber(isoCode: 'AE');
    return BlocBuilder<PhoneLoginCubit, PhoneLoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return InternationalPhoneNumberInput(
          onInputChanged: (phone) => context
              .read<PhoneLoginCubit>()
              .phoneNumberChanged("${phone.dialCode}${phone.parseNumber().replaceAll(" ", "")}"),
          onInputValidated: (value) => context.read<PhoneLoginCubit>().phoneNumberValidate(value),
          initialValue: number,
          spaceBetweenSelectorAndTextField: Insets.sm,
          keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
          inputBorder: OutlineInputBorder(),
          selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.DROPDOWN),
          errorMessage: state.status == PhoneAuthStatus.phoneInvalid ? 'invalid mobile number' : null,
        );
      },
    );
  }
}

class _SubmitPhoneNumberButton extends StatelessWidget {
  const _SubmitPhoneNumberButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneLoginCubit, PhoneLoginState>(
      builder: (context, state) {
        return PrimaryElevatedButton(
          onTap: () => context.read<PhoneLoginCubit>().phoneNumberSubmitted(),
          text: "Next",
          disabled: !(state.status == PhoneAuthStatus.phoneValid),
          isLoading: state.status == PhoneAuthStatus.phoneSubmissionInProgress,
        );
      },
    );
  }
}

// ======================================================================
// OTP Section
// ======================================================================

class _OTPLogin extends StatefulWidget {
  const _OTPLogin({
    Key? key,
  }) : super(key: key);

  @override
  _OTPLoginState createState() => _OTPLoginState();
}

class _OTPLoginState extends State<_OTPLogin> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("OTP", style: TextStyles.body14.copyWith(color: kLightBlue)),
        SizedBox(height: 4),
        _OTPField(),
        SizedBox(height: 20),
        Row(
          children: [
            Text("Didn’t Recieve OTP", style: TextStyles.body14.copyWith(color: kBlackVariant)),
            Spacer(),
            Text("Resend OTP",
                style: TextStyles.body14.copyWith(color: kSupportBlue, decoration: TextDecoration.underline))
          ],
        ),
        SizedBox(height: 20),
        _SubmitOTPButton(),
        SizedBox(height: 20)
      ],
    );
  }
}

class _OTPField extends StatelessWidget {
  const _OTPField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      text: "Enter OTP",
      keyboardType: TextInputType.number,
      onChanged: (otp) => context.read<PhoneLoginCubit>().onOTPChanged(otp),
    );
  }
}

class _SubmitOTPButton extends StatelessWidget {
  const _SubmitOTPButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneLoginCubit, PhoneLoginState>(
      builder: (context, state) {
        return PrimaryElevatedButton(
          onTap: () => context.read<PhoneLoginCubit>().confirmOTPCode(),
          text: "Login",
          disabled: !(state.status == PhoneAuthStatus.otpValid),
          isLoading: state.status == PhoneAuthStatus.otpSubmissionInProgress,
        );
      },
    );
  }
}
