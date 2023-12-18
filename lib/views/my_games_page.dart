import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:werkos/views/word_related_page.dart';
import 'package:werkos/widget/navigator.dart';
import 'package:provider/provider.dart';
import 'package:werkos/api_services.dart';
import 'package:werkos/utils/buttons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:werkos/utils/font_size.dart';
import 'package:werkos/utils/all_colors.dart';
import 'package:werkos/components/labels.dart';
import 'package:werkos/utils/custom_app_bar.dart';
import 'package:werkos/views/create_word_page.dart';
import 'package:werkos/views/leaderboard_page.dart';
import 'package:werkos/providers/games_provider.dart';
import 'package:werkos/components/custom_dialogs.dart';
import 'package:share_plus/share_plus.dart';
import '../components/suggestion/model/suggestion.dart';
import '../providers/game_screen_provider.dart';
import '../providers/home_provider.dart';
import '../providers/timer_provider.dart';
import '../widget/widgets.dart';
import '../widget/sahared_prefs.dart';
import '../providers/profile_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyGamesPage extends StatefulWidget {
  const MyGamesPage({Key? key}) : super(key: key);

  @override
  State<MyGamesPage> createState() => _MyGamesPageState();
}

class _MyGamesPageState extends State<MyGamesPage> {
  final ApiServices _apiServices = ApiServices();

  bool public = true;

  @override
  void initState() {
    getData(true);

    super.initState();
  }

