
import 'package:crossword/components/word_line.dart';
import 'package:flutter/material.dart';
import "dart:math";
class GameScreenProvider with ChangeNotifier {
  dynamic _gameData;
  dynamic get gameData => _gameData;

  dynamic _gameEnded = false;
  dynamic get gameEnded => _gameEnded;

  dynamic _wordIsMarked = false;
  dynamic get wordIsMarked => _wordIsMarked;

  dynamic _hasGoBack = false;
  dynamic get hasGoBack => _hasGoBack;

  dynamic _hasRated = false;
  dynamic get hasRated => _hasRated;

  dynamic _isMarkingCurrently = false;
  dynamic get isMarkingCurrently => _isMarkingCurrently;

  dynamic _currentMarkedWord = "Word";
  dynamic get currentMarkedWord => _currentMarkedWord;
  dynamic _randomColor = const Color(0x00000000);
  dynamic get randomColor => _randomColor;
  dynamic _allowMark = true;
  dynamic get allowMark => _allowMark;

  dynamic _challengeData = "";
  dynamic get challengeData => _challengeData;

  changeGameData(dynamic value) {
    print('add data');
    _gameData = value;
    addToTiles();
    notifyListeners();
  }

  setIsMarkingCurrently(bool status) {
    _isMarkingCurrently = status;
    notifyListeners();
  }

  changeHasGoBack(bool value) {
    _hasGoBack = value;
    notifyListeners();
  }

  changeHasRated(bool value) {
    _hasRated = value;
    notifyListeners();
  }
  setCurrentMarkedWord(String word) {
    _currentMarkedWord = word;
    notifyListeners();
  }

  setChallengeData(dynamic data) {
    _challengeData = data;
    notifyListeners();
  }

  setRandomColor(Color color) {
    _randomColor = color;
    notifyListeners();
  }

  setAllowMark(status) {
    _allowMark=status;
    notifyListeners();
  }
  setWordIsMarked(status) {
    _allowMark=status;
    // notifyListeners();
  }

  final List<String> _allWordsFromAPI = [];
  List<String> get allWordsFromAPI => _allWordsFromAPI;

  final List<String> _filteredWordsFromAPI = [];
  List<String> get filteredWordsFromAPI => _filteredWordsFromAPI;
  final List<String> _correctWordsFromAPI = [];
  List<String> get correctWordsFromAPI => _correctWordsFromAPI;

  final List<String> _incorrectWordsFromAPI = [];
  List<String> get incorrectWordsFromAPI => _incorrectWordsFromAPI;

  final List<String> _allMarkedWords = [];
  List<String> get allMarkedWords => _allMarkedWords;

  final List<WordLine> _allWordlineMarkedWords = [];
  List<WordLine> get allWordlineMarkedWords => _allWordlineMarkedWords;

  final List<List<int>> _wordLineWordsIndex = [];
  List<List<int>> get wordLineWordsIndex => _wordLineWordsIndex;

  setGameEnded(status) {
    _gameEnded= status;
    notifyListeners();
  }

