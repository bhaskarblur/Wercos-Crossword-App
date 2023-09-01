import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';

class HomeProvider with ChangeNotifier {
  int _selectedIndex = 4;
  int get selectedIndex => _selectedIndex;

  String _flag_selected = "assets/images/us_flag.png";
  String get flag_selected => _flag_selected;
  changeSelectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  getFlag() {
    Prefs.getPrefs('gameLanguage')
    .then((value) => {
      debugPrint(value),
      if(value.toString().contains("es")) {
        _flag_selected = "assets/images/spanish_flag.png"
      }
      else {
        _flag_selected = "assets/images/us_flag.png"
      }
    });
    return _flag_selected;
  }

  changeFlag(String value) {
    _flag_selected = value;
    notifyListeners();
  }
}
