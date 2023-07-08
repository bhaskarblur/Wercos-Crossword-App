import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/components/suggestion/model/suggestion.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/subscription_page.dart';

class CustomDialog {
  Future<void> showPurchaseDialog({required BuildContext context}) async {
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
                  gradient: AllColors.alertGradient),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 50),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Label(
                            align: TextAlign.center,
                            text:
                                "This feature is only available for premium users. Upgrade to use this feature.",
                            fontSize: FontSize.p2,
                          ),
                        ),
                        Spacer(),
                        ShadowButton(fillColors: [
                          AllColors.semiLiteGreen,
                          AllColors.shineGreen
                        ], onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> SubscriptionPage()));
                        }, title: "UPGRADE")
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

  Future<void> showSuggestionDialog(
      {required BuildContext context,
      required List<Suggestion> suggestions}) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 750,
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: AllColors.alertGradient),
              child: SuggestionHolder(suggestions: suggestions),
            ),
          ],
        );
      },
    );
  }
}

class SuggestionHolder extends StatefulWidget {
  final List<Suggestion> suggestions;

  const SuggestionHolder({super.key, required this.suggestions});

  @override
  State<SuggestionHolder> createState() => _SuggestionHolderState();
}

class _SuggestionHolderState extends State<SuggestionHolder> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    Suggestion suggestion = widget.suggestions[index];
    return Stack(
      children: [
        Positioned(
          top: 10,
          right: 10,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            minSize: 0,
            onPressed: () {
              if (index == widget.suggestions.length-1) {
                Navigator.pop(context);
              } else {
                index++;
                setState(() {});
              }
            },
            child: Icon(
              CupertinoIcons.multiply_circle,
              color: AllColors.white,
              size: 30,
            ),
          ),
        ),


        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(color: AllColors.litePurple, borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AllColors.superDarkPurple.withOpacity(0.6),
                          offset: Offset(0, -5),
                          blurRadius: 0,
                          spreadRadius: -1,
                        ),
                        BoxShadow(
                          color: AllColors.superDarkPurple,
                          offset: Offset(1, -5),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ]

                  ),

                  child: Icon(
                    Icons.info_outline,
                    color: AllColors.white,
                    size: 30,
                  ),
                ),

                SizedBox(height: 40,),
                Label(
                  align: TextAlign.center,
                  text: suggestion.title,
                  fontSize: FontSize.h4,
                  fontWeight: FontWeight.bold,

                ),

                SizedBox(height: 10,),

                Label(
                  align: TextAlign.center,
                  text: suggestion.description,
                  fontSize: FontSize.p2,
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
