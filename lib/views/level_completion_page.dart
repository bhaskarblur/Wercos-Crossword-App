import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app_word_search/admob/admob_service_details.dart';
import 'package:mobile_app_word_search/api_services.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/providers/game_screen_provider.dart';
import 'package:mobile_app_word_search/providers/home_provider.dart';
import 'package:mobile_app_word_search/providers/profile_provider.dart';
import 'package:mobile_app_word_search/providers/timer_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_app_word_search/views/leaderboard_page.dart';
import 'package:mobile_app_word_search/widget/navigator.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../widget/widgets.dart';

class LevelCompletionPage extends StatefulWidget {
  final bool isCompleted;
  final int totalWord;
  final int correctWord;
  final int seconds;
  const LevelCompletionPage(
      {Key? key,
      required this.isCompleted,
      required this.totalWord,
      required this.correctWord,
      required this.seconds})
      : super(key: key);

  @override
  State<LevelCompletionPage> createState() => _LevelCompletionPageState();
}

class _LevelCompletionPageState extends State<LevelCompletionPage> {
  final ApiServices _apiServices = ApiServices();

  double rating = 0.00;

  @override
  void initState() {
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        _apiServices.post(
            context: context,
            endpoint: 'addUserGameRecord',
            body: {
              "accessToken": token,
              "userId": loginId,
              "gameId": provider.gameData['gameDetails']['gameid'].toString(),
              "timeScore": timerProvider.seconds.toString(),
              "timeScoreText": formatTime(timerProvider.seconds),
              "crosswordScore": provider.correctWords.length.toString(),
              "playerName": profileProvider.profile['username'],
            },
            progressBar: false);
      });

      final provider_ = Provider.of<ProfileProvider>(context,
          listen: false);
      if (provider_.profile['subscriptionstatus'] ==
          '1year' || provider_.profile['subscriptionstatus'] ==
          '1month' ) {}
      else {
        playVideoAd();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        rate();
        final pProvider =
            Provider.of<GameScreenProvider>(context, listen: false);

        pProvider.reset();

        final p = Provider.of<TimerProvider>(context, listen: false);
        p.resetSeconds();
        p.resetSeconds();

        return true;
      },
      child: kIsWeb ?
      Scaffold(
        backgroundColor: AllColors.purple_2,
        body:  Center(
            child:
            SizedBox(width: 400 ,child:
            Container(
              decoration: const BoxDecoration(gradient: AllColors.bg),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 100),
                        Consumer<GameScreenProvider>(builder: (context, provider, _) {
                          return Label(
                              text: provider.gameData['gameDetails']['searchtype'] ==
                                  'search'
                                  ? AppLocalizations.of(context)!.rate_this
                                  : AppLocalizations.of(context)!.rate_this_challange,
                              fontSize: FontSize.p2);
                        }),
                        const SizedBox(height: 10),
                        StatefulBuilder(builder: (context, st) {
                          return RatingBarIndicator(
                              rating: rating,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  st(() {
                                    rating = index + 1;
                                  });
                                },
                                child: const Icon(Icons.star,
                                    color: AllColors.superLightGreen),
                              ),
                              itemCount: 5,
                              itemPadding: const EdgeInsets.all(4),
                              unratedColor: AllColors.grey,
                              itemSize: 30);
                        }),
                        const SizedBox(height: 24),
                        !widget.isCompleted
                            ? Label(
                            text: AppLocalizations.of(context)!.game,
                            fontSize: FontSize.h4,
                            fontWeight: FontWeight.bold)
                            : Label(
                            text: AppLocalizations.of(context)!.congratulations,
                            fontSize: FontSize.h4),
                        const SizedBox(height: 4),
                        !widget.isCompleted
                            ? Label(
                            text: AppLocalizations.of(context)!.not_complete,
                            fontSize: FontSize.h4,
                            color: AllColors.liteRed,
                            fontWeight: FontWeight.bold)
                            : Label(
                            text: AppLocalizations.of(context)!.complete,
                            fontSize: FontSize.h4,
                            color: AllColors.liteGreen,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 40),
                        Label(
                            text: AppLocalizations.of(context)!.hits,
                            fontSize: FontSize.p1,
                            fontWeight: FontWeight.w600),
                        const SizedBox(height: 10),
                        Label(
                            text:
                            '${widget.correctWord} ${AppLocalizations.of(context)!.offf} ${widget.totalWord}',
                            fontSize: FontSize.p1,
                            fontWeight: FontWeight.w600),
                        const SizedBox(height: 40),
                        Label(
                            text: AppLocalizations.of(context)!.time,
                            fontSize: FontSize.p1,
                            fontWeight: FontWeight.w600),
                        const SizedBox(height: 10),
                        Consumer<TimerProvider>(builder: (context, provider, _) {
                          return Label(
                              text: formatTime(widget.seconds),
                              fontSize: FontSize.p1,
                              fontWeight: FontWeight.w600);
                        }),
                        const SizedBox(height: 60),
                        ShadowButton(
                            fillColors: const [
                              AllColors.semiLiteGreen,
                              AllColors.shineGreen
                            ],
                            onPressed: () {
                              rate();

                              final p =
                              Provider.of<TimerProvider>(context, listen: false);
                              p.resetSeconds();
                              final provider =
                              Provider.of<HomeProvider>(context, listen: false);
                              provider.changeSelectedIndex(0);

                              final pProvider = Provider.of<GameScreenProvider>(
                                  context,
                                  listen: false);
                              //pProvider.reset();
                              Nav.pop(context);
                              final provider_ =
                              Provider.of<HomeProvider>(context, listen: false);
                              provider_.changeSelectedIndex(4);
                            },
                            title: AppLocalizations.of(context)!.back),
                        const SizedBox(height: 16),
                        ShadowButton(
                            fillColors: const [
                              AllColors.liteOrange,
                              AllColors.orange
                            ],
                            onPressed: () {
                              rate();

                              final provider = Provider.of<GameScreenProvider>(
                                  context,
                                  listen: false);

                              print('gamedata');
                              print(provider.gameData['gameDetails']);
                              Nav.push(
                                  context,
                                  LeaderBoardPage(
                                      pageName: 'levelComplete',
                                      gameDetails: provider.gameData['gameDetails']));

                              //  provider.reset();
                            },
                            title: AppLocalizations.of(context)!.see_leaderboard),
                        const SizedBox(height: 16),
                        // widget.isCompleted
                        //     ? const SizedBox()
                        ShadowButton(
                            fillColors: const [
                              AllColors.semiLiteGreen,
                              AllColors.shineGreen
                            ],
                            onPressed: () {
                              rate();

                              final pProvider = Provider.of<GameScreenProvider>(
                                  context,
                                  listen: false);
                              //   pProvider.reset();

                              final p = Provider.of<TimerProvider>(context,
                                  listen: false);
                              p.resetSeconds();
                              p.resetSeconds();
                              Nav.pop(context);
                              final provider =
                              Provider.of<HomeProvider>(context, listen: false);
                              provider.changeSelectedIndex(1);
                            },
                            title: AppLocalizations.of(context)!.startNew_game),
                      ],
                    ),
                  ),
                ),
              ),
            ))),
      ) :
      Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 100),
                  Consumer<GameScreenProvider>(builder: (context, provider, _) {
                    return Label(
                        text: provider.gameData['gameDetails']['searchtype'] ==
                                'search'
                            ? AppLocalizations.of(context)!.rate_this
                            : AppLocalizations.of(context)!.rate_this_challange,
                        fontSize: FontSize.p2);
                  }),
                  const SizedBox(height: 10),
                  StatefulBuilder(builder: (context, st) {
                    return RatingBarIndicator(
                        rating: rating,
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                st(() {
                                  rating = index + 1;
                                });
                              },
                              child: const Icon(Icons.star,
                                  color: AllColors.superLightGreen),
                            ),
                        itemCount: 5,
                        itemPadding: const EdgeInsets.all(4),
                        unratedColor: AllColors.grey,
                        itemSize: 30);
                  }),
                  const SizedBox(height: 24),
                  !widget.isCompleted
                      ? Label(
                          text: AppLocalizations.of(context)!.game,
                          fontSize: FontSize.h4,
                          fontWeight: FontWeight.bold)
                      : Label(
                          text: AppLocalizations.of(context)!.congratulations,
                          fontSize: FontSize.h4),
                  const SizedBox(height: 4),
                  !widget.isCompleted
                      ? Label(
                          text: AppLocalizations.of(context)!.not_complete,
                          fontSize: FontSize.h4,
                          color: AllColors.liteRed,
                          fontWeight: FontWeight.bold)
                      : Label(
                          text: AppLocalizations.of(context)!.complete,
                          fontSize: FontSize.h4,
                          color: AllColors.liteGreen,
                          fontWeight: FontWeight.bold),
                  const SizedBox(height: 40),
                  Label(
                      text: AppLocalizations.of(context)!.hits,
                      fontSize: FontSize.p1,
                      fontWeight: FontWeight.w600),
                  const SizedBox(height: 10),
                  Label(
                      text:
                          '${widget.correctWord} ${AppLocalizations.of(context)!.offf} ${widget.totalWord}',
                      fontSize: FontSize.p1,
                      fontWeight: FontWeight.w600),
                  const SizedBox(height: 40),
                  Label(
                      text: AppLocalizations.of(context)!.time,
                      fontSize: FontSize.p1,
                      fontWeight: FontWeight.w600),
                  const SizedBox(height: 10),
                  Consumer<TimerProvider>(builder: (context, provider, _) {
                    return Label(
                        text: formatTime(widget.seconds),
                        fontSize: FontSize.p1,
                        fontWeight: FontWeight.w600);
                  }),
                  const SizedBox(height: 60),
                  ShadowButton(
                      fillColors: const [
                        AllColors.semiLiteGreen,
                        AllColors.shineGreen
                      ],
                      onPressed: () {
                        rate();

                        final p =
                            Provider.of<TimerProvider>(context, listen: false);
                        p.resetSeconds();
                        final provider =
                            Provider.of<HomeProvider>(context, listen: false);
                        provider.changeSelectedIndex(0);

                        final pProvider = Provider.of<GameScreenProvider>(
                            context,
                            listen: false);
                        //pProvider.reset();
                        Nav.pop(context);
                        final provider_ =
                        Provider.of<HomeProvider>(context, listen: false);
                        provider_.changeSelectedIndex(4);
                      },
                      title: AppLocalizations.of(context)!.back),
                  const SizedBox(height: 16),
                  ShadowButton(
                      fillColors: const [
                        AllColors.liteOrange,
                        AllColors.orange
                      ],
                      onPressed: () {
                        rate();

                        final provider = Provider.of<GameScreenProvider>(
                            context,
                            listen: false);

                        print('gamedata');
                        print(provider.gameData['gameDetails']);
                        Nav.push(
                            context,
                            LeaderBoardPage(
                                pageName: 'levelComplete',
                                gameDetails: provider.gameData['gameDetails']));

                      //  provider.reset();
                      },
                      title: AppLocalizations.of(context)!.see_leaderboard),
                  const SizedBox(height: 16),
                  // widget.isCompleted
                  //     ? const SizedBox()
                      ShadowButton(
                          fillColors: const [
                              AllColors.semiLiteGreen,
                              AllColors.shineGreen
                            ],
                          onPressed: () {
                            rate();

                            final pProvider = Provider.of<GameScreenProvider>(
                                context,
                                listen: false);
                         //   pProvider.reset();

                            final p = Provider.of<TimerProvider>(context,
                                listen: false);
                            p.resetSeconds();
                            p.resetSeconds();
                            Nav.pop(context);
                            final provider =
                            Provider.of<HomeProvider>(context, listen: false);
                            provider.changeSelectedIndex(1);
                          },
                          title: AppLocalizations.of(context)!.startNew_game),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  rate() {
    if(rating > 0) {
      final provider = Provider.of<GameScreenProvider>(context, listen: false);
      Prefs.getToken().then((token) {
        print('gameRated Successfully!');
        Prefs.getPrefs('loginId').then((loginId) {
          _apiServices.post(context: context, endpoint: 'addGameRating', body: {
            "accessToken": token,
            "gameid": provider.gameData['gameDetails']['gameid'].toString(),
            "userId": loginId,
            "rating": rating.toString(),
          }, progressBar: false);
        });
      });
    }
  }

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
}
