import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkos/api_services.dart';
import 'package:werkos/providers/leaderboard_provider.dart';
import 'package:werkos/utils/all_colors.dart';
import 'package:werkos/utils/buttons.dart';
import 'package:werkos/utils/custom_app_bar.dart';
import 'package:werkos/views/tab_screen.dart';
import 'package:werkos/widget/navigator.dart';
import 'package:werkos/widget/sahared_prefs.dart';
import 'package:werkos/widget/widgets.dart';
import 'package:provider/provider.dart';

import '../components/labels.dart';
import '../utils/font_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaderBoardPage extends StatefulWidget {
  final String pageName;
  final dynamic gameDetails;
  const LeaderBoardPage({Key? key, this.gameDetails, required this.pageName})
      : super(key: key);

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<LeaderBoardProvider>(context, listen: false);

    print('leaderboardshere');
    print(widget.gameDetails);
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        _apiServices.post(context: context, endpoint: 'getLeaderboards', body: {
          "accessToken": token,
          "gameId": widget.gameDetails['gameid'].toString(),
          "userId": loginId,
        }).then((value) {
          provider.changeLeaderboard(value);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ?
    Scaffold(
      backgroundColor: AllColors.purple_2,
      body:  Center(
          child:
          SizedBox(width: 400 ,child:
          Container(
            decoration: const BoxDecoration(gradient: AllColors.bg),
            child: Scaffold(
                appBar: const PreferredSize(
                    preferredSize: Size.fromHeight(70),
                    child: CustomAppBar(isBack: true, isLang: true)),
                body: Consumer<LeaderBoardProvider>(builder: (context, provider, _) {
                  return Center(
                    child: provider.leaderboard == null
                        ? gap(0)
                        : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Label(
                              text: AppLocalizations.of(context)!.leaderboard,
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.h5),
                          Label(
                              text:
                              '${AppLocalizations.of(context)!.word_search_name}: ${provider.leaderboard['gameName']}',
                              fontWeight: FontWeight.w500,
                              fontSize: FontSize.p2),
                          const SizedBox(height: 10),
                          ListView.separated(
                              shrinkWrap: true,
                              itemCount:
                              provider.leaderboard['leaderboards'].length,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return gap(10);
                              },
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 34),
                                      padding: const EdgeInsets.only(
                                          left: 34, right: 10),
                                      width: double.maxFinite,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: AllColors.liteDarkPurple,
                                          borderRadius:
                                          BorderRadius.circular(50)),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Label(
                                                text: provider.leaderboard[
                                                'leaderboards'][index]
                                                ['playername'],
                                                fontSize: FontSize.p2),
                                          ),
                                          Expanded(
                                              flex: 1,
                                              child: Text(
                                                  provider.leaderboard['leaderboards'][index]['crosswordscore'].toString() + " " +
                                                      AppLocalizations.of(context)!.hits,
                                                  textAlign: TextAlign.end,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: FontSize.p5))
                                          ),
                                          horGap(10),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                                provider.leaderboard[
                                                'leaderboards'][index]
                                                ['timescoretext'],
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: AllColors.orange,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: FontSize.p5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 14,
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                            color: AllColors.white,
                                            borderRadius:
                                            BorderRadius.circular(50)),
                                        child: Center(
                                            child: Label(
                                                text: (index + 1).toString(),
                                                color: AllColors.black,
                                                fontSize: FontSize.p4,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(height: 30),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ShadowButton(
                              onPressed: () {
                                if (widget.pageName == 'myGames') {
                                  Navigator.pop(context);
                                }
                                if (widget.pageName == 'levelComplete') {
                                  // Nav.pushAndRemoveAll(
                                  //     context, const TabScreen());
                                  Navigator.pop(context);
                                }
                              },
                              title: AppLocalizations.of(context)!.back,
                              fillColors: const [
                                AllColors.liteOrange,
                                AllColors.orange
                              ],
                            ),
                          ),
                          gap(20)
                        ],
                      ),
                    ),
                  );
                }),
                backgroundColor: Colors.transparent),
          ))),
    ) :
    Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomAppBar(isBack: true, isLang: true)),
          body: Consumer<LeaderBoardProvider>(builder: (context, provider, _) {
            return Center(
              child: provider.leaderboard == null
                  ? gap(0)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Label(
                              text: AppLocalizations.of(context)!.leaderboard,
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.h5),
                          Label(
                              text:
                                  '${AppLocalizations.of(context)!.word_search_name}: ${provider.leaderboard['gameName']}',
                              fontWeight: FontWeight.w500,
                              fontSize: FontSize.p2),
                          const SizedBox(height: 10),
                          ListView.separated(
                              shrinkWrap: true,
                              itemCount:
                                  provider.leaderboard['leaderboards'].length,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) {
                                return gap(10);
                              },
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 34),
                                      padding: const EdgeInsets.only(
                                          left: 34, right: 10),
                                      width: double.maxFinite,
                                      height: 55,
                                      decoration: BoxDecoration(
                                          color: AllColors.liteDarkPurple,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Label(
                                                text: provider.leaderboard[
                                                        'leaderboards'][index]
                                                    ['playername'],
                                                fontSize: FontSize.p2),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                                provider.leaderboard['leaderboards'][index]['crosswordscore'].toString() + " " +
                                                    AppLocalizations.of(context)!.hits,
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: FontSize.p5))
                                          ),
                                          horGap(10),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                                provider.leaderboard[
                                                        'leaderboards'][index]
                                                    ['timescoretext'],
                                                textAlign: TextAlign.end,
                                                style: const TextStyle(
                                                    color: AllColors.orange,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: FontSize.p5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 20,
                                      top: 14,
                                      child: Container(
                                        height: 24,
                                        width: 24,
                                        decoration: BoxDecoration(
                                            color: AllColors.white,
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: Center(
                                            child: Label(
                                                text: (index + 1).toString(),
                                                color: AllColors.black,
                                                fontSize: FontSize.p4,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          const SizedBox(height: 30),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ShadowButton(
                              onPressed: () {
                                if (widget.pageName == 'myGames') {
                                  Navigator.pop(context);
                                }
                                if (widget.pageName == 'levelComplete') {
                                  // Nav.pushAndRemoveAll(
                                  //     context, const TabScreen());
                                  Navigator.pop(context);
                                }
                              },
                              title: AppLocalizations.of(context)!.back,
                              fillColors: const [
                                AllColors.liteOrange,
                                AllColors.orange
                              ],
                            ),
                          ),
                          gap(20)
                        ],
                      ),
                    ),
            );
          }),
          backgroundColor: Colors.transparent),
    );
  }
}
