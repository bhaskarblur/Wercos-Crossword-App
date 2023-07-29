import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/l10n/l10n.dart';
import 'package:mobile_app_word_search/providers/language_provider.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';

import '../utils/all_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomAppBar(isBack: true, isLang: false)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: FutureBuilder(
              future: Prefs.getPrefs('language'),
              builder: (context, snapshot) {
                return Column(
                  children: [
                    const SizedBox(height: 20),
                    const Label(
                        text: "SELECCIONAR IDIOMA",
                        fontSize: FontSize.p2,
                        fontWeight: FontWeight.bold),
                    const SizedBox(height: 16),
                    languageCard(
                        image: 'assets/images/us_flag.png',
                        langName: 'English',
                        selected: snapshot.data == 'en' ? true : false),
                    languageCard(
                        image: 'assets/images/spanish_flag.png',
                        langName: 'ESPAÑOL',
                        selected: snapshot.data == 'es' ? true : false)
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget languageCard({String? image, String? langName, bool? selected}) {
    return CupertinoButton(
      onPressed: () {
        final provider = Provider.of<LanguageProvider>(context, listen: false);
        if (langName == 'English') {
          print(1);
          Prefs.setPrefs('language', 'en');
          provider.setLocale(Locale('en'));
          print(provider.locale.languageCode);
        }
        if (langName == 'ESPAÑOL') {
          print(2);
          Prefs.setPrefs('language', 'es');
          provider.setLocale(Locale('es'));
          print(provider.locale.languageCode);
        }
        setState(() {});
      },
      padding: EdgeInsets.zero,
      minSize: 0,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(image!, height: 35, width: 35),
            Label(text: langName!, fontSize: FontSize.p2),
            selected!
                ? const SizedBox(
                    width: 20,
                    child: Icon(Icons.check, color: AllColors.liteGreen))
                : const SizedBox(width: 20)
          ],
        ),
      ),
    );
  }
}
