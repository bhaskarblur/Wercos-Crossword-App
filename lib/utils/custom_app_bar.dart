import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/cutom_image_button.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/language_selection_page.dart';
import 'package:mobile_app_word_search/views/level_page.dart';
import 'package:mobile_app_word_search/widget/navigator.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';
import 'package:mobile_app_word_search/widget/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';

class CustomAppBar extends StatefulWidget {
  @override
  State<CustomAppBar> createState() => _CustomAppBar();
  const CustomAppBar({
    super.key,
    this.languageOnPressed,
    this.backOnPressed,
    this.levelOnPressed,
    required this.isLang,
    required this.isBack,
    this.isLevel = true,
  });

  final VoidCallback? languageOnPressed;
  final VoidCallback? backOnPressed;
  final VoidCallback? levelOnPressed;

  final bool isLang;
  final bool isBack;
  final bool isLevel;


}
  class _CustomAppBar extends State<CustomAppBar> {

  late String flag="assets/images/us_flag.png";

  @override
  void initState() {
  super.initState();

  Prefs.getPrefs('gameLanguage').then((lang) =>{
    if(lang.toString().contains('es')) {
      flag = "assets/images/spanish_flag.png"
    }
    else {
      flag =  "assets/images/us_flag.png"
  }
  });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Consumer<HomeProvider>(builder: (context, provider, _)
    {
      return Row(
        children: [
          widget.isLang
              ? Expanded(
            child: CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const LanguageSelectionPage(
                            changeType: 'game')));
              },
              child: Column(
                children: [
                  CustomImageButton(
                      image: provider.getFlag()),
                  SizedBox(height: 5),
                  Label(
                      text: "Idioma/Language",
                      fontSize: FontSize.p4,
                      color: AllColors.superLitePurple)
                ],
              ),
            ),
          )
              : const Expanded(child: SizedBox()),
          widget.isBack
              ? Expanded(
            child: CupertinoButton(
              onPressed: () {
                Nav.pop(context);
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => Dashboard()));
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  const SizedBox(
                      height: 50,
                      child: Icon(
                          CupertinoIcons.arrowshape_turn_up_left_fill,
                          color: Colors.white,
                          size: 34)),
                  const SizedBox(height: 5),
                  Label(
                      text: AppLocalizations.of(context)!.back,
                      fontSize: FontSize.p4,
                      color: AllColors.superLitePurple)
                ],
              ),
            ),
          )
              : const Expanded(child: SizedBox()),
          Expanded(
            child: widget.isLevel
                ? CupertinoButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LevelPage()));
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  const CustomImageButton(
                      image: "assets/images/hash.png"),
                  const SizedBox(height: 5),
                  Label(
                      text: AppLocalizations.of(context)!.level,
                      fontSize: FontSize.p4,
                      color: AllColors.superLitePurple)
                ],
              ),
            )
                : gap(0),
          )
        ],
      );
    }
    ),
    );
  }

  }

