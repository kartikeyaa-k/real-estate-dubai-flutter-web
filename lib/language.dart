import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

class Language extends ChangeNotifier {
  Locale _appLocale = Locale("en");

  Locale get appLocale => _appLocale;

  S s(BuildContext context) {
    return S.of(context);
  }

  void switchLanguage(String languageCode) {
    _appLocale = Locale(languageCode);
    notifyListeners();
  }
}

Language appLang(BuildContext context) {
  return Provider.of<Language>(context);
}

Language appLangStatic(BuildContext context) {
  return Provider.of<Language>(context, listen: false);
}
