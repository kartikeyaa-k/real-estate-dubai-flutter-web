import 'package:firebase_authentication_repository/firebase_authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/page/app.dart';
import 'core/utils/constants.dart';
import 'env/base_env.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const String environment =
      String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: Environment.DEV,
  );

  Environment().initConfig(environment);

  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  final firebaseAuthenticationRepository =
      di.sl<FirebaseAuthenticationRepository>();
  await firebaseAuthenticationRepository
      .user.first;

  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
    statusBarColor: kSupportBlue,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]).then(
    (_) {
      runApp(MyApp());
    },
  );
}
