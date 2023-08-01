import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/providers/home_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_app_word_search/widget/navigator.dart';
import 'package:provider/provider.dart';

import '../providers/game_screen_provider.dart';

class WordRelatedPage extends StatelessWidget {
  final dynamic data;
  const WordRelatedPage({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.alertGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomAppBar(
              isBack: true,
              isLang: true,
            )),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                const SizedBox(height: 100),
                 Label(
                    text: '${AppLocalizations.of(context)!.only_mark_the_words_related_to}:',
                    align: TextAlign.center,
                    fontSize: FontSize.h3,
                    fontWeight: FontWeight.w500),
                const SizedBox(height: 80),
                Label(
                    text: data['topicsname'],
                    align: TextAlign.center,
                    fontSize: FontSize.h4,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 120),
                ShadowButton(
                    onPressed: () {
                      final gameScreenProvider =
                          Provider.of<GameScreenProvider>(context,
                              listen: false);
                      gameScreenProvider.changeGameType('category');

                      Nav.pop(context);
                      Nav.pop(context);
                      final provider =
                          Provider.of<HomeProvider>(context, listen: false);
                      provider.changeSelectedIndex(4);
                      // Nav.pushAndRemoveAll(context, TabScreen());
                    },
                    title: AppLocalizations.of(context)!.continuee,
                    fillColors: const [AllColors.liteOrange, AllColors.orange])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
