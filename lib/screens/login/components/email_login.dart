import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../components/snack_bar/custom_snack_bar.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import '../cubit/login_cubit.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({
    Key? key,
  }) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          SnackBar snackBar = CustomSnackBar.errorSnackBar(
              state.errorMessage ?? "Unexpected failure occured at login. Please try again after sometime.");

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        } else if (state.status.isSubmissionSuccess) {
          print("user credential in listener ${state.isNewUser}");
          if (state.isNewUser) {
            context.vRouter.to(SignupFormPath);
          } else {
            final redirectPath = context.vRouter.queryParameters['redirect'];

            if (redirectPath == null || redirectPath.isEmpty) {
              context.vRouter.to(HomePath);
            } else {
              // Taking id from property listing screen and passing it to Property details

              if (redirectPath == AvailableTimeSlotDialogPath) {
                String? property_id;
                property_id = context.vRouter.queryParameters['property_id'];

                context.vRouter.to(redirectPath, queryParameters: {"property_id": property_id ?? ""});
              } else if (redirectPath == FacilityManagementPath) {
                context.vRouter.to(redirectPath, queryParameters: {"amcType": context.vRouter.queryParameters['amcType'] ?? ""});
              } else {
                context.vRouter.to(redirectPath);
              }
            }
          }
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EmailField(),
          _PasswordField(),
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() => _rememberMe = value!);
                },
              ),
              Text(
                "Remember Me",
                style: TextStyles.body14.copyWith(
                  color: kBlackVariant,
                ),
              ),
              Spacer(),
              Text(
                "Forgot Password?",
                style: TextStyles.body14.copyWith(
                  color: kSupportBlue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          _LoginButton()
        ],
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Email Address", style: TextStyles.body14.copyWith(color: kLightBlue)),
        SizedBox(height: 4),
        PrimaryTextField(
          inputFormatters: [FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))],
          text: "example@example.com",
          onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current Password",
          style: TextStyles.body14.copyWith(color: kLightBlue),
        ),
        SizedBox(height: 4),
        BlocBuilder<LoginCubit, LoginState>(
          buildWhen: (previous, current) => previous.password != current.password,
          builder: (context, state) {
            return PrimaryTextField(
              obscureText: true,
              text: "******",
              onChanged: (password) => context.read<LoginCubit>().passwordChanged(password),
              errorText: state.password.invalid ? 'min 8 characters' : null,
            );
          },
        ),
      ],
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return PrimaryElevatedButton(
          onTap: () => context.read<LoginCubit>().logInWithCredentials(),
          text: "Login",
          disabled: !state.status.isValidated,
          isLoading: state.status.isSubmissionInProgress,
        );
      },
    );
  }
}
