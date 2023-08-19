import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app_word_search/providers/game_screen_provider.dart';
import 'package:mobile_app_word_search/views/level_completion_page.dart';
import 'package:mobile_app_word_search/widget/navigator.dart';
import 'package:provider/provider.dart';
import 'package:mobile_app_word_search/views/play_page.dart';
import 'package:mobile_app_word_search/views/drug_page.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/views/create_page.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/views/option_page.dart';
import 'package:mobile_app_word_search/views/my_games_page.dart';
import 'package:mobile_app_word_search/providers/home_provider.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:mobile_app_word_search/components/model/bottom_navigation_item.dart';

import '../providers/timer_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({super.key});

  @override
  State<TabScreen> createState() => TabScreenState();
}

class TabScreenState extends State<TabScreen> {
  final List<Widget> pages = [
    const CreatePage(),
    const PlayPage(),
    const MyGamesPage(),
    const OptionPage(),
    const DrugPage()
  ];

  List<BottomNavigationItem>? iconList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    iconList = [
      BottomNavigationItem(
          iconData: CupertinoIcons.square_grid_2x2_fill,
          text: AppLocalizations.of(context)!.create),
      BottomNavigationItem(
          iconData: CupertinoIcons.star_fill,
          text: AppLocalizations.of(context)!.play),
      BottomNavigationItem(
          iconData: CupertinoIcons.person_3_fill,
          text: AppLocalizations.of(context)!.my_games),
      BottomNavigationItem(
          iconData: Icons.settings,
          text: AppLocalizations.of(context)!.options),
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, provider, _) {
      return Container(
          decoration: BoxDecoration(
              gradient: AllColors.bg,
              color: provider.selectedIndex == 4
                  ? Colors.white
                  : const Color(0xFF1E155C)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: pages[provider.selectedIndex],
            resizeToAvoidBottomInset: false,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom != 0.0
                ? null
                : AnimatedBottomNavigationBar.builder(
                    notchMargin: 22,
                    height: 60,
                    shadow: BoxShadow(
                        color: AllColors.black.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 10,
                        offset: const Offset(1, -6)),
                    backgroundColor: AllColors.superDarkPurple,
                    activeIndex: provider.selectedIndex,
                    gapLocation: GapLocation.center,
                    notchSmoothness: NotchSmoothness.defaultEdge,
                    onTap: (index) {
                      final p =
                          Provider.of<TimerProvider>(context, listen: false);
                      p.resetSeconds();
                      provider.changeSelectedIndex(index);
                    },
                    itemCount: 4,
                    tabBuilder: (int index, bool isActive) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          children: [
                            Icon(
                              iconList![index].iconData,
                              color: isActive
                                  ? AllColors.liteGreen
                                  : AllColors.superLitePurple,
                            ),
                            Label(
                                text: iconList![index].text,
                                color: isActive
                                    ? AllColors.liteGreen
                                    : AllColors.superLitePurple)
                          ],
                        ),
                      );
                    },
                  ),
            floatingActionButton: MediaQuery.of(context).viewInsets.bottom !=
                    0.0
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: FloatingActionButton(
                      backgroundColor: provider.selectedIndex == 4
                          ? AllColors.liteRed
                          : AllColors.liteGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      child: Icon(
                        provider.selectedIndex == 4
                            ? CupertinoIcons.square_fill
                            : Icons.play_arrow,
                        size: provider.selectedIndex == 4 ? 36 : 50,
                        color: AllColors.white,
                        shadows: [
                          BoxShadow(
                              color: AllColors.black.withOpacity(0.5),
                              blurRadius: 6,
                              spreadRadius: 10,
                              offset: const Offset(-1, 3)),
                        ],
                      ),
                      onPressed: () {
                        final p =
                            Provider.of<TimerProvider>(context, listen: false);
                        final gameProvider = Provider.of<GameScreenProvider>(
                            context,
                            listen: false);

                        if (provider.selectedIndex == 4) {
                          p.cancelTimer();
                          print(gameProvider.gameData['gameDetails']
                                  ['searchtype']);
                          if (gameProvider.gameData['gameDetails']
                                  ['searchtype'] ==
                              'search') {
                            Nav.push(
                                context,
                                LevelCompletionPage(
                                  isCompleted:
                                      gameProvider.allWordsFromAPI.length ==
                                          gameProvider.correctWords.length,
                                  totalWord:
                                      gameProvider.allWordsFromAPI.length,
                                  correctWord: gameProvider.correctWords.length,
                                ));
                          } else {
                            // TODO:
                          }
                        } else {
                          provider.changeSelectedIndex(4);
                        }
                      },
                    ),
                  ),
          ));
    });
  }
}