  addToCorrectWordsIncorrectWordsFromAPI() {
    _allWordsFromAPI.clear();
    _filteredWordsFromAPI.clear();
    _allMarkedWords.clear();
    _allWordlineMarkedWords.clear();
    _wordLineWordsIndex.clear();
    _correctWordsFromAPI.clear();
    _incorrectWordsFromAPI.clear();
    if (gameData['gameDetails']['searchtype'] == 'search') {
      for (int i = 0; i < _gameData['limitedWords'].length; i++) {
        _allWordsFromAPI.add(_gameData['limitedWords'][i].toUpperCase());
        filteredWordsFromAPI.add(_gameData['filteredWords'][0][i].toUpperCase());
      }
    } else {
      for (int i = 0; i < _gameData['limitedWords'].length; i++) {
        _allWordsFromAPI.add(_gameData['limitedWords'][i].toUpperCase());
        filteredWordsFromAPI.add(_gameData['filteredWords'][0][i].toUpperCase());
      }
    }

    if (_gameData['correctWords'] != null) {
      for (int i = 0; i < _gameData['correctWords'].length; i++) {
        print("correct words__");
        print(_gameData['correctWords'][i]);



        try {
          _correctWordsFromAPI
              .add(_gameData['correctWords'][i].toUpperCase());
        }
        catch(e) {
          _correctWordsFromAPI
              .add(_gameData['correctWords'][i].toUpperCase());
        }
      }
      print('correctWords length');
      print(_correctWordsFromAPI.length.toString());
    }
    if (_gameData['incorrectWords'] != null) {
      for (int i = 0; i < _gameData['incorrectWords'].length; i++) {
        try {
          _incorrectWordsFromAPI
              .add(_gameData['incorrectWords'][i].toUpperCase());
        }
        catch(e) {
          _incorrectWordsFromAPI
              .add(_gameData['incorrectWords'][i].toUpperCase());
        }
      }
    }
    notifyListeners();
  }

  reAddWordsForChallenge() {
    _allWordsFromAPI.clear();
    _filteredWordsFromAPI.clear();
    _allMarkedWords.clear();
    _allWordlineMarkedWords.clear();
    _wordLineWordsIndex.clear();
    _correctWordsFromAPI.clear();
    _incorrectWordsFromAPI.clear();
    if (challengeData['gameDetails']['searchtype'] == 'search') {
      for (int i = 0; i < challengeData['limitedWords'].length; i++) {
        _allWordsFromAPI.add(challengeData['limitedWords'][i].toUpperCase());
        filteredWordsFromAPI.add(challengeData['filteredWords'][0][i].toUpperCase());
      }
    } else {
      for (int i = 0; i < challengeData['limitedWords'].length; i++) {
        _allWordsFromAPI.add(challengeData['limitedWords'][i].toUpperCase());
        filteredWordsFromAPI.add(challengeData['filteredWords'][0][i].toUpperCase());
      }
    }

    if (challengeData['correctWords'] != null) {
      for (int i = 0; i < challengeData['correctWords'].length; i++) {
        print("correct words__");
        print(challengeData['correctWords'][i]);



        try {
          _correctWordsFromAPI
              .add(challengeData['correctWords'][i].toUpperCase());
        }
        catch(e) {
          _correctWordsFromAPI
              .add(challengeData['correctWords'][i].toUpperCase());
        }
      }
      print('correctWords length');
      print(_correctWordsFromAPI.length.toString());
    }
    if (challengeData['incorrectWords'] != null) {
      for (int i = 0; i < challengeData['incorrectWords'].length; i++) {
        try {
          _incorrectWordsFromAPI
              .add(challengeData['incorrectWords'][i].toUpperCase());
        }
        catch(e) {
          _incorrectWordsFromAPI
              .add(challengeData['incorrectWords'][i].toUpperCase());
        }
      }
    }

    addToTiles();
    notifyListeners();
  }
  resetCorrectWordsFromAPI() {
    _correctWordsFromAPI.clear();
    notifyListeners();
  }

  addToCorrectWords(var correctWord) {
    correctWords.add(correctWord);
    notifyListeners();
  }
  addToMarkedWords(var correctWord) {
    allMarkedWords.add(correctWord);
    notifyListeners();
  }

  addToWordLineMarkedWords(var correctWord) {
    allWordlineMarkedWords.add(correctWord);
    notifyListeners();
  }

  addToWordLineIndex(var index) {
    wordLineWordsIndex.add(index);
    notifyListeners();
  }

  addToInCorrectWords(var correctWord) {
    incorrectWords.add(correctWord);
    notifyListeners();
  }

  addToFilteredCorrectWords(var correctWord) {
    filteredcorrectWords.add(correctWord);
    notifyListeners();
  }

