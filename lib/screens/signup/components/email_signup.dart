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
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../cubit/signup_cubit.dart';
import 'switch_account_text.dart';

class EmailSignup extends StatefulWidget {
  const EmailSignup({
    Key? key,
  }) : super(key: key);

  @override
  _EmailSignupState createState() => _EmailSignupState();
}

class _EmailSignupState extends State<EmailSignup> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final bool layoutChangeCondition = Responsive.isTablet(context) && !Responsive.isLandscape(context);

    return BlocListener<SignUpCubit, SignUpState>(
      listener: (_, state) async {
        if (state.status.isSubmissionFailure) {
          final errorSnackBar = CustomSnackBar.errorSnackBar(state.errorMessage ?? "Unexpected error");
          ScaffoldMessenger.of(context)
              .showSnackBar(errorSnackBar)
              .closed
              .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
        } else if (state.status.isSubmissionSuccess) {
          context.vRouter.to(SignupFormPath, queryParameters: context.vRouter.queryParameters);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EmailField(),
          _PasswordField(obscurePassword: _obscurePassword),
          _ConfirmPasswordField(obscurePassword: _obscurePassword),
          _SignupButton(),
          if (layoutChangeCondition) SwitchAccountText()
        ],
      ),
    );
  }
}

class _SignupButton extends StatelessWidget {
  const _SignupButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        return PrimaryElevatedButton(
          onTap: () => context.read<SignUpCubit>().signUpFormSubmitted(),
          text: "Next",
          disabled: !state.status.isValidated,
          isLoading: state.status.isSubmissionInProgress,
        );
      },
    );
  }
}

class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField({
    Key? key,
    required bool obscurePassword,
  })  : _obscurePassword = obscurePassword,
        super(key: key);

  final bool _obscurePassword;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Confirm Password",
          style: TextStyles.body14.copyWith(color: kLightBlue),
        ),
        SizedBox(height: 4),
        BlocBuilder<SignUpCubit, SignUpState>(
          buildWhen: (previous, current) =>
              previous.password != current.password || previous.confirmedPassword != current.confirmedPassword,
          builder: (context, state) {
            return PrimaryTextField(
              text: "******",
              obscureText: _obscurePassword,
              onChanged: (confirmPassword) => context.read<SignUpCubit>().confirmedPasswordChanged(confirmPassword),
              errorText: state.confirmedPassword.invalid ? 'passwords do not match' : null,
            );
          },
        ),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    Key? key,
    required bool obscurePassword,
  })  : _obscurePassword = obscurePassword,
        super(key: key);

  final bool _obscurePassword;

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
        BlocBuilder<SignUpCubit, SignUpState>(
          buildWhen: (previous, current) => previous.password != current.password,
          builder: (context, state) {
            return PrimaryTextField(
                text: "******",
                onChanged: (password) => context.read<SignUpCubit>().passwordChanged(password),
                obscureText: _obscurePassword,
                errorText: state.password.invalid ? 'min 8 characters' : null);
          },
        ),
      ],
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
        Text(
          "Email Address",
          style: TextStyles.body14.copyWith(color: kLightBlue),
        ),
        SizedBox(height: 4),
        PrimaryTextField(
          inputFormatters: [FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))],
          onChanged: (email) => context.read<SignUpCubit>().emailChanged(email),
          keyboardType: TextInputType.emailAddress,
          text: "example@example.com",
        )
      ],
    );
  }
}
