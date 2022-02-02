import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:real_estate_portal/injection_container.dart';

import '../../core/utils/responsive.dart';
import '../../core/utils/styles.dart';
import '../login/components/login_app_bar.dart';
import 'components/signup_form.dart';
import 'signup_form_bloc/signup_form_bloc.dart';

class SignupFormScreen extends StatelessWidget {
  const SignupFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Axis direction =
        Responsive.isTablet(context) && !Responsive.isLandscape(context) ? Axis.vertical : Axis.horizontal;
    final bool layoutChangeCondition = Responsive.isTablet(context) && !Responsive.isLandscape(context);

    // _handleSwitchToLogin() {
    //   appState.currentAction = PageAction(state: PageState.addPage, page: loginPageConfig);
    // }

    return BlocProvider(
      create: (context) => sl<SignupFormBloc>(),
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
                body: Container(
                  color: Colors.white,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height < 900 ? 900 : MediaQuery.of(context).size.height,
                    minHeight: 900,
                  ),
                  padding: EdgeInsets.all(Responsive.isDesktop(context) ? Insets.xxl : Insets.lg),
                  child: Column(
                    children: [
                      if (!Responsive.isMobile(context)) ...[LoginAppBar(text: "Signup"), SizedBox(height: 30)],
                      Expanded(
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height > 700
                                  ? MediaQuery.of(context).size.height -
                                      MediaQuery.of(context).padding.vertical -
                                      kToolbarHeight -
                                      2 * (Responsive.isDesktop(context) ? Insets.xxl : Insets.lg)
                                  : 698,
                            ),
                            child: SignupForm(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
