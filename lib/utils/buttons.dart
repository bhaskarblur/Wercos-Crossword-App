import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';

class GreenShadowButton extends StatelessWidget {
  const GreenShadowButton({
  super.key, required this.onPressed, required this.title,
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
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(color: AllColors.darkLiteGreen,
                offset: Offset(0,0),
                blurRadius:0,
                spreadRadius: 0,


              ),

              BoxShadow(color: AllColors.white.withOpacity(.4),
                offset: Offset(-3,6),
                blurRadius: 1,
                spreadRadius: -13,


              ),
              BoxShadow(color: AllColors.white.withOpacity(.7),
                offset: Offset(2,-6),
                blurRadius: 1,
                spreadRadius: -10,


              ),
              BoxShadow(color: AllColors.shineGreen,
                offset: Offset(0,0),
                blurRadius: 1,
                spreadRadius: 0,


              ),
              BoxShadow(color: AllColors.darkLiteGreen,
                offset: Offset(-1,7),
                blurRadius: 10,
                spreadRadius: -10,


              ),




            ]
        ),
        child: Center(
            child: Label(
              text: title,
              fontSize: FontSize.p2,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }
}

class OrangeShadowButton extends StatelessWidget {
  const OrangeShadowButton({
  super.key, required this.onPressed, required this.title,
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
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              BoxShadow(color: AllColors.darkLiteGreen,
                offset: Offset(0,0),
                blurRadius:0,
                spreadRadius: 0,


              ),

              BoxShadow(color: AllColors.white.withOpacity(.4),
                offset: Offset(-3,6),
                blurRadius: 1,
                spreadRadius: -13,


              ),
              BoxShadow(color: AllColors.white.withOpacity(.7),
                offset: Offset(2,-6),
                blurRadius: 1,
                spreadRadius: -10,


              ),
              BoxShadow(color: AllColors.shineGreen,
                offset: Offset(0,0),
                blurRadius: 1,
                spreadRadius: 0,


              ),
              BoxShadow(color: AllColors.darkLiteGreen,
                offset: Offset(-1,7),
                blurRadius: 10,
                spreadRadius: -10,


              ),




            ]
        ),
        child: Center(
            child: Label(
              text: title,
              fontSize: FontSize.p2,
              fontWeight: FontWeight.w500,
            )),
      ),
    );
  }
}