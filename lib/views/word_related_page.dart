import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';

class WordRelatedPage extends StatelessWidget {
  const WordRelatedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.alertGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(70), child: CustomAppBar(isBack: true, isLang: true,)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                SizedBox(height:100,),
                Label(
                  text: 'Only mark the words \n related to:',
                  align: TextAlign.center,
                  fontSize: FontSize.h3,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: 80,),
                Label(
                  text: 'BEACH VACATION',
                  align: TextAlign.center,
                  fontSize: FontSize.h4,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 120,),

           ShadowButton(onPressed: (){}, title: 'CONTINUE', fillColors: [AllColors.liteOrange,
             AllColors.orange],)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
