import 'package:firebase_auth/firebase_auth.dart';
// import 'package:real_estate_portal/core/constent.dart';
import 'package:real_estate_portal/core/localization/app_language.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'iprefs_helper.dart';

class PrefsHelper implements IPrefsHelper {
  // @override
  // Future<SharedPreferences> getPrefs() async {
  //   return await SharedPreferences.getInstance();
  // }

  // @override
  // Future<int> getAppLanguage() async {
  //   return (await getPrefs()).getInt(APP_LANGUAGE) ?? AppLanguageKeys.EN;
  // }

  // @override
  // Future<void> setAppLanguage(int value) async {
  //   (await getPrefs()).setInt(APP_LANGUAGE, value);
  // }

  // @override
  // Future<void> saveUser(
  //   UserCredential user,
  //   bool active,
  // ) async {
  //   (await getPrefs()).setString(ID, user.user!.uid);
  //   (await getPrefs()).setString(EMAIL, user.user!.email ?? "");
  //   if (active) {
  //     (await getPrefs()).setBool(IS_LOGIN, true);
  //   }
  // }
}
