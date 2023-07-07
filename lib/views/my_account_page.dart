import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/subscription_page.dart';

class MyAccountPage extends StatelessWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70), child: CustomAppBar(isBack: true, isLang: true,)),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Label(
                      text: "MY ACCOUNT",
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.p2,
                    )),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Label(
                          text: "Username: ",
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.p2,
                        ),
                        Label(
                          text: " User3763",
                          fontSize: FontSize.p2,
                        ),
                        Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          onPressed: () {},
                          child: Label(
                            text: "Change",
                            fontSize: FontSize.p2,
                            color: AllColors.superLightGreen,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Label(
                          text: "Current plan:",
                          fontWeight: FontWeight.bold,
                          fontSize: FontSize.p2,
                        ),
                        Label(
                          text: " Free",
                          fontSize: FontSize.p2,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Label(
                      text: "Remaining games of day 49/50",
                      fontSize: FontSize.p2,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ShadowButton(  fillColors: [
                  AllColors.semiLiteGreen,
                  AllColors.shineGreen
                ],onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SubscriptionPage()));

                }, title: 'UPGRADE'),
              )
            ],
          ),
        ));
  }
}
