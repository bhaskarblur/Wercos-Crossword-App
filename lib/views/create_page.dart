import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:werkos/providers/home_provider.dart';
import 'package:werkos/providers/profile_provider.dart';
import 'package:werkos/utils/all_colors.dart';
import 'package:werkos/utils/custom_app_bar.dart';
import 'package:werkos/views/create_word_page.dart';
import 'package:werkos/components/custom_dialogs.dart';
import 'package:werkos/widget/widgets.dart';
import 'package:provider/provider.dart';

import '../components/labels.dart';
import '../providers/game_screen_provider.dart';
import '../providers/timer_provider.dart';
import '../utils/font_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widget/navigator.dart';

class CreatePage extends StatelessWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Consumer<HomeProvider>(builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomAppBar(isBack: provider.prevIndex != 0 ? true : false, isLang: true, backOnPressed: () {
                final timeProvider =
                Provider.of<TimerProvider>(context, listen: false);

                final homeProvider = Provider.of<HomeProvider>(
                    context,
                    listen: false);

                final gameProvider = Provider.of<GameScreenProvider>(
                    context,
                    listen: false);
                print(homeProvider.prevIndex);
                if(homeProvider.prevIndex == 4) {
                  gameProvider.changeGameType('random');
                  gameProvider.reset();
                  timeProvider.stopSeconds();
                  timeProvider.resetSeconds();
                  gameProvider.setGameEnded(false);
                  homeProvider.changeSelectedIndex(4);
                  homeProvider.setSearching(false);
                }
                else {
                  homeProvider.changeSelectedIndex(homeProvider.prevIndex);
                  provider.changePreviousIndex(provider.selectedIndex);
                }
              },)),
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
                        CustomDialog.showChallenge(
                            context: context);
                        
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
        ); }));
  }
}
