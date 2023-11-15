import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:werkos/components/labels.dart';
import 'package:werkos/providers/home_provider.dart';
import 'package:werkos/utils/all_colors.dart';
import 'package:werkos/utils/custom_app_bar.dart';
import 'package:werkos/utils/font_size.dart';
import 'package:werkos/views/language_selection_page.dart';
import 'package:werkos/views/level_page.dart';
import 'package:werkos/views/my_account_page.dart';
import 'package:werkos/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/game_screen_provider.dart';
import '../providers/timer_provider.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({Key? key}) : super(key: key);

  get isEnglish => true;

  @override
  State<OptionPage> createState() => OptionPageState();

}
class OptionPageState extends State<OptionPage> {

  var soundActive = true;
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 0), ()
    async {
      var soundPref = await Prefs.getPrefs("sound");
      if (soundPref == "off") {
        soundActive = false;
      }
      else {
        soundActive = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child:FutureBuilder(
        future: Prefs.getPrefs('language'),
    builder: (context, snapshot) {
       return Scaffold(
          backgroundColor: Colors.transparent,
         appBar: PreferredSize(
             preferredSize: Size.fromHeight(70),
             child: CustomAppBar(isBack: provider.prevIndex != 3 ? true : false, isLang: true, backOnPressed: () {
               final timeProvider =
               Provider.of<TimerProvider>(context, listen: false);

               final homeProvider = Provider.of<HomeProvider>(
                   context,
                   listen: false);

               final gameProvider = Provider.of<GameScreenProvider>(
                   context,
                   listen: false);
               print(homeProvider.prevIndex);
               if(homeProvider.prevIndex == 4) {
                 gameProvider.changeGameType('random');
                 gameProvider.reset();
                 timeProvider.stopSeconds();
                 timeProvider.resetSeconds();
                 gameProvider.setGameEnded(false);
                 homeProvider.changeSelectedIndex(4);
                 homeProvider.setSearching(false);
               }
               else {
                 homeProvider.changeSelectedIndex(homeProvider.prevIndex);
                 provider.changePreviousIndex(provider.selectedIndex);
               }
             },)),
          body: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Label(
                    text: AppLocalizations.of(context)!.options.toUpperCase(),
                    fontSize: FontSize.p1,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 14),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const LanguageSelectionPage(
                                changeType: 'app')));
                  },
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: double.maxFinite,
                      height: 55,
                      decoration: BoxDecoration(
                          color: AllColors.liteDarkPurple,
                          borderRadius: BorderRadius.circular(50)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Label(
                              text: AppLocalizations.of(context)!
                                  .select_language
                                  .toUpperCase(),
                              fontSize: FontSize.p2),
                          const SizedBox(width: 10),
                          FutureBuilder(
                              future: Prefs.getPrefs('language'),
                              builder: (context, snapshot) {
                                return Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    snapshot.data == 'en'
                                        ? Image.asset(
                                        'assets/images/us_flag.png',
                                        height: 45,
                                        width: 45)
                                        : Image.asset(
                                        'assets/images/spanish_flag.png',
                                        height: 45,
                                        width: 45),
                                    const SizedBox(width: 5),
                                  ],
                                );
                              }),
                        ],
                      )),
                ),
                const SizedBox(height: 20),
                OptionItem(
                  optionName: AppLocalizations.of(context)!.level.toUpperCase(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LevelPage()));
                  },
                ),
                OptionItem(
                  optionName:
                  AppLocalizations.of(context)!.my_games.toUpperCase(),
                  onPressed: () {
                    final provider =
                    Provider.of<HomeProvider>(context, listen: false);
                    provider.changeSelectedIndex(2);
                  },
                ),
                OptionItem(
                  optionName: AppLocalizations.of(context)!.play.toUpperCase(),
                  onPressed: () async {
                    final provider =
                    Provider.of<HomeProvider>(context, listen: false);
                    provider.changeSelectedIndex(1);
                  },
                ),
                OptionItem(
                  optionName:
                  AppLocalizations.of(context)!.my_account.toUpperCase(),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyAccountPage()));
                  },
                ),
            Column(
                        children: [
                          !soundActive ?
                          OptionItem(
                            optionName:
                            AppLocalizations.of(context)!.sound.toUpperCase() +
                                ": "
                                + AppLocalizations.of(context)!.inactive
                                .toUpperCase(),
                            onPressed: () async {
                              await Prefs.setPrefs('sound', 'on');
                              setState(() {
                                soundActive = true;
                              } ) ;
                            },
                          ) :
                          OptionItem(
                            optionName:
                            AppLocalizations.of(context)!.sound.toUpperCase() +
                                ": "
                                + AppLocalizations.of(context)!.active
                                .toUpperCase(),
                            onPressed: () async {
                              await Prefs.setPrefs('sound', 'off');
                              setState(() {
                                soundActive = false;
                              } ) ;
                            },
                          )
                        ],
                      ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    var url = Uri.parse("https://www.google.com");
                    if (await canLaunchUrl(url)) {
                    await launchUrl(url).then((value) => {});

                    // You can handle further navigation after the browser task here.
                    // For example, you can listen for when the user returns to your app.
                    }
                  },
                  child:
                Label(
                    text: AppLocalizations.of(context)!.privacy_policy,
                    fontSize: FontSize.p2),
                    )
              ],
            ),
          ),
        );})); });
  }
}

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.optionName,
    required this.onPressed,
  });

  final String optionName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minSize: 0,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        width: double.maxFinite,
        height: 55,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Label(
            text: optionName,
            fontSize: FontSize.p2,
          ),
        ),
      ),
    );
  }
}
