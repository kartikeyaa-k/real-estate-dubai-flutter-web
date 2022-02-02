import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/utils/constants.dart';
import '../../core/utils/responsive.dart';
import '../bottom_navbar.dart';
import '../footer.dart';
import '../mobile_app_bar.dart';
import '../toolbar.dart';

class PrimaryScaffold extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets bodyPadding;
  final PreferredSizeWidget? appBar;

  /// It adds the scaffold with [ToolBar] or [MobileAppBar] depending on the type
  /// of screen available. Also [Footer] is added at end of the children list
  const PrimaryScaffold({
    Key? key,
    required this.children,
    this.bodyPadding = EdgeInsets.zero,
    this.appBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        bottomNavigationBar: !Responsive.isDesktop(context) ? BottomNavBar() : null,
        body: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          color: kBackgroundColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ...children.map(
                  (e) => Padding(
                    padding: bodyPadding,
                    child: e,
                  ),
                ),
                if (Responsive.isDesktop(context)) Footer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
