import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:werkos/providers/category_provider.dart';
import 'package:werkos/providers/game_screen_provider.dart';
import 'package:werkos/providers/home_provider.dart';
import 'package:werkos/soundConstants.dart';
import 'package:werkos/utils/all_colors.dart';
import 'package:werkos/widget/navigator.dart';
import 'package:werkos/widget/widgets.dart';
import 'package:provider/provider.dart';
import '../api_services.dart';
import '../components/custom_dialogs.dart';
import '../components/labels.dart';
import '../components/suggestion/model/suggestion.dart';
import '../crosswordfile.dart';
import '../linedecoration.dart';
import '../providers/timer_provider.dart';
import '../utils/font_size.dart';
import '../widget/sahared_prefs.dart';
import 'level_completion_page.dart';

class DrugPage extends StatefulWidget {
  const DrugPage({Key? key}) : super(key: key);

  @override
  State<DrugPage> createState() => _DrugPageState();
}

class _DrugPageState extends State<DrugPage> {
  final ApiServices _apiServices = ApiServices();
  late final player;
  List<Color> lineColors = [];

  Color generateRandomColor() {
    Random random = Random();
    // var generatedColor = Random().nextInt(Colors.primaries.length)

    int r = random.nextInt(200) - 128; // Red component between 128 and 255
    int g = random.nextInt(200) - 128; // Green component between 128 and 255
    int b = random.nextInt(200) - 128; // Blue component between 128 and 255

    return Color.fromARGB(155, r, g, b);
  }

  var soundPref_ = "on";

