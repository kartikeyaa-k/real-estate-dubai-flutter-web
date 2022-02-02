import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/primary_outlined_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class CompanyInformation extends StatefulWidget {
  const CompanyInformation({Key? key}) : super(key: key);

  @override
  _CompanyInformationState createState() => _CompanyInformationState();
}

class _CompanyInformationState extends State<CompanyInformation> {
  late TextEditingController _employeeIdController;
  late TextEditingController _jobTitleController;
  late TextEditingController _departmentController;
  late TextEditingController _companyNameController;
  late TextEditingController _companyPhoneNumberController;

  @override
  void initState() {
    super.initState();
    _employeeIdController = TextEditingController();
    _jobTitleController = TextEditingController();
    _departmentController = TextEditingController();
    _companyNameController = TextEditingController();
    _companyPhoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _employeeIdController.dispose();
    _jobTitleController.dispose();
    _departmentController.dispose();
    _companyNameController.dispose();
    _companyPhoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget createSingleTextBox =
        _createSingleTextBox(name: "Company Phone Number", controller: _companyPhoneNumberController);

    return Container(
      padding: Responsive.isMobile(context) ? null : EdgeInsets.all(Insets.xl),
      decoration: Responsive.isMobile(context)
          ? null
          : BoxDecoration(border: Border.all(color: Colors.black.withOpacity(0.1)), borderRadius: Corners.xlBorder),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _coupleTextBox(
            _createSingleTextBox(name: "Employee ID", controller: _employeeIdController),
            _createSingleTextBox(name: "Job Title", controller: _jobTitleController),
          ),
          SizedBox(height: Insets.xl),
          _coupleTextBox(
            _createSingleTextBox(name: "Department", controller: _departmentController),
            _createSingleTextBox(name: "Company Name", controller: _companyNameController),
          ),
          SizedBox(height: Insets.xl),
          if (!Responsive.isMobile(context))
            Row(
              children: [
                createSingleTextBox,
                SizedBox(height: 16, width: 20),
                Flexible(child: SizedBox(width: double.infinity))
              ],
            )
          else
            createSingleTextBox,
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
