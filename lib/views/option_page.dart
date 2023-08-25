import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/providers/home_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/language_selection_page.dart';
import 'package:mobile_app_word_search/views/level_page.dart';
import 'package:mobile_app_word_search/views/my_account_page.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class OptionPage extends StatelessWidget {
 const OptionPage({Key? key}) : super(key: key);

  get isEnglish => true;


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
  Label(
  text: AppLocalizations.of(context)!.options.toUpperCase(),
  fontSize: FontSize.p1,
  fontWeight: FontWeight.bold),
  const SizedBox(height: 14),
  CupertinoButton(
  onPressed: () {
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => const LanguageSelectionPage(
  changeType: 'app')));
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
  child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children:[

  Label(
  text: AppLocalizations.of(context)!.select_language.toUpperCase(),
  fontSize: FontSize.p2),
  const SizedBox(width: 10),


  Image.asset('assets/images/us_flag.png',
  height: 45, width: 45) ,
    const SizedBox(width: 5),
  Image.asset('assets/images/spanish_flag.png',
  height: 45, width: 45)
  ],
  )),
  ),
  const SizedBox(height: 20),

  OptionItem(
  optionName: AppLocalizations.of(context)!.level.toUpperCase(),
  onPressed: () {
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => const LevelPage()));
  },
  ),
  OptionItem(
  optionName:
  AppLocalizations.of(context)!.my_games.toUpperCase(),
  onPressed: () {
  final provider =
  Provider.of<HomeProvider>(context, listen: false);
  provider.changeSelectedIndex(2);
  },
  ),
  OptionItem(
  optionName: AppLocalizations.of(context)!.play.toUpperCase(),
  onPressed: () {
  final provider =
  Provider.of<HomeProvider>(context, listen: false);
  provider.changeSelectedIndex(1);
  },
  ),
  OptionItem(
  optionName:
  AppLocalizations.of(context)!.my_account.toUpperCase(),
  onPressed: () {
  Navigator.push(
  context,
  MaterialPageRoute(
  builder: (context) => const MyAccountPage()));
  },
  ),
  ],
  ),
  ),
  ));
  }


  }

class OptionItem extends StatelessWidget {
  const OptionItem({
    super.key,
    required this.optionName,
    required this.onPressed,
  });

  final String optionName;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minSize: 0,
      child: Container(
        margin: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
        width: double.maxFinite,
        height: 55,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)),
        child: Center(
          child: Label(
            text: optionName,
            fontSize: FontSize.p2,
          ),
        ),
      ),
    );
  }
}
