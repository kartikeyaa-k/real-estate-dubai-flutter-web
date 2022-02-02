import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/constants.dart';
import '../../../core/utils/styles.dart';
import 'email_login.dart';
import 'mobile_login.dart';

class LoginTabs extends StatefulWidget {
  const LoginTabs({Key? key, required this.direction}) : super(key: key);
  final Axis direction;

  @override
  _LoginTabsState createState() => _LoginTabsState();
}

class _LoginTabsState extends State<LoginTabs> with TickerProviderStateMixin {
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
              Text("Email Login", style: TextStyles.h4.copyWith(color: kBlackVariant)),
              Text("Mobile Login", style: TextStyles.h4.copyWith(color: kBlackVariant))
            ],
          ),
          // SizedBox(height: 30),
          Spacer(),
          Expanded(
            flex: 12,
            child: TabBarView(
              controller: _tabController,
              children: [EmailLogin(), MobileLogin()],
            ),
          ),
        ],
      ),
    );
  }
}
