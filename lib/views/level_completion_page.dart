import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

import '../widget/widgets.dart';

class LevelCompletionPage extends StatefulWidget {
  final bool isCompleted;
  final int totalWord;
  final int correctWord;
  const LevelCompletionPage(
      {Key? key,
      required this.isCompleted,
      required this.totalWord,
      required this.correctWord})
      : super(key: key);

  @override
  State<LevelCompletionPage> createState() => _LevelCompletionPageState();
}

class _LevelCompletionPageState extends State<LevelCompletionPage> {
  final ApiServices _apiServices = ApiServices();

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
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final pProvider =
            Provider.of<GameScreenProvider>(context, listen: false);

        pProvider.reset();

        final p = Provider.of<TimerProvider>(context, listen: false);
        p.resetSeconds();
        p.startTimer();

        return true;
      },
      child: Container(
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
                  RatingBarIndicator(
                      rating: 5,
                      itemBuilder: (context, index) => const Icon(Icons.star,
                          color: AllColors.superLightGreen),
                      itemCount: 5,
                      itemPadding: const EdgeInsets.all(4),
                      unratedColor: AllColors.grey,
                      itemSize: 30.0),
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
                        text: formatTime(provider.seconds),
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
                        final p =
                            Provider.of<TimerProvider>(context, listen: false);
                        p.resetSeconds();
                        final provider =
                            Provider.of<HomeProvider>(context, listen: false);
                        provider.changeSelectedIndex(0);

                        final pProvider = Provider.of<GameScreenProvider>(
                            context,
                            listen: false);
                        pProvider.reset();
                        Nav.pop(context);
                      },
                      title: AppLocalizations.of(context)!.back),
                  const SizedBox(height: 16),
                  ShadowButton(
                      fillColors: const [
                        AllColors.liteOrange,
                        AllColors.orange
                      ],
                      onPressed: () {
                        final provider = Provider.of<GameScreenProvider>(
                            context,
                            listen: false);

                        Nav.push(
                            context,
                            LeaderBoardPage(
                              pageName: 'levelComplete',
                                gameDetails: provider.gameData['gameDetails']));

                        provider.reset();
                      },
                      title: AppLocalizations.of(context)!.see_leaderboard),
                  const SizedBox(height: 16),
                  widget.isCompleted
                      ? const SizedBox()
                      : ShadowButton(
                          fillColors: const [
                              AllColors.semiLiteGreen,
                              AllColors.shineGreen
                            ],
                          onPressed: () {
                            final pProvider = Provider.of<GameScreenProvider>(
                                context,
                                listen: false);
                            pProvider.reset();

                            final p = Provider.of<TimerProvider>(context,
                                listen: false);
                            p.resetSeconds();
                            p.startTimer();
                            Nav.pop(context);
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
}
