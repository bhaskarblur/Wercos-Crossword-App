import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/providers/category_provider.dart';
import 'package:mobile_app_word_search/providers/game_screen_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/widget/navigator.dart';
import 'package:mobile_app_word_search/widget/widgets.dart';
import 'package:provider/provider.dart';

import '../api_services.dart';
import '../providers/timer_provider.dart';
import '../widget/sahared_prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrugPage extends StatefulWidget {
  const DrugPage({Key? key}) : super(key: key);

  @override
  State<DrugPage> createState() => _DrugPageState();
}

class _DrugPageState extends State<DrugPage> {
  final ApiServices _apiServices = ApiServices();

  Timer? timer;

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
                          constraints: const BoxConstraints(minHeight: 150),
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
                                itemCount: provider
                                        .gameData['limitedWords'].isEmpty
                                    ? provider.gameData['allWords'].length
                                    : provider.gameData['limitedWords'].length,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        childAspectRatio: 3, crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return Center(
                                      child: Text(
                                          provider.gameData['allWords'][index]
                                                  ['words']
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)));
                                },
                              ),
                            ],
                          ),
                        ),
                        gap(10),
                        Expanded(
                            flex: 3,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    for (int i = 0;
                                        i <
                                            provider.gameData['crossword_grid']
                                                .length;
                                        i++)
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (int j = 0;
                                                j <
                                                    provider
                                                        .gameData[
                                                            'crossword_grid'][i]
                                                        .length;
                                                j++)
                                              Expanded(
                                                child: Text(
                                                    provider.gameData[
                                                        'crossword_grid'][i][j],
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22)),
                                              )
                                          ]),
                                  ],
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
    provider.changeGameData(null);
    print('--------------------');
    print(provider.gameType);
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
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        setState(() {
          provider.chnageSeconds();
        });
      },
    );
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
              startTimer();
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
          _apiServices.post(
              context: context,
              endpoint: 'randomsystemgenerated_crossword',
              body: {
                "language": language,
                "userId": loginId,
                "accessToken": token,
                "type": 'search',
              }).then((value) {
            if (value['gameDetails'] != null) {
              provider.changeGameData(value);
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

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void dispose() {
    super.dispose();
    // timer!.cancel();
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(size.width, 0);
    final p2 = Offset(0, size.height);
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) => false;
}
