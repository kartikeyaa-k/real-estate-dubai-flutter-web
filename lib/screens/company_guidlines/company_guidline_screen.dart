import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:real_estate_portal/components/snack_bar/custom_snack_bar.dart';
import 'package:real_estate_portal/components/toolbar.dart';
import 'package:real_estate_portal/core/utils/constants.dart';
import 'package:real_estate_portal/screens/services/components/property_filter_app_bar.dart';

import '../../components/footer.dart';
import '../../components/scaffold/sliver_scaffold.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import 'components/company_guidline_body.dart';
import 'components/page_header.dart';
import 'cubit/community_cubit.dart';

class CommunityGuidlineScreen extends StatefulWidget {
  const CommunityGuidlineScreen({Key? key}) : super(key: key);

  @override
  _CommunityGuidlineScreenState createState() => _CommunityGuidlineScreenState();
}

class _CommunityGuidlineScreenState extends State<CommunityGuidlineScreen> with TickerProviderStateMixin {
  late TextEditingController _searchController;
  final _cubit = sl<CommunityCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getCommunityGuidelines();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool _toolBarSwitchCondition = !Responsive.isMobile(context);

    Widget _tabBarWithImageBanner =
        PageHeader(toolBarSwitchCondition: _toolBarSwitchCondition, searchController: _searchController);

    Widget body = BlocBuilder<CommunityCubit, CommunityState>(
      bloc: _cubit,
      builder: (_, state) {
        if (state is LCommunityGuidelines) {
          return Center(child: SpinKitThreeBounce(color: kSupportBlue));
        } else if (state is FCommunityGuidelines) {
          // SnackBar snackBar = CustomSnackBar.errorSnackBar(state.failure.errorMessage.isEmpty
          //     ? state.failure.errorMessage
          //     : "Unexpected failure occured at login. Please try again after sometime.");

          // ScaffoldMessenger.of(context)
          //   ..hideCurrentSnackBar()
          //   ..showSnackBar(snackBar);
          return Center(
            child: Column(
              children: [
                Text(
                    state.failure.errorMessage.isEmpty
                        ? state.failure.errorMessage
                        : "Unexpected failure occured at login. Please try again after sometime.",
                    style: TextStyles.h4),
                SizedBox(height: Insets.med),
              ],
            ),
          );
        } else if (state is SCommunityGuidelines) {
          if (state.result.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text("Ops! It seems we don't have any emirates", style: TextStyles.h4),
                  SizedBox(height: Insets.med),
                ],
              ),
            );
          }
          return CompanyGuidlinesBody(
            toolBarSwitchCondition: _toolBarSwitchCondition,
            result: state.result,
          );
        } else
          return Container();
      },
    );

    Widget mobileView = SliverScaffold(
      hideBottomNav: false,
      child: Container(
        child: Padding(
          padding: EdgeInsetsDirectional.only(top: Insets.med),
          child: body,
        ),
      ),
      title: "Emirates",
    );

    Widget webView = Scaffold(
      appBar: Responsive.isDesktop(context) ? ToolBar() : PropertyFilterAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _tabBarWithImageBanner,
            body,
            if (Responsive.isDesktop(context)) Footer(),
          ],
        ),
      ),
    );

    return _toolBarSwitchCondition ? webView : mobileView;
  }
}
