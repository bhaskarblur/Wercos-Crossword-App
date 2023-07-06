import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/custom_switch_button.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/language_selection_page.dart';

import '../components/cutom_image_button.dart';

class CreateWordPage extends StatefulWidget {
  const CreateWordPage({Key? key}) : super(key: key);

  @override
  State<CreateWordPage> createState() => _CreateWordPageState();
}





class _CreateWordPageState extends State<CreateWordPage> {
  @override

  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          centerTitle: true,
          backgroundColor: Colors.transparent,
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
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Label(
                  text: "CREAR SOPA",
                  fontSize: FontSize.p2,
                  fontWeight: FontWeight.w500,
                )),
                Label(
                  text: "Mode de publicación",
                  fontSize: FontSize.p4,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(
                  height: 14,
                ),
                CustomSwitchButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  isOn: true,
                  labels: ["Pública", "Privada"],
                ),
                SizedBox(
                  height: 16,
                ),
                CustomSwitchButton(
                  onPressed: () {_showMyDialog();},
                  isOn: true,
                  labels: ["Fija", "Dinámica"],
                ),
                SizedBox(
                  height: 20,
                ),
                CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AllColors.white)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Label(
                          text: "Idioma/ Language",
                          fontSize: FontSize.p4,
                          align: TextAlign.center,
                        ),
                        Icon(
                          CupertinoIcons.arrowtriangle_down_fill,
                          color: AllColors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(color: AllColors.black.withOpacity(0.6),
                          offset: Offset(0,-1),
                          blurRadius: 0,
                          spreadRadius: -1,


                        ),

                        BoxShadow(color: AllColors.litePurple,
                          offset: Offset(1,1),
                          blurRadius: 10,
                          spreadRadius: 0,


                        ),

                      ]),
                  height: 50,
                  width: double.maxFinite,
                  child: Label(
                    text: "Ingresar nombre de la sopa",
                    fontSize: FontSize.p2,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(color: AllColors.black.withOpacity(0.6),
                          offset: Offset(0,-1),
                          blurRadius: 0,
                          spreadRadius: -1,


                        ),

                        BoxShadow(color: AllColors.litePurple,
                          offset: Offset(1,1),
                          blurRadius: 10,
                          spreadRadius: 0,


                        ),
                      ]),
                  height: 50,
                  width: double.maxFinite,
                  child: Label(
                    text: "Ingresar palabra",
                    fontSize: FontSize.p2,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Container(
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: AllColors.white)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Label(
                          text: "Agregar",
                          fontSize: FontSize.p4,
                          align: TextAlign.center,
                        ),
                        Icon(
                          CupertinoIcons.add,
                          color: AllColors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: AllColors.liteDarkPurple,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(
                        text: "Palabra",
                        fontSize: FontSize.p2,
                      ),
                      CupertinoButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          child: Icon(
                            Icons.close,
                            color: AllColors.white,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
                  height: 50,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: AllColors.liteDarkPurple,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Label(
                        text: "Palabra",
                        fontSize: FontSize.p2,
                      ),
                      CupertinoButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          child: Icon(
                            Icons.close,
                            color: AllColors.white,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GreenShadowButton(onPressed: () {  }, title: "GENERAR",),
              ],
            ),
          ),
        ),

      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 24),




              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: AllColors.alertBg

              ),

              child: Stack(
                children: [
                  Positioned(
                    top:10,
                    right: 10,

                    child: CupertinoButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      child: Icon(
                        CupertinoIcons.multiply_circle,
                        color: AllColors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 50),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric( horizontal: 20,vertical: 10),
                          child: Label(align: TextAlign.center,text: "El máximo de palabras para el plan freemium es de 6", fontSize: FontSize.p2,),
                        ),
                        Spacer(),

                        GreenShadowButton(onPressed: (){}, title: "Hazte Premium")


                      ],
                    ),
                  ),
                ],
              ),

            ),
          ],
        );
      },
    );
  }
}