  @override
  void initState() {
    getData();

    Future.delayed(const Duration(milliseconds: 0), () async {
      var soundPref = await Prefs.getPrefs("sound");
      setState(() {
        try {
          soundPref_ = soundPref!;
        } catch (e) {
          print(e);
        }
      });
    });
    super.initState();
    lineColors = List.generate(100, (index) => generateRandomColor()).toList();
    player = AudioPlayer();
  }

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
        //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Exit App'),
              content: Text(AppLocalizations.of(context)!.exit_app),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text(AppLocalizations.of(context)!.no),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  //return true when click on "Yes"
                  child: Text(AppLocalizations.of(context)!.yes),
                ),
              ],
            ),
      ) ??
          false; //if showDialouge had returned null, then return false
    }

    final ScrollController _scrollController = ScrollController();
    return WillPopScope(
        onWillPop: showExitPopup,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Consumer<GameScreenProvider>(builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: provider.gameData == null
                  ?
              Column(
                  children: [
                    statusBar(context),
                    Text('00.00',
                        style: GoogleFonts.inter(
                            textStyle:
                            Theme
                                .of(context)
                                .textTheme
                                .headlineLarge,
                            fontSize: 23,
                            color: const Color(0xFF221962),
                            fontWeight: FontWeight.w700)),
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
                    child:
                    Column(
                        children: [
                      statusBar(context),
                      gap(5),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: AllColors.bg,
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gap(5),
                            Consumer<TimerProvider>(
                                builder: (context, timer, _) {
                                  return Consumer<GameScreenProvider>(
                                      builder: (context, gameProv, _) {
                              return Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment: gameProv.hasGoBack? MainAxisAlignment.end :
                                MainAxisAlignment.center,
                                //Center Row contents horizontally,
                                children: [
                                  Column(
                                      children: [
                                        Text(formatTime(timer.seconds),
                                            style: GoogleFonts.inter(textStyle: Theme
                                                .of(context)
                                                .textTheme
                                                .bodyMedium,
                                                fontSize: 18,
                                                color: AllColors.white,
                                                fontWeight: FontWeight.w700)),
                                        const SizedBox(height: 10),
                                        Row(
                                        children : [
                                        Text(
                                            provider.gameData['gameDetails']
                                            ['gamename'],
                                            style: GoogleFonts.inter(
                                                textStyle: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .headlineLarge,
                                                fontSize: 18,
                                                color: AllColors.liteGreen,
                                                fontWeight: FontWeight.w800)),
                                          if (provider.gameType ==
                                              'randomwordchallenge' ||
                                              provider.gameType ==
                                                  'challengebycategory' ||
                                              provider.gameType == 'challenge' ||
                                              provider.gameData['gameDetails']
                                              ['searchtype'] ==
                                                  'challenge')
                                            horGap(10),
                                          if (provider.gameType ==
                                              'randomwordchallenge' ||
                                              provider.gameType ==
                                                  'challengebycategory' ||
                                              provider.gameType == 'challenge' ||
                                              provider.gameData['gameDetails']
                                              ['searchtype'] ==
                                                  'challenge')
                                            InkWell(
                                                onTap: () {
                                                  CustomDialog
                                                      .showSuggestionDialog(
                                                      context: context,
                                                      suggestions: [
                                                        Suggestion(
                                                            AppLocalizations.of(
                                                                context)!
                                                                .what_is_challenge,
                                                            AppLocalizations.of(
                                                                context)!
                                                                .what_is_challenge_description),
                                                      ]);
                                                },
                                                child: const Icon(
                                                    Icons.info_outline,
                                                    color: AllColors.white,
                                                    size: 22)),
                                        ]),
                                      ]),
                                  gameProv.hasGoBack && provider.gameData['gameDetails']
                                  ['gamename'].toString().length > 15 ?
                                  const SizedBox(width: 55) : gameProv.hasGoBack && provider.gameData['gameDetails']
                                  ['gamename'].toString().length <= 15 ?
                                  const SizedBox(width: 95) : const SizedBox(),
                                  gameProv.hasGoBack ?
                                  CupertinoButton(
                                    onPressed: () {
                                      navigate();
                                    },
                                    minSize: 0,
                                    padding: EdgeInsets.zero,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                            height: 36,
                                            child: Icon(
                                                CupertinoIcons
                                                    .arrowshape_turn_up_left_fill,
                                                color: Colors.white,
                                                size: 28)),
                                        const SizedBox(height: 4),
                                        Label(
                                            text: AppLocalizations.of(
                                                context)!.back,
                                            fontSize: FontSize.p4,
                                            color: AllColors.superLitePurple)
                                      ],
                                    ),
                                  ): const SizedBox(),
                                  gameProv.hasGoBack ?
                                  const SizedBox(width: 20) : const SizedBox(),
                                ],
                              ); });
                                }),
                              if (provider.gameData['gameDetails']
                              ['searchtype'] ==
                                  'search')
                                Expanded(
                                  child: RawScrollbar(
                                      controller: _scrollController,
                                      interactive: true,
                                      thickness: 3,
                                      scrollbarOrientation:
                                      ScrollbarOrientation.right,
                                      thumbVisibility: true,
                                      trackVisibility: true,
                                      thumbColor: AllColors.shineGreen,
                                      radius: Radius.circular(10),
                                      child: GridView.builder(
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 14),
                                        itemCount: provider
                                            .allWordsFromAPI.length,
                                        gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 5,
                                            crossAxisCount: 3),
                                        itemBuilder: (context, index) {
                                          return Container(
                                              child: Text(
                                                  provider
                                                      .allWordsFromAPI[index]
                                                      .toUpperCase(),
                                                  textAlign:
                                                  (index + 1) % 3 == 0
                                                      ? TextAlign.end
                                                      : (index) % 3 ==
                                                      0
                                                      ? TextAlign
                                                      .start
                                                      : TextAlign
                                                      .center,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      decoration: provider
                                                          .correctWords
                                                          .contains(
                                                          provider
                                                              .allWordsFromAPI[index]
                                                              .toUpperCase())
                                                          ? TextDecoration
                                                          .lineThrough
                                                          : TextDecoration
                                                          .none,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: provider
                                                          .correctWords
                                                          .contains(provider
                                                          .allWordsFromAPI[index]
                                                          .toUpperCase())
                                                          ? Colors.green
                                                          : Colors.white)));
                                        },
                                      )),
                                ),
                              if (provider.gameData['gameDetails']
                              ['searchtype'] ==
                                  'challenge')
                                Expanded(
                                  child: RawScrollbar(
                                      controller: _scrollController,
                                      interactive: true,
                                      thickness: 6,
                                      scrollbarOrientation:
                                      ScrollbarOrientation.right,
                                      thumbVisibility: true,
                                      trackVisibility: true,
                                      thumbColor: AllColors.shineGreen,
                                      radius: Radius.circular(10),
                                      child: GridView.builder(
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 14),
                                        itemCount: provider
                                            .allWordsFromAPI.length,
                                        gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 5,
                                            crossAxisCount: 3),
                                        itemBuilder: (context, index) {
                                          return Container(
                                              child: Text(
                                                  provider
                                                      .allWordsFromAPI[index]
                                                      .toUpperCase(),
                                                  textAlign: (index + 1) % 3 ==
                                                      0
                                                      ? TextAlign.end
                                                      : (index) % 3 == 0
                                                      ? TextAlign
                                                      .start
                                                      : TextAlign
                                                      .center,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      decoration: provider
                                                          .correctWords
                                                          .contains(provider
                                                          .allWordsFromAPI[index]
                                                          .toUpperCase())
                                                          ? TextDecoration
                                                          .lineThrough
                                                          : provider
                                                          .incorrectWords
                                                          .contains(provider
                                                          .allWordsFromAPI[index]
                                                          .toUpperCase())
                                                          ? TextDecoration
                                                          .lineThrough
                                                          : TextDecoration
                                                          .none,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: provider
                                                          .correctWords
                                                          .contains(provider
                                                          .allWordsFromAPI[index]
                                                          .toUpperCase())
                                                          ? Colors.green
                                                          : provider
                                                          .incorrectWords
                                                          .contains(provider
                                                          .allWordsFromAPI[index]
                                                          .toUpperCase())
                                                          ? Colors.red
                                                          : Colors.white)));
                                        },
                                      )),
                                ),
                            ],
                          ),
                        ),
                      ),
                      gap(10),
                    ]),
                  ),
                  if (!provider.gameEnded || provider.allowMark)
                    if (provider.grid_.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        child: Crossword(
                          letters: provider.grid_,
                          acceptReversedDirection: true,
                          drawVerticalLine: true,
                          drawHorizontalLine: true,
                          spacing:
                          MediaQuery
                              .of(context)
                              .size
                              .width <= 376
                              ? const Offset(30, 33)
                              : const Offset(32, 33),
                          drawCrossLine: true,
                          onLineDrawn: (List<String> words) async {
                            var reverseWord = words.last
                                .toString()
                                .split('')
                                .reversed
                                .join('');
                            print(reverseWord);
                            var index = provider.filteredWordsFromAPI.
                            indexOf(words.last.toString());

                            if (index < 0) {
                              index = provider.filteredWordsFromAPI
                                  .indexOf(reverseWord);
                            }
                            var word_ = provider.allWordsFromAPI[index];

                            if (provider.gameData['gameDetails']
                            ['searchtype'] ==
                                'search') {
                              if (provider.allWordsFromAPI
                                  .contains(word_)) {
                                provider.addToCorrectWords(word_);
                                provider.addToFilteredCorrectWords(
                                    words.last.toString());
                                if (soundPref_ == "on") {
                                  await AudioPlayer()
                                      .play(soundConstants.correctAnswer);
                                }
                                // print(player.playing);
                              }
                            }
                            else {
                              if (provider.correctWordsFromAPI
                                  .contains(words.last.toString()) ||
                                  provider.correctWordsFromAPI
                                      .contains(reverseWord)) {
                                provider.addToCorrectWords(word_);
                                provider.addToMarkedWords(word_);
                                provider.addToFilteredCorrectWords(
                                    words.last.toString());
                                if (soundPref_ == "on") {
                                  await AudioPlayer()
                                      .play(soundConstants.correctAnswer);
                                }
                              } else if (provider.incorrectWordsFromAPI
                                  .contains(words.last.toString()) ||
                                  provider.incorrectWordsFromAPI
                                      .contains(reverseWord)) {
                                provider.addToInCorrectWords(word_);
                                print('__incorrect__');
                                provider.addToMarkedWords(word_);
                                provider.addToFilteredInCorrectWords(
                                    words.last.toString());
                                if (soundPref_ == "on") {
                                  await AudioPlayer()
                                      .play(soundConstants.wrongAnswer);
                                }
                                // print(player.playing);
                              }
                            }

                            print(provider.allMarkedWords.length
                                .toString());
                            if (provider.gameData['gameDetails']
                            ['searchtype'] ==
                                'search') {
                              if (provider.allWordsFromAPI.length ==
                                  provider.correctWords.length) {
                                navigate();
                              }
                            } else {
                              List<String> correctWordsMarked = [];
                              List<String> wordsToMark = [];

                              for (var word
                              in provider.correctWordsFromAPI) {
                                if (provider.allWordsFromAPI
                                    .contains(word)) {
                                  wordsToMark.add(word);
                                }
                                if (provider.allMarkedWords
                                    .contains(word)) {
                                  correctWordsMarked.add(word);
                                }
                              }

                              if (provider.correctWordsFromAPI.length ==
                                  provider.correctWords.length) {
                                navigate();
                              } else if (provider
                                  .allWordsFromAPI.length ==
                                  provider.allMarkedWords.length) {
                                navigate();
                              } else {
                                if (provider.correctWords.length > 0) {
                                  if (correctWordsMarked.length ==
                                      wordsToMark.length) {
                                    navigate();
                                  }
                                }
                              }
                            }
                          },
                          textStyle: TextStyle(
                              fontSize: 23,
                              color: const Color(0xFF221962),
                              fontWeight: FontWeight.w900),
                          lineDecoration: LineDecoration(
                              lineColors: lineColors,
                              incorrectColor: Colors.red,
                              strokeWidth: 28,
                              borderColor: Colors.red),
                          allWords:
                          provider.filteredWordsFromAPI.isNotEmpty
                              ? provider.filteredWordsFromAPI
                              : [],
                          correctWords: provider.gameData['gameDetails']
                          ['searchtype'] ==
                              'challenge'
                              ? provider.correctWordsFromAPI
                              : provider.allWordsFromAPI,
                          incorrWords: provider.incorrectWordsFromAPI,
                        ),
                      ),
                  if (provider.gameEnded && !provider.allowMark)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Listener(
                            onPointerDown: null,
                            onPointerMove: null,
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
                                      border: Border.all(
                                          color: provider
                                              .tiles[index].borderColor!),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      color: provider
                                          .tiles[index].backgroundColor),
                                  child: Center(
                                    child: Foo(
                                      index: index,
                                      child: Text(
                                        provider.tiles[index].alphabet!,
                                        style: GoogleFonts.inter(
                                            textStyle: Theme
                                                .of(context)
                                                .textTheme
                                                .headlineLarge,
                                            fontSize: 23,
                                            color:
                                            const Color(0xFF221962),
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
          }),
          floatingActionButton:
          Consumer<GameScreenProvider>(builder: (context, provider, _) {
            return provider.isMarkingCurrently
                ? Container(
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height < 900 &&
                        MediaQuery
                            .of(context)
                            .size
                            .height > 650
                        ? MediaQuery
                        .of(context)
                        .size
                        .height / 2 -
                        MediaQuery
                            .of(context)
                            .size
                            .height / 4
                        : MediaQuery
                        .of(context)
                        .size
                        .height / 2 -
                        MediaQuery
                            .of(context)
                            .size
                            .height / 3.5),
                child: Container(
                    decoration: BoxDecoration(
                      color: AllColors.shineGreen,
                      borderRadius: BorderRadius.circular(0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset:
                          Offset(1, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 6, bottom: 6, left: 12, right: 12),
                      child: Text(provider.currentMarkedWord.toString(),
                          style: GoogleFonts.inter(
                              textStyle:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .headlineSmall,
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    )))
                : Container();
          }),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        ));
  }

  @override
  void dispose() {
    super.dispose();
    if (timer != null) {
      timer!.cancel();
    }
    // final provider = Provider.of<TimerProvider>(context, listen: false);
    // provider.cancelTimer(); 5064121
  }

  getData() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    // provider.reset();
    timerProvider.stopSeconds();
    timerProvider.setTicking(false);
    timerProvider.resetSeconds();

    if (provider.gameType != 'gamewithcode') {
      provider.reset();
    }
    print(provider.gameType);
    if (provider.gameType == 'random') {
      getRandomGame();
    }
    if (provider.gameType == 'gamewithcode') {
      // getGameWithCode();
      startTimer();
    }
    if (provider.gameType == 'randomwordsearch') {
      getRandomWordSearchOrChallenge();
    }
    if (provider.gameType == 'randomwordchallenge') {
      startTimer();
      // getRandomWordSearch();
    }
    if (provider.gameType == 'challenge') {
      getCategorySearch();
    }

    if (provider.gameType == 'challengebycategory' ||
        provider.gameType == 'searchbycategory') {
      categorySearch();
    }

    print(provider.correctWordsFromAPI);
    print(provider.incorrectWordsFromAPI);
  }

  void startTimer() {
    final provider_game =
    Provider.of<GameScreenProvider>(context, listen: false);
    final provider = Provider.of<TimerProvider>(context, listen: false);
    provider.resetSeconds();
    provider.setTicking(true);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (provider_game.gameType.contains("randomwordchallenge")) {
        provider_game.reAddWordsForChallenge();
      }
      provider_game.setGameEnded(false);
      provider_game.setAllowMark(true);
    });

    print(provider.ticking);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (provider.ticking == true) {
        provider.changeSeconds();
        // print(provider_game.filteredcorrectWords);
        // print(provider_game.gameEnded);
        // print(provider_game.allowMark);
        // print(provider.seconds);
      } else {
        provider.stopSeconds();
        print('timer stopped');
        timer.cancel();
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
                endpoint: 'randomsearch_crossword',
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
                  if (value['message']
                      .toString()
                      .contains('Cannot play more')) {
                    // dialog(context, 'Your have reached daily limit of your games. Come back tomorrow or upgrade to continue.', () {
                    //   Nav.pop(context);
                    CustomDialog.showGamesFinishedDialog(context: context);
                    // final provider =
                    // Provider.of<HomeProvider>(context, listen: false);
                    // provider.changeSelectedIndex(1);
                    // });
                  } else {
                    CustomDialog.noGameAvailable(context: context);
                  }
                }
              }
            });
          });
        });
      });
    });
  }

  getRandomWordSearchOrChallenge() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('wordLimit').then((wordLimit) {
          Prefs.getPrefs('gameLanguage').then((language) {
            _apiServices.post(
                context: context,
                endpoint: 'randomsearch_crossword',
                body: {
                  "language": language,
                  "userId": loginId,
                  "accessToken": token,
                  "words_limit": wordLimit,
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
                if (value['message'].toString().contains('Cannot play more')) {
                  CustomDialog.showGamesFinishedDialog(context: context);
                } else {
                  CustomDialog.noGameAvailable(context: context);
                }
              }
            });
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
            print('this is data');
            // print({
            //   "language": language,
            //   "userId": loginId,
            //   "words_limit": wordLimit,
            //   'type': provider.gameType == 'challengebycategory'
            //       ? 'challenge'
            //       : 'search',
            //   "accessToken": token,
            //   "category" : '',
            //   "topic": cProvider.selectedCategory['topicsname'].toString(),
            // });
            _apiServices
                .post(context: context, endpoint: 'topicwise_crossword', body: {
              "language": language,
              "userId": loginId,
              "words_limit": wordLimit,
              'type': provider.gameType == 'challengebycategory'
                  ? 'challenge'
                  : 'search',
              "accessToken": token,
              "category": cProvider.selectedCategory['categoryname'],
              "topic": cProvider.selectedCategory['topicsname'],
            }).then((value) {
              print('hello');
              if (value['gameDetails'] != null) {
                provider.changeGameData(value);
                provider.addToCorrectWordsIncorrectWordsFromAPI();
                if (provider.gameType == 'challengebycategory') {
                  Nav.pop(context);

                  final provider_ =
                  Provider.of<HomeProvider>(context, listen: false);
                  provider_.changeSelectedIndex(4);
                }
                startTimer();
              } else {
                if (value['message'].toString().contains('Cannot play more')) {
                  CustomDialog.showGamesFinishedDialog(context: context);
                } else {
                  CustomDialog.noGameAvailable(context: context);
                }
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
            print('here is data');
            _apiServices
                .post(context: context, endpoint: 'topicwise_crossword', body: {
              "language": language,
              "words_limit": wordLimit,
              'type': 'search',
              'userId': loginId,
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
                  if (value['message']
                      .toString()
                      .contains('Cannot play more')) {
                    CustomDialog.showGamesFinishedDialog(context: context);
                  } else {
                    // dialog(context, 'No Game Available', () {
                    //   Nav.pop(context);
                    //   final provider =
                    //   Provider.of<HomeProvider>(context, listen: false);
                    //   provider.changeSelectedIndex(1);
                    // });
                    CustomDialog.noGameAvailable(context: context);
                  }
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

    // print('all');
    // print(provider.allWordsFromAPI);
    // print('correct');
    // print(provider.correctWordsFromAPI);
    // print('incorrect');
    // print(provider.incorrectWordsFromAPI);
    // print('correct selected');
    // print(provider.correctWords);
    // print('incorrect selected');
    // print(provider.incorrectWords);

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

    p.stopSeconds();
    p.setTicking(false);
    gameProvider.setGameEnded(true);
    print('totalWords_');
    print(gameProvider.allWordsFromAPI.length);
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (gameProvider.gameData['gameDetails']['searchtype'] == 'search') {
        if (soundPref_ == "on") {
          if(!gameProvider.hasGoBack) {
            await AudioPlayer().play(soundConstants.gameCompleted);
          }
        }
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
        final provider =
        Provider.of<GameScreenProvider>(context, listen: false);
        // if (provider.allWordsFromAPI.length == provider.allMarkedWords.length) {

        // }
        List<String> correctWordsMarked = [];
        List<String> wordsToMark = [];

        for (var word in provider.correctWordsFromAPI) {
          if (provider.allWordsFromAPI.contains(word)) {
            wordsToMark.add(word);
          }
          if (provider.allMarkedWords.contains(word)) {
            correctWordsMarked.add(word);
          }
        }
        if (provider.correctWords.length > 0) {
          if (correctWordsMarked.length == wordsToMark.length) {
            if (soundPref_ == "on") {
              if(!provider.hasGoBack) {
                await AudioPlayer().play(soundConstants.gameCompleted);
              }
            }

            if (provider.incorrectWords.length > 0) {
              Nav.push(
                  context,
                  LevelCompletionPage(
                    // isCompleted: gameProvider.correctWordsFromAPI.length ==
                    //     gameProvider.correctWords.length,
                    isCompleted: true,
                    totalWord: gameProvider.filteredWordsFromAPI.length,
                    correctWord: gameProvider.filteredWordsFromAPI.length -
                        gameProvider.incorrectWords.length,
                    seconds: p.seconds,
                  ));
            } else {
              Nav.push(
                  context,
                  LevelCompletionPage(
                    // isCompleted: gameProvider.correctWordsFromAPI.length ==
                    //     gameProvider.correctWords.length,
                    isCompleted: true,
                    totalWord: gameProvider.filteredWordsFromAPI.length,
                    correctWord: gameProvider.allWordsFromAPI.length,
                    seconds: p.seconds,
                  ));
            }
          } else if (provider.allWordsFromAPI.length ==
              provider.allMarkedWords.length) {
            if (correctWordsMarked.length == wordsToMark.length) {
              if (soundPref_ == "on") {
                if(!provider.hasGoBack) {
                  await AudioPlayer().play(soundConstants.gameCompleted);
                }
              }
            } else {
              if (soundPref_ == "on") {
                if(!provider.hasGoBack) {
                  await AudioPlayer().play(soundConstants.gameEnded);
                }
              }
            }

            if (provider.incorrectWords.length > 0) {
              Nav.push(
                  context,
                  LevelCompletionPage(
                    // isCompleted: gameProvider.correctWordsFromAPI.length ==
                    //     gameProvider.correctWords.length,
                    isCompleted: true,
                    totalWord: gameProvider.filteredWordsFromAPI.length,
                    correctWord: gameProvider.filteredWordsFromAPI.length -
                        gameProvider.incorrectWords.length,
                    seconds: p.seconds,
                  ));
            } else {
              Nav.push(
                  context,
                  LevelCompletionPage(
                    // isCompleted: gameProvider.correctWordsFromAPI.length ==
                    //     gameProvider.correctWords.length,
                    isCompleted: true,
                    totalWord: gameProvider.filteredWordsFromAPI.length,
                    correctWord: gameProvider.filteredWordsFromAPI.length,
                    seconds: p.seconds,
                  ));
            }
          }
        }
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
