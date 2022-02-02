import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_text_field.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

class AddServiceDialog extends StatefulWidget {
  const AddServiceDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  TextEditingController _otherServiceName = TextEditingController();
  Key _formKey = GlobalKey<FormState>();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
    Column _singleBlock({required String text, required Widget child, double width = double.infinity, double height = 48}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: TextStyles.body14.copyWith(color: kLightBlue)),
          SizedBox(height: 4),
          Container(width: width, height: height, child: child),
        ],
      );
    }

    Widget _header = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Add Service", textAlign: TextAlign.left, style: TextStyles.h2),
      ],
    );
    Widget _body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Mention the service name.",
              textAlign: TextAlign.center,
              style: TextStyles.body16.copyWith(color: kBlackVariant.withOpacity(0.7)),
            ),
          ],
        ),
        SizedBox(
          height: Insets.xl,
        ),
        _singleBlock(
          text: "Enter here",
          width: 280,
          child: PrimaryTextField(key: _formKey, controller: _otherServiceName, text: "Enter Service", onChanged: (firstName) {}),
        ),
      ],
    );

    Widget _btns = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrimaryButton(
          onTap: () {
            context.vRouter.to(ServiceRegistrationScreenPath, queryParameters: {'other_service_name': ""});
          },
          text: "Cancel",
          backgroundColor: kBackgroundColor,
          color: kSupportBlue,
          height: 45,
          width: 110,
          fontSize: 12,
        ),
        SizedBox(
          width: Insets.xl,
        ),
        PrimaryButton(
          onTap: () {
            if (_otherServiceName.text != "")
              context.vRouter.to(ServiceRegistrationScreenPath, queryParameters: {'other_service_name': _otherServiceName.text});
          },
          text: "Add",
          height: 45,
          width: 110,
          fontSize: 12,
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.7),
      body: Dialog(
        child: Container(
          height: hp(41),
          width: wp(35),
          alignment: Alignment.center,
          padding: EdgeInsets.all(Insets.xl),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _header,
                      SizedBox(
                        height: Insets.offset,
                      ),
                      _body
                    ],
                  ),
                  SizedBox(
                    height: Insets.xl,
                  ),
                  _btns,
                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      // context.vRouter.to(ServiceRegistrationScreenPath, queryParameters: {'other_service_name': ""});
                    },
                    child: Icon(Icons.close, size: 20)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