  addToFilteredInCorrectWords(var correctWord) {
    filteredincorrectWords.add(correctWord);
    notifyListeners();
  }
  resetIncorrectWordsFromAPI() {
    _incorrectWordsFromAPI.clear();
    notifyListeners();
  }

  // final _random = Random();
  final List<Color> randomColors = [
    Colors.blue,
    Colors.yellow,
    Colors.green,
    Colors.purple,
    Colors.cyan,
    Colors.lime,
    Colors.indigo,
    Colors.pink,
    Colors.redAccent,
    Colors.black12,
    Colors.amber,
    Colors.redAccent,
    Colors.deepOrangeAccent
  ];

  Color _selectedColor = Colors.cyan;
  Color get selectedColor => _selectedColor;

  changeSelectedColor() {
    int index = randomColors.indexOf(_selectedColor);
    if (index == (randomColors.length - 1)) {
      _selectedColor = randomColors[0];
    } else {
      _selectedColor = randomColors[index + 1];
    }
    final _random = new Random();
    _selectedColor =  randomColors[_random.nextInt(randomColors.length)];
  }

  String? _gameType;
  String get gameType => _gameType!;

  changeGameType(String value) {
    _gameType = value;
  }

  final List<String> _correctWords = [];
  List<String> get correctWords => _correctWords;

  final List<String> _incorrectWords = [];
  List<String> get incorrectWords => _incorrectWords;

  final List<String> _filteredcorrectWords = [];
  List<String> get filteredcorrectWords => _filteredcorrectWords;

  final List<String> _filteredincorrectWords = [];
  List<String> get filteredincorrectWords => _filteredincorrectWords;

  addToCorrectOrIncorrectWords() {
    int correctIndex = 0;
    if (gameData['gameDetails']['searchtype'] == 'search') {
      correctIndex = _allWordsFromAPI.indexOf(_selectedWord.toUpperCase());
    } else {
      correctIndex = _correctWordsFromAPI.indexOf(_selectedWord.toUpperCase());
    }

    if (correctIndex > -1) {
      _correctWords.add(_selectedWord);
      for (var element in _trackLastIndex) {
        _tiles[element].backgroundColor = _selectedColor;
        _tiles[element].textColor = Colors.white;
        _tiles[element].borderColor = Colors.transparent;
      }
    } else {
      String temp = _selectedWord.split('').reversed.join().toUpperCase();
      correctIndex = _allWordsFromAPI.indexOf(temp);

      if (correctIndex > -1) {
        _correctWords.add(temp);
        for (var element in _trackLastIndex) {
          _tiles[element].backgroundColor = _selectedColor;
          _tiles[element].textColor = Colors.white;
          _tiles[element].borderColor = Colors.transparent;
        }
      } else {
        for (var element in _trackLastIndex) {
          _allSelectedIndex.remove(element);
          _tiles[element].backgroundColor = Colors.white;
          _tiles[element].textColor = const Color(0xFF221962);
          _tiles[element].borderColor = Colors.transparent;
        }
      }
    }

    int incorrectIndex =
    _incorrectWordsFromAPI.indexOf(_selectedWord.toUpperCase());

    if (incorrectIndex > -1) {
      _incorrectWords.add(_selectedWord);
      for (var element in _trackLastIndex) {
        _tiles[element].backgroundColor = Colors.white;
        _tiles[element].textColor = const Color(0xFF221962);
        _tiles[element].borderColor = Colors.red;
      }
    }

    resetSelectedWord();
    resetTrackLastIndex();

    notifyListeners();
  }
  Color generateRandomColor() {
    Random random = Random();
    // var generatedColor = Random().nextInt(Colors.primaries.length)

    int r = random.nextInt(200) - 110; // Red component between 128 and 255
    int g = random.nextInt(200) - 110; // Green component between 128 and 255
    int b = random.nextInt(200) - 110; // Blue component between 128 and 255

    return Color.fromARGB(255, r, g, b);
  }

