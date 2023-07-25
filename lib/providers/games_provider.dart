import 'package:flutter/material.dart';

class GamesProvider with ChangeNotifier {
  dynamic _searchGames;
  dynamic get searchGames => _searchGames;

  changeSearchGames(dynamic value) {
    _searchGames = value;
    notifyListeners();
  }

  dynamic _challengeGames;
  dynamic get challengeGames => _challengeGames;

  changeChallengeGames(dynamic value) {
    _challengeGames = value;
    notifyListeners();
  }
}
