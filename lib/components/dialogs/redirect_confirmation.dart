import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_button.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/responsive.dart';
import 'package:real_estate_portal/core/utils/styles.dart';

Widget _header(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text("Login Required",
          textAlign: TextAlign.left, style: Responsive.isDesktop(context) ? TS.miniHeaderBlack : MS.lableBlack),
    ],
  );
}

Widget _body(BuildContext context) {
  return Row(
    children: [
      Flexible(
        child: Text('Please login to your existing account or create a new account to continue.',
            maxLines: 3, style: Responsive.isDesktop(context) ? TS.bodyBlack : MS.bodyBlack),
      )
    ],
  );
}

redirectConfimationDialog({required BuildContext context, Function()? onSignUp, Function()? onLogin}) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
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
                      width: Responsive.isDesktop(context) ? width / 2 : width - 50,
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
                                    _body(context)
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
                                        onSignUp!();
                                      },
                                      text: "Sign Up",
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
                                        onLogin!();
                                      },
                                      text: "Login",
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