  changeTile(dynamic value) {
    for (int i = 0; i < value['wordsFound'].length; i++) {
      var color = generateRandomColor();
      for (int j = 0; j < value['wordsFound'][i].length; j++) {
        _tiles[value['wordsFound'][i][j]].backgroundColor = Colors.white;
        _tiles[value['wordsFound'][i][j]].textColor = const Color(0xFF221962);
        _tiles[value['wordsFound'][i][j]].borderColor = color;
      }
    }
    print('corrLength');
    print(value);
    print('_corrword');
    print(filteredcorrectWords);
    for (int i = 0; i < value['correctWordsFound'].length; i++) {
      var color;
      if(allWordlineMarkedWords.length == value['correctWordsFound'].length) {
        color = allWordlineMarkedWords[i].color;
      }
      else {
        color = generateRandomColor();
      }


      for (int j = 0; j < value['correctWordsFound'][i].length; j++) {
        _tiles[value['correctWordsFound'][i][j]].backgroundColor = color;
        _tiles[value['correctWordsFound'][i][j]].textColor = const Color(0xFF221962);
        _tiles[value['correctWordsFound'][i][j]].borderColor = color;
      }
    }

    notifyListeners();
  }

  resetCorrectWords() {
    _correctWords.clear();
    _filteredcorrectWords.clear();
    notifyListeners();
  }

  final List<int> _trackLastIndex = [];
  List<int> get trackLastIndex => _trackLastIndex;

  addToTrackLastIndex(int value) {
    if (!_trackLastIndex.contains(value) &&
        !_allSelectedIndex.contains(value)) {
      _trackLastIndex.add(value);
    }
    notifyListeners();
  }

  resetTrackLastIndex() {
    _trackLastIndex.clear();
    notifyListeners();
  }

  final List<SingleTileModel> _tiles = [];
  late List<List<String>> grid_ = [];
  List<SingleTileModel> get tiles => _tiles;

  addToTiles() {
    print('add tiles');
    _tiles.clear();
    grid_.clear();
    for (int i = 0; i < _gameData['crossword_grid'].length; i++) {
      List<String> list__= [];
      for (int j = 0; j < _gameData['crossword_grid'][i].length; j++) {
        _tiles.add(SingleTileModel(
            alphabet: _gameData['crossword_grid'][i][j].toUpperCase(),
            backgroundColor: Colors.white,
            textColor: const Color(0xFF221962),
            borderColor: Colors.transparent));

        list__.add(_gameData['crossword_grid'][i][j].toUpperCase());
      }
      grid_.add(list__);
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
    _allWordsFromAPI.clear();
    _filteredWordsFromAPI.clear();
    filteredcorrectWords.clear();
    _correctWordsFromAPI.clear();
    _incorrectWordsFromAPI.clear();
    _allSelectedIndex.clear();
    _correctWords.clear();
    _incorrectWords.clear();
    _trackLastIndex.clear();
    _allMarkedWords.clear();
    _allWordlineMarkedWords.clear();
    _wordLineWordsIndex.clear();
    _tiles.clear();
    grid_.clear();
    _gameEnded = false;
  }

  resetOldGame() {
    _allWordsFromAPI.clear();
    _filteredWordsFromAPI.clear();
    filteredcorrectWords.clear();
    _correctWordsFromAPI.clear();
    _incorrectWordsFromAPI.clear();
    _filteredincorrectWords.clear();
    _filteredcorrectWords.clear();
    _tiles.clear();
    grid_.clear();
    _gameEnded = false;
  }
}

class SingleTileModel {
  String? alphabet;
  int? index;
  Color? backgroundColor;
  Color? textColor;
  Color? borderColor;

  SingleTileModel(
      {this.alphabet,
      this.index,
      this.backgroundColor,
      this.textColor,
      this.borderColor});
}
