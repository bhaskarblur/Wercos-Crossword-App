import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:crossword_flutter/components/labels.dart';
import 'package:crossword_flutter/components/suggestion/model/suggestion.dart';
import 'package:crossword_flutter/utils/all_colors.dart';
import 'package:crossword_flutter/utils/buttons.dart';
import 'package:crossword_flutter/utils/font_size.dart';
import 'package:crossword_flutter/views/subscription_page.dart';
import 'package:crossword_flutter/widget/navigator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:crossword_flutter/widget/widgets.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';
import '../views/create_word_page.dart';

class CustomDialog {
  static showPurchaseDialog({required BuildContext context}) {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 300,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AllColors.alertGradient),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Stack(children: [
                        Positioned(
                            top: 10,
                            right: 10,
                            child: CupertinoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                child: const Icon(
                                    CupertinoIcons.multiply_circle,
                                    color: AllColors.white,
                                    size: 30))),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 50),
                            child: Column(children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Label(
                                      align: TextAlign.center,
                                      text: AppLocalizations.of(context)!
                                          .this_feature,
                                      fontSize: FontSize.p2)),
                              const Spacer(),
                              ShadowButton(
                                  fillColors: const [
                                    AllColors.semiLiteGreen,
                                    AllColors.shineGreen
                                  ],
                                  onPressed: () {
                                    Nav.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SubscriptionPage()));
                                  },
                                  title: AppLocalizations.of(context)!.upgrade)
                            ]))
                      ]),
                    ))
              ]);
        });
  }

  static showWordsLimit({required BuildContext context}) {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AllColors.alertGradient),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Stack(children: [
                        Positioned(
                            top: 10,
                            right: 10,
                            child: CupertinoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                child: const Icon(
                                    CupertinoIcons.multiply_circle,
                                    color: AllColors.white,
                                    size: 30))),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 50),
                            child: Column(children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Label(
                                      align: TextAlign.center,
                                      text: AppLocalizations.of(context)!.words_limit
                                      ,
                                      fontSize: FontSize.p2)),
                              const Spacer(),
                              ShadowButton(
                                  fillColors: const [
                                    AllColors.semiLiteGreen,
                                    AllColors.shineGreen
                                  ],
                                  onPressed: () {
                                    Nav.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const SubscriptionPage()));
                                  },
                                  title: AppLocalizations.of(context)!.upgrade)
                            ]))
                      ]),
                    ))
              ]);
        });
  }

  static show18WordsCant({required BuildContext context}) {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AllColors.alertGradient),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Stack(children: [
                        Positioned(
                            top: 10,
                            right: 10,
                            child: CupertinoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                child: const Icon(
                                    CupertinoIcons.multiply_circle,
                                    color: AllColors.white,
                                    size: 30))),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 50),
                            child: Column(children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Label(
                                      align: TextAlign.center,
                                      text: AppLocalizations.of(context)!._words_cant
                                      ,
                                      fontSize: FontSize.p2)),
                              const Spacer(),
                              ShadowButton(
                                  fillColors: const [
                                    AllColors.semiLiteGreen,
                                    AllColors.shineGreen
                                  ],
                                  onPressed: () {
                                    Nav.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const SubscriptionPage()));
                                  },
                                  title: AppLocalizations.of(context)!.upgrade)
                            ]))
                      ]),
                    ))
              ]);
        });
  }
  static showGamesFinishedDialog({required BuildContext context}) {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AllColors.alertGradient),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Stack(children: [
                        Positioned(
                            top: 10,
                            right: 10,
                            child: CupertinoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                child: const Icon(
                                    CupertinoIcons.multiply_circle,
                                    color: AllColors.white,
                                    size: 30))),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 50),
                            child: Column(children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Label(
                                      align: TextAlign.center,
                                      text: AppLocalizations.of(context)!.game_limit
                                          ,
                                      fontSize: FontSize.p2)),
                              const Spacer(),
                              ShadowButton(
                                  fillColors: const [
                                    AllColors.semiLiteGreen,
                                    AllColors.shineGreen
                                  ],
                                  onPressed: () {
                                    Nav.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                            const SubscriptionPage()));
                                  },
                                  title: AppLocalizations.of(context)!.upgrade)
                            ]))
                      ]),
                    ))
              ]);
        });
  }

  static noGameAvailable({required BuildContext context}) {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 240,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AllColors.alertGradient),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Stack(children: [
                        Positioned(
                            top: 10,
                            right: 10,
                            child: CupertinoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                child: const Icon(
                                    CupertinoIcons.multiply_circle,
                                    color: AllColors.white,
                                    size: 30))),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 50),
                            child: Column(children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Label(
                                      align: TextAlign.center,
                                      text: AppLocalizations.of(context)!.nogame
                                      ,
                                      fontSize: FontSize.p2)),
                              const Spacer(),
                              ShadowButton(
                                  fillColors: const [
                                    AllColors.semiLiteGreen,
                                    AllColors.shineGreen
                                  ],
                                  onPressed: () {
                                    Nav.pop(context);
                                    final provider =
                                    Provider.of<HomeProvider>(context, listen: false);
                                    provider.changeSelectedIndex(1);
                                  },
                                  title: AppLocalizations.of(context)!.ok)
                            ]))
                      ]),
                    ))
              ]);
        });
  }

  static wrongCode({required BuildContext context}) {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 260,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AllColors.alertGradient),
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: Stack(children: [
                        Positioned(
                            top: 10,
                            right: 10,
                            child: CupertinoButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                padding: EdgeInsets.zero,
                                minSize: 0,
                                child: const Icon(
                                    CupertinoIcons.multiply_circle,
                                    color: AllColors.white,
                                    size: 30))),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 50),
                            child: Column(children: [
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Label(
                                      align: TextAlign.center,
                                      text: AppLocalizations.of(context)!.wrongcode
                                      ,
                                      fontSize: FontSize.p2)),
                              const Spacer(),
                              ShadowButton(
                                  fillColors: const [
                                    AllColors.semiLiteGreen,
                                    AllColors.shineGreen
                                  ],
                                  onPressed: () {
                                    Nav.pop(context);
                                    final provider =
                                    Provider.of<HomeProvider>(context, listen: false);
                                    provider.changeSelectedIndex(1);
                                  },
                                  title: AppLocalizations.of(context)!.ok)
                            ]))
                      ]),
                    ))
              ]);
        });
  }

  static showChallenge(
      {required BuildContext context}) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height - 50,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: AllColors.alertGradient),
                child:  Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
        children: [
        Positioned(
        top: 10,
        right: 10,
        child: CupertinoButton(
        padding: EdgeInsets.zero,
        minSize: 0,
        onPressed: () {
        // if (index == widget.suggestions.length - 1) {
        Navigator.pop(context);
        // } else {
        // index++;
        // setState(() {});
        // }
        },
        child: const Icon(CupertinoIcons.multiply_circle,
        color: AllColors.white, size: 30))),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
        child: Column(
        children: [
        Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
        color: AllColors.litePurple,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
        BoxShadow(
        color: AllColors.superDarkPurple.withOpacity(0.6),
        offset: const Offset(0, -5),
        blurRadius: 0,
        spreadRadius: -1),
        const BoxShadow(
        color: AllColors.superDarkPurple,
        offset: Offset(1, -5),
        blurRadius: 10,
        spreadRadius: 0)
        ]),
        child: const Icon(Icons.info_outline,
        color: AllColors.white, size: 30),
        ),
        const SizedBox(height: 40),
        Label(
        align: TextAlign.center,
        text:  AppLocalizations.of(context)!.what_is_challenge,
        fontSize: FontSize.h4,
        fontWeight: FontWeight.bold),
        const SizedBox(height: 10),
        Label(
        align: TextAlign.center,
        text: AppLocalizations.of(context)!
            .what_is_challenge_description,
        fontSize: FontSize.p2),
         gap(40),
          ShadowButton(
              onPressed: () {
                Nav.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) {
                      return CreateWordPage(
                          type: 'challenge');
                    }));
              },
              title: AppLocalizations.of(context)!
                  .continuee.toString().toUpperCase(),
              fillColors: const [
                AllColors.liteOrange,
                AllColors.orange
              ])
        ],
        ),
        ),
        ),
        ],
        ),
        )),
          ],
        );
      },
    );
  }
  static showSuggestionDialog(
      {required BuildContext context,
      required List<Suggestion> suggestions}) async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: MediaQuery.of(context).size.height - 50,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: AllColors.alertGradient),
                child: SuggestionHolder(suggestions: suggestions)),
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
              top: 10,
              right: 10,
              child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  onPressed: () {
                    if (index == widget.suggestions.length - 1) {
                      Navigator.pop(context);
                    } else {
                      index++;
                      setState(() {});
                    }
                  },
                  child: const Icon(CupertinoIcons.multiply_circle,
                      color: AllColors.white, size: 30))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Center(
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: AllColors.litePurple,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                              color: AllColors.superDarkPurple.withOpacity(0.6),
                              offset: const Offset(0, -5),
                              blurRadius: 0,
                              spreadRadius: -1),
                          const BoxShadow(
                              color: AllColors.superDarkPurple,
                              offset: Offset(1, -5),
                              blurRadius: 10,
                              spreadRadius: 0)
                        ]),
                    child: const Icon(Icons.info_outline,
                        color: AllColors.white, size: 30),
                  ),
                  const SizedBox(height: 40),
                  Label(
                      align: TextAlign.center,
                      text: suggestion.title,
                      fontSize: FontSize.h4,
                      fontWeight: FontWeight.bold),
                  const SizedBox(height: 10),
                  Label(
                      align: TextAlign.center,
                      text: suggestion.description,
                      fontSize: FontSize.p2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