  getData(bool progressBar) {
    final provider = Provider.of<GamesProvider>(context, listen: false);

    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        _apiServices
            .post(
                context: context,
                endpoint: 'getAllUserGames',
                body: {
                  "accessToken": token,
                  "userId": loginId,
                  "type": public ? 'search' : 'challenge'
                },
                progressBar: progressBar)
            .then((value) {
          if (public) {
            provider.changeSearchGames(value['allGames']);
          } else {
            provider.changeChallengeGames(value['allGames']);
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: CustomAppBar(isBack: provider.prevIndex != 2 ? true : false, isLang: true, backOnPressed: () {
                  final timeProvider =
                  Provider.of<TimerProvider>(context, listen: false);

                  final homeProvider = Provider.of<HomeProvider>(
                      context,
                      listen: false);

                  final gameProvider = Provider.of<GameScreenProvider>(
                      context,
                      listen: false);
                  print(homeProvider.prevIndex);
                  if(homeProvider.prevIndex == 4) {
                    gameProvider.changeGameType('random');
                    gameProvider.reset();
                    timeProvider.stopSeconds();
                    timeProvider.resetSeconds();
                    gameProvider.setGameEnded(false);
                    homeProvider.changeSelectedIndex(4);
                    homeProvider.setSearching(false);
                  }
                  else {
                    homeProvider.changeSelectedIndex(homeProvider.prevIndex);
                    provider.changePreviousIndex(provider.selectedIndex);
                  }
                },)),
            body: Consumer<GamesProvider>(builder: (context, provider, _) {
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Label(
                            text: AppLocalizations.of(context)!
                                .my_crated_games
                                .toUpperCase(),
                            fontSize: FontSize.p2,
                            fontWeight: FontWeight.w500),
                        const SizedBox(height: 20),
                        customSwitch([
                          AppLocalizations.of(context)!
                              .word_searches
                              .toUpperCase(),
                          AppLocalizations.of(context)!.challenges
                        ], value: public, onTap: () {
                          final provider = Provider.of<ProfileProvider>(context,
                              listen: false);
                          if (provider.profile['subscriptionstatus'] ==
                              'none') {
                            CustomDialog.showPurchaseDialog(context: context);
                          } else {
                            setState(() {
                              public = !public;
                            });
                            getData(true);
                          }
                        }, info: () {
                          CustomDialog.showPurchaseDialog(context: context);
                        }, showInfo: false),
                        const SizedBox(height: 20),
                        if (public)
                          if (provider.searchGames != null)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.searchGames.length,
                              separatorBuilder: (context, index) {
                                return gap(10);
                              },
                              itemBuilder: (context, index) {
                                return gamesItem(provider.searchGames[index]);
                              },
                            ),
                        if (!public)
                          if (provider.challengeGames != null)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: provider.challengeGames.length,
                              separatorBuilder: (context, index) {
                                return gap(10);
                              },
                              itemBuilder: (context, index) {
                                return gamesItem(
                                    provider.challengeGames[index]);
                              },
                            ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              );
            }),
            resizeToAvoidBottomInset: false,
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
              child: ShadowButton(
                  fillColors: const [
                    AllColors.semiLiteGreen,
                    AllColors.shineGreen
                  ],
                  onPressed: () {

                    if(!public) {
                      CustomDialog.showChallenge(
                          context: context);
                    }
                    else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return CreateWordPage(
                                type: public ? 'search' : 'challenge');
                          }));
                    }
                  },
                  title: public
                      ? AppLocalizations.of(context)!.create_word_search
                      : ('${AppLocalizations.of(context)!.create} ${AppLocalizations.of(context)!.challenge.toLowerCase()}')),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked)); });
  }

  gamesItem(var details) {
    var provider = Provider.of<ProfileProvider>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: double.maxFinite,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border.all(color: AllColors.purple, width: 1),
          color: AllColors.liteDarkPurple,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Center(
              child: GestureDetector(
              onTap: () async {
                await Clipboard.setData(ClipboardData(text: details['sharecode'].toString()));
                var snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.code_copied)
                , backgroundColor: AllColors.liteDarkPurple );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);

            }, child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children : [
        const SizedBox(width: 10),
        Expanded(child:
        Label(text:'${AppLocalizations.of(context)!.code_to_share.toUpperCase()}: ${details['sharecode'].toString()}',
            fontSize: FontSize.p2,
            align: TextAlign.center,
            maxLine: 2,
          )),
        CupertinoButton(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: details['sharecode'].toString()));
              var snackBar = SnackBar(content: Text(AppLocalizations.of(context)!.code_copied)
                  , backgroundColor: AllColors.liteDarkPurple );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);

            },
            padding: EdgeInsets.only(left: 8, top:4 , bottom: 4),
            minSize: 0,
            child: const Icon(Icons.copy, color: AllColors.white))
    ])
              )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Label(
                    text:
                        '${AppLocalizations.of(context)!.word_search_title}: ${details['gamename']}',
                    fontSize: FontSize.p2),
              ),
              CupertinoButton(
                  onPressed: () {
                    Share.share('Hello there! Play my crossword game. Use this sharecode to play my crossword game: '+details['sharecode'].toString(), subject: 'Welcome Message');
                  },
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: const Icon(Icons.share, color: AllColors.white))
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                  text:
                  '${AppLocalizations.of(context)!.words}: ${details['totalwords']}',
                  fontSize: FontSize.p2),
              Row(
                  children: [
                    CupertinoButton(
                        onPressed: () {
                          final provider = Provider.of<GameScreenProvider>(context, listen: false);
                          provider.reset();
                          Prefs.getToken().then((token) {
                            Prefs.getPrefs('loginId').then((loginId) {
                                _apiServices.post(context: context, endpoint: 'getGameByCode', body: {
                                  "accessToken": token,
                                  "userId": loginId,
                                  "sharecode": details['sharecode'].toString(),
                                }).then((value) {
                                  if (value['gameDetails'] != null) {
                                    provider.changeGameData(value);
                                    provider.changeGameType('gamewithcode');
                                    provider.addToCorrectWordsIncorrectWordsFromAPI();
                                    if (value['gameDetails']['searchtype'] == 'search') {
                                      final provider =
                                      Provider.of<HomeProvider>(context, listen: false);
                                      provider.changeSelectedIndex(4);
                                    } else {
                                      Nav.push(context, WordRelatedPage(data: value));
                                    }
                                  } else {
                                    print(value['message'].toString().toLowerCase());
                                    if (value['message'].toString().toLowerCase().contains('Cannot play')) {
                                      CustomDialog.cannotPlayed6(
                                          context: context);
                                    }
                                    else {
                                      CustomDialog.wrongCode(
                                          context: context);
                                    }
                                  }
                                });
                            });
                          });
                        },
                        padding: EdgeInsets.zero,
                        minSize: 0,
                        child: Icon(Icons.play_arrow, color: Colors.white, size: 26,)),
                    const SizedBox(width: 10),
                    CupertinoButton(
                  onPressed: () {
                    CustomDialog.deleteGame(
                      onPressed: () {
                        Prefs.getToken().then((token) {
                          Prefs.getPrefs('loginId').then((loginId) {
                            _apiServices
                                .post(context: context, endpoint: 'deleteUserGame', body: {
                              "accessToken": token,
                              "gameId":details['gameid'].toString(),
                              "userId": loginId,
                            }).then((value) {
                              print('delete');
                              print(details['gameid'].toString());
                              getData(false);
                              if(value['message'].toString().contains("deleted"))
                              {
                                dialog(context,
                                    AppLocalizations.of(context)!.deleted_success, () {
                                      Nav.pop(context);
                                      Nav.pop(context);
                                    });
                              }
                              // dialog(context, value['message'], () {
                              //   Nav.pop(context);
                              // });
                            });
                          });
                        });
                      },
                      apiServices : _apiServices,
                      gameId: details['gameid'].toString(),
                        context: context);
                  },
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: const Icon(Icons.delete, color: AllColors.white)),
                    const SizedBox(width: 10),
              CupertinoButton(
                  onPressed: () {
                    Nav.push(
                        context,
                        CreateWordPage(
                            type: details['searchtype'] == 'search'
                                ? 'search'
                                : 'challenge',
                            gameDetails: details));
                  },
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Image.asset('assets/icons/edit_icon.png'))
    ])
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                  text:
                      '${AppLocalizations.of(context)!.users}: '
                          '${details["totalplayed"]}/' '${provider.profile['subscriptionstatus'] ==
              'none'? '6' : '∞'}',
                  fontSize: FontSize.p2),
              Row(
                  children: [
                    Label(
                        text:
                        '${AppLocalizations.of(context)!.ratings}: ',
                        fontSize: FontSize.p2),
                    RatingBarIndicator(
                  rating: details["avgratings"] == null
                      ? 0
                      : double.parse(details["avgratings"]),
                  itemBuilder: (context, index) =>
                      const Icon(Icons.star, color: AllColors.superLightGreen),
                  itemCount: 5,
                  unratedColor: AllColors.grey,
                  itemSize: 22)]),
            ],
          ),
          const SizedBox(height: 10),
          CupertinoButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LeaderBoardPage(
                          pageName: 'myGames', gameDetails: details)));
            },
            minSize: 0,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.maxFinite,
              height: 30,
              decoration: BoxDecoration(
                  color: AllColors.litePurple,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AllColors.white, width: 1)),
              child: Center(
                  child: Label(
                      text: AppLocalizations.of(context)!.leaderboard,
                      fontSize: FontSize.p4)),
            ),
          ),
          const SizedBox(height: 10),
          CupertinoButton(
            onPressed: () {
              Prefs.getToken().then((token) {
                Prefs.getPrefs('loginId').then((loginId) {
                  _apiServices
                      .post(context: context, endpoint: 'duplicateGame', body: {
                    "accessToken": token,
                    "gameid": details['gameid'].toString(),
                    "userId": loginId,
                  }).then((value) {
                    print('duplicate');
                    print(details.toString());
                    if(value['message'].toString().contains("duplicated successfully"))
                    {
                      dialog(context,
                          AppLocalizations.of(context)!.duplicated_success, () {
                            Nav.pop(context);
                            Nav.pop(context);

                          });
                    }
                    // dialog(context, value['message'], () {
                    //   Nav.pop(context);
                    // });
                    getData(false);
                  });
                });
              });
            },
            minSize: 0,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.maxFinite,
              height: 30,
              decoration: BoxDecoration(
                  color: AllColors.litePurple,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AllColors.white, width: 1)),
              child: Center(
                  child: Label(
                      text: AppLocalizations.of(context)!.duplicate,
                      fontSize: FontSize.p4)),
            ),
          ),
        ],
      ),
    );
  }
}
