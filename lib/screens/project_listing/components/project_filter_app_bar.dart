import 'package:flutter/material.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/vrouter.dart';

import '../../../core/utils/constants.dart';

class ProjectFilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProjectFilterAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: kSupportBlue),
      actionsIconTheme: IconThemeData(color: kSupportBlue),
      actions: [
        IconButton(
          onPressed: () {
            context.vRouter.to(ProjectFilterScreenPath, queryParameters: context.vRouter.queryParameters);
          },
          icon: Icon(Icons.filter_list),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
