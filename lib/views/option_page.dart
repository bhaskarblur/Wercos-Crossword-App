import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';

class OptionPage extends StatelessWidget {
  const OptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70), child: CustomAppBar()),
          body: Center(
            child: Column(
              children: [
                SizedBox(height: 20,),
                Label(
                  text: 'OPTIONS',
                  fontSize: FontSize.p2,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 14,),
                CupertinoButton(
                  onPressed: () {  },
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),

                    width: double.maxFinite,
                    height: 55,
                    decoration: BoxDecoration(
                        color: AllColors.liteDarkPurple,
                        borderRadius: BorderRadius.circular(50)),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Label(
                          text: 'APP LANGUAGE/IDIOMA',
                          fontSize: FontSize.p2,
                        ),
                        SizedBox(width: 10,),

                        Image.asset('assets/images/us_flag.png', height: 45,width: 45,),
                        SizedBox(width: 5,),
                        Image.asset('assets/images/spanish_flag.png', height: 45,width: 45,)
                      ],
                    )),
                ),

                SizedBox(height: 20,),

                OptionItem(optionName: 'LEVEL', onPressed: () {  },),
                OptionItem(optionName: 'MY GAMES', onPressed: () {  },),
                OptionItem(optionName: 'PLAY', onPressed: () {  },),
                OptionItem(optionName: 'MY ACCOUNT', onPressed: () {  },),
              ],
            ),
          ),
        ));
  }
}

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key, required this.optionName, required this.onPressed,
  });

  final String optionName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minSize: 0,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),

        width: double.maxFinite,
        height: 55,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Label(
            text: optionName,
            fontSize: FontSize.p2,
          ),
        ),
      ),
    );
  }
}
