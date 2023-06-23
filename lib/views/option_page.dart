import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/cutom_image_button.dart';
import '../components/labels.dart';
import '../utils/all_colors.dart';
import '../utils/font_size.dart';

class OptionPage extends StatelessWidget {
  const OptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),

        child: Scaffold(
          backgroundColor: Colors.transparent,

          appBar: AppBar(
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
