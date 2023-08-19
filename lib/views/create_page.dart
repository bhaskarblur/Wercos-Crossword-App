import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app_word_search/providers/profile_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/views/create_word_page.dart';
import 'package:mobile_app_word_search/components/custom_dialogs.dart';
import 'package:mobile_app_word_search/widget/widgets.dart';
import 'package:provider/provider.dart';

import '../components/labels.dart';
import '../utils/font_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/navigator.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomAppBar(isBack: false, isLang: true)),
          body: Column(
            children: [
              const SizedBox(height: 20),
              Label(
                  text: AppLocalizations.of(context)!.create.toUpperCase(),
                  fontSize: FontSize.h4,
                  fontWeight: FontWeight.bold),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateWordPage(type: 'search')));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: double.maxFinite,
                  height: 55,
                  decoration: BoxDecoration(
                      color: AllColors.liteDarkPurple,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                      child: Label(
                          text: AppLocalizations.of(context)!
                              .word_search
                              .toUpperCase(),
                          fontSize: FontSize.p1)),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Consumer<ProfileProvider>(builder: (context, pprovider, _) {
                  return InkWell(
                    onTap: () {
                      if (pprovider.profile['subscriptionstatus'] == 'none') {
                        CustomDialog.showPurchaseDialog(context: context);
                      } else {
                        Nav.push(context, const CreateWordPage(type: 'challenge'));
                        
                      }
                    },
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                              color: AllColors.liteDarkPurple,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Label(
                                text: AppLocalizations.of(context)!
                                    .challenge
                                    .toUpperCase(),
                                fontSize: FontSize.p1),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: 20,
                          child: pprovider.profile['subscriptionstatus'] == 'none'
                              ? const Icon(CupertinoIcons.lock_fill,
                                  color: AllColors.liteGreen, size: 28)
                              : gap(0),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ));
  }
}
