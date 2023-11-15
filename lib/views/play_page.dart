import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:werkos/api_services.dart';
import 'package:werkos/components/labels.dart';
import 'package:werkos/providers/game_screen_provider.dart';
import 'package:werkos/providers/home_provider.dart';
import 'package:werkos/utils/all_colors.dart';
import 'package:werkos/utils/buttons.dart';
import 'package:werkos/utils/custom_app_bar.dart';
import 'package:werkos/utils/font_size.dart';
import 'package:werkos/views/category_page.dart';
import 'package:werkos/views/word_related_page.dart';
import 'package:werkos/widget/navigator.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/custom_dialogs.dart';
import '../providers/timer_provider.dart';
import '../widget/sahared_prefs.dart';
import '../widget/widgets.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _playByCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomAppBar(isBack: provider.prevIndex != 1 ? true : false, isLang: true, backOnPressed: () {
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
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Label(
                        text: AppLocalizations.of(context)!.play,
                        fontWeight: FontWeight.bold,
                        fontSize: FontSize.h5),
                    const SizedBox(height: 20),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.only(left: 30, right: 20),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: AllColors.liteDarkPurple,
                          borderRadius: BorderRadius.circular(50)),
                      child: Center(
                        child: TextFormField(
                            style: const TextStyle(
                                fontSize: FontSize.p2, color: AllColors.white),
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              hintText: AppLocalizations.of(context)!.search,
                              contentPadding: EdgeInsets.only(top: 15),
                              hintStyle: const TextStyle(
                                  fontSize: FontSize.p2,
                                  color: AllColors.white),
                              suffixIcon: const Icon(Icons.search_sharp,
                                  color: AllColors.white),
                            ),
                            onFieldSubmitted: (value) {
                              if(value.toString()!='') {
                                searchGame(value.toString().toUpperCase());
                                provider.setSearching(true);
                              }
                              else {
                                provider.setSearching(false);
                              }
                            },),
                      ),
                    ),
                    if(provider.isSearching)
                      ListView.separated(
                          shrinkWrap: true,
                          physics:
                          const NeverScrollableScrollPhysics(),
                          itemCount: provider.searchResult != null ?
                          provider.searchResult['gamesFound'] != null ? provider
                          .searchResult['gamesFound'].length : 0 : 0,
                          separatorBuilder: (context, i) {
                            return gap(0);
                          },
                          itemBuilder: (context, i) {
                            return gameButton(
                              onPressed: () =>
                            {
                            Prefs.getToken().then((token) {
                              Prefs.getPrefs('loginId').then((loginId) {
                                Prefs.getPrefs('wordLimit').then((
                                    wordLimit) {
                                  final provider__ =
                                  Provider.of<GameScreenProvider>(
                                      context, listen: false);

                                  _apiServices.post(context: context,
                                      endpoint: 'getGameByCode_backup',
                                      body: {
                                        "accessToken": token,
                                        "userId": loginId,
                                        "words_limit": wordLimit,
                                        "sharecode": provider
                                            .searchResult['gamesFound'][i]['sharecode'],
                                      }).then((value) {
                                    if (value['gameDetails'] != null) {
                                      provider__.changeGameData(value);
                                      provider__.changeGameType('gamewithcode');
                                      provider__
                                          .addToCorrectWordsIncorrectWordsFromAPI();
                                      if (value['gameDetails']['searchtype'] ==
                                          'search') {
                                        final provider =
                                        Provider.of<HomeProvider>(
                                            context, listen: false);
                                        provider.changeSelectedIndex(4);
                                        provider.setSearching(false);
                                      } else {
                                        Nav.push(
                                            context, WordRelatedPage(data: value));
                                        provider.setSearching(false);
                                      }
                                    } else {
                                      if (value['message'] != null) {
                                        CustomDialog.wrongCode(
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
                            }),
                              // TO DO here

                              }, topicName: provider
                                .searchResult['gamesFound'][i]!=null? provider
                                .searchResult['gamesFound'][i]['gamename'] : '',
                            );
                          }),
                    if(provider.isSearching)
                    gap(50),
                    if(!provider.isSearching)
                      Column(
                        children: [
                          SearchButton(
                              onPressed: () {
                                final gameScreenProvider =
                                Provider.of<GameScreenProvider>(context,
                                    listen: false);
                                gameScreenProvider.changeGameType('randomwordsearch');
                                final provider =
                                Provider.of<HomeProvider>(context, listen: false);
                                provider.changeSelectedIndex(4);
                              },
                              title:
                              AppLocalizations.of(context)!.random_word_search.toString().toUpperCase()),
                          SearchButton(
                              onPressed: () {
                                Nav.push(context, const CategoryPage(type: 'search'));
                              },
                              title: AppLocalizations.of(context)!
                                  .word_search_categories.toString().toUpperCase()),
                          SearchButton(
                              onPressed: () {
                                print('Hellothere');
                                final gameScreenProvider =
                                Provider.of<GameScreenProvider>(context,
                                    listen: false);

                                Prefs.getToken().then((token) {
                                  Prefs.getPrefs('loginId').then((loginId) {
                                    Prefs.getPrefs('wordLimit').then((wordLimit) {
                                      Prefs.getPrefs('gameLanguage').then((language) {
                                        _apiServices.post(context: context, endpoint: 'randomsearch_crossword', body: {
                                          "accessToken": token,
                                          "userId": loginId,
                                          "words_limit" : wordLimit,
                                          "type": 'challenge',
                                          'language':language,
                                        }).then((value) {
                                          print('testgmae');
                                          print(value);
                                          if (value['gameDetails'] != null) {
                                            gameScreenProvider.reset();
                                            gameScreenProvider.changeGameData(value);
                                            gameScreenProvider.setChallengeData(value);
                                            gameScreenProvider.changeGameType('randomwordchallenge');
                                            gameScreenProvider.addToCorrectWordsIncorrectWordsFromAPI();
                                            if (value['gameDetails']['searchtype'] == 'search') {
                                              final provider =
                                              Provider.of<HomeProvider>(context, listen: false);
                                              provider.changeSelectedIndex(4);
                                            } else {
                                              Nav.push(context, WordRelatedPage(data: value));
                                            }
                                          } else {
                                            if (value['message'] != null) {
                                              dialog(context, value['message'], () {
                                                Nav.pop(context);
                                              });
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

                                // gameScreenProvider
                                //     .changeGameType('randomwordchallenge');
                                // final provider =
                                //     Provider.of<HomeProvider>(context, listen: false);
                                // provider.changeSelectedIndex(4);
                              },
                              title: AppLocalizations.of(context)!.random_challenge.toString().toUpperCase()),
                          SearchButton(
                              onPressed: () {
                                Nav.push(
                                    context, const CategoryPage(type: 'category'));
                              },
                              title: AppLocalizations.of(context)!
                                  .challenge_by_category.toString().toUpperCase()),
                          const SizedBox(height: 12),
                          Label(
                              text:
                              AppLocalizations.of(context)!.play_by_entering_code.toString().toUpperCase(),
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.h5),
                          const SizedBox(height: 20),
                          Container(
                              height: 60,
                              padding: const EdgeInsets.only(left: 30, right: 20),
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: AllColors.liteDarkPurple,
                                  borderRadius: BorderRadius.circular(50)),
                              child: Center(
                                  child: TextFormField(
                                      controller: _playByCodeController,
                                      style: const TextStyle(
                                          fontSize: FontSize.p2,
                                          color: AllColors.white),
                                      decoration: InputDecoration(
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          hintText: AppLocalizations.of(context)!
                                              .enter_code,
                                          hintStyle: const TextStyle(
                                              fontSize: FontSize.p2,
                                              color: AllColors.white)),
                                      onSaved: (value) {}))),
                          const SizedBox(height: 20),
                          ShadowButton(
                              onPressed: () {
                                final gameScreenProvider =
                                Provider.of<GameScreenProvider>(context,
                                    listen: false);
                                gameScreenProvider.changeGameType('gamewithcode');
                                // gameScreenProvider
                                //     .changeSearch(_playByCodeController.text);
                                getGameWithCode();
                              },
                              title: AppLocalizations.of(context)!
                                  .play_with_entered_code.toString().toUpperCase(),
                              fillColors: const [
                                AllColors.liteOrange,
                                AllColors.orange
                              ])
                        ],
                      )

                  ],
                ),
              ),
            ),
          ),
        ));});
  }

  getGameWithCode() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    provider.reset();
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('wordLimit').then((wordLimit) {
          _apiServices.post(context: context, endpoint: 'getGameByCode', body: {
            "accessToken": token,
            "userId": loginId,
            "sharecode": _playByCodeController.text,
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
    });
  }

  void searchGame(var keyword) {
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('wordLimit').then((wordLimit) {
          Prefs.getPrefs('gameLanguage').then((language) {
    _apiServices
        .post(context: context, endpoint: 'search_crossword', body: {
      "userId": loginId,
      'keyword': keyword,
      "words_limit": wordLimit,
      "searchLimit": '30',
      "accessToken": token,
    }).then((value) {
      print('resulthere');
      print(value);
      final provider = Provider.of<HomeProvider>(context, listen: false);

      provider.updateSearchResult(value);


      if(provider.searchResult['gamesFound'] == null ||
          value['message'].toString().contains('No game found')) {
        // List<dynamic> results = provider.searchResult['gamesFound']
          CustomDialog.nosearchfound(
              context: context);
      }
  }).catchError((err) {
    print(err.toString());
    });
        });
        });
      });
    });
}
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
    required this.onPressed,
    required this.title,
  });
  final VoidCallback onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minSize: 0,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(top: 12),
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)),
        child: Center(
            child: Label(
          text: title,
          fontSize: FontSize.p2,
        )),
      ),
    );
  }
}

class gameButton extends StatelessWidget {
  const gameButton({
    super.key,
    required this.onPressed,
    required this.topicName,
  });

  final VoidCallback onPressed;
  final String topicName;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minSize: 0,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(top: 12),
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)),
        child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Label(
                  text: topicName,
                  fontSize: FontSize.p2,
                ),
              ],
            )),
      ),
    );
  }
}