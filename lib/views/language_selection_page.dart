import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkos/components/labels.dart';
import 'package:werkos/providers/home_provider.dart';
import 'package:werkos/providers/language_provider.dart';
import 'package:werkos/utils/custom_app_bar.dart';
import 'package:werkos/utils/font_size.dart';
import 'package:werkos/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';

import '../utils/all_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelectionPage extends StatefulWidget {
  final String changeType;
  const LanguageSelectionPage({Key? key, required this.changeType})
      : super(key: key);

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return kIsWeb ?
    Scaffold(
      backgroundColor: AllColors.purple_2,
      body:  Center(
          child:
          SizedBox(width: 400 ,child:
          Container(
            decoration: const BoxDecoration(gradient: AllColors.bg),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(70),
                  child: CustomAppBar(isBack: true, isLang: false)),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: widget.changeType == 'app'
                    ? FutureBuilder(
                    future: Prefs.getPrefs('language'),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          Label(
                              text: AppLocalizations.of(context)!
                                  .select_language
                                  .toUpperCase(),
                              fontSize: FontSize.p2,
                              fontWeight: FontWeight.bold),
                          const SizedBox(height: 16),
                          languageCard(
                              image: 'assets/images/us_flag.png',
                              langName: 'ENGLISH',
                              selected: snapshot.data == 'en' ? true : false),
                          languageCard(
                              image: 'assets/images/spanish_flag.png',
                              langName: 'ESPAÑOL',
                              selected: snapshot.data == 'es' ? true : false)
                        ],
                      );
                    })
                    : FutureBuilder(
                    future: Prefs.getPrefs('gameLanguage'),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          Label(
                              text: AppLocalizations.of(context)!
                                  .select_language
                                  .toUpperCase(),
                              fontSize: FontSize.p2,
                              fontWeight: FontWeight.bold),
                          const SizedBox(height: 16),
                          languageCard(
                              image: 'assets/images/us_flag.png',
                              langName: 'ENGLISH',
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
          ))),
    ) :
    Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomAppBar(isBack: true, isLang: false)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: widget.changeType == 'app'
              ? FutureBuilder(
                  future: Prefs.getPrefs('language'),
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Label(
                            text: AppLocalizations.of(context)!
                                .select_language
                                .toUpperCase(),
                            fontSize: FontSize.p2,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 16),
                        languageCard(
                            image: 'assets/images/us_flag.png',
                            langName: 'ENGLISH',
                            selected: snapshot.data == 'en' ? true : false),
                        languageCard(
                            image: 'assets/images/spanish_flag.png',
                            langName: 'ESPAÑOL',
                            selected: snapshot.data == 'es' ? true : false)
                      ],
                    );
                  })
              : FutureBuilder(
                  future: Prefs.getPrefs('gameLanguage'),
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Label(
                            text: AppLocalizations.of(context)!
                                .select_language
                                .toUpperCase(),
                            fontSize: FontSize.p2,
                            fontWeight: FontWeight.bold),
                        const SizedBox(height: 16),
                        languageCard(
                            image: 'assets/images/us_flag.png',
                            langName: 'ENGLISH',
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
        if (widget.changeType == 'app') {
          if (langName == 'ENGLISH') {
            Prefs.setPrefs('language', 'en');
            provider.setLocale(const Locale('en'));
          }
          if (langName == 'ESPAÑOL') {
            Prefs.setPrefs('language', 'es');
            provider.setLocale(const Locale('es'));
          }
        } else {
          final provider = Provider.of<HomeProvider>(context, listen: false);
          if (langName == 'ENGLISH') {
            Prefs.setPrefs('gameLanguage', 'en');
            provider.changeFlag("assets/images/us_flag.png");
          }
          if (langName == 'ESPAÑOL') {
            Prefs.setPrefs('gameLanguage', 'es');
            provider.changeFlag("assets/images/spanish_flag.png");
          }
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
