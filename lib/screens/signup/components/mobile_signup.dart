import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';
import 'switch_account_text.dart';

// class MobileSignup extends StatefulWidget {
//   const MobileSignup({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _MobileSignupState createState() => _MobileSignupState();
// }

// class _MobileSignupState extends State<MobileSignup> {
//   late TextEditingController _phoneNumber;

//   @override
//   void initState() {
//     super.initState();
//     _phoneNumber = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _phoneNumber.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bool layoutChangeCondition = Responsive.isTablet(context) && !Responsive.isLandscape(context);

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Mobile", style: TextStyles.body14.copyWith(color: kLightBlue)),
//         SizedBox(height: 4),
//         PrimaryTextField(controller: _phoneNumber, text: "+832347358435"),
//         SizedBox(height: 20),
//         PrimaryButton(
//           onTap: () {},
//           text: "Next",
//           width: double.infinity,
//         ),
//         SizedBox(height: 20),
//         if (layoutChangeCondition) SwitchAccountText()
//       ],
//     );
//   }
// }
