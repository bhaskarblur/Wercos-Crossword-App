import 'package:flutter/material.dart';
import 'package:werkos/widget/sahared_prefs.dart';

class HomeProvider with ChangeNotifier {
  int _selectedIndex = 4;
  int get selectedIndex => _selectedIndex;

  int _prevIndex = 4;
  int get prevIndex => _prevIndex;
  dynamic _isSearching = false;
  dynamic get isSearching => _isSearching;

  String _flag_selected = "assets/images/us_flag.png";
  String get flag_selected => _flag_selected;

  dynamic  _searchResult;
  dynamic get searchResult => _searchResult;

   late List<dynamic>  _filteredsearchResult;
  List<dynamic> get filteredsearchResult => _filteredsearchResult;

  changeSelectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
  changePreviousIndex(int value) {
    _prevIndex = value;
    notifyListeners();
  }

  setSearching(var status) {
    _isSearching = status;
    notifyListeners();
  }

  updateSearchResult(var data){
    _searchResult = data;
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
