import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:werkos/api_services.dart';
import 'package:werkos/providers/game_screen_provider.dart';
import 'package:werkos/views/level_completion_page.dart';
import 'package:werkos/widget/navigator.dart';
import 'package:werkos/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';
import 'package:werkos/views/play_page.dart';
import 'package:werkos/views/drag_page.dart';
import 'package:werkos/utils/all_colors.dart';
import 'package:werkos/views/create_page.dart';
import 'package:werkos/components/labels.dart';
import 'package:werkos/views/option_page.dart';
import 'package:werkos/views/my_games_page.dart';
import 'package:werkos/providers/home_provider.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:werkos/components/model/bottom_navigation_item.dart';

import '../admob/admob_service_details.dart';
import '../providers/timer_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen> {
  final ApiServices _apiServices = ApiServices();

  final List<Widget> pages = [
    const CreatePage(),
    const PlayPage(),
    const MyGamesPage(),
    const OptionPage(),
    const DrugPage()
  ];

  List<BottomNavigationItem>? iconList;

  void playVideoAd() {
    // MobileAds.instance.updateRequestConfiguration(
    //     RequestConfiguration(testDeviceIds:["BB4BB9E08099BB1C91E2FE93C8E2B6FB"]));

    RewardedInterstitialAd.load(adUnitId: AdmobService.videoAdUnitID!,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
            onAdLoaded: (ad) => {
              print('adLoaded'),
              ad.fullScreenContentCallback = FullScreenContentCallback(
                  onAdDismissedFullScreenContent: (ad_) {
                    ad_.dispose();
                  },
                  onAdFailedToShowFullScreenContent: (ad_, error) {
                    ad_.dispose();
                    playVideoAd();
                  }
              ),
              ad.show(onUserEarnedReward: (ad,reward) => {
                print(reward)
              })
            },
            onAdFailedToLoad: (err)=> {
              print('adFailed'),
              print(err.message)
            }));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    iconList = [
      BottomNavigationItem(
          iconData: CupertinoIcons.square_grid_2x2_fill,
          text: AppLocalizations.of(context)!.create),
      BottomNavigationItem(
          iconData: CupertinoIcons.star_fill,
          text: AppLocalizations.of(context)!.play),
      BottomNavigationItem(
          iconData: CupertinoIcons.person_3_fill,
          text: AppLocalizations.of(context)!.my_games),
      BottomNavigationItem(
          iconData: Icons.settings,
          text: AppLocalizations.of(context)!.options),
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog( //show confirm dialogue
        //the return value will be from "Yes" or "No" options
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Exit App'),
          content: Text(AppLocalizations.of(context)!.exit_app),
          actions:[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child:Text(AppLocalizations.of(context)!.no),
            ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              //return true when click on "Yes"
              child:Text(AppLocalizations.of(context)!.yes),
            ),

          ],
        ),
      )??false; //if showDialouge had returned null, then return false
    }
    return WillPopScope(
        onWillPop: showExitPopup,
        child:Consumer<HomeProvider>(builder: (context, provider, _) {
      return kIsWeb ?
          Scaffold(
            backgroundColor: AllColors.purple_2,
            body:  Center(
                child:
                SizedBox(width: 400 ,child:
                Container(
                    decoration: BoxDecoration(
                        gradient: AllColors.bg,
                        color: provider.selectedIndex == 4
                            ? Colors.white
                            : const Color(0xFF1E155C)),
                    child:Consumer<GameScreenProvider>(builder: (context, gprovider, _) {
                      return Scaffold(
                        backgroundColor: Colors.transparent,
                        body: pages[provider.selectedIndex],
                        resizeToAvoidBottomInset: false,
                        floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                        bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom != 0.0
                            ? null
                            : AnimatedBottomNavigationBar.builder(
                          notchMargin: 22,
                          height: 60,
                          shadow: BoxShadow(
                              color: AllColors.black.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 10,
                              offset: const Offset(1, -6)),
                          backgroundColor: AllColors.superDarkPurple,
                          activeIndex: provider.selectedIndex,
                          gapLocation: GapLocation.center,
                          notchSmoothness: NotchSmoothness.defaultEdge,
                          onTap: (index) {
                            final p =
                            Provider.of<TimerProvider>(context, listen: false);
                            final p__ =
                            Provider.of<GameScreenProvider>(context, listen: false);
                            p__.reset();
                            p.stopSeconds();
                            p.stopSeconds();
                            p.setTicking(false);

                            provider.changeSelectedIndex(index);
                            provider.setSearching(false);
                            // playVideoAd();
                          },
                          itemCount: 4,
                          tabBuilder: (int index, bool isActive) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Column(
                                children: [
                                  Icon(
                                    iconList![index].iconData,
                                    color: isActive
                                        ? AllColors.liteGreen
                                        : AllColors.superLitePurple,
                                  ),
                                  Label(
                                      text: iconList![index].text,
                                      color: isActive
                                          ? AllColors.liteGreen
                                          : AllColors.superLitePurple)
                                ],
                              ),
                            );
                          },
                        ),
                        floatingActionButton: MediaQuery.of(context).viewInsets.bottom !=
                            0.0
                            ? null
                            : Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: FloatingActionButton(
                            backgroundColor: provider.selectedIndex == 4
                                && !gprovider.gameEnded
                                ? AllColors.liteRed
                                : AllColors.liteGreen,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Icon(
                              provider.selectedIndex == 4
                                  && !gprovider.gameEnded
                                  ? CupertinoIcons.square_fill
                                  : Icons.play_arrow,
                              size: provider.selectedIndex == 4 && !gprovider.gameEnded? 36 : 50,
                              color: AllColors.white,
                              shadows: [
                                BoxShadow(
                                    color: AllColors.black.withOpacity(0.5),
                                    blurRadius: 6,
                                    spreadRadius: 10,
                                    offset: const Offset(-1, 3)),
                              ],
                            ),
                            onPressed: () {
                              final p =
                              Provider.of<TimerProvider>(context, listen: false);
                              final gameProvider = Provider.of<GameScreenProvider>(
                                  context,
                                  listen: false);

                              if (provider.selectedIndex == 4) {

                                print(1);
                                if (gameProvider.gameData['gameDetails']
                                ['searchtype'] ==
                                    'search') {
                                  print(2);
                                  if (gameProvider.allWordsFromAPI.length ==
                                      gameProvider.correctWords.length) {
                                    print(3);
                                    print('here i am!');
                                    print('reach here1');
                                    provider.changeSelectedIndex(1);
                                    // Nav.push(
                                    //     context,
                                    //     LevelCompletionPage(
                                    //       isCompleted:
                                    //       gameProvider.allWordsFromAPI.length ==
                                    //           gameProvider.correctWords.length,
                                    //       totalWord:
                                    //       gameProvider.allWordsFromAPI.length,
                                    //       correctWord:
                                    //       gameProvider.correctWords.length,
                                    //       seconds: p.seconds,
                                    //     ));
                                  }

                                  else {
                                    print(4);
                                    final p__ =
                                    Provider.of<GameScreenProvider>(context, listen: false);
                                    print('gameEnded here');
                                    print(p__.gameEnded);

                                    if(p__.gameEnded != true) {
                                      borderRest();
                                    }
                                    else {
                                      print(82);
                                      provider.changeSelectedIndex(1);
                                      provider.setSearching(false);
                                      // gameProvider.changeGameType('random');
                                      // final p__ =
                                      // Provider.of<GameScreenProvider>(context, listen: false);
                                      // p__.reset();
                                      // p.stopSeconds();
                                      // p.resetSeconds();
                                      // provider.changeSelectedIndex(4);
                                      // p__.setGameEnded(false);
                                    }
                                  }
                                }
                                else {
                                  print(5);

                                  if (gameProvider.correctWordsFromAPI.length ==
                                      gameProvider.correctWords.length) {
                                    print(6);

                                    print('check Here');
                                    print('reach here2');
                                    provider.changeSelectedIndex(1);
                                    if(gameProvider.allowMark) {
                                      // Nav.push(
                                      //     context,
                                      //     LevelCompletionPage(
                                      //       isCompleted: gameProvider
                                      //           .correctWordsFromAPI.length ==
                                      //           gameProvider.correctWords.length,
                                      //       totalWord:
                                      //       gameProvider.correctWordsFromAPI.length,
                                      //       correctWord:
                                      //       gameProvider.correctWords.length,
                                      //       seconds: p.seconds,
                                      //     ));
                                    }
                                    else {
                                      // provider.changeSelectedIndex(1);
                                      // final p__ =
                                      // Provider.of<GameScreenProvider>(context, listen: false);
                                      // p__.reset();
                                      // p.stopSeconds();
                                      // p.resetSeconds();
                                      // p__.setGameEnded(false);
                                      print(83);

                                      provider.changeSelectedIndex(1);
                                      provider.setSearching(false);
                                      // gameProvider.changeGameType('random');
                                      // final p__ =
                                      // Provider.of<GameScreenProvider>(context, listen: false);
                                      // p__.reset();
                                      // p.stopSeconds();
                                      // p.resetSeconds();
                                      // provider.changeSelectedIndex(4);
                                      // p__.setGameEnded(false);

                                    }

                                  }
                                  else {
                                    final p__ =
                                    Provider.of<GameScreenProvider>(context, listen: false);
                                    print('gameEnded');
                                    print(p__.gameEnded);

                                    if(p__.gameEnded != true) {
                                      borderRest();
                                    }
                                    else {
                                      print(84);
                                      provider.changeSelectedIndex(1);
                                      provider.setSearching(false);
                                      // gameProvider.changeGameType('random');
                                      // final p__ =
                                      // Provider.of<GameScreenProvider>(context, listen: false);
                                      // p__.reset();
                                      // p.stopSeconds();
                                      // p.resetSeconds();
                                      // provider.changeSelectedIndex(4);
                                      // p__.setGameEnded(false);
                                    }
                                  }
                                }
                              }

                              else {
                                print(85);
                                gameProvider.changeGameType('random');
                                gameProvider.reset();
                                p.stopSeconds();
                                p.resetSeconds();
                                provider.changeSelectedIndex(4);
                                provider.setSearching(false);
                                gameProvider.setGameEnded(false);
                              }
                            },
                          ),
                        ),
                      );})))),
         ):
      Container(
          decoration: BoxDecoration(
              gradient: AllColors.bg,
              color: provider.selectedIndex == 4
                  ? Colors.white
                  : const Color(0xFF1E155C)),
          child:Consumer<GameScreenProvider>(builder: (context, gprovider, _) {
            return Scaffold(
            backgroundColor: Colors.transparent,
            body: pages[provider.selectedIndex],
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom != 0.0
                ? null
                : AnimatedBottomNavigationBar.builder(
                    notchMargin: 22,
                    height: 60,
                    shadow: BoxShadow(
                        color: AllColors.black.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 10,
                        offset: const Offset(1, -6)),
                    backgroundColor: AllColors.superDarkPurple,
                    activeIndex: provider.selectedIndex,
                    gapLocation: GapLocation.center,
                    notchSmoothness: NotchSmoothness.defaultEdge,
                    onTap: (index) {
                      final p =
                          Provider.of<TimerProvider>(context, listen: false);
                      final p__ =
                      Provider.of<GameScreenProvider>(context, listen: false);
                      p__.reset();
                      p.stopSeconds();
                      p.stopSeconds();
                      p.setTicking(false);

                      provider.changeSelectedIndex(index);
                      provider.setSearching(false);
                      // playVideoAd();
                    },
                    itemCount: 4,
                    tabBuilder: (int index, bool isActive) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Icon(
                              iconList![index].iconData,
                              color: isActive
                                  ? AllColors.liteGreen
                                  : AllColors.superLitePurple,
                            ),
                            Label(
                                text: iconList![index].text,
                                color: isActive
                                    ? AllColors.liteGreen
                                    : AllColors.superLitePurple)
                          ],
                        ),
                      );
                    },
                  ),
            floatingActionButton: MediaQuery.of(context).viewInsets.bottom !=
                    0.0
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: FloatingActionButton(
                      backgroundColor: provider.selectedIndex == 4
                      && !gprovider.gameEnded
                          ? AllColors.liteRed
                          : AllColors.liteGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        provider.selectedIndex == 4
                            && !gprovider.gameEnded
                            ? CupertinoIcons.square_fill
                            : Icons.play_arrow,
                        size: provider.selectedIndex == 4 && !gprovider.gameEnded? 36 : 50,
                        color: AllColors.white,
                        shadows: [
                          BoxShadow(
                              color: AllColors.black.withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 10,
                              offset: const Offset(-1, 3)),
                        ],
                      ),
                      onPressed: () {
                        final p =
                            Provider.of<TimerProvider>(context, listen: false);
                        final gameProvider = Provider.of<GameScreenProvider>(
                            context,
                            listen: false);

                        if (provider.selectedIndex == 4 && gameProvider.allowMark) {

                          print(1);
                          if (gameProvider.gameData['gameDetails']
                                  ['searchtype'] ==
                              'search') {
                            print(2);
                            if (gameProvider.allWordsFromAPI.length ==
                                gameProvider.correctWords.length) {
                              print(3);
                              print('here i am!');
                              print('reach here3');
                              provider.changeSelectedIndex(1);
                              // Nav.push(
                              //     context,
                              //     LevelCompletionPage(
                              //       isCompleted:
                              //           gameProvider.allWordsFromAPI.length ==
                              //               gameProvider.correctWords.length,
                              //       totalWord:
                              //           gameProvider.allWordsFromAPI.length,
                              //       correctWord:
                              //           gameProvider.correctWords.length,
                              //       seconds: p.seconds,
                              //     ));
                            }

                            else {
                              print(4);
                              final p__ =
                              Provider.of<GameScreenProvider>(context, listen: false);
                              print('gameEnded here');
                              print(p__.gameEnded);

                              if(p__.gameEnded != true) {
                                borderRest();
                              }
                              else {
                                print(86);
                                provider.changeSelectedIndex(1);
                                provider.setSearching(false);
                                // gameProvider.changeGameType('random');
                                // final p__ =
                                // Provider.of<GameScreenProvider>(context, listen: false);
                                // p__.reset();
                                // p.stopSeconds();
                                // p.resetSeconds();
                                // provider.changeSelectedIndex(4);
                                // p__.setGameEnded(false);
                              }
                            }
                          }
                          else {
                            print(5);

                            if (gameProvider.correctWordsFromAPI.length ==
                                gameProvider.correctWords.length) {
                              print(6);

                              print('check Here');
                              print('reach here4');
                              provider.changeSelectedIndex(1);
                              if(gameProvider.allowMark) {
                                // Nav.push(
                                //     context,
                                //     LevelCompletionPage(
                                //       isCompleted: gameProvider
                                //               .correctWordsFromAPI.length ==
                                //           gameProvider.correctWords.length,
                                //       totalWord:
                                //           gameProvider.correctWordsFromAPI.length,
                                //       correctWord:
                                //           gameProvider.correctWords.length,
                                //       seconds: p.seconds,
                                //     ));
                              }
                              else {
                                // provider.changeSelectedIndex(1);
                                // final p__ =
                                // Provider.of<GameScreenProvider>(context, listen: false);
                                // p__.reset();
                                // p.stopSeconds();
                                // p.resetSeconds();
                                // p__.setGameEnded(false);
                                print(87);

                                provider.changeSelectedIndex(1);
                                provider.setSearching(false);
                                // gameProvider.changeGameType('random');
                                // final p__ =
                                // Provider.of<GameScreenProvider>(context, listen: false);
                                // p__.reset();
                                // p.stopSeconds();
                                // p.resetSeconds();
                                // provider.changeSelectedIndex(4);
                                // p__.setGameEnded(false);

                              }

                            }
                            else {
                              final p__ =
                              Provider.of<GameScreenProvider>(context, listen: false);
                              print('gameEnded');
                              print(p__.gameEnded);

                              if(p__.gameEnded != true) {
                                borderRest();
                              }
                              else {
                                print(88);
                                provider.setSearching(false);
                                provider.changeSelectedIndex(1);
                                // gameProvider.changeGameType('random');
                                // final p__ =
                                // Provider.of<GameScreenProvider>(context, listen: false);
                                // p__.reset();
                                // p.stopSeconds();
                                // p.resetSeconds();
                                // provider.changeSelectedIndex(4);
                                // p__.setGameEnded(false);
                              }
                            }
                          }
                        }

                        else {
                          if(provider.selectedIndex != 4) {
                            print(81);
                            gameProvider.changeGameType('random');
                            final p__ =
                            Provider.of<GameScreenProvider>(
                                context, listen: false);
                            p__.reset();
                            p.stopSeconds();
                            p.resetSeconds();
                            provider.changeSelectedIndex(4);
                            provider.setSearching(false);
                            p__.setGameEnded(false);
                          }
                          else {
                            provider.changeSelectedIndex(1);
                          }
                        }
                      },
                    ),
                  ),
          );}));
    })
    );
  }

  borderRest() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    final p = Provider.of<TimerProvider>(context, listen: false);
    List<String> rest = [];

    final player = AudioPlayer();
    if(!player.playing) {
      // Create a player
      player.setAudioSource(AudioSource.uri(Uri.parse(
          "https://res.cloudinary.com/dsnb1bl19/video/upload/v1693173512/gameended_zfar4v.mp3"))); // Schemes: (https: | file: | asset: )     // Play without waiting for completion
      player.play();
      print(player.playing);
    }
    provider.setGameEnded(true);
    provider.setAllowMark(false);

    p.stopSeconds();
    p.setTicking(false);
    print('checkhere');
    print(provider.gameType);
    if(provider.gameType.contains("challenge")) {
      provider.filteredWordsFromAPI.forEach((element) {
        print(!provider.allMarkedWords.contains(element));
        print(provider.correctWordsFromAPI.contains(element));
        if(!provider.allMarkedWords.contains(element)
            && provider.correctWordsFromAPI.contains(element)) {

         rest.add(element);
        }
      });
    }
    else {
      provider.filteredWordsFromAPI.forEach((element) {
        if (!provider.correctWordsFromAPI.contains(element) &&
            !provider.filteredincorrectWords.contains(element)) {
          rest.add(element);
        }
      });
    }
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        _apiServices.post(
            context: context,
            endpoint: 'gamewords_resultposition',
            body: {
              "userId": loginId,
              "accessToken": token,
              "grid": jsonEncode(provider.gameData['crossword_grid']),
              "words": json.encode(rest),
              "correctWords":json.encode(provider.filteredcorrectWords),
            }).then((value) {
          provider.changeTile(value);
          if (provider.gameData['gameDetails']['searchtype'] == 'search') {
            Future.delayed(const Duration(seconds: 5), () {
              Nav.push(
                  context,
                  LevelCompletionPage(
                    isCompleted: provider.allWordsFromAPI.length ==
                        provider.correctWords.length,
                    totalWord: provider.allWordsFromAPI.length,
                    correctWord: provider.correctWords.length,
                    seconds: p.seconds,
                  ));
            });
          }
          else {
            Future.delayed(const Duration(seconds: 5), () {
              Nav.push(
                  context,
                  LevelCompletionPage(
                    isCompleted: provider.correctWordsFromAPI.length ==
                        provider.correctWords.length,
                    totalWord: provider.correctWordsFromAPI.length,
                    correctWord: provider.correctWords.length,
                    seconds: p.seconds,
                  ));
            });
          }
        });
      });
    });
  }
}
