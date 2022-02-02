import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/routes/routes.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/buttons/primary_button.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/styles.dart';
import 'components/project_filter.dart';

class ProjectFilterScreen extends StatelessWidget {
  const ProjectFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: kSupportBlue),
        title: Text("Filter Properties", style: TextStyles.h3.copyWith(color: kBlackVariant)),
        actions: [
          TextButton(
            onPressed: () {
              context.vRouter.to(context.vRouter.path, isReplacement: true);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Insets.sm),
              child: Text("Clear Filters"),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 62,
        decoration: BoxDecoration(boxShadow: Shadows.smallReverse),
        padding: EdgeInsets.symmetric(horizontal: 20.5, vertical: 10.5),
        child: Row(
          children: [
            Expanded(
              child: PrimaryButton(
                onTap: () {
                  context.vRouter.to(ProjectListingScreenPath, queryParameters: context.vRouter.queryParameters);
                },
                text: "Apply Filter",
                height: 41,
                // width: 110,
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: ProjectFilter(isFullPageView: true, cubit: context.read()),
        ),
      ),
    );
  }
}
