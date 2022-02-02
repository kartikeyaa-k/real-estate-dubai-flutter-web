import 'package:flutter/material.dart';
import 'package:real_estate_portal/components/buttons/primary_flat_button.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/core/utils/styles.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/src/core/extended_context.dart';

import 'cover_nav_button.dart';

AppBar mobileAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: kSupportBlue),
    actionsIconTheme: IconThemeData(color: kSupportBlue),
    leading: Padding(
      padding: const EdgeInsetsDirectional.only(
        top: 8,
        bottom: 8,
        start: 16,
      ),
      child: Image(
        image: AssetImage('assets/app/logo.png'),
      ),
    ),
    actions: [
      PrimaryFlatButton(
          mobileCoverScreen: true,
          backgroundColor: kSupportBlue,
          text: Text("Search for more properties".toUpperCase(), textAlign: TextAlign.center, style: MS.miniestHeaderWhite),
          onTap: () => context.vRouter.to(HomePath)),
    ],
  );
}
