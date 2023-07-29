import 'package:flutter/material.dart';

class GameScreenProvider with ChangeNotifier {
  dynamic _gameData;
  dynamic get gameData => _gameData;

  changeGameData(dynamic value) {
    _gameData = value;
    notifyListeners();
  }

  String? _gameType;
  String get gameType => _gameType!;

  changeGameType(String value) {
    _gameType = value;
  }

  String? _search;
  String get search => _search!;

  changeSearch(String value) {
    _search = value;
  }
}
