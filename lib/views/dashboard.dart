import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/components/model/bottom_navigation_item.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/views/create_page.dart';
import 'package:mobile_app_word_search/views/create_word_page.dart';
import 'package:mobile_app_word_search/views/drug_page.dart';

import 'package:mobile_app_word_search/views/language_selection_page.dart';
import 'package:mobile_app_word_search/views/level_page.dart';
import 'package:mobile_app_word_search/views/my_games_page.dart';
import 'package:mobile_app_word_search/views/option_page.dart';
import 'package:mobile_app_word_search/views/play_page.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  bool isStart = true;

  final List<Widget> pages = [
    CreatePage(),
    PlayPage(),
    MyGamesPage(),
    OptionPage(),
  ];
  List<BottomNavigationItem> _iconList = [
    BottomNavigationItem(
        iconData: CupertinoIcons.square_grid_2x2_fill, text: "Creat"),
    BottomNavigationItem(iconData: CupertinoIcons.star_fill, text: "Play"),
    BottomNavigationItem(
        iconData: CupertinoIcons.person_3_fill, text: "My games"),
    BottomNavigationItem(iconData: Icons.settings, text: "Options"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: pages[_currentIndex],
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: 60,
            width: 60,
            child: isStart?FloatingActionButton(
              backgroundColor:
                   AllColors.liteGreen,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
               Icons.play_arrow,
                size:  60,
                color: AllColors.white,
                shadows: [
                  BoxShadow(
                    color: AllColors.black.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 10,
                    offset: Offset(-1, 3),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {

                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Dashboard2()));

                });
              },
            ):FloatingActionButton(
              backgroundColor:
              AllColors.liteRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                CupertinoIcons.square_fill,
                size:  40,
                color: AllColors.white,
                shadows: [
                  BoxShadow(
                    color: AllColors.black.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 10,
                    offset: Offset(-1, 3),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Dashboard()));
              },
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,



        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          notchMargin: 20,
          height: 60,
          shadow: BoxShadow(
            color: AllColors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 10,
            offset: Offset(1, -6),
          ),

          backgroundColor: AllColors.superDarkPurple,

          activeIndex: _currentIndex,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,

          onTap: (index) => setState(() => _currentIndex = index),
          itemCount: 4,
          tabBuilder: (int index, bool isActive) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Icon(
                    _iconList[index].iconData,
                    color: isActive
                        ? AllColors.liteGreen
                        : AllColors.superLitePurple,
                  ),
                  Label(
                      text: _iconList[index].text,
                      color: isActive
                          ? AllColors.liteGreen
                          : AllColors.superLitePurple)
                ],
              ),
            );
          },

          //other params
        ),
      ),
    );
  }
}

class Dashboard2 extends StatefulWidget {
  Dashboard2({Key? key}) : super(key: key);

  @override
  _DashboardState2 createState() => _DashboardState2();
}

class _DashboardState2 extends State<Dashboard2> {
  int _currentIndex = 0;
  bool isStart = true;

  final List<Widget> pages = [
    DrugPage()
  ];
  List<BottomNavigationItem> _iconList = [
    BottomNavigationItem(
        iconData: CupertinoIcons.square_grid_2x2_fill, text: "Creat"),
    BottomNavigationItem(iconData: CupertinoIcons.star_fill, text: "Play"),
    BottomNavigationItem(
        iconData: CupertinoIcons.person_3_fill, text: "My games"),
    BottomNavigationItem(iconData: Icons.settings, text: "Options"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: pages[_currentIndex],
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SizedBox(
            height: 60,
            width: 60,
            child: isStart?FloatingActionButton(
              backgroundColor:
              AllColors.liteRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                CupertinoIcons.square_fill,
                size:  40,
                color: AllColors.white,
                shadows: [
                  BoxShadow(
                    color: AllColors.black.withOpacity(0.5),
                    blurRadius: 6,
                    spreadRadius: 10,
                    offset: Offset(-1, 3),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Dashboard()));
              },
            ):FloatingActionButton(
            backgroundColor:
            AllColors.liteGreen,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50)),
            child: Icon(
              Icons.play_arrow,
              size:  60,
              color: AllColors.white,
              shadows: [
                BoxShadow(
                  color: AllColors.black.withOpacity(0.5),
                  blurRadius: 6,
                  spreadRadius: 10,
                  offset: Offset(-1, 3),
                ),
              ],
            ),
            onPressed: () {
              setState(() {

                isStart=!isStart;

              });
            },
          ),
          ),
        ),
        resizeToAvoidBottomInset: false,



        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: AnimatedBottomNavigationBar.builder(
          notchMargin: 20,
          height: 60,
          shadow: BoxShadow(
            color: AllColors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 10,
            offset: Offset(1, -6),
          ),

          backgroundColor: AllColors.superDarkPurple,


          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,

          onTap: (index) {},
          itemCount: 4,
          tabBuilder: (int index, bool isActive) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  Icon(
                    _iconList[index].iconData,
                    color: isActive
                        ? AllColors.liteGreen
                        : AllColors.superLitePurple,
                  ),
                  Label(
                      text: _iconList[index].text,
                      color: isActive
                          ? AllColors.liteGreen
                          : AllColors.superLitePurple)
                ],
              ),
            );
          }, activeIndex: -1,

          //other params
        ),
      ),
    );
  }
}


