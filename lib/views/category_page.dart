import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/api_services.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/providers/category_provider.dart';
import 'package:mobile_app_word_search/providers/game_screen_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/word_related_page.dart';
import 'package:mobile_app_word_search/widget/sahared_prefs.dart';
import 'package:mobile_app_word_search/widget/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/custom_dialogs.dart';
import '../providers/home_provider.dart';
import '../widget/navigator.dart';

class CategoryPage extends StatefulWidget {
  final String? type;
  const CategoryPage({Key? key, this.type}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final ApiServices _apiServices = ApiServices();

  @override
  void initState() {
    getData();

    super.initState();
  }

  late final String subStatus;
  getData() {
    final provider = Provider.of<CategoryProvider>(context, listen: false);

    Prefs.getPrefs('subStatus').then((value) => {
      subStatus = value!
    });
    Prefs.getPrefs('loginId').then((loginId) {
      Prefs.getPrefs('gameLanguage').then((language) {
        _apiServices.post(
            context: context,
            endpoint: 'getcatstopics',
            body: {"language": language, "userId": loginId,
              "searchtype": widget.type == 'search' ? 'search' : 'challenge'})
            .then((value) {
          print(widget.type);
          print(value);
          provider.changeCategories(value['categoriesTopics']);
        });
      });
    });
  }

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
                  child: CustomAppBar(isBack: true, isLang: true)),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Consumer<CategoryProvider>(builder: (context, provider, _) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Label(
                            text: AppLocalizations.of(context)!
                                .categories
                                .toUpperCase(),
                            fontWeight: FontWeight.bold,
                            fontSize: FontSize.h5),
                        const SizedBox(height: 20),
                        if (provider.categories != null)
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.categories.length,
                            separatorBuilder: (context, index) {
                              return gap(20);
                            },
                            itemBuilder: (context, index) {
                              bool isCategoryVisible = false;
                              return StatefulBuilder(builder: (context, st) {
                                return Column(
                                  children: [
                                    ShadowButton(
                                        onPressed: () {
                                          st(() {
                                            isCategoryVisible = !isCategoryVisible;
                                          });
                                        },
                                        title: provider.categories[index]
                                        ['categoryName'],
                                        fillColors: const [
                                          AllColors.semiLiteGreen,
                                          AllColors.shineGreen
                                        ]),
                                    if (isCategoryVisible)
                                      ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                          const NeverScrollableScrollPhysics(),
                                          itemCount: provider
                                              .categories[index]['topicsList'].length,
                                          separatorBuilder: (context, i) {
                                            return gap(0);
                                          },
                                          itemBuilder: (context, i) {
                                            return TopicButton(
                                                onPressed: () {
                                                  if (provider.categories[index]
                                                  ['topicsList'][i]
                                                  ['status'] ==
                                                      'locked' && subStatus.toString().contains('none')) {
                                                    CustomDialog.showPurchaseDialog(
                                                        context: context);
                                                  } else {
                                                    final provider =
                                                    Provider.of<CategoryProvider>(
                                                        context,
                                                        listen: false);
                                                    final gamePvider = Provider.of<
                                                        GameScreenProvider>(
                                                        context,
                                                        listen: false);

                                                    if (widget.type == 'search') {
                                                      gamePvider.changeGameType(
                                                          'searchbycategory');
                                                      provider.changeSelectedCategory(
                                                          provider.categories[index]
                                                          ['topicsList'][i]);
                                                      Nav.pop(context);
                                                      final hprovider =
                                                      Provider.of<HomeProvider>(
                                                          context,
                                                          listen: false);
                                                      hprovider
                                                          .changeSelectedIndex(4);
                                                    } else {

                                                      Prefs.getToken().then((token) {
                                                        Prefs.getPrefs('loginId').then((loginId) {
                                                          Prefs.getPrefs('wordLimit').then((wordLimit) {
                                                            Prefs.getPrefs('gameLanguage').then((language) {
                                                              print(provider.categories[index]['categoryName']);
                                                              print(provider.categories[index]
                                                              ['topicsList'][i]['topicsname']);
                                                              _apiServices
                                                                  .post(context: context, endpoint: 'topicwise_crossword', body: {
                                                                "language": language,
                                                                "userId": loginId,
                                                                "words_limit": wordLimit,
                                                                'type':'challenge',
                                                                "accessToken": token,
                                                                "category" : provider.categories[index]['categoryName'],
                                                                "topic": provider.categories[index]
                                                                ['topicsList'][i]['topicsname'],
                                                              }).then((value) {

                                                                // print('here');
                                                                // print(value);
                                                                if (value['gameDetails'] != null) {
                                                                  gamePvider.changeGameType(
                                                                      'challengebycategory');
                                                                  provider.changeSelectedCategory(
                                                                      provider.categories[index]
                                                                      ['topicsList'][i]);
                                                                  print(provider
                                                                      .categories[
                                                                  index][
                                                                  'topicsList'][i]);
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              WordRelatedPage(
                                                                                  data: value)));
                                                                }
                                                                else {
                                                                  if(value['message'].toString().contains('Cannot play more')) {
                                                                    CustomDialog.showGamesFinishedDialog(
                                                                        context: context);
                                                                  }
                                                                  else {
                                                                    CustomDialog.noGameAvailable(
                                                                        context: context);
                                                                  }
                                                                }

                                                              });

                                                            });
                                                          });
                                                        });
                                                      });

                                                    };
                                                  }
                                                },
                                                lock: provider.categories[index]
                                                ['topicsList'][i]['status'],
                                                subStatus: subStatus,
                                                topicName: provider.categories[index]
                                                ['topicsList'][i]['topicsname']);
                                          }),
                                  ],
                                );
                              });
                            },
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ))),
    ):
    Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(70),
            child: CustomAppBar(isBack: true, isLang: true)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Consumer<CategoryProvider>(builder: (context, provider, _) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Label(
                      text: AppLocalizations.of(context)!
                          .categories
                          .toUpperCase(),
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.h5),
                  const SizedBox(height: 20),
                  if (provider.categories != null)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.categories.length,
                      separatorBuilder: (context, index) {
                        return gap(20);
                      },
                      itemBuilder: (context, index) {
                        bool isCategoryVisible = false;
                        return StatefulBuilder(builder: (context, st) {
                          return Column(
                            children: [
                              ShadowButton(
                                  onPressed: () {
                                    st(() {
                                      isCategoryVisible = !isCategoryVisible;
                                    });
                                  },
                                  title: provider.categories[index]
                                      ['categoryName'],
                                  fillColors: const [
                                    AllColors.semiLiteGreen,
                                    AllColors.shineGreen
                                  ]),
                              if (isCategoryVisible)
                                ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: provider
                                        .categories[index]['topicsList'].length,
                                    separatorBuilder: (context, i) {
                                      return gap(0);
                                    },
                                    itemBuilder: (context, i) {
                                      return TopicButton(
                                          onPressed: () {
                                            if (provider.categories[index]
                                                        ['topicsList'][i]
                                                    ['status'] ==
                                                'locked' && subStatus.toString().contains('none')) {
                                              CustomDialog.showPurchaseDialog(
                                                  context: context);
                                            } else {
                                              final provider =
                                                  Provider.of<CategoryProvider>(
                                                      context,
                                                      listen: false);
                                              final gamePvider = Provider.of<
                                                      GameScreenProvider>(
                                                  context,
                                                  listen: false);

                                              if (widget.type == 'search') {
                                                gamePvider.changeGameType(
                                                    'searchbycategory');
                                                provider.changeSelectedCategory(
                                                    provider.categories[index]
                                                        ['topicsList'][i]);
                                                Nav.pop(context);
                                                final hprovider =
                                                    Provider.of<HomeProvider>(
                                                        context,
                                                        listen: false);
                                                hprovider
                                                    .changeSelectedIndex(4);
                                              } else {

                                                Prefs.getToken().then((token) {
    Prefs.getPrefs('loginId').then((loginId) {
    Prefs.getPrefs('wordLimit').then((wordLimit) {
    Prefs.getPrefs('gameLanguage').then((language) {
      print(provider.categories[index]['categoryName']);
      print(provider.categories[index]
      ['topicsList'][i]['topicsname']);
    _apiServices
        .post(context: context, endpoint: 'topicwise_crossword', body: {
    "language": language,
    "userId": loginId,
    "words_limit": wordLimit,
    'type':'challenge',
    "accessToken": token,
    "category" : provider.categories[index]['categoryName'],
    "topic": provider.categories[index]
    ['topicsList'][i]['topicsname'],
    }).then((value) {

      // print('here');
      // print(value);
    if (value['gameDetails'] != null) {
      gamePvider.changeGameType(
          'challengebycategory');
      provider.changeSelectedCategory(
          provider.categories[index]
          ['topicsList'][i]);
      print(provider
          .categories[
      index][
      'topicsList'][i]);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  WordRelatedPage(
                      data: value)));
    }
    else {
    if(value['message'].toString().contains('Cannot play more')) {
    CustomDialog.showGamesFinishedDialog(
    context: context);
    }
    else {
    CustomDialog.noGameAvailable(
    context: context);
    }
    }
    
    });

    });
    });
    });
                                                });

                                              };
                                            }
                                          },
                                          lock: provider.categories[index]
                                          ['topicsList'][i]['status'],
                                          subStatus: subStatus,
                                          topicName: provider.categories[index]
                                              ['topicsList'][i]['topicsname']);
                                    }),
                            ],
                          );
                        });
                      },
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class TopicButton extends StatelessWidget {
  const TopicButton({
    super.key,
    required this.onPressed,
    required this.topicName,
    required this.lock,
    required this.subStatus
  });

  final VoidCallback onPressed;
  final String topicName;
  final String lock;
  final String subStatus;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      minSize: 0,
      child: Container(
        height: 55,
        margin: const EdgeInsets.only(top: 12),
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: AllColors.liteDarkPurple,
            borderRadius: BorderRadius.circular(50)),
        child: Center(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (lock == "locked" && subStatus.toString().contains('none'))
              const Icon(CupertinoIcons.lock_fill,
                  color: AllColors.liteGreen, size: 20),
            if (lock == 'locked' && subStatus.toString().contains('none')) horGap(10),
            Label(
              text: topicName,
              fontSize: FontSize.p2,
            ),
          ],
        )),
      ),
    );
  }
}
