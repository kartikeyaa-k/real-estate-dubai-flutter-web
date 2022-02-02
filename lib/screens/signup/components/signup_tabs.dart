import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_estate_portal/screens/login/components/mobile_login.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import 'email_signup.dart';
import 'mobile_signup.dart';

class SignupTabs extends StatefulWidget {
  const SignupTabs({Key? key, required this.direction}) : super(key: key);
  final Axis direction;

  @override
  _SignupTabsState createState() => _SignupTabsState();
}

class _SignupTabsState extends State<SignupTabs> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelPadding: EdgeInsets.symmetric(horizontal: Insets.med, vertical: Insets.med),
            tabs: [
              Text("Email Signup", style: TextStyles.h4.copyWith(color: kBlackVariant)),
              Text("Mobile Signup", style: TextStyles.h4.copyWith(color: kBlackVariant))
            ],
          ),
          Spacer(),
          Expanded(
            flex: 12,
            child: TabBarView(
              controller: _tabController,
              children: [EmailSignup(), MobileLogin()],
            ),
          ),
        ],
      ),
    );
  }
}
