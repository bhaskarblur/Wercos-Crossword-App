import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/word_related_page.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isCategoryVisible = false;



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70), child: CustomAppBar(isBack: true, isLang: true,)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Label(
                  text: 'CATEGORIES',
                  fontWeight: FontWeight.bold,
                  fontSize: FontSize.h5,
                ),
                SizedBox(
                  height: 20,
                ),
                ShadowButton(
                    onPressed: () {
                      setState(() {
                        isCategoryVisible = !isCategoryVisible;
                      });
                    },
                    title: 'CATEGORY 1', fillColors: [
                      AllColors.semiLiteGreen,
                  AllColors.shineGreen
                ],),
                isCategoryVisible
                    ? SizedBox()
                    : TopicButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> WordRelatedPage()));
                }, topicName: 'Beach vacation',),

                SizedBox(
                  height: 20,
                ),

                ShadowButton(
                    fillColors: [
                      AllColors.semiLiteGreen,
                      AllColors.shineGreen
                    ],
                    onPressed: () {

                    },
                    title: 'CATEGORY 2'),
                SizedBox(
                  height: 20,
                ),
                ShadowButton(  fillColors: [
                  AllColors.semiLiteGreen,
                  AllColors.shineGreen
                ],
                    onPressed: () {

                    },
                    title: 'CATEGORY 3'),
                SizedBox(
                  height: 20,
                ),
                ShadowButton(  fillColors: [
                  AllColors.semiLiteGreen,
                  AllColors.shineGreen
                ],
                    onPressed: () {

                    },
                    title: 'CATEGORY 4'),
                SizedBox(
                  height: 20,
                ),
                ShadowButton(  fillColors: [
                  AllColors.semiLiteGreen,
                  AllColors.shineGreen
                ],
                    onPressed: () {

                    },
                    title: 'CATEGORY 5'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopicButton extends StatelessWidget {
  const TopicButton({
    super.key, required this.onPressed, required this.topicName,
  });

  final VoidCallback onPressed;
  final String topicName;

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
            text: topicName,
            fontSize: FontSize.p2,
          )),
        ),
      );
  }
}
