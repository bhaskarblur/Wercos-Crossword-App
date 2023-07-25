import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';

import '../utils/all_colors.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(preferredSize: Size.fromHeight(70),
            child: CustomAppBar(isBack: true, isLang: false,)),
        
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Label(text: "SELECCIONAR IDIOMA", fontSize: FontSize.p2, fontWeight: FontWeight.bold,),
            SizedBox(
            height: 16,
      ),

          LangSelectionCard(image: 'assets/images/us_flag.png', langName: 'English',),
              LangSelectionCard(image: 'assets/images/spanish_flag.png', langName: 'ESPAÑOL',)
            ],
          ),
        ),
      ),
    );
  }
}

class LangSelectionCard extends StatelessWidget {
  const LangSelectionCard({
    super.key, required this.image, required this.langName,
  });

  final String image;

  final String langName;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {  },
      padding: EdgeInsets.zero,
      minSize: 0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),


        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)
        ),


        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Image.asset(image, height: 35, width: 35,),

            Label(text: langName, fontSize: FontSize.p2,),
            const SizedBox(width: 30,),
          ],
        ),

      ),
    );
  }
}
