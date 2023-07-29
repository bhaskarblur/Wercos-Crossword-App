import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  int _seconds = 0;
  int get seconds => _seconds;

  chnageSeconds() {
    _seconds++;
    notifyListeners();
  }

  resetSeconds() {
    _seconds = 0;
    notifyListeners();
  }
}
