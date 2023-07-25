import 'package:flutter/material.dart';

class LeaderBoardProvider with ChangeNotifier {
  dynamic _leaderboard;
  dynamic get leaderboard => _leaderboard;

  changeLeaderboard(dynamic value) {
    _leaderboard = value;
    notifyListeners();
  }
}
