import 'package:flutter/material.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/vrouter.dart';

import '../../../components/logo.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/utils/styles.dart';

class LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  const LoginAppBar({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Logo(size: 20),
      title: Text(
        text,
        style: TextStyles.h2.copyWith(color: kBlackVariant),
      ),
      centerTitle: !Responsive.isDesktop(context),
      actions: [
        InkWell(
          onTap: () {
            context.vRouter.to(HomePath);
          },
          child: Padding(
            padding: EdgeInsets.all(Insets.sm),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  "Home",
                  style: TextStyles.body12.copyWith(color: kSupportBlue),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: kSupportBlue,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
