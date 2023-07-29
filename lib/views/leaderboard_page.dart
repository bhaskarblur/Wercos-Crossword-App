import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/api_services.dart';
import 'package:mobile_app_word_search/providers/leaderboard_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';
import 'package:mobile_app_word_search/widget/widgets.dart';
import 'package:provider/provider.dart';

import '../components/labels.dart';
import '../utils/font_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaderBoardPage extends StatefulWidget {
  final dynamic gameDetails;
  const LeaderBoardPage({Key? key, this.gameDetails}) : super(key: key);

  @override
  State<LeaderBoardPage> createState() => _LeaderBoardPageState();
}

class _LeaderBoardPageState extends State<LeaderBoardPage> {
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    super.initState();
    print(widget.gameDetails);

    final provider = Provider.of<LeaderBoardProvider>(context, listen: false);

    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        _apiServices.post(context: context, endpoint: 'getLeaderboards', body: {
          "accessToken": token,
          "gameId": widget.gameDetails['id'].toString(),
          "userId": loginId,
        }).then((value) {
          provider.changeLeaderboard(value);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomAppBar(isBack: true, isLang: true)),
          body: Consumer<LeaderBoardProvider>(builder: (context, provider, _) {
            return Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Label(
                      text: 'Leaderboard',
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.h5),
                  const Label(
                      text: 'Word Search Name: Beach Vacation',
                      fontWeight: FontWeight.w500,
                      fontSize: FontSize.p2),
                  const SizedBox(height: 10),
                  if (provider.leaderboard != null)
                    ListView.separated(
                        shrinkWrap: true,
                        itemCount: provider.leaderboard['leaderboards'].length,
                        separatorBuilder: (context, index) {
                          return gap(10);
                        },
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 34),
                                padding:
                                    const EdgeInsets.only(left: 34, right: 10),
                                width: double.maxFinite,
                                height: 55,
                                decoration: BoxDecoration(
                                    color: AllColors.liteDarkPurple,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Label(
                                        text:
                                            provider.leaderboard['leaderboards']
                                                [index]['playername'],
                                        fontSize: FontSize.p2),
                                    Label(
                                        text:
                                            '${provider.leaderboard['totalWords']} of ${provider.leaderboard['leaderboards'][index]['crosswordscore']}',
                                        fontWeight: FontWeight.w600,
                                        fontSize: FontSize.p5),
                                    Label(
                                        text:
                                            provider.leaderboard['leaderboards']
                                                [index]['timescoretext'],
                                        fontWeight: FontWeight.w600,
                                        fontSize: FontSize.p5,
                                        color: AllColors.orange),
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
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Center(
                                      child: Label(
                                    text: index.toString(),
                                    color: AllColors.black,
                                    fontSize: FontSize.p4,
                                    fontWeight: FontWeight.w500,
                                  )),
                                ),
                              ),
                            ],
                          );
                        }),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ShadowButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      title: 'Back',
                      fillColors: const [
                        AllColors.liteOrange,
                        AllColors.orange
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          backgroundColor: Colors.transparent),
    );
  }
}
