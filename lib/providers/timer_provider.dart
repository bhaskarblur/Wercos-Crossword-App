import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  int _seconds = 0;
  int get seconds => _seconds;

  Timer? timer;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        chnageSeconds();
      },
    );
  }

  cancelTimer() {
    timer!.cancel();
  }

  chnageSeconds() {
    _seconds++;
    notifyListeners();
  }

  resetSeconds() {
    _seconds = 0;
    notifyListeners();
  }
}
