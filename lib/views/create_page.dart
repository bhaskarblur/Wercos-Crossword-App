import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/views/create_word_page.dart';
import 'package:mobile_app_word_search/components/custom_dialogs.dart';

import '../components/labels.dart';
import '../utils/font_size.dart';

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
          body: Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Label(
                    text: 'CREATE',
                    fontSize: FontSize.p2,
                    fontWeight: FontWeight.bold),
                const SizedBox(height: 20),
                CupertinoButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateWordPage()));
                  },
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: double.maxFinite,
                    height: 55,
                    decoration: BoxDecoration(
                        color: AllColors.liteDarkPurple,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Center(
                        child:
                            Label(text: 'WORD SEARCH', fontSize: FontSize.p2)),
                  ),
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  onPressed: () {
                    CustomDialog().showPurchaseDialog(context: context);
                  },
                  padding: EdgeInsets.zero,
                  minSize: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.only(right: 30, left: 60),
                    width: double.maxFinite,
                    height: 55,
                    decoration: BoxDecoration(
                        color: AllColors.liteDarkPurple,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: SizedBox()),
                        Label(text: 'CHALLENGE', fontSize: FontSize.p2),
                        Expanded(child: SizedBox()),
                        Icon(CupertinoIcons.lock_fill,
                            color: AllColors.liteGreen, size: 28),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
