import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:crossword_flutter/api_services.dart';
import 'package:crossword_flutter/providers/profile_provider.dart';
import 'package:crossword_flutter/utils/buttons.dart';
import 'package:crossword_flutter/utils/font_size.dart';
import 'package:crossword_flutter/utils/all_colors.dart';
import 'package:crossword_flutter/components/labels.dart';
import 'package:crossword_flutter/utils/custom_app_bar.dart';
import 'package:crossword_flutter/widget/navigator.dart';
import 'package:crossword_flutter/widget/sahared_prefs.dart';
import 'package:crossword_flutter/widget/widgets.dart';
import 'package:provider/provider.dart';
import '../components/custom_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../components/suggestion/model/suggestion.dart';
import '../providers/games_provider.dart';

class CreateWordPage extends StatefulWidget {
  final String type;
  final dynamic gameDetails;
  const CreateWordPage({Key? key, required this.type, this.gameDetails})
      : super(key: key);

  @override
  State<CreateWordPage> createState() => _CreateWordPageState();
}

class _CreateWordPageState extends State<CreateWordPage> {
  final ApiServices _apiServices = ApiServices();
  bool public = true;
  bool fixDynamo = true;

  late String selectedLanguage = '';
  String selectedWordCount = '';

  final TextEditingController _c1 = TextEditingController();
  final TextEditingController _c2 = TextEditingController();

  final List<Word> _list = [];

  @override
  void initState() {
    if (widget.gameDetails != null) {
      getGameWithCode();
    }

    super.initState();

  }

  getGameWithCode() {
    selectedLanguage = AppLocalizations.of(context)!.select_language.toString().toUpperCase();
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        Prefs.getPrefs('wordLimit').then((wordLimit) {
          _apiServices.post(context: context, endpoint: 'getGameByCode', body: {
            "accessToken": token,
            "userId": loginId,
            "sharecode": widget.gameDetails['sharecode'],
          }).then((value) {
            if (value['gameDetails'] != null) {
              if (value['gameDetails']['gametype'] == 'public') {
                public = true;
              } else {
                public = false;
              }
              if(value['gameDetails']['gridtype'] == 'dynamic') {
                fixDynamo = false;
              }
              else {
                fixDynamo = true;
              }

              if (value['gameDetails']['gamelanguage'] == 'en') {
                selectedLanguage = 'ENGLISH';
              } else {
                selectedLanguage = 'ESPAÑOL';
              }
              selectedWordCount =
                  value['gameDetails']['limitedwords'].toString();
              _c1.text = value['gameDetails']['gamename'];
              if (value['gameDetails']['searchtype'] == 'search') {
                value['allWords'].forEach((e) {
                  print(e);
                  _list.add(Word(word: e, correct: true));
                });
              } else {
                value['correctWords'].forEach((e) {
                  _list.add(Word(word: e, correct: true));
                });
                value['incorrectWords'].forEach((e) {
                  _list.add(Word(word: e, correct: false));
                });
              }
              setState(() {});
            } else {
              if (value['message'] != null) {
                dialog(context, value['message'], () {
                  Nav.pop(context);
                });
              }
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  kIsWeb ?
    Scaffold(
      backgroundColor: AllColors.purple_2,
      body:  Center(
          child:
          SizedBox(width: 400 ,child:
          Container(
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
                                text:
                                '${AppLocalizations.of(context)!.create.toUpperCase()}  ${widget.type == 'challenge' ? AppLocalizations.of(context)!.challenge.toUpperCase() : AppLocalizations.of(context)!.word_search.toUpperCase()}',
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
                            CustomDialog.showPurchaseDialog(context: context);
                          } else {
                            setState(() {
                              public = !public;
                            });
                          }
                        }, info: () {
                          CustomDialog.showSuggestionDialog(
                              context: context,
                              suggestions: [
                                Suggestion(
                                    AppLocalizations.of(context)!.what_is_challenge,
                                    AppLocalizations.of(context)!
                                        .what_is_challenge_description),
                              ]);
                        }),
                        gap(16),
                        customSwitch([
                          AppLocalizations.of(context)!.fixed,
                          AppLocalizations.of(context)!.dynam
                        ], value: fixDynamo, onTap: () {
                          final provider =
                          Provider.of<ProfileProvider>(context, listen: false);
                          if (provider.profile['subscriptionstatus'] == 'none') {
                            CustomDialog.showPurchaseDialog(context: context);
                          } else {
                            setState(() {
                              fixDynamo = !fixDynamo;
                              print('what is it!');
                              print(fixDynamo);
                            });
                          }
                        }, info: () {
                          CustomDialog.showSuggestionDialog(
                              context: context,
                              suggestions: [
                                Suggestion(
                                    AppLocalizations.of(context)!.dynamic_word_search,
                                    AppLocalizations.of(context)!
                                        .dynamic_word_search_description),
                              ]);
                        }),
                        if (!fixDynamo && widget.type == 'search') const SizedBox(height: 20),
                        if (!fixDynamo && widget.type == 'search')
                          customDropdown(selectedWordCount!= ''? selectedWordCount : 'Word Count', [
                            for (int i = 0; i < _list.length; i++) (i + 1).toString()
                          ], (value) {
                            setState(() {
                              selectedWordCount = value!;
                            });
                          }, AppLocalizations.of(context)!.wordcount),
                        const SizedBox(height: 20),
                        customDropdown(selectedLanguage != ''? selectedLanguage : AppLocalizations.of(context)!.select_language.toString().toUpperCase(), [
                          AppLocalizations.of(context)!.select_language.toString().toUpperCase(),'ENGLISH', 'ESPAÑOL'],
                                (value) {
                              setState(() {
                                selectedLanguage = value!;
                              });
                            }, "Language/Idioma"),
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
                            if(_c2.text.length>14) {
                              var snackBar = SnackBar(content: Text(
                                  AppLocalizations.of(context)!.wordlimit_
                              )
                                  , backgroundColor: AllColors.liteDarkPurple );

                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            }
                            else {
                              Prefs.getPrefs('subStatus').then((value) => {

                                if(value.toString().contains('1month') ||
                                    value.toString().contains('1year')  ) {
                                  if (_c2.text.isNotEmpty) {
                                    _list.add(
                                        Word(word: _c2.text.toUpperCase(),
                                            correct: true)),
                                    selectedWordCount = _list.length.toString(),
                                    _c2.clear()
                                  }
                                }
                                else {
                                  if(_list.length >= 6) {
                                    if (_c2.text.isNotEmpty) {
                                      FocusScope.of(context).unfocus(),
                                      Future.delayed(const Duration(milliseconds: 200), (){
                                        CustomDialog.showWordsLimit(
                                            context: context);
                                      }),

                                    }
                                  }
                                  else {
                                    if (_c2.text.isNotEmpty) {
                                      _list.add(
                                          Word(word: _c2.text.toUpperCase(),
                                              correct: true)),
                                      selectedWordCount = _list.length.toString(),
                                      _c2.clear()
                                    }
                                  },
                                }
                              });

                            }
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
                              return Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 15),
                                      height: 60,
                                      width: double.maxFinite,
                                      decoration: BoxDecoration(
                                          color: AllColors.liteDarkPurple,
                                          borderRadius: BorderRadius.circular(50)),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Label(
                                              text: _list[index].word!,
                                              fontSize: FontSize.p2),
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
                                    ),
                                  ),
                                  if (widget.type == 'challenge') horGap(10),
                                  if (widget.type == 'challenge')
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            _list[index].correct =
                                            !(_list[index].correct!);
                                          });
                                        },
                                        child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: _list[index].correct!
                                                    ? const Color.fromARGB(
                                                    255, 196, 238, 197)
                                                    : Colors.transparent,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    width: 2,
                                                    color: _list[index].correct!
                                                        ? Colors.transparent
                                                        : Colors.green)),
                                            child: _list[index].correct! ? const Center(
                                                child: Icon(Icons.done,
                                                    color: Colors.green, size: 40)):
                                            Icon(Icons.done,
                                                color: Colors.green, size: 0)) ),
                                ],
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
                          if (_c1.text.isNotEmpty) {
                            if (_list.isNotEmpty) {
                              Prefs.getToken().then((token) {
                                Prefs.getPrefs('loginId').then((loginId) {
                                  Prefs.getPrefs('wordLimit').then((wordLimit) {
                                    List<String> allWords = [];
                                    List<String> correctWords = [];
                                    List<String> incorrectWords = [];

                                    for (var element in _list) {
                                      allWords.add(element.word!.toString());
                                      if (element.correct!) {
                                        correctWords.add(element.word!.toString().trim());
                                      } else {
                                        incorrectWords.add(element.word!.toString().trim());
                                      }
                                    }

                                    _apiServices.post(
                                        context: context,
                                        endpoint: widget.gameDetails != null
                                            ? 'editGame'
                                            : 'createGame',
                                        body: {
                                          "accessToken": token,
                                          "userId": loginId,
                                          "gameName": _c1.text,
                                          "gameLanguage":
                                          selectedLanguage == "ENGLISH"
                                              ? 'en'
                                              : (selectedLanguage == "SPANISH") ? 'es':'en',
                                          "totalWords": _list.length.toString(),
                                          "limitedWords":
                                          widget.type == 'search'
                                              ? selectedWordCount != '' ? selectedWordCount : _list.length.toString()
                                              : _list.length.toString()
                                          // : (!public1 &&
                                          //         selectedWordCount != null)
                                          //     ? selectedLanguage
                                          //     : wordLimit
                                          ,
                                          "allWords": jsonEncode(allWords),



                                          if (widget.type == 'challenge')
                                            "correctWords": jsonEncode(correctWords),
                                          if (widget.type == 'challenge')
                                            "incorrectWords":
                                            jsonEncode(incorrectWords),
                                          if (widget.gameDetails != null)
                                            "gameId": widget.gameDetails['gameid']
                                                .toString(),
                                          "gameType": public ? 'public' : 'private',
                                          "searchType": widget.type == 'challenge'
                                              ? 'challenge'
                                              : "search",
                                        }).then((value) {
                                      getData(false);
                                      if(value['message'].toString().contains('created successfully'))
                                      {
                                        dialog(context,
                                            AppLocalizations.of(context)!.created_success, () {
                                              Nav.pop(context);
                                              Nav.pop(context);

                                            });
                                      }
                                      else if(value['message'].toString().contains('updated successfully'))
                                      {
                                        dialog(context,
                                            AppLocalizations.of(context)!.edited_success, () {
                                              Nav.pop(context);
                                              Nav.pop(context);

                                            });
                                      }
                                      else {
                                        dialog(context,
                                            AppLocalizations.of(context)!.edited_success, () {
                                              // Nav.pop(context);
                                              Nav.pop(context);

                                            });
                                      }

                                    });
                                  });
                                });
                              });
                            } else {
                              dialog(context, AppLocalizations.of(context)!.addword, () {
                                Nav.pop(context);
                              });
                            }
                          } else {
                            dialog(context, 'Enter Name.', () {
                              Nav.pop(context);
                            });
                          }
                        },
                        title: widget.gameDetails != null
                            ? AppLocalizations.of(context)!.save
                            : AppLocalizations.of(context)!.generate)),
                floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked),
          ))),
    ) :
    Container(
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
                          text:
                              '${AppLocalizations.of(context)!.create.toUpperCase()}  ${widget.type == 'challenge' ? AppLocalizations.of(context)!.challenge.toUpperCase() : AppLocalizations.of(context)!.word_search.toUpperCase()}',
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
                      CustomDialog.showPurchaseDialog(context: context);
                    } else {
                      setState(() {
                        public = !public;
                      });
                    }
                  }, info: () {
                    CustomDialog.showSuggestionDialog(
                        context: context,
                        suggestions: [
                          Suggestion(
                              AppLocalizations.of(context)!.what_is_challenge,
                              AppLocalizations.of(context)!
                                  .what_is_challenge_description),
                        ]);
                  }),
                  gap(16),
                  customSwitch([
                    AppLocalizations.of(context)!.fixed,
                    AppLocalizations.of(context)!.dynam
                  ], value: fixDynamo, onTap: () {
                    final provider =
                        Provider.of<ProfileProvider>(context, listen: false);
                    if (provider.profile['subscriptionstatus'] == 'none') {
                      CustomDialog.showPurchaseDialog(context: context);
                    } else {
                      setState(() {
                        fixDynamo = !fixDynamo;
                        print('what is it!');
                        print(fixDynamo);
                      });
                    }
                  }, info: () {
                    CustomDialog.showSuggestionDialog(
                        context: context,
                        suggestions: [
                          Suggestion(
                              AppLocalizations.of(context)!.dynamic_word_search,
                              AppLocalizations.of(context)!
                                  .dynamic_word_search_description),
                        ]);
                  }),
                  if (!fixDynamo && widget.type == 'search') const SizedBox(height: 20),
                  if (!fixDynamo && widget.type == 'search')
                    customDropdown(selectedWordCount!= ''? selectedWordCount : 'Word Count', [
                      for (int i = 0; i < _list.length; i++) (i + 1).toString()
                    ], (value) {
                      setState(() {
                        selectedWordCount = value!;
                      });
                    }, AppLocalizations.of(context)!.wordcount),
                  const SizedBox(height: 20),
                  customDropdown(selectedLanguage != ''? selectedLanguage : AppLocalizations.of(context)!.select_language.toString().toUpperCase(), [
                    AppLocalizations.of(context)!.select_language.toString().toUpperCase(),'ENGLISH', 'ESPAÑOL'],
                      (value) {
                    setState(() {
                      selectedLanguage = value!;
                    });
                  }, "Language/Idioma"),
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
                      if(_c2.text.length>14) {
                        var snackBar = SnackBar(content: Text(
                          AppLocalizations.of(context)!.wordlimit_
                        )
                            , backgroundColor: AllColors.liteDarkPurple );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      }
                      else {
                        Prefs.getPrefs('subStatus').then((value) => {

                          if(_list.length < 18) {


                          if(value.toString().contains('1month') ||
                              value.toString().contains('1year')  ) {
                            if (_c2.text.isNotEmpty) {
                          _list.add(
                              Word(word: _c2.text.toUpperCase(),
                                  correct: true)),
                          selectedWordCount = _list.length.toString(),
                          _c2.clear()
                        }
                          }
                          else
                            {
                              if(_list.length >= 6) {
                                if (_c2.text.isNotEmpty) {
                                  FocusScope.of(context).unfocus(),
                                  Future.delayed(
                                      const Duration(milliseconds: 200), () {
                                    CustomDialog.showWordsLimit(
                                        context: context);
                                  }),

                                }
                              }
                              else
                                {
                                  if (_c2.text.isNotEmpty) {
                                    _list.add(
                                        Word(word: _c2.text.toUpperCase(),
                                            correct: true)),
                                    selectedWordCount = _list.length.toString(),
                                    _c2.clear()
                                  }
                                },
                            }
                          }
                          else {
                            FocusScope.of(context).unfocus(),
                            Future.delayed(
                                const Duration(milliseconds: 200), () {
                              CustomDialog.show18WordsCant(
                                  context: context);
                            }),

                          }
                        });

                      }
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
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 15),
                                height: 60,
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    color: AllColors.liteDarkPurple,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Label(
                                        text: _list[index].word!,
                                        fontSize: FontSize.p2),
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
                              ),
                            ),
                            if (widget.type == 'challenge') horGap(10),
                            if (widget.type == 'challenge')
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _list[index].correct =
                                        !(_list[index].correct!);
                                  });
                                },
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: _list[index].correct!
                                            ? const Color.fromARGB(
                                                255, 196, 238, 197)
                                            : Colors.transparent,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            width: 2,
                                            color: _list[index].correct!
                                                ? Colors.transparent
                                                : Colors.green)),
                                    child: _list[index].correct! ? const Center(
                                        child: Icon(Icons.done,
                                            color: Colors.green, size: 40)):
                        Icon(Icons.done,
                        color: Colors.green, size: 0)) ),
                          ],
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
                    if (_c1.text.isNotEmpty) {
                      if (_list.isNotEmpty) {
                        Prefs.getToken().then((token) {
                          Prefs.getPrefs('loginId').then((loginId) {
                            Prefs.getPrefs('wordLimit').then((wordLimit) {
                              List<String> allWords = [];
                              List<String> correctWords = [];
                              List<String> incorrectWords = [];

                              for (var element in _list) {
                                allWords.add(element.word!.toString());
                                if (element.correct!) {
                                  correctWords.add(element.word!.toString().trim());
                                } else {
                                  incorrectWords.add(element.word!.toString().trim());
                                }
                              }

                              _apiServices.post(
                                  context: context,
                                  endpoint: widget.gameDetails != null
                                      ? 'editGame'
                                      : 'createGame',
                                  body: {
                                    "accessToken": token,
                                    "userId": loginId,
                                    "gameName": _c1.text,
                                    "gameLanguage":
                                        selectedLanguage == "ENGLISH"
                                            ? 'en'
                                            : (selectedLanguage == "SPANISH") ? 'es':'en',
                                    "totalWords": _list.length.toString(),
                                    "limitedWords":
                                        widget.type == 'search'
                                            ? selectedWordCount != '' ? selectedWordCount : _list.length.toString()
                                            : _list.length.toString()
                                    // : (!public1 &&
                                    //         selectedWordCount != null)
                                    //     ? selectedLanguage
                                    //     : wordLimit
                                    ,
                                    "allWords": jsonEncode(allWords),

                                    if (widget.type == 'challenge')
                                      "correctWords": jsonEncode(correctWords),
                                    if (widget.type == 'challenge')
                                      "incorrectWords":
                                          jsonEncode(incorrectWords),
                                    if (widget.gameDetails != null)
                                      "gameId": widget.gameDetails['gameid']
                                          .toString(),
                                    "gameType": public ? 'public' : 'private',
                                    "searchType": widget.type == 'challenge'
                                        ? 'challenge'
                                        : "search",
                                    "gridType" : fixDynamo ? 'fixed' : 'dynamic'
                                  }).then((value) {
                                getData(false);
                                if(value['message'].toString().contains('created successfully'))
                                {
                                  dialog(context,
                                      AppLocalizations.of(context)!.created_success, () {
                                    Nav.pop(context);
                                    Nav.pop(context);

                                  });
                                }
                                else if(value['message'].toString().contains('updated successfully'))
                                {
                                  dialog(context,
                                      AppLocalizations.of(context)!.edited_success, () {
                                        Nav.pop(context);
                                        Nav.pop(context);

                                      });
                                }
                                else {
                                  dialog(context,
                                      AppLocalizations.of(context)!.edited_success, () {
                                        // Nav.pop(context);
                                        Nav.pop(context);

                                      });
                                }

                              });
                            });
                          });
                        });
                      } else {
                        dialog(context, AppLocalizations.of(context)!.addword, () {
                          Nav.pop(context);
                        });
                      }
                    } else {
                      dialog(context, 'Enter Name.', () {
                        Nav.pop(context);
                      });
                    }
                  },
                  title: widget.gameDetails != null
                      ? AppLocalizations.of(context)!.save
                      : AppLocalizations.of(context)!.generate)),
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

  Widget customDropdown(String value, List<String> list,
      void Function(String?)? onChanged, String hint) {
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
            hint: Text(hint,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: FontSize.p3, color: Colors.white)),
            icon: const Icon(CupertinoIcons.arrowtriangle_down_fill,
                color: AllColors.white, size: 20),
            value: value,
            items: list.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white)),
              );
            }).toList(),
            onChanged: onChanged),
      ),
    );
  }

  getData(bool progressBar) {
    final provider = Provider.of<GamesProvider>(context, listen: false);

    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        _apiServices
            .post(
                context: context,
                endpoint: 'getAllUserGames',
                body: {
                  "accessToken": token,
                  "userId": loginId,
                  "type": 'search'
                },
                progressBar: progressBar)
            .then((value) {
          provider.changeSearchGames(value['allGames']);
        });

        _apiServices
            .post(
                context: context,
                endpoint: 'getAllUserGames',
                body: {
                  "accessToken": token,
                  "userId": loginId,
                  "type": 'challenge'
                },
                progressBar: progressBar)
            .then((value) {
          provider.changeChallengeGames(value['allGames']);
        });
      });
    });
  }
}

class Word {
  String? word;
  bool? correct;

  Word({this.word, this.correct});
}
