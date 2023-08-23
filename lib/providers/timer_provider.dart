import 'package:flutter/material.dart';

class TimerProvider with ChangeNotifier {
  int _seconds = 0;
  bool ticking = true;
  int get seconds => _seconds;

  // Timer? timer;

  // void startTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   timer = Timer.periodic(
  //     oneSec,
  //     (Timer timer) {
  //       chnageSeconds();
  //     },
  //   );
  // }

  // cancelTimer() {
  //   timer!.cancel();
  // }

  changeSeconds() {
    _seconds++;
    ticking =true;
    notifyListeners();
  }

  resetSeconds() {
    _seconds = 0;
  }

  setTicking(bool tick) {
    ticking = tick;
  }

  stopSeconds() {
    // _seconds = _sec;
    ticking = false;
  }
}
