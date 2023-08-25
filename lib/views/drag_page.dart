import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mobile_app_word_search/providers/category_provider.dart';
import 'package:mobile_app_word_search/providers/game_screen_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/widget/navigator.dart';
import 'package:mobile_app_word_search/widget/widgets.dart';
import 'package:provider/provider.dart';

import '../api_services.dart';
import '../providers/timer_provider.dart';
import '../widget/sahared_prefs.dart';
import 'level_completion_page.dart';

class DrugPage extends StatefulWidget {
  const DrugPage({Key? key}) : super(key: key);

  @override
  State<DrugPage> createState() => _DrugPageState();
}

class _DrugPageState extends State<DrugPage> {
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    getData();
    super.initState();
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

    return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Consumer<GameScreenProvider>(builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: provider.gameData == null
                  ? Column(children: [
                      statusBar(context),
                      const Text('00.00',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18)),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: AllColors.bg,
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      gap(10),
                      Expanded(
                          flex: 3,
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white)))
                    ])
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(children: [
                            statusBar(context),
                            Consumer<TimerProvider>(
                                builder: (context, timer, _) {
                              return Text(formatTime(timer.seconds),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18));
                            }),
                            gap(5),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    gradient: AllColors.bg,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    gap(5),
                                    Text(
                                        provider.gameData['gameDetails']
                                            ['gamename'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 18)),
                                    if (provider.gameData['gameDetails']
                                            ['searchtype'] ==
                                        'search')
                                      Expanded(
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          itemCount:
                                              provider.allWordsFromAPI.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 5,
                                                  crossAxisCount: 3),
                                          itemBuilder: (context, index) {
                                            return Text(
                                                provider.allWordsFromAPI[index]
                                                    .toUpperCase(),
                                                textAlign: (index + 1) % 3 == 0
                                                    ? TextAlign.end
                                                    : (index) % 3 == 0
                                                        ? TextAlign.start
                                                        : TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    decoration: provider
                                                            .correctWords
                                                            .contains(provider
                                                                .allWordsFromAPI[
                                                                    index]
                                                                .toUpperCase())
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                                    fontWeight: FontWeight.bold,
                                                    color: provider.correctWords
                                                            .contains(provider
                                                                .allWordsFromAPI[
                                                                    index]
                                                                .toUpperCase())
                                                        ? Colors.green
                                                        : Colors.white));
                                          },
                                        ),
                                      ),
                                    if (provider.gameData['gameDetails']
                                            ['searchtype'] ==
                                        'challenge')
                                      GridView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        itemCount:
                                            provider.allWordsFromAPI.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 5,
                                                crossAxisCount: 3),
                                        itemBuilder: (context, index) {
                                          return Text(
                                              provider.allWordsFromAPI[index]
                                                  .toUpperCase(),
                                              textAlign: (index + 1) % 3 == 0
                                                  ? TextAlign.end
                                                  : (index) % 3 == 0
                                                      ? TextAlign.start
                                                      : TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  decoration: provider
                                                          .correctWords
                                                          .contains(
                                                              provider.allWordsFromAPI[index]
                                                                  .toUpperCase())
                                                      ? TextDecoration
                                                          .lineThrough
                                                      : provider.incorrectWords
                                                              .contains(provider
                                                                  .allWordsFromAPI[
                                                                      index]
                                                                  .toUpperCase())
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : TextDecoration.none,
                                                  fontWeight: FontWeight.bold,
                                                  color: provider.correctWords
                                                          .contains(provider
                                                              .allWordsFromAPI[index]
                                                              .toUpperCase())
                                                      ? Colors.green
                                                      : provider.incorrectWords.contains(provider.allWordsFromAPI[index].toUpperCase())
                                                          ? Colors.red
                                                          : Colors.white));
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            gap(10),
                          ]),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Listener(
                                onPointerDown: _detectTapedItem,
                                onPointerMove: _detectTapedItem,
                                onPointerUp: _clearSelection,
                                child: GridView.builder(
                                  key: key,
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: provider.tiles.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 11,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 3,
                                    mainAxisSpacing: 3
                                  ),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: provider
                                                  .tiles[index].borderColor!),
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          color: provider
                                              .tiles[index].backgroundColor),
                                      child: Center(
                                        child: Foo(
                                          index: index,
                                          child: Text(
                                            provider.tiles[index].alphabet!,
                                            style: TextStyle(
                                                color: provider
                                                    .tiles[index].textColor,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 22),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            );
          }),
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
