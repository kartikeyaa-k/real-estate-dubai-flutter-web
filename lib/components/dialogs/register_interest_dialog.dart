import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_dropdown_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_text_field.dart';
import 'package:real_estate_portal/core/utils/app_responsive.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

class RegisterInterestDialog extends StatefulWidget {
  const RegisterInterestDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterInterestDialog> createState() => _RegisterInterestDialogState();
}

class _RegisterInterestDialogState extends State<RegisterInterestDialog> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // get id from url and load data
    // if id is missing redirect to [PropertyListingScreen]
    if (!context.vRouter.queryParameters.keys.contains("property_id")) {
    } else {
      int propertyId = int.parse(context.vRouter.queryParameters["property_id"] as String);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Function wp = ScreenUtils(MediaQuery.of(context)).wp;
    final Function hp = ScreenUtils(MediaQuery.of(context)).hp;
    Widget _header = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text("Registration Form", textAlign: TextAlign.left, style: TextStyles.h2),
      ],
    );
    Widget _body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            flex: 4,
            child: _FieldLayout(
              caption: "First Name",
              child: PrimaryTextField(
                text: '',
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 4,
            child: _FieldLayout(
              caption: "Last Name",
              child: PrimaryTextField(
                text: '',
              ),
            ),
          ),
        ]),
        SizedBox(
          height: Insets.med,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, children: [
          Expanded(
            flex: 4,
            child: _FieldLayout(
              caption: "Email",
              child: PrimaryTextField(
                text: '',
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 4,
            child: _FieldLayout(
              caption: "Phone Number",
              child: PrimaryTextField(
                text: '',
              ),
            ),
          ),
        ]),
      ],
    );
    Widget _btns = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PrimaryButton(
          onTap: () {
            context.vRouter.to(CoverPath);
          },
          text: "Cancel",
          backgroundColor: kBackgroundColor,
          color: kSupportBlue,
          height: 45,
          width: 110,
          fontSize: 12,
        ),
        SizedBox(
          width: Insets.med,
        ),
        PrimaryButton(
          onTap: () {
            context.vRouter.to(CoverPath);
          },
          text: "Submit",
          height: 45,
          width: 110,
          fontSize: 12,
        )
      ],
    );

    return Scaffold(
      body: Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: wp(50),
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(Insets.xl),
                    child: Column(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _header,
                            SizedBox(
                              height: Insets.med,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                          onTap: () {
                            context.vRouter.to(CoverPath);
                          },
                          child: Icon(Icons.close, size: 20)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLayout extends StatelessWidget {
  const _FieldLayout({
    Key? key,
    required String caption,
    required Widget child,
  })  : _caption = caption,
        _child = child,
        super(key: key);

  final String _caption;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text(_caption, style: TextStyles.body12.copyWith(color: Color(0xFF99C9E7))), SizedBox(height: 4), _child],
    );
  }
}
