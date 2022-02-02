import 'package:flutter/material.dart';
import 'package:vrouter/vrouter.dart';

import '../../components/buttons/primary_outlined_button.dart';
import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../routes/routes.dart';
import 'components/login_app_bar.dart';
import 'components/login_tabs.dart';
import 'components/separater.dart';
import 'components/social_component.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final Axis direction =
        Responsive.isTablet(context) && !Responsive.isLandscape(context) ? Axis.vertical : Axis.horizontal;

    final bool layoutChangeCondition = Responsive.isTablet(context) && !Responsive.isLandscape(context);

    Widget tabContent = Flex(
      direction: layoutChangeCondition ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: layoutChangeCondition ? 10 : 14,
          child: LoginTabs(direction: direction),
        ),
        Spacer(flex: 1),
        // OR
        Separator(direction: direction),
        Spacer(),
        // Socila login section
        Expanded(
          flex: 6,
          child: SocailComponent(),
        ),
        Spacer(flex: 1),
        if (!Responsive.isTablet(context))
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: PrimaryOutlinedButton(
              onTap: () => context.vRouter.to(SignupPath),
              text: "Create Account",
            ),
          ),
      ],
    );

    Widget _carousel = Expanded(
      flex: layoutChangeCondition ? 7 : 9,
      child: Stack(
        children: [
          Image.asset(
            "assets/app/login_banner.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
        ],
      ),
    );

    Widget _emailAndMobileLoginTab = Expanded(
      flex: layoutChangeCondition ? 6 : 4,
      child: Scaffold(
        appBar: Responsive.isMobile(context) ? LoginAppBar(text: "Login") : null,
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height < 700 ? 700 : MediaQuery.of(context).size.height,
              minHeight: 700,
            ),
            padding: EdgeInsets.all(
              Responsive.isDesktop(context) ? Insets.xxl : Insets.lg,
            ),
            child: Column(
              children: [
                if (!Responsive.isMobile(context)) ...[LoginAppBar(text: "Login"), Spacer()],
                Expanded(
                  flex: 60,
                  child: tabContent,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Flex(
        direction: direction,
        children: [
          // carousel
          if (!Responsive.isMobile(context)) _carousel,

          // Tab containing Email and Mobile login tabs
          _emailAndMobileLoginTab,
        ],
      ),
    );
  }
}
