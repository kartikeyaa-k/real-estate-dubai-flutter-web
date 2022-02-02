import 'package:flutter/material.dart';

import '../core/utils/constants.dart';

class MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MobileAppBar(
      {Key? key, this.actions, this.elevation, this.showLeadingLogo = true})
      : super(key: key);
  final List<Widget>? actions;
  final double? elevation;
  final bool showLeadingLogo;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: elevation,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: kSupportBlue),
      actionsIconTheme: IconThemeData(color: kSupportBlue),
      leading: showLeadingLogo
          ? Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 8,
                bottom: 8,
                start: 16,
              ),
              child: Image(
                image: AssetImage('assets/app/logo.png'),
              ),
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
