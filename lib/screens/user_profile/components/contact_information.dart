import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/primary_outlined_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class ContactInformation extends StatefulWidget {
  const ContactInformation({Key? key}) : super(key: key);

  @override
  _ContactInformationState createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
  late TextEditingController _emailController;
  late TextEditingController _mobileNumberController;
  late TextEditingController _emergencyContactNameController;
  late TextEditingController _emergencyContactController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _mobileNumberController = TextEditingController();
    _emergencyContactNameController = TextEditingController();
    _emergencyContactController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _mobileNumberController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Responsive.isMobile(context) ? null : EdgeInsets.all(Insets.xl),
      decoration: Responsive.isMobile(context)
          ? null
          : BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.1)), borderRadius: Corners.xlBorder),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _coupleTextBox(
            _createSingleTextBox(name: "Email", controller: _emailController),
            _createSingleTextBox(name: "Mobile Number", controller: _mobileNumberController),
          ),
          SizedBox(height: Insets.xl),
          _coupleTextBox(
            _createSingleTextBox(name: "Emergency Contact Name", controller: _emergencyContactNameController),
            _createSingleTextBox(name: "Emergency Contact Number", controller: _emergencyContactController),
          ),
          SizedBox(height: Insets.xl),
          Row(
            children: [
              Spacer(),
              PrimaryOutlinedButton(onTap: () {}, text: "Cancel"),
              SizedBox(width: Insets.xl),
              PrimaryButton(onTap: () {}, text: "Save Changes", width: null)
            ],
          )
        ],
      ),
    );
  }

  Flex _coupleTextBox(Widget child1, Widget child2, [bool? condition]) {
    return Flex(
      direction: condition ?? Responsive.isMobile(context) ? Axis.vertical : Axis.horizontal,
      children: [
        child1,
        SizedBox(height: 16, width: 20),
        child2,
      ],
    );
  }

  Widget _createSingleTextBox({required String name, required TextEditingController controller, bool? condition}) {
    Widget _textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyles.body14.copyWith(color: kLightBlue)),
        SizedBox(height: 4),
        PrimaryTextField(controller: controller, text: name),
      ],
    );

    return condition ?? Responsive.isMobile(context) ? _textColumn : Flexible(child: _textColumn);
  }
}
