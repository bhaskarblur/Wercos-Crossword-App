import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app_word_search/widget/navigator.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app_word_search/api_services.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/views/create_word_page.dart';
import 'package:mobile_app_word_search/views/leaderboard_page.dart';
import 'package:mobile_app_word_search/providers/games_provider.dart';
import 'package:mobile_app_word_search/components/custom_dialogs.dart';

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
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: CustomAppBar(isBack: false, isLang: true)),
            body: Consumer<GamesProvider>(builder: (context, provider, _) {
              return SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Label(
                            text: 'MY CREATED GAMES',
                            fontSize: FontSize.p2,
                            fontWeight: FontWeight.w500),
                        const SizedBox(height: 20),
                        customSwitch(['WORD SEARCHES', 'CHALLENGES'],
                            value: public, onTap: () {
                          final provider = Provider.of<ProfileProvider>(context,
                              listen: false);
                          if (provider.profile['subscriptionstatus'] ==
                              'none') {
                            CustomDialog().showPurchaseDialog(context: context);
                          } else {
                            setState(() {
                              public = !public;
                            });
                            getData(true);
                          }
                        }, info: () {
                          CustomDialog().showPurchaseDialog(context: context);
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateWordPage()));
                  },
                  title: 'CREATE WORD SEARCH'),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked));
  }

  gamesItem(var details) {
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
              child: Label(
                  text: 'CODE TO SHARE: ${details['sharecode'].toString()}',
                  fontSize: FontSize.p2)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                  text: 'Word search title: ${details['gamename']}',
                  fontSize: FontSize.p2),
              CupertinoButton(
                  onPressed: () {},
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
                  text: 'Words: ${details['totalwords']}',
                  fontSize: FontSize.p2),
              CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Image.asset('assets/icons/edit_icon.png'))
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Label(text: 'Users: 4/10', fontSize: FontSize.p2),
              RatingBarIndicator(
                  rating: 5,
                  itemBuilder: (context, index) =>
                      const Icon(Icons.star, color: AllColors.superLightGreen),
                  itemCount: 5,
                  unratedColor: AllColors.grey,
                  itemSize: 22.0),
            ],
          ),
          const SizedBox(height: 10),
          CupertinoButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LeaderBoardPage(gameDetails: details)));
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
              child: const Center(
                  child: Label(text: 'Leaderboard', fontSize: FontSize.p4)),
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
                    "gameid": details['id'].toString(),
                    "userId": loginId,
                  }).then((value) {
                    dialog(context, value['message'], () {
                      Nav.pop(context);
                    });
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
              child: const Center(
                  child: Label(text: 'Duplicate', fontSize: FontSize.p4)),
            ),
          ),
        ],
      ),
    );
  }
}
