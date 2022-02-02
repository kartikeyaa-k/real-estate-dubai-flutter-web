import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/components/input_fields/primary_text_field.dart';
import 'package:real_estate_portal/components/mobile_padding.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

Widget _header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text("Add Service", textAlign: TextAlign.left, style: Responsive.isDesktop(context) ? TS.miniHeaderBlack : MS.lableBlack),
    ],
  );
}

Column _singleBlock({required String text, required Widget child, double width = double.infinity, double height = 48}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(text, style: TS.bodyBlack.copyWith(color: kSupportBlue)),
      SizedBox(height: 4),
      Container(width: width, height: height, child: child),
    ],
  );
}

Widget _body(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Row(
        children: [Text('Mention the service name.', style: Responsive.isDesktop(context) ? TS.bodyBlack : MS.bodyBlack)],
      ),
      Responsive.isDesktop(context)
          ? SizedBox(
              height: Insets.xl,
            )
          : mobileVerticalSizedBox,
      _singleBlock(
        text: "Enter here",
        width: 280,
        child: PrimaryTextField(text: "Enter Service", onChanged: (firstName) {}),
      ),
    ],
  );
}

addNewServiceDialog({required BuildContext context, Function(String)? onAdd}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  TextEditingController serviceName = TextEditingController();
  return showDialog(
      context: context,
      useSafeArea: false,
      barrierLabel: "asd",
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return Scaffold(
            backgroundColor: Colors.black.withOpacity(0.7),
            body: Center(
              child: Container(
                color: kPlainWhite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: Responsive.isDesktop(context) ? width / 2.5 : width - 50,
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
                                    _header(context),
                                    SizedBox(
                                      height: Insets.med,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text('Mention the service name.',
                                                style: Responsive.isDesktop(context) ? TS.bodyBlack : MS.bodyBlack)
                                          ],
                                        ),
                                        Responsive.isDesktop(context)
                                            ? SizedBox(
                                                height: Insets.xl,
                                              )
                                            : mobileVerticalSizedBox,
                                        _singleBlock(
                                          text: "Enter here",
                                          width: 280,
                                          child: PrimaryTextField(
                                              text: "Enter Service Name",
                                              onChanged: (firstName) {
                                                serviceName.text = firstName;
                                              }),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: Insets.xl,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    PrimaryButton(
                                      onTap: () {
                                        Navigator.of(context).pop();
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
                                        onAdd!(serviceName.text);
                                      },
                                      text: "Add",
                                      height: 45,
                                      width: 110,
                                      fontSize: 12,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
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
            ),
          );
        });
      });
}
