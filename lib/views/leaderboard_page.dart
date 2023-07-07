import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/cutom_image_button.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/views/language_selection_page.dart';

import '../components/labels.dart';
import '../utils/font_size.dart';

class LeaderBoardPage extends StatelessWidget {
  const LeaderBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(70),
            child: CustomAppBar(isBack: false, isLang: true,)),

        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Label(
                text: 'Leaderboard',
                fontWeight: FontWeight.bold,
                fontSize: FontSize.h5,
              ),
              Label(
                text: 'Word Search Name: Beach Vacation',
                fontWeight: FontWeight.w500,
                fontSize: FontSize.p2,
              ),
              SizedBox(height: 4,),
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: 'PLayer Name',
                          fontSize: FontSize.p2,
                        ),
                        Label(
                          text: '6 of 6',
                          fontWeight: FontWeight.w600,
                          fontSize: FontSize.p5,
                        ),
                        Label(
                          text: '1 min 30 sec',
                          fontWeight: FontWeight.w600,
                          fontSize: FontSize.p5,
                          color: AllColors.orange,
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
                          borderRadius: BorderRadius.circular(50)),

                      child: Center(child: Label(text: '1', color: AllColors.black, fontSize: FontSize.p4, fontWeight: FontWeight.w500,)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ShadowButton(onPressed: (){
                  Navigator.pop(context);
                }, title: 'Back' , fillColors: [
                  AllColors.liteOrange,
                  AllColors.orange
                  ],),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
