import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/input_fields/primary_dropdown_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../components/snack_bar/custom_snack_bar.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import '../../../routes/routes.dart';
import '../signup_form_bloc/signup_form_bloc.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  // late TextEditingController _phoneController;

  String _phoneNumber = "";
  bool _phoneValid = false;
  String? gender;
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    _firstNameController = TextEditingController(text: user?.displayName);
    _lastNameController = TextEditingController();
    _emailController = TextEditingController(text: user?.email);
    // _phoneController = TextEditingController(text: user?.phoneNumber);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    // _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool layoutChangeCondition = Responsive.isTablet(context) && !Responsive.isLandscape(context);
    final size = MediaQuery.of(context).size;
    // screen width - padding for tablets - half of runSpacing
    final double width = layoutChangeCondition ? (size.width / 2) - (Insets.lg) - 10 : size.width;

    List<Widget> _formFields = [
      Wrap(
        direction: Axis.horizontal,
        runSpacing: 20,
        spacing: 20,
        children: [
          _singleBlock(
            text: "First Name",
            child: PrimaryTextField(
              controller: _firstNameController,
              text: "First Name",
              onChanged: (value) => context.read<SignupFormBloc>().add(SignupFormChanged(
                  firstName: value,
                  lastName: _lastNameController.text,
                  email: _emailController.text,
                  gender: gender,
                  phoneNumber: _phoneNumber,
                  phoneValid: _phoneValid)),
            ),
            width: width,
          ),
          _singleBlock(
            text: "Last Name",
            child: PrimaryTextField(
              controller: _lastNameController,
              text: "Last Name",
              onChanged: (value) {
                context.read<SignupFormBloc>().add(SignupFormChanged(
                    firstName: _firstNameController.text,
                    lastName: value,
                    email: _emailController.text,
                    gender: gender,
                    phoneNumber: _phoneNumber,
                    phoneValid: _phoneValid));
              },
            ),
            width: width,
          ),
          _singleBlock(
            text: "Email",
            child: PrimaryTextField(
              controller: _emailController,
              readOnly: user?.email != null && user!.email!.isNotEmpty,
              inputFormatters: [FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s"))],
              text: "Email",
              onChanged: (value) => context.read<SignupFormBloc>().add(SignupFormChanged(
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  email: value,
                  gender: gender,
                  phoneNumber: _phoneNumber,
                  phoneValid: _phoneValid)),
            ),
            width: width,
          ),
          _singleBlock(
            text: "Mobile Number",
            child: BlocBuilder<SignupFormBloc, SignupFormState>(
              builder: (context, state) {
                return InternationalPhoneNumberInput(
                  // textFieldController: _phoneController,
                  onInputChanged: (phone) {
                    _phoneNumber = "${phone.dialCode}${phone.parseNumber().replaceAll(" ", "")}";
                    context.read<SignupFormBloc>().add(SignupFormChanged(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        gender: gender,
                        phoneNumber: "${phone.dialCode}${phone.parseNumber()}",
                        phoneValid: phone.parseNumber().length > 2));
                  },
                  onInputValidated: (value) {
                    // _phoneValid = value;
                    _phoneValid = _phoneNumber.length > 2;
                    context.read<SignupFormBloc>().add(SignupFormChanged(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        gender: gender,
                        phoneNumber: _phoneNumber,
                        phoneValid: _phoneValid));
                  },
                  countries: [
                    'AE',
                    // 'IN',
                  ],
                  spaceBetweenSelectorAndTextField: Insets.sm,
                  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                  inputBorder: OutlineInputBorder(),
                  selectorConfig: SelectorConfig(selectorType: PhoneInputSelectorType.DROPDOWN),
                  autoValidateMode: AutovalidateMode.disabled,
                  ignoreBlank: true,
                  formatInput: false,
                );
              },
            ),
            width: width,
          ),
          _singleBlock(
            text: "Gender",
            child: PrimaryDropdownButton<String>(
              hint: "Select gender",
              itemList: [
                DropdownMenuItem(child: Text("Male"), value: 'MALE'),
                DropdownMenuItem(child: Text("Female"), value: 'FEMALE'),
              ],
              value: gender,
              onChanged: (String? value) {
                gender = value;
                context.read<SignupFormBloc>().add(SignupFormChanged(
                    firstName: _firstNameController.text,
                    lastName: _lastNameController.text,
                    email: _emailController.text,
                    gender: value,
                    phoneNumber: _phoneNumber,
                    phoneValid: _phoneValid));
              },
            ),
            width: width,
          )
        ],
      )
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Personal Details", style: TextStyles.h4.copyWith(color: kBlackVariant)),
        SizedBox(height: 40),
        ..._formFields,
        Spacer(),
        BlocConsumer<SignupFormBloc, SignupFormState>(
          listener: (_, state) async {
            if (state is SignupFormFailure) {
              final errorSnackBar = CustomSnackBar.errorSnackBar(state.failureMessage);
              ScaffoldMessenger.of(context)
                  .showSnackBar(errorSnackBar)
                  .closed
                  .then((value) => ScaffoldMessenger.of(context).clearSnackBars());
            } else if (state is SignupFormSucessful) {
              // FIXME: change from anonymous routing to navigator 2.0
              context.vRouter.to(EmailVerificationPath, queryParameters: context.vRouter.queryParameters);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => EmailVerificationScreen(),
              //   ),
              // );
            }
          },
          builder: (_, state) {
            return PrimaryElevatedButton(
              onTap: () {
                context.read<SignupFormBloc>().add(
                      SignupFormButtonClicked(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text,
                        gender: gender,
                        phoneNumber: _phoneNumber,
                      ),
                    );
              },
              text: "Next",
              disabled: state.disabled,
              isLoading: state.isLoading,
            );
          },
        ),
        // if (!Responsive.isDesktop(context)) Spacer()
      ],
    );
  }

  Column _singleBlock(
      {required String text, required Widget child, double width = double.infinity, double height = 48}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: TextStyles.body14.copyWith(color: kLightBlue)),
        SizedBox(height: 4),
        Container(width: width, height: height, child: child),
      ],
    );
  }
}
