import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/providers/profile_provider.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';

import '../components/labels.dart';
import '../utils/all_colors.dart';
import '../utils/font_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LevelPage extends StatefulWidget {
  const LevelPage({Key? key}) : super(key: key);

  @override
  State<LevelPage> createState() => _LevelPageState();
}

class _LevelPageState extends State<LevelPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomAppBar(isBack: true, isLang: true, isLevel: false)),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Consumer<ProfileProvider>(builder: (context, provider, _) {
              print(provider.profile['subscriptionstatus']);
              return Column(
                children: [
                  const SizedBox(height: 20),
                  const Label(
                      text: "SELECT LEVEL",
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.p2),
                  const SizedBox(height: 20),
                  levelCard('6', '6 WORDS (EASY)', false),
                  levelCard('9', '9 WORDS (MEDIUM)', false),
                  levelCard(
                      '12',
                      '12 WORDS (ADVANCED)',
                      provider.profile['subscriptionstatus'] == 'none'
                          ? true
                          : false),
                  levelCard(
                      '15',
                      '15 WORDS (HARD)',
                      provider.profile['subscriptionstatus'] == 'none'
                          ? true
                          : false),
                  levelCard(
                      '18',
                      '18  WORDS (EXPERT)',
                      provider.profile['subscriptionstatus'] == 'none'
                          ? true
                          : false),
                ],
              );
            }),
          ),
        ));
  }

  Widget levelCard(String value, String level, bool premium) {
    return GestureDetector(
      onTap: () {
        if (!premium) {
          Prefs.setPrefs('wordLimit', value);
          setState(() {});
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        height: 50,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FutureBuilder(
                future: Prefs.getPrefs('wordLimit'),
                builder: (context, snapshot) {
                  return Icon(
                      premium
                          ? CupertinoIcons.lock_fill
                          : snapshot.hasData
                              ? snapshot.data == value
                                  ? Icons.check
                                  : null
                              : null,
                      color: AllColors.liteGreen);
                }),
            Label(text: level, fontSize: FontSize.p2),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
