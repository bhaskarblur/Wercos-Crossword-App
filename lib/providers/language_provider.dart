import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/l10n/l10n.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = L10n.all.first;
  Locale get locale => _locale;

  setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  // clearLocale() {
  //   _locale = null;
  //   notifyListeners();
  // }
}
