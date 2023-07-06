import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/cutom_image_button.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/language_selection_page.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70), child: CustomAppBar()),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Label(
                    text: 'PLAY',
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.h5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 30, right: 20),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: AllColors.liteDarkPurple,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: FontSize.p2, color: AllColors.white),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: TextStyle(
                              fontSize: FontSize.p2, color: AllColors.white),
                          suffixIcon: Icon(
                            Icons.search_sharp,
                            color: AllColors.white,
                          ),
                        ),
                        onSaved: (value) {},
                      ),
                    ),
                  ),
                  SearchButton(
                    onPressed: () {},
                    title: 'RANDOM WORD SEARCH',
                  ),
                  SearchButton(
                    onPressed: () {},
                    title: 'WORD SEARCH CATEGORIES',
                  ),
                  SearchButton(
                    onPressed: () {},
                    title: 'RANDOM CHALLENGE',
                  ),
                  SearchButton(
                    onPressed: () {},
                    title: 'CHALLENGE BY CATEGORY',
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Label(
                    text: 'Play by entering code',
                    fontWeight: FontWeight.bold,
                    fontSize: FontSize.h5,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 30, right: 20),
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: AllColors.liteDarkPurple,
                        borderRadius: BorderRadius.circular(50)),
                    child: Center(
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: FontSize.p2, color: AllColors.white),
                        decoration: InputDecoration(
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: 'Enter  Code',
                          hintStyle: TextStyle(
                              fontSize: FontSize.p2, color: AllColors.white),
                        ),
                        onSaved: (value) {},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  OrangeShadowButton(
                      onPressed: () {}, title: 'PLAY WITH THE ENTERED CODE')
                ],
              ),
            ),
          ),
        ));
  }
}

class SearchButton extends StatelessWidget {
  const SearchButton({
    super.key,
    required this.onPressed,
    required this.title,
  });
  final VoidCallback onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minSize: 0,
      child: Container(
        height: 55,
        margin: EdgeInsets.only(top: 12),
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)),
        child: Center(
            child: Label(
          text: title,
          fontSize: FontSize.p2,
        )),
      ),
    );
  }
}
