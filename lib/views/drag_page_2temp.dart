import 'dart:async';
import 'dart:math';

import 'package:crossword/components/line_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:crossword_flutter/providers/category_provider.dart';
import 'package:crossword_flutter/providers/game_screen_provider.dart';
import 'package:crossword_flutter/utils/all_colors.dart';
import 'package:crossword_flutter/widget/navigator.dart';
import 'package:crossword_flutter/widget/widgets.dart';
import 'package:provider/provider.dart';

import '../api_services.dart';
import '../providers/timer_provider.dart';
import '../widget/sahared_prefs.dart';
import 'level_completion_page.dart';
import 'package:crossword_flutter/crosswordfile.dart';

class DrugPage2 extends StatefulWidget {
  const DrugPage2({Key? key}) : super(key: key);

  @override
  State<DrugPage2> createState() => _DrugPageState();
}

class _DrugPageState extends State<DrugPage2> {
  final ApiServices _apiServices = ApiServices();
  List<Color> lineColors = [];

  List<int> letterGrid = [11, 14];

  List<List<String>> generateRandomLetters() {
    final random = Random();
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    List<List<String>> array = List.generate(
        letterGrid.first,
            (_) => List.generate(
            letterGrid.last, (_) => letters[random.nextInt(letters.length)]));

    return array;
  }

  Color generateRandomColor() {
    Random random = Random();

    int r = random.nextInt(200) - 128; // Red component between 128 and 255
    int g = random.nextInt(200) - 128; // Green component between 128 and 255
    int b = random.nextInt(200) - 128; // Blue component between 128 and 255

    return Color.fromARGB(255, r, g, b);
  }
  @override
  void initState() {
    // getData();
    super.initState();
    lineColors = List.generate(100, (index) => generateRandomColor()).toList();
  }

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text('Do you want to exit the App?'),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child:Text('No'),
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              //return true when click on "Yes"
              child:Text('Yes'),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }

    return Scaffold(
        backgroundColor: Colors.black,
        body: Crossword(

          letters: const [
            ["F", "L", "U", "T", "T", "E", "R", "W", "U", "D", "B", "C"],
            ["R", "M", "I", "O", "P", "U", "I", "Q", "R", "L", "E", "G"],
            ["T", "V", "D", "I", "R", "I", "M", "U", "A", "H", "E", "A"],
            ["D", "A", "R", "T", "N", "S", "T", "O", "Y", "J", "R", "M"],
            ["O", "G", "A", "M", "E", "S", "C", "O", "L", "O", "R", "S"],
            ["S", "R", "T", "I", "I", "I", "F", "X", "S", "P", "E", "D"],
            ["Y", "S", "N", "E", "T", "M", "M", "C", "E", "A", "T", "S"],
            ["W", "E", "T", "P", "A", "T", "D", "Y", "L", "M", "N", "U"],
            ["O", "T", "E", "H", "R", "O", "G", "P", "T", "U", "O", "E"],
            ["K", "R", "R", "C", "G", "A", "M", "E", "S", "S", "T", "S"],
            ["S", "E", "S", "T", "L", "A", "O", "P", "U", "P", "E", "S"]
          ],
          acceptReversedDirection: true,
          drawVerticalLine:true,
          drawHorizontalLine:true,
          spacing: const Offset(30, 30),
          drawCrossLine:true,
          onLineDrawn: (List<String> words) {

          },
          textStyle: const TextStyle(color: Colors.white, fontSize: 20),
          allWords: const ["FLUTTER", "GAMES", "UI", "COLORS"],
          incorrWords: [],
          correctWords: [],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
    // final provider = Provider.of<TimerProvider>(context, listen: false);
    // // provider.cancelTimer();
  }

  getData() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    // provider.reset();
    timerProvider.resetSeconds();
    // provider.changeSelectedColor();

    print(provider.gameType);
    if (provider.gameType == 'random') {
      getRandomGame();
    }
    if (provider.gameType == 'gamewithcode') {
      // getGameWithCode();
      startTimer();
    }
    if (provider.gameType == 'randomwordsearch') {
      getRandomWordSearch();
    }
    if (provider.gameType == 'randomwordchallenge') {
      startTimer();
      // getRandomWordSearch();
    }
    if (provider.gameType == 'category') {
      getCategorySearch();
    }

    if (provider.gameType == 'challengebycategory' ||
        provider.gameType == 'searchbycategory') {
          categorySearch();
        }
  }

  void startTimer() {
    final provider = Provider.of<TimerProvider>(context, listen: false);
    provider.resetSeconds();
    provider.setTicking(true);
    print(provider.ticking);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(provider.ticking == true) {
        provider.changeSeconds();
      }
      else {
        provider.stopSeconds();
      }

    });


  }

  // getGameWithCode() {
  //   final provider = Provider.of<GameScreenProvider>(context, listen: false);
  //   Prefs.getToken().then((token) {
  //     Prefs.getPrefs('loginId').then((loginId) {
  //       Prefs.getPrefs('wordLimit').then((wordLimit) {
  //         _apiServices.post(context: context, endpoint: 'getGameByCode', body: {
  //           "accessToken": token,
  //           "userId": loginId,
  //           "sharecode": provider.search,
  //         }).then((value) {
  //           if (value['gameDetails'] != null) {
  //             provider.changeGameData(value);
  //             provider.addToCorrectWordsIncorrectWordsFromAPI();
  //             startTimer();
  //           } else {
  //             if (value['message'] != null) {
  //               dialog(context, value['message'], () {
  //                 Nav.pop(context);
  //               });
  //             }
  //           }
  //         });
  //       });
  //     });
  //   });
  // }

  getRandomGame() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('gameLanguage').then((language) {
          Prefs.getPrefs('wordLimit').then((wordLimit) {
            _apiServices.post(
                context: context,
                endpoint: 'randomsystemgenerated_crossword',
                body: {
                  "language": language,
                  "userId": loginId,
                  "words_limit": wordLimit,
                  "accessToken": token,
                  "type": 'search',
                }).then((value) {
              if (value['gameDetails'] != null) {
                provider.changeGameData(value);
                provider.addToCorrectWordsIncorrectWordsFromAPI();

                startTimer();
              } else {
                if (value['message'] != null) {
                  dialog(context, 'No Game Available', () {
                    Nav.pop(context);
                  });
                }
              }
            });
          });
        });
      });
    });
  }

  getRandomWordSearch() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('gameLanguage').then((language) {
          _apiServices.post(
              context: context,
              endpoint: 'randomusergenerated_crossword',
              body: {
                "language": language,
                "userId": loginId,
                "accessToken": token,
                'type': provider.gameType == 'randomwordchallenge'
                    ? 'challenge'
                    : 'search'
              }).then((value) {
            if (value['gameDetails'] != null) {
              print('testinggames');
              print(value['gameDetails']);
              provider.changeGameData(value);
              provider.addToCorrectWordsIncorrectWordsFromAPI();

              startTimer();
            } else {
                dialog(context, 'No Game Available', () {
                  Nav.pop(context);
                });
              
            }
          });
        });
      });
    });
  }

  categorySearch() {
    print('------------------');
    print('categorySearch');
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    final cProvider = Provider.of<CategoryProvider>(context, listen: false);
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('wordLimit').then((wordLimit) {
          Prefs.getPrefs('gameLanguage').then((language) {
            print(cProvider.selectedCategory.toString());
            print({
              "language": language,
              "userId": loginId,
              "words_limit": wordLimit,
              'type': provider.gameType == 'challengebycategory'
                  ? 'challenge'
                  : 'search',
              "accessToken": token,
              "category" : '',
              "topic": cProvider.selectedCategory['topicsname'].toString(),
            });
            _apiServices
                .post(context: context, endpoint: 'topicwise_crossword', body: {
              "language": language,
              "userId": loginId,
              "words_limit": wordLimit,
              'type': provider.gameType == 'challengebycategory'
                  ? 'challenge'
                  : 'search',
              "accessToken": token,
              "category" : cProvider.selectedCategory['categoryname'],
              "topic": cProvider.selectedCategory['topicsname'],
            }).then((value) {
              if (value['gameDetails'] != null) {
                provider.changeGameData(value);
                provider.addToCorrectWordsIncorrectWordsFromAPI();

                startTimer();
              } else {
                dialog(context, 'No Game Available', () {
                  Nav.pop(context);
                });
              }
            });
          });
        });
      });
    });
  }

  getCategorySearch() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('gameLanguage').then((language) {
          Prefs.getPrefs('wordLimit').then((wordLimit) {
            _apiServices
                .post(context: context, endpoint: 'topicwise_crossword', body: {
              "language": language,
              "words_limit": wordLimit,
              'type': 'search',
              "category": categoryProvider.selectedCategory['categoryname']
                  .toLowerCase(),
              "topic":
                  categoryProvider.selectedCategory['topicsname'].toLowerCase(),
            }).then((value) {
              if (value['gameDetails'] != null) {
                provider.changeGameData(value);
                provider.addToCorrectWordsIncorrectWordsFromAPI();

                startTimer();
              } else {
                if (value['message'] != null) {
                  dialog(context, 'No Game Available', () {
                    Nav.pop(context);
                  });
                }
              }
            });
          });
        });
      });
    });
  }

  // final Set<int> selectedIndexes = <int>{};
  final key = GlobalKey();
  // final Set<_Foo> _trackTaped = <_Foo>{};
  String word = '';

  _detectTapedItem(PointerEvent event) {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);

    final RenderBox box =
        key.currentContext!.findAncestorRenderObjectOfType<RenderBox>()!;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        if (target is _Foo) {
          if (!provider.allSelectedIndex.contains(target.index)) {
            provider.changeGridAndTextColor(target.index);
          }
          provider.addToTrackLastIndex(target.index);
          provider.addToAllSelectedIndex(target.index);
        }
      }
    }
  }

  void _clearSelection(PointerUpEvent event) {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);

    // // add the word to word list
    provider.makeWord();
    provider.addToCorrectOrIncorrectWords();

    print('all');
    print(provider.allWordsFromAPI);
    print('correct');
    print(provider.correctWordsFromAPI);
    print('incorrect');
    print(provider.incorrectWordsFromAPI);
    print('correct selected');
    print(provider.correctWords);
    print('incorrect selected');
    print(provider.incorrectWords);

    // to automatically travel to result screen after selecting all screens

    if (provider.gameData['gameDetails']['searchtype'] == 'search') {
      if (provider.allWordsFromAPI.length == provider.correctWords.length) {
        navigate();
      }
    } else {
      if (provider.correctWordsFromAPI.length == provider.correctWords.length) {
        navigate();
      }
    }

    // change the color of selection of grid
    provider.changeSelectedColor();
  }

  navigate() {
    final gameProvider =
        Provider.of<GameScreenProvider>(context, listen: false);
    final p = Provider.of<TimerProvider>(context, listen: false);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (gameProvider.gameData['gameDetails']['searchtype'] == 'search') {
        Nav.push(
            context,
            LevelCompletionPage(
              isCompleted: gameProvider.allWordsFromAPI.length ==
                  gameProvider.correctWords.length,
              totalWord: gameProvider.allWordsFromAPI.length,
              correctWord: gameProvider.correctWords.length,
              seconds: p.seconds,
            ));
      } else {
        Nav.push(
            context,
            LevelCompletionPage(
              isCompleted: gameProvider.correctWordsFromAPI.length ==
                  gameProvider.correctWords.length,
              totalWord: gameProvider.correctWordsFromAPI.length,
              correctWord: gameProvider.correctWords.length,
              seconds: p.seconds,
            ));
      }
    });
  }
}

class Foo extends SingleChildRenderObjectWidget {
  final int index;

  const Foo({required Widget child, required this.index, Key? key})
      : super(child: child, key: key);

  @override
  _Foo createRenderObject(BuildContext context) {
    return _Foo(index);
  }

  @override
  void updateRenderObject(BuildContext context, _Foo renderObject) {
    renderObject.index = index;
  }
}

class _Foo extends RenderProxyBox {
  int index;
  _Foo(this.index);
}
