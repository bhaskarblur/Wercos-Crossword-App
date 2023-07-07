import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';

import '../components/cutom_image_button.dart';
import '../components/labels.dart';
import '../utils/all_colors.dart';
import '../utils/font_size.dart';

class LevelPage extends StatelessWidget {
  const LevelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),

        child: Scaffold(
          backgroundColor: Colors.transparent,

          appBar: PreferredSize(preferredSize: Size.fromHeight(70),
              child: CustomAppBar()),

          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Label(text: "SELECCIONAR NIVEL", fontWeight: FontWeight.bold, fontSize: FontSize.p2,),

                SizedBox(height: 20,),
                LevelCard(level: '6 PALABRAS  (FÁCIL)', isPremium: false,),
                LevelCard(level: '9 PALABRAS (MEDIO)', isPremium: false,),
                LevelCard(level: '12 PALABRAS (AVANZADO)', isPremium: true,),
                LevelCard(level: '15 PALABRAS  (DÍFICIL)', isPremium: true,),
                LevelCard(level: '18  PALABRAS  (EXPERTO)', isPremium: true,),


              ],
            ),
          ),

        ));
  }
}

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key, required this.level, required this.isPremium,
  });

  final String level;
  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      height: 50,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: AllColors.liteDarkPurple,
          borderRadius: BorderRadius.circular(50)
      ),


      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Icon(isPremium?CupertinoIcons.lock_fill:null, color: AllColors.liteGreen,),

          Label(text: level, fontSize: FontSize.p2,),
          SizedBox(),
        ],
      ),

    );
  }
}