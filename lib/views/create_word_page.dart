import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app_word_search/api_services.dart';
import 'package:mobile_app_word_search/providers/profile_provider.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/widget/navigator.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';
import 'package:mobile_app_word_search/widget/widgets.dart';
import 'package:provider/provider.dart';

import '../components/custom_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateWordPage extends StatefulWidget {
  const CreateWordPage({Key? key}) : super(key: key);

  @override
  State<CreateWordPage> createState() => _CreateWordPageState();
}

class _CreateWordPageState extends State<CreateWordPage> {
  final ApiServices _apiServices = ApiServices();

  bool public = true;
  bool public1 = true;

  String? selectedLanguage;

  final TextEditingController _c1 = TextEditingController();
  final TextEditingController _c2 = TextEditingController();

  final List<String> _list = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: const PreferredSize(
              preferredSize: Size.fromHeight(70),
              child: CustomAppBar(isBack: true, isLang: true)),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                      child: Label(
                          text: AppLocalizations.of(context)!
                              .create_word_search
                              .toUpperCase(),
                          fontSize: FontSize.p2,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Label(
                      text: AppLocalizations.of(context)!.publication_mode,
                      fontSize: FontSize.p4,
                      fontWeight: FontWeight.w500),
                  const SizedBox(height: 14),
                  customSwitch([
                    AppLocalizations.of(context)!.public,
                    AppLocalizations.of(context)!.privet
                  ], value: public, onTap: () {
                    final provider =
                        Provider.of<ProfileProvider>(context, listen: false);
                    if (provider.profile['subscriptionstatus'] == 'none') {
                      CustomDialog().showPurchaseDialog(context: context);
                    } else {
                      setState(() {
                        public = !public;
                      });
                    }
                  }, info: () {
                    CustomDialog().showPurchaseDialog(context: context);
                  }),
                  gap(16),
                  customSwitch([
                    AppLocalizations.of(context)!.fixed,
                    AppLocalizations.of(context)!.dynam
                  ], value: public1, onTap: () {
                    final provider =
                        Provider.of<ProfileProvider>(context, listen: false);
                    if (provider.profile['subscriptionstatus'] == 'none') {
                      CustomDialog().showPurchaseDialog(context: context);
                    } else {
                      setState(() {
                        public1 = !public1;
                      });
                    }
                  }, info: () {
                    CustomDialog().showPurchaseDialog(context: context);
                  }),
                  const SizedBox(height: 20),
                  customDropdown(
                    ['English', 'ESPAÑOL'],
                    (value) {
                      setState(() {
                        selectedLanguage = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  customTextField(
                      _c1,
                      AppLocalizations.of(context)!
                          .enter_name_of_the_word_search),
                  const SizedBox(height: 14),
                  customTextField(
                      _c2, AppLocalizations.of(context)!.enter_word),
                  const SizedBox(height: 14),
                  CupertinoButton(
                    onPressed: () {
                      _list.add(_c2.text.toUpperCase());
                      _c2.clear();
                      print(_list.length);
                      setState(() {});
                    },
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    child: Container(
                      width: double.maxFinite,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: AllColors.white)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Label(
                              text: AppLocalizations.of(context)!.add,
                              fontSize: 16,
                              align: TextAlign.center),
                          horGap(5),
                          const Icon(CupertinoIcons.add,
                              color: AllColors.white, size: 18)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  ListView.separated(
                      shrinkWrap: true,
                      itemCount: _list.length,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return gap(10);
                      },
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 15),
                          height: 50,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: AllColors.liteDarkPurple,
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Label(text: _list[index], fontSize: FontSize.p2),
                              CupertinoButton(
                                  onPressed: () {
                                    _list.remove(_list[index]);
                                    setState(() {});
                                  },
                                  padding: EdgeInsets.zero,
                                  minSize: 0,
                                  child: const Icon(Icons.close,
                                      color: AllColors.white)),
                            ],
                          ),
                        );
                      }),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
          floatingActionButton: Padding(
              padding: const EdgeInsets.only(bottom: 25, left: 10, right: 10),
              child: ShadowButton(
                  fillColors: const [
                    AllColors.semiLiteGreen,
                    AllColors.shineGreen
                  ],
                  onPressed: () {
                    if (_c2.text.isNotEmpty) {
                      Prefs.getToken().then((token) {
                        Prefs.getPrefs('loginId').then((loginId) {
                          _apiServices.post(
                              context: context,
                              endpoint: 'createGame',
                              body: {
                                "accessToken": token,
                                "userId": loginId,
                                "gameName": _c1.text,
                                "gameLanguage":
                                    selectedLanguage == "English" ? 'en' : 'es',
                                "totalWords": _list.length.toString(),
                                "limitedWords": "2",
                                "allWords": jsonEncode(_list),
                                // "correctWords": "",
                                // "incorrectWords": "",
                                "gameType": public ? 'public' : 'privet',
                                "searchType": "search",
                              }).then((value) {
                            dialog(context, value['message'], () {
                              Nav.pop(context);
                            });
                          });
                        });
                      });
                    }
                  },
                  title: AppLocalizations.of(context)!.generate)),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked),
    );
  }

  Widget customTextField(TextEditingController controller, String hint) {
    return Stack(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                      color: AllColors.black.withOpacity(0.6),
                      offset: const Offset(0, -1),
                      blurRadius: 0,
                      spreadRadius: -1),
                  const BoxShadow(
                      color: AllColors.litePurple,
                      offset: Offset(1, 1),
                      blurRadius: 10,
                      spreadRadius: 0),
                ]),
            height: 50,
            width: double.maxFinite),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                        color: Colors.white54, fontWeight: FontWeight.w400),
                    border: InputBorder.none)))
      ],
    );
  }

  Widget customDropdown(List<String> list, void Function(String?)? onChanged) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          border: Border.all(color: AllColors.white)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: DropdownButton<String>(
            isExpanded: true,
            alignment: AlignmentDirectional.center,
            underline: gap(0),
            dropdownColor: AllColors.superLitePurple,
            hint: const Text("Language/Idioma",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: FontSize.p4, color: Colors.white)),
            icon: const Icon(CupertinoIcons.arrowtriangle_down_fill,
                color: AllColors.white, size: 20),
            value: selectedLanguage,
            items: list.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: onChanged),
      ),
    );
  }
}
