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

class DrugPage extends StatefulWidget {
  const DrugPage({Key? key}) : super(key: key);

  @override
  State<DrugPage> createState() => _DrugPageState();
}

class _DrugPageState extends State<DrugPage> {
  final ApiServices _apiServices = ApiServices();

  Color selectedColor = Colors.red;

  double strokeWidth = 20;

  List<dynamic> drawingPoints = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
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
                      children: [
                        statusBar(context),
                        Consumer<TimerProvider>(builder: (context, timer, _) {
                          return Text(formatTime(timer.seconds),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16));
                        }),
                        gap(5),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: AllColors.bg,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            children: [
                              gap(5),
                              Text(provider.gameData['gameDetails']['gamename'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 18)),
                              GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(10),
                                itemCount: provider.correctWordsFromAPI.length,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 5, crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return Center(
                                      child: Text(
                                          provider.correctWordsFromAPI[index],
                                          style: TextStyle(
                                              decoration: provider.correctWords
                                                      .contains(provider
                                                          .correctWordsFromAPI[
                                                              index]
                                                          .toUpperCase())
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              fontWeight: FontWeight.bold,
                                              color: provider.correctWords
                                                      .contains(provider
                                                          .correctWordsFromAPI[
                                                              index]
                                                          .toUpperCase())
                                                  ? Colors.green
                                                  : Colors.white)));
                                },
                              ),
                            ],
                          ),
                        ),
                        gap(10),
                        Expanded(
                            flex: 2,
                            child: Container(
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 11,
                                              childAspectRatio: 1,
                                              crossAxisSpacing: 3,
                                              mainAxisSpacing: 3),
                                      itemBuilder: (context, index) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: provider.tiles[index]
                                                  .backgroundColor),
                                          child: Center(
                                            child: Foo(
                                              index: index,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Text(
                                                  provider
                                                      .tiles[index].alphabet!,
                                                  style: TextStyle(
                                                      color: provider
                                                          .tiles[index]
                                                          .textColor,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
            );
          }),
        ));
  }

  getData() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    provider.resetGameData();
    if (provider.gameType == 'random') {
      getRandomGame();
    }
    if (provider.gameType == 'gamewithcode') {
      getGameWithCode();
    }
    if (provider.gameType == 'randomwordsearch') {
      getRandomWordSearch();
    }
    if (provider.gameType == 'randomwordchallenge') {
      getRandomWordSearch();
    }
    if (provider.gameType == 'category') {
      getCategorySearch();
    }
  }

  void startTimer() {
    final provider = Provider.of<TimerProvider>(context, listen: false);

    provider.startTimer();
  }

  getGameWithCode() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('wordLimit').then((wordLimit) {
          _apiServices.post(context: context, endpoint: 'getGameByCode', body: {
            "accessToken": token,
            "userId": loginId,
            "sharecode": provider.search,
          }).then((value) {
            if (value['gameDetails'] != null) {
              provider.changeGameData(value);
              provider.addToCorrectWordsFromAPI();
              startTimer();
            } else {
              if (value['message'] != null) {
                dialog(context, value['message'], () {
                  Nav.pop(context);
                });
              }
            }
          });
        });
      });
    });
  }

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
                provider.addToCorrectWordsFromAPI();
                startTimer();
              } else {
                if (value['message'] != null) {
                  dialog(context, value['message'], () {
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
              provider.changeGameData(value);
              provider.addToCorrectWordsFromAPI();
              startTimer();
            } else {
              if (value['message'] != null) {
                dialog(context, value['message'], () {
                  Nav.pop(context);
                });
              }
            }
          });
        });
      });
    });
  }

  challengeByCategory() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('wordLimit').then((wordLimit) {
          Prefs.getPrefs('gameLanguage').then((language) {
            _apiServices
                .post(context: context, endpoint: 'topicwise_crossword', body: {
              "language": language,
              "userId": loginId,
              "words_limit": wordLimit,
              'type': 'challenge',
              "accessToken": token,
            }).then((value) {
              if (value['gameDetails'] != null) {
                provider.changeGameData(value);
                provider.addToCorrectWordsFromAPI();
                startTimer();
              } else {
                dialog(context, value['message'], () {
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
                provider.addToCorrectWordsFromAPI();
                startTimer();
              } else {
                if (value['message'] != null) {
                  dialog(context, value['message'], () {
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
    // change the color of selection of grid
    provider.changeSelectedColor();

    // // add the word to word list
    provider.makeWord();
    provider.addToCorrectWords();
    provider.resetSelectedWord();
    provider.resetTrackLastIndex();
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
