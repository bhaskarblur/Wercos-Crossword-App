import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/cutom_image_button.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/dashboard.dart';
import 'package:mobile_app_word_search/views/language_selection_page.dart';
import 'package:mobile_app_word_search/views/level_page.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
  super.key, this.languageOnPressed, this.backOnPressed, this.levelOnPressed, required this.isLang, required this.isBack, this.isLevel,
  });

  final VoidCallback ? languageOnPressed;
  final VoidCallback ? backOnPressed;
  final VoidCallback ? levelOnPressed;

  final bool  isLang;
  final bool  isBack;
  final bool ? isLevel;



  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          isLang?Expanded(
            child: CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LanguageSelectionPage()));
              },
              child: Column(
                children: [
                  CustomImageButton(
                    image: "assets/images/spanish_flag.png",
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Label(
                      text: "Idioma/Languaje",
                      fontSize: FontSize.p4,
                      color: AllColors.superLitePurple)
                ],
              ),
            ),
          ):Expanded(child: SizedBox()),
          isBack?Expanded(
            child: CupertinoButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Dashboard()));
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Icon(
                      CupertinoIcons.arrowshape_turn_up_left_fill,
                      color: Colors.white,
                      size: 34,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Label(
                      text: "Back",
                      fontSize: FontSize.p4,
                      color: AllColors.superLitePurple)
                ],
              ),
            ),
          ):Expanded(child: SizedBox()),
          Expanded(
            child: CupertinoButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> LevelPage()));

              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  CustomImageButton(
                    image: "assets/images/hash.png",
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Label(
                    text: "Level",
                    fontSize: FontSize.p4,
                    color: AllColors.superLitePurple,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}