import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../../injection_container.dart';
import '../login/components/login_app_bar.dart';
import '../login/components/separater.dart';
import 'components/signup_tabs.dart';
import 'components/social_component.dart';
import 'components/switch_account_text.dart';
import 'cubit/signup_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final Axis direction =
        Responsive.isTablet(context) && !Responsive.isLandscape(context) ? Axis.vertical : Axis.horizontal;
    final bool layoutChangeCondition = Responsive.isTablet(context) && !Responsive.isLandscape(context);

    var tabContent = Flex(
      direction: layoutChangeCondition ? Axis.horizontal : Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: layoutChangeCondition ? 10 : 16,
          child: SignupTabs(
            direction: direction,
          ),
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

        if (!layoutChangeCondition) ...[Spacer(), SwitchAccountText()]
      ],
    );

    return BlocProvider(
      create: (context) => sl<SignUpCubit>(),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        child: Flex(
          direction: direction,
          children: [
            // carousel
            if (!Responsive.isMobile(context))
              Expanded(
                flex: layoutChangeCondition ? 5 : 9,
                child: Image.asset(
                  "assets/app/login_banner.jpg",
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),

            // Tab containing Email and Mobile login tabs
            Expanded(
              flex: layoutChangeCondition ? 6 : 4,
              child: Scaffold(
                appBar: Responsive.isMobile(context) ? LoginAppBar(text: "Signup") : null,
                body: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height < 800 ? 800 : MediaQuery.of(context).size.height,
                      minHeight: 800,
                    ),
                    padding: EdgeInsets.all(
                      Responsive.isDesktop(context) ? Insets.xxl : Insets.lg,
                    ),
                    child: Column(
                      children: [
                        if (!Responsive.isMobile(context)) ...[LoginAppBar(text: "Signup"), Spacer()],
                        Expanded(flex: 60, child: tabContent),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
