import 'package:flutter/material.dart';
import 'package:crossword_flutter/l10n/l10n.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = L10n.all.first;
  Locale get locale => _locale;

  setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

    Locale _gameLocale = L10n.all.first;
  Locale get gameLocale => _gameLocale;

  setGameLFocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;
    _gameLocale = locale;
    notifyListeners();
  }

}
