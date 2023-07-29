import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  int _selectedIndex = 4;
  int get selectedIndex => _selectedIndex;

  changeSelectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }
}
