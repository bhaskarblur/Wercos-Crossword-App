import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/api_services.dart';
import 'package:mobile_app_word_search/providers/leaderboard_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';

import '../components/labels.dart';
import '../utils/font_size.dart';

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
          "userId ": loginId,
          "gameId": widget.gameDetails['id'].toString()
        }).then((value) {
          provider.changeLeaderboard(value['leaderboards']);
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
          body: Center(
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
                Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 34),
                      padding: const EdgeInsets.only(left: 34, right: 10),
                      width: double.maxFinite,
                      height: 55,
                      decoration: BoxDecoration(
                          color: AllColors.liteDarkPurple,
                          borderRadius: BorderRadius.circular(50)),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(text: 'PLayer Name', fontSize: FontSize.p2),
                          Label(
                              text: '6 of 6',
                              fontWeight: FontWeight.w600,
                              fontSize: FontSize.p5),
                          Label(
                              text: '1 min 30 sec',
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
                        child: const Center(
                            child: Label(
                          text: '1',
                          color: AllColors.black,
                          fontSize: FontSize.p4,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ShadowButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    title: 'Back',
                    fillColors: const [AllColors.liteOrange, AllColors.orange],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.transparent),
    );
  }
}
