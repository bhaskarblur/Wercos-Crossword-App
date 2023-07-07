import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app_word_search/components/custom_dialogs.dart';
import 'package:mobile_app_word_search/components/custom_switch_button.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/leaderboard_page.dart';

class MyGamesPage extends StatelessWidget {
  const MyGamesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70), child: CustomAppBar(isBack: false, isLang: true,)),
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Label(
                      text: 'MY CREATED GAMES',
                      fontSize: FontSize.p2,
                      fontWeight: FontWeight.w500,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomSwitchButton(
                      onPressed: () {
                        CustomDialog().showPurchaseDialog(context: context);
                      },
                      labels: ['WORD SEARCHES', 'CHALLENGES'],
                      infoButton: false,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CreatedGamesItem(),
                    CreatedGamesItem(),

                    SizedBox(height: 80,),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, left: 24,right: 24),
            child: ShadowButton(  fillColors: [
              AllColors.semiLiteGreen,
              AllColors.shineGreen
            ],onPressed: () {  }, title: 'CREATE CHALLENGE',),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ));
  }
}

class CreatedGamesItem extends StatelessWidget {
  const CreatedGamesItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: double.maxFinite,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AllColors.purple, width: 1),
        color: AllColors.liteDarkPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Center(
              child: Label(
            text: 'CODE TO SHARE: XYZ1234',
            fontSize: FontSize.p2,
          )),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                text: 'Word search title: ',
                fontSize: FontSize.p2,
              ),
              CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Icon(
                    Icons.share,
                    color: AllColors.white,
                  ))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                text: 'Words: 12',
                fontSize: FontSize.p2,
              ),
              CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Icon(
                    Icons.share,
                    color: AllColors.white,
                  ))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                text: 'Users: 4/10',
                fontSize: FontSize.p2,
              ),
              RatingBarIndicator(
                rating: 5,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: AllColors.superLightGreen,
                ),
                itemCount: 5,
                unratedColor: AllColors.grey,
                itemSize: 22.0,
              ),
            ],
          ),
          SizedBox(height: 10,),
          CupertinoButton(
            onPressed: () {

              Navigator.push(context, MaterialPageRoute(builder: (context)=> LeaderBoardPage()));
            },
            minSize: 0,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.maxFinite,
              height: 30,
              decoration: BoxDecoration(
                  color: AllColors.litePurple,
                  borderRadius: BorderRadius.circular(50),
                  border:
                      Border.all(color: AllColors.white, width: 1)),
              child: Center(child: Label(text: 'Leaderboard', fontSize: FontSize.p4,)),
            ),
          ),
          SizedBox(height: 10,),
          CupertinoButton(
            onPressed: () {  },
            minSize: 0,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.maxFinite,
              height: 30,
              decoration: BoxDecoration(
                  color: AllColors.litePurple,
                  borderRadius: BorderRadius.circular(50),
                  border:
                      Border.all(color: AllColors.white, width: 1)),
              child: Center(child: Label(text: 'Duplicate', fontSize: FontSize.p4,)),
            ),
          ),
        ],
      ),
    );
  }
}
