import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:crossword_flutter/providers/category_provider.dart';
import 'package:crossword_flutter/providers/game_screen_provider.dart';
import 'package:crossword_flutter/providers/home_provider.dart';
import 'package:crossword_flutter/utils/all_colors.dart';
import 'package:crossword_flutter/widget/navigator.dart';
import 'package:crossword_flutter/widget/widgets.dart';
import 'package:provider/provider.dart';
import '../api_services.dart';
import '../components/custom_dialogs.dart';
import '../components/suggestion/model/suggestion.dart';
import '../crosswordfile.dart';
import '../linedecoration.dart';
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


  @override
  void initState() {
    getData();

    super.initState();
    lineColors = List.generate(100, (index) => generateRandomColor()).toList();
    player = AudioPlayer();
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
                Text('00.00',
                          style: GoogleFonts.inter(textStyle:
                          Theme.of(context).textTheme.headlineLarge,fontSize: 23, color: const Color(0xFF221962)
                              , fontWeight: FontWeight.w700)),
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
                                  style: GoogleFonts.inter(textStyle:
                                  Theme.of(context).textTheme.headlineLarge,fontSize: 18, color: Colors.white
                                      , fontWeight: FontWeight.w700));
                            }),
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
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,

                                      children: [
                                        Text(
                                            provider.gameData['gameDetails']
                                            ['gamename'],
                                            style: GoogleFonts.inter(textStyle:
                                            Theme.of(context).textTheme.headlineLarge,fontSize: 18, color: Colors.white
                                                , fontWeight: FontWeight.w700)),
                                        if (provider.gameType == 'randomwordchallenge' ||
                                        provider.gameType == 'challengebycategory'
                                        || provider.gameType == 'challenge'
                                        || provider.gameData['gameDetails']
                                            ['searchtype'] == 'challenge' )
                                          horGap(10),
                                        if (provider.gameType == 'randomwordchallenge' ||
                                            provider.gameType == 'challengebycategory'
                                            || provider.gameType == 'challenge'
                                            || provider.gameData['gameDetails']
                                            ['searchtype'] == 'challenge')
                                          InkWell(
                                              onTap: () {
                                                CustomDialog.showSuggestionDialog(
                                                    context: context,
                                                    suggestions: [
                                                      Suggestion(
                                                          AppLocalizations.of(context)!.what_is_challenge,
                                                          AppLocalizations.of(context)!
                                                              .what_is_challenge_description),
                                                    ]);
                                              },
                                              child: const Icon(Icons.info_outline,
                                                  color: AllColors.white, size: 22)),
                                      ],
                                    )
                                   ,
                                    if (provider.gameData['gameDetails']
                                            ['searchtype'] ==
                                        'search')
                                      Expanded(
                                        child: GridView.builder(
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 16),
                                          itemCount:
                                              provider.allWordsFromAPI.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  childAspectRatio: 3.1,
                                                  crossAxisCount: 3),
                                          itemBuilder: (context, index) {
                                            return Container(

                                                child: Text(
                                                provider.allWordsFromAPI[index]
                                                    .toUpperCase(),
                                                textAlign: (index + 1) % 3 == 0
                                                    ? TextAlign.end
                                                    : (index) % 3 == 0
                                                        ? TextAlign.start
                                                        : TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    height: 1.2,
                                                    decoration: provider
                                                            .correctWords
                                                            .contains(provider
                                                                .allWordsFromAPI[
                                                                    index]
                                                                .toUpperCase())
                                                        ? TextDecoration
                                                            .lineThrough
                                                        : TextDecoration.none,
                                                    fontWeight: FontWeight.w600,
                                                    color: provider.correctWords
                                                            .contains(provider
                                                                .allWordsFromAPI[
                                                                    index]
                                                                .toUpperCase())
                                                        ? Colors.green
                                                        : Colors.white)));
                                          },
                                        ),
                                      ),
                                    if (provider.gameData['gameDetails']
                                            ['searchtype'] ==
                                        'challenge')
                                      GridView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 16),
                                        itemCount:
                                            provider.allWordsFromAPI.length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 3.1,
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
                                                  height: 1.2,
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
                                                  fontWeight: FontWeight.w600,
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

                        if(!provider.gameEnded)
                          if(provider.grid_.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Crossword(

                            letters: provider.grid_,
                            acceptReversedDirection: true,
                            drawVerticalLine:true,
                            drawHorizontalLine:true,
                            spacing: const Offset(32, 33),
                            drawCrossLine:true,
                            onLineDrawn: (List<String> words) async {
                              print(words.last.toString());

                              var index = provider.filteredWordsFromAPI.indexOf(words.last.toString());
                              var word_ = provider.allWordsFromAPI[index];
                              if (provider.gameData['gameDetails']['searchtype'] == 'search')
                              {
                                if (provider.allWordsFromAPI.contains(
                                    word_)) {
                                  provider.addToCorrectWords(
                                      word_);
                                  provider.addToFilteredCorrectWords(words.last.toString());
                                  player.setAudioSource(AudioSource.uri(Uri.parse(
                                      "https://res.cloudinary.com/dsnb1bl19/video/upload/v1693172345/correctanswer_szreyi.mp3"))); // Schemes: (https: | file: | asset: )     // Play without waiting for completion
                                  player.play();
                                  // print(player.playing);
                                }
                                }
                              else {
                                if (provider.correctWordsFromAPI.contains(
                                    words.last.toString())) {
                                  provider.addToCorrectWords(
                                     word_);
                                  provider.addToMarkedWords(word_);
                                  provider.addToFilteredCorrectWords(words.last.toString());
                                  player.setAudioSource(AudioSource.uri(Uri.parse(
                                      "https://res.cloudinary.com/dsnb1bl19/video/upload/v1693172345/correctanswer_szreyi.mp3"))); // Schemes: (https: | file: | asset: )     // Play without waiting for completion
                                  player.play();
                                  // print(player.playing);
                                }
                                else if (provider.incorrectWordsFromAPI.contains(
                                    words.last.toString())) {
                                  provider.addToInCorrectWords(
                                      word_);
                                  provider.addToMarkedWords(word_);
                                  provider.addToFilteredInCorrectWords(words.last.toString());
                                  player.setAudioSource(AudioSource.uri(Uri.parse(
                                      "https://res.cloudinary.com/dsnb1bl19/video/upload/v1693172345/wronganswer_oyvx87.wav"))); // Schemes: (https: | file: | asset: )     // Play without waiting for completion
                                  player.play();
                                  // print(player.playing);
                                }
                              }

                              print('size');
                              print(provider.allMarkedWords.length.toString());
                              if (provider.gameData['gameDetails']['searchtype'] == 'search') {
                                if (provider.allWordsFromAPI.length == provider.correctWords.length) {
                                  navigate();
                                }
                              }
                              else {
                                List<String> correctWordsMarked = [];
                                List<String> wordsToMark = [];

                                for(var word in provider.correctWordsFromAPI) {
                                  if(provider.allWordsFromAPI
                                      .contains(word)) {
                                    wordsToMark.add(word);
                                  }
                                  if(provider.allMarkedWords.contains(word)) {
                                    correctWordsMarked.add(word);
                                  }
                                }
                                print('allCorrect');
                                print(correctWordsMarked.length.toString());
                                print('wordsToMark');
                                print(wordsToMark.length.toString());

                                if (provider.correctWordsFromAPI.length == provider.correctWords.length) {
                                  navigate();
                                }
                                else if (provider.allWordsFromAPI.length == provider.allMarkedWords.length) {
                                  navigate();
                                }
                                else {

                                  if (provider.correctWords.length > 0) {
                                    if (correctWordsMarked.length ==
                                        wordsToMark.length) {
                                      navigate();
                                    }
                                  }
                                }
                              }
                            },

                            textStyle: TextStyle(fontSize: 23, color: const Color(0xFF221962)
                                  , fontWeight: FontWeight.w900),
                            lineDecoration:
                            LineDecoration(lineColors: lineColors,
                                incorrectColor: Colors.red,
                                strokeWidth: 28, borderColor: Colors.red ),
                            allWords: provider.filteredWordsFromAPI.isNotEmpty ? provider.filteredWordsFromAPI : [],
                            correctWords : provider.gameData['gameDetails']
                            ['searchtype'] ==
                                'challenge' ? provider.correctWordsFromAPI : provider.allWordsFromAPI,
                            incorrWords: provider.incorrectWordsFromAPI,
                          ),
                        ),
                        if(provider.gameEnded==true && !provider.allowMark)
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
                                            BorderRadius.circular(10),
                                            color: provider
                                                .tiles[index].backgroundColor),
                                        child: Center(
                                          child: Foo(
                                            index: index,
                                            child: Text(
                                              provider.tiles[index].alphabet!,
                                              style: GoogleFonts.inter(textStyle:
                                              Theme.of(context).textTheme.headlineLarge,fontSize: 23, color: const Color(0xFF221962)
                                                  , fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                                ,
                              ),
                            ),
                          )


                      ],
                    ),
            );
          }),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    if(timer !=null) {
      timer!.cancel();
    }
    // final provider = Provider.of<TimerProvider>(context, listen: false);
    // provider.cancelTimer();
  }

  getData() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    // provider.reset();
    timerProvider.stopSeconds();
    timerProvider.setTicking(false);
    timerProvider.resetSeconds();
    provider.setAllowMark(true);


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
    if (provider.gameType == 'challenge') {
      getCategorySearch();
    }

    if (provider.gameType == 'challengebycategory' ||
        provider.gameType == 'searchbycategory') {
          categorySearch();
        }


  }

  void startTimer() {
    final provider_game = Provider.of<GameScreenProvider>(context, listen: false);
    final provider = Provider.of<TimerProvider>(context, listen: false);
    provider.resetSeconds();
    provider.setTicking(true);
    Future.delayed(const Duration(milliseconds: 500), () {
      provider_game.setGameEnded(false);
    });

    print(provider.ticking);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(provider.ticking == true) {
       provider.changeSeconds();
       print(provider_game.allowMark);
       print(provider_game.gameEnded);

        print(provider.seconds);
      }
      else {
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
                  if(value['message'].toString().contains('Cannot play more')) {
                    // dialog(context, 'Your have reached daily limit of your games. Come back tomorrow or upgrade to continue.', () {
                    //   Nav.pop(context);
                    CustomDialog.showGamesFinishedDialog(
                        context: context);
                      // final provider =
                      // Provider.of<HomeProvider>(context, listen: false);
                      // provider.changeSelectedIndex(1);
                    // });
                  }
                  else {
                    CustomDialog.noGameAvailable(
                        context: context);
                  }
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
              if(value['message'].toString().contains('Cannot play more')) {
                CustomDialog.showGamesFinishedDialog(
                    context: context);
              }
              else {
                CustomDialog.noGameAvailable(
                    context: context);
              }
              
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
              "category" : cProvider.selectedCategory['categoryname'],
              "topic": cProvider.selectedCategory['topicsname'],
            }).then((value) {
              print('hello');
              if (value['gameDetails'] != null) {
                provider.changeGameData(value);
                provider.addToCorrectWordsIncorrectWordsFromAPI();
                if(provider.gameType == 'challengebycategory') {
                Nav.pop(context);

                final provider_ =
                Provider.of<HomeProvider>(context, listen: false);
                provider_.changeSelectedIndex(4);
              }
                startTimer();
              } else {
                if(value['message'].toString().contains('Cannot play more')) {
                  CustomDialog.showGamesFinishedDialog(
                      context: context);
                }
                else {
                  CustomDialog.noGameAvailable(
                      context: context);
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
              'userId':loginId,
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
                  if(value['message'].toString().contains('Cannot play more')) {
                    CustomDialog.showGamesFinishedDialog(
                        context: context);
                  }
                  else {
                    // dialog(context, 'No Game Available', () {
                    //   Nav.pop(context);
                    //   final provider =
                    //   Provider.of<HomeProvider>(context, listen: false);
                    //   provider.changeSelectedIndex(1);
                    // });
                    CustomDialog.noGameAvailable(
                        context: context);
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
    gameProvider.setAllowMark(false);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (gameProvider.gameData['gameDetails']['searchtype'] == 'search') {
        final player = AudioPlayer();
        if(!player.playing) {
          // Create a player
          player.setAudioSource(AudioSource.uri(Uri.parse(
              "https://res.cloudinary.com/dsnb1bl19/video/upload/v1693172346/gamecompleted_dktied.wav"))); // Schemes: (https: | file: | asset: )     // Play without waiting for completion
          player.play();
          print(player.playing);
        }
        else {
          player.stop();
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

        for(var word in provider.correctWordsFromAPI) {
          if(provider.allWordsFromAPI
              .contains(word)) {
            wordsToMark.add(word);
          }
          if(provider.allMarkedWords.contains(word)) {
            correctWordsMarked.add(word);
          }
        }
        if (provider.correctWords.length > 0) {

          if (correctWordsMarked.length ==
              wordsToMark.length) {

            final player = AudioPlayer();
            if(!player.playing) {
              // Create a player
              player.setAudioSource(AudioSource.uri(Uri.parse(
                  "https://res.cloudinary.com/dsnb1bl19/video/upload/v1693172346/gamecompleted_dktied.wav"))); // Schemes: (https: | file: | asset: )     // Play without waiting for completion
              player.play();
              print(player.playing);
            }
            else {
              player.stop();
            }

            Nav.push(
                context,
                LevelCompletionPage(
                  // isCompleted: gameProvider.correctWordsFromAPI.length ==
                  //     gameProvider.correctWords.length,
                  isCompleted: true,
                  totalWord: provider.allMarkedWords.length,
                  correctWord: gameProvider.correctWords.length,
                  seconds: p.seconds,
                ));
          }

         else if(provider.allWordsFromAPI.length == provider.allMarkedWords.length) {

            if(correctWordsMarked.length == wordsToMark.length) {
              final player = AudioPlayer();
              if(!player.playing) {
                // Create a player
                player.setAudioSource(AudioSource.uri(Uri.parse(
                    "https://res.cloudinary.com/dsnb1bl19/video/upload/v1693172346/gamecompleted_dktied.wav"))); // Schemes: (https: | file: | asset: )     // Play without waiting for completion
                player.play();
                print(player.playing);
              }
              else {
                player.stop();
              }
            }
            else {
              final player = AudioPlayer();
              if(!player.playing) {
                // Create a player
                player.setAudioSource(AudioSource.uri(Uri.parse(
                    "https://res.cloudinary.com/dsnb1bl19/video/upload/v1693173512/gameended_zfar4v.mp3"))); // Schemes: (https: | file: | asset: )     // Play without waiting for completion
                player.play();
                print(player.playing);
              }
              else {
                player.stop();
              }
            }
            Nav.push(
                context,
                LevelCompletionPage(
                  isCompleted: correctWordsMarked.length ==
                      wordsToMark.length,
                  // isCompleted: true,
                  totalWord: provider.allMarkedWords.length,
                  correctWord: gameProvider.correctWords.length,
                  seconds: p.seconds,
                ));
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
