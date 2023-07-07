import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/cutom_image_button.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/language_selection_page.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
  super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          Expanded(
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
          ),
          Expanded(
            child: CupertinoButton(
              onPressed: () {},
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
          ),
          Expanded(
            child: CupertinoButton(
              onPressed: () {},
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