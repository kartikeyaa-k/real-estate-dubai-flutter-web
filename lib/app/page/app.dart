import 'package:firebase_authentication_repository/firebase_authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:real_estate_portal/screens/home/filter_bloc/home_filter_bloc.dart';
import 'package:real_estate_portal/screens/project_listing/cubit/project_listing_cubit.dart';
import 'package:real_estate_portal/screens/property_listing/cubit/property_listing_cubit.dart';
import 'package:real_estate_portal/services/home/home_services.dart';
import 'package:real_estate_portal/services/project_services/project_services.dart';
import 'package:real_estate_portal/services/property_services/property_services.dart';
import 'package:vrouter/vrouter.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/theme.dart';
import '../../injection_container.dart';
import '../../routes/routes.dart';
import '../../screens/login/cubit/login_cubit.dart';
import '../../screens/login/cubit/phone_login_cubit.dart';
import '../bloc/rep_bloc.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: sl<FirebaseAuthenticationRepository>(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => RepBloc(authenticationRepository: sl<FirebaseAuthenticationRepository>()),
          ),

          // FIXME: registering so many blocs is bad practice. This is done because of vRouter. Try to switch to proper navigator 2.0
          // when possible

          //  registered Logincubit and phone login, to reuse the same in signup
          BlocProvider(
            create: (_) => sl<LoginCubit>(),
          ),
          BlocProvider(
            create: (_) => sl<PhoneLoginCubit>(),
          ),

          // home filter and property listing. It's made global as I can't find a way to pass the value using vRouter
          BlocProvider(
            create: (_) =>
                PropertyListingCubit(propertyServices: sl<PropertyServices>(), homeServices: sl<HomeServices>()),
          ),
          BlocProvider(
            create: (_) => HomeFilterBloc(homeServices: sl<HomeServices>()),
          ),
          BlocProvider(
            create: (_) =>
                ProjectListingCubit(homeServices: sl<HomeServices>(), projectServices: sl<ProjectServices>()),
          )
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1366, 768),
      builder: () => Portal(
        child: VRouter(
          transitionDuration: Duration(milliseconds: 0),
          buildTransition: (animation, secondaryAnimation, child) {
            return child;
          },
          onGenerateTitle: (context) => "Abu Dhabi United Real Estate Company LCC",
          debugShowCheckedModeBanner: false,
          mode: VRouterMode.history,
          theme: lightThemeData(context),
          onPop: (vRedirector) async {
            if (vRedirector.historyCanBack()) {
              return vRedirector.historyBack();
            }
          },
          onSystemPop: (vRedirector) async {
            if (vRedirector.historyCanBack()) {
              return vRedirector.historyBack();
            }
          },
          // TODO: change the language selection, currently both en
          locale: Locale('en', ''),
          initialUrl: CoverPath,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          routes: routes,
        ),
      ),
    );
  }
}
