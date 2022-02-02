import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:real_estate_portal/screens/company_guidlines/company_guidline_screen.dart';
import 'package:vrouter/vrouter.dart';

import '../../app/bloc/rep_bloc.dart';
import '../../components/mobile_app_bar.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';
import '../../routes/routes.dart';

const grey2 = Color(0xFFD5D5D5);
const grey4 = Color(0xFF808080);

class MobileMenuScreen extends StatefulWidget {
  const MobileMenuScreen({Key? key}) : super(key: key);

  @override
  State<MobileMenuScreen> createState() => _MobileMenuScreenState();
}

class _MobileMenuScreenState extends State<MobileMenuScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MobileAppBar(),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(vertical: Insets.lg),
        children: [
          // Account
          _padding([Text("Quick Links", style: TextStyles.h3.copyWith(color: grey2))]),
          _settingButton(
            title: "Home",
            onTap: () {
              context.vRouter.to(HomePath, queryParameters: {"type": "r"});
            },
          ),
          _settingButton(
            title: "Properties",
            onTap: () {
              context.vRouter.to(PropertyListingScreenPath, queryParameters: {"type": "r"});
            },
          ),
          _settingButton(
            title: "Projects",
            onTap: () {
              context.vRouter.to(ProjectListingScreenPath);
            },
          ),
          _settingButton(
            title: "Service Providers",
            onTap: () {
              context.vRouter.to(ServiceProviderScreenPath);
            },
          ),
          _settingButton(
            title: "Property Owners",
            onTap: () {
              context.vRouter.to(PropertyOwnerPath);
            },
          ),
          _settingButton(
            title: "Community Guidelines",
            onTap: () {
              context.vRouter.to(CommunityGuidlinePath);
            },
          ),
          _settingButton(
            title: "Services",
            onTap: () {
              context.vRouter.to(ServiceMainScreenPath);
            },
          ),
          _settingButton(
            title: "My Properties",
            onTap: () {
              context.vRouter.to(MyPropertiesScreenPath);
            },
          ),
          _settingButton(
            title: "My Services",
            onTap: () {
              context.vRouter.to(MyServicesScreenPath);
            },
          ),
          Divider(color: grey2),

          if (user != null)
            InkWell(
              onTap: () async {
                await showCupertinoDialog<bool>(
                  context: context,
                  builder: (_) {
                    return BlocProvider.value(
                      value: context.read<RepBloc>(),
                      child: CupertinoAlertDialog(
                        content: Text("Do you really wish to signout?"),
                        title: Text("Confirm", style: TextStyles.h4),
                        actions: [
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            child: Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          CupertinoDialogAction(
                              textStyle: TextStyle(color: Colors.red),
                              isDefaultAction: true,
                              child: Text("Sign out"),
                              onPressed: () {
                                context.read<RepBloc>().add(RepLogoutRequested());
                                context.vRouter.to(LoginPath);
                              }),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Insets.med, horizontal: Insets.sm),
                child: Row(
                  children: [
                    SizedBox(width: Insets.sm),
                    Text("Sign out", style: TextStyles.h4.copyWith(color: kErrorColor)),
                    Spacer(),
                    Icon(Icons.logout, color: kErrorColor),
                  ],
                ),
              ),
            )
          else
            InkWell(
              onTap: () {
                context.vRouter.to(LoginPath);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: Insets.med, horizontal: Insets.sm),
                child: Row(
                  children: [
                    SizedBox(width: Insets.sm),
                    Text("Login/ Signup", style: TextStyles.h4.copyWith(color: kSupportBlue)),
                    Spacer(),
                    Icon(FeatherIcons.logIn, color: kSupportBlue),
                  ],
                ),
              ),
            ),

          Divider(color: grey2),

          SizedBox(height: Insets.sm),
          _padding([Text("App Version v1.0.0", style: TextStyles.body10.copyWith(color: grey4))])
        ],
      ),
    );
  }

  InkWell _settingButton({required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Insets.med, horizontal: Insets.sm),
        child: Row(
          children: [
            SizedBox(width: Insets.med),
            Text(title, style: TextStyles.h4.copyWith(color: kBlackVariant)),
            Spacer(),
            Icon(Icons.keyboard_arrow_right, size: 24, color: kDarkGrey)
          ],
        ),
      ),
    );
  }

  Padding _padding(List<Widget> children) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.med),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
