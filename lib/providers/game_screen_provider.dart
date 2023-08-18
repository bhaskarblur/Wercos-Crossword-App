import 'dart:math';
import 'package:flutter/material.dart';

class GameScreenProvider with ChangeNotifier {
  dynamic _gameData;
  dynamic get gameData => _gameData;

  changeGameData(dynamic value) {
    _gameData = value;
    addToTiles();
    notifyListeners();
  }

  resetGameData() {
    _gameData = null;
  }

  final List<String> _correctWordsFromAPI = [];
  List<String> get correctWordsFromAPI => _correctWordsFromAPI;

  addToCorrectWordsFromAPI() {
    _correctWordsFromAPI.clear();
    if (_gameData['limitedWords'].isNotEmpty) {
      for (int i = 0; i < _gameData['limitedWords'].length; i++) {
        _correctWordsFromAPI.add(_gameData['limitedWords'][i].toUpperCase());
      }
    } else {
      for (int i = 0; i < _gameData['allWords'].length; i++) {
        _correctWordsFromAPI
            .add(_gameData['allWords'][i]['words'].toUpperCase());
      }
    }
  }

  resetCorrectWordsFromAPI() {
    _correctWordsFromAPI.clear();
    notifyListeners();
  }

  final _random = Random();
  final List<Color> randomColors = [
    Colors.red,
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.purple,
    Colors.cyan,
  ];

  Color _selectedColor = Colors.red;
  Color get selectedColor => _selectedColor;

  changeSelectedColor() {
    _selectedColor = randomColors[_random.nextInt(randomColors.length)];
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

  final List<String> _correctWords = [];
  List<String> get correctWords => _correctWords;

  addToCorrectWords() {
    print(_selectedWord);
    int index = _correctWordsFromAPI.indexOf(_selectedWord.toUpperCase());
    print(index);
    print(_correctWordsFromAPI.length);
    _correctWordsFromAPI.forEach((element) {
      print(element);
    });
    if (index > -1) {
      _correctWords.add(_selectedWord);
    } else {
      for (var element in _trackLastIndex) {
        _allSelectedIndex.remove(element);
        _tiles[element].backgroundColor = Colors.white;
        _tiles[element].textColor = Colors.black;
      }
    }
    notifyListeners();
  }

  resetCorrectWords() {
    _correctWords.clear();
    notifyListeners();
  }

  final List<String> _inCorrectWords = [];
  List<String> get inCorrectWords => _inCorrectWords;

  addToIncorrectWrods(String value) {
    _inCorrectWords.add(value);
    notifyListeners();
  }

  resetIncorrectWords() {
    _inCorrectWords.clear();
    notifyListeners();
  }

  final List<int> _trackLastIndex = [];
  List<int> get trackLastIndex => _trackLastIndex;

  addToTrackLastIndex(int value) {
    if (!_trackLastIndex.contains(value) &&
        !_allSelectedIndex.contains(value)) {
      _trackLastIndex.add(value);
    }
    print(_trackLastIndex);
    notifyListeners();
  }

  resetTrackLastIndex() {
    _trackLastIndex.clear();
    notifyListeners();
  }

  final List<SingleTileModel> _tiles = [];
  List<SingleTileModel> get tiles => _tiles;

  addToTiles() {
    _tiles.clear();
    for (int i = 0; i < _gameData['crossword_grid'].length; i++) {
      for (int j = 0; j < _gameData['crossword_grid'][i].length; j++) {
        _tiles.add(SingleTileModel(
            alphabet: _gameData['crossword_grid'][i][j].toUpperCase(),
            backgroundColor: Colors.white,
            textColor: const Color(0xFF221962)));
      }
    }
    notifyListeners();
  }

  changeGridAndTextColor(int index) {
    _tiles[index].backgroundColor = selectedColor;
    _tiles[index].textColor = Colors.white;
    notifyListeners();
  }

  final List<int> _allSelectedIndex = [];
  List<int> get allSelectedIndex => _allSelectedIndex;

  addToAllSelectedIndex(int value) {
    if (!_allSelectedIndex.contains(value)) {
      _allSelectedIndex.add(value);
    }
  }

  String _selectedWord = '';
  String get selectedWord => _selectedWord;

  makeWord() {
    for (var element in _trackLastIndex) {
      _selectedWord = _selectedWord + _tiles[element].alphabet!;
    }
  }

  resetSelectedWord() {
    _selectedWord = '';
    notifyListeners();
  }

  reset() {
    _gameData = null;
    _correctWordsFromAPI.clear();
    _correctWords.clear();
    _inCorrectWords.clear();
    _trackLastIndex.clear();
    _tiles.clear();
    _allSelectedIndex.clear();
  }
}

class SingleTileModel {
  String? alphabet;
  int? index;
  Color? backgroundColor;
  Color? textColor;

  SingleTileModel(
      {this.alphabet, this.index, this.backgroundColor, this.textColor});
}
