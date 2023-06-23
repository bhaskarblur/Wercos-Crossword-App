import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/cutom_image_button.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';

import '../utils/all_colors.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              Expanded(
                child: CupertinoButton(
                  minSize: 0,
                  padding: EdgeInsets.zero,
                  onPressed: () {},
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
                  onPressed: () {
                    Navigator.pop(context);
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
                          text: "Regresar",
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
                        text: "Nível",
                        fontSize: FontSize.p4,
                        color: AllColors.superLitePurple,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
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
        margin: EdgeInsets.only(bottom: 14),
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),


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
            SizedBox(width: 30,),
          ],
        ),

      ),
    );
  }
}
