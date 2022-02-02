import 'package:flutter/material.dart';

import '../../../components/buttons/primary_button.dart';
import '../../../components/buttons/primary_outlined_button.dart';
import '../../../components/input_fields/primary_text_field.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class BasicInformationTab extends StatefulWidget {
  const BasicInformationTab({
    Key? key,
  }) : super(key: key);

  @override
  _BasicInformationTabState createState() => _BasicInformationTabState();
}

class _BasicInformationTabState extends State<BasicInformationTab> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _numberOfDependantsController;
  late TextEditingController _emiratesIdController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _numberOfDependantsController = TextEditingController();
    _emiratesIdController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _numberOfDependantsController.dispose();
    _emiratesIdController.dispose();
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
          Center(child: Image.asset("assets/temp/avatar.png")),
          SizedBox(height: 48),
          _coupleTextBox(
            _createSingleTextBox(name: "First Name", controller: _firstNameController),
            _createSingleTextBox(name: "Last Name", controller: _lastNameController),
          ),
          SizedBox(height: Insets.xl),
          _coupleTextBox(
            _createSingleTextBox(name: "DOB", controller: _firstNameController, keepFlexible: false),
            _createSingleTextBox(
                name: "Number of Dependants", controller: _numberOfDependantsController, keepFlexible: false),
            false,
          ),
          SizedBox(height: Insets.xl),
          _coupleTextBox(
            _createSingleTextBox(name: "Emirates ID", controller: _emiratesIdController),
            _createSingleTextBox(name: "Emirates ID Expiry Date", controller: _numberOfDependantsController),
          ),
          SizedBox(height: Insets.xl),
          _coupleTextBox(
            _createSingleTextBox(name: "Upload Visa", controller: _emiratesIdController),
            _createSingleTextBox(name: "Visa Expiry Date", controller: _numberOfDependantsController),
          ),
          SizedBox(height: Insets.xl),
          _coupleTextBox(
            _createSingleTextBox(name: "Housing Budget", controller: _emiratesIdController),
            _createSingleTextBox(name: "Currency", controller: _numberOfDependantsController),
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

  Widget _createSingleTextBox(
      {required String name, required TextEditingController? controller, bool? keepFlexible, Widget? child}) {
    if (child == null)
      assert(controller != null, "If child widget is not provided. TextEditingController needs to be provided");

    Widget _textColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyles.body14.copyWith(color: kLightBlue)),
        SizedBox(height: 4),
        child ?? PrimaryTextField(controller: controller!, text: name),
      ],
    );

    return keepFlexible ?? Responsive.isMobile(context) ? _textColumn : Flexible(child: _textColumn);
  }
}
