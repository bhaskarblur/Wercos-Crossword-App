import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/api_services.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:mobile_app_word_search/views/subscription_page.dart';
import 'package:provider/provider.dart';

import '../providers/profile_provider.dart';
import '../widget/sahared_prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  final ApiServices _apiServices = ApiServices();

  final TextEditingController _userName = TextEditingController();

  bool change = false;

  @override
  void initState() {
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        _apiServices.post(
            context: context,
            endpoint: 'getUserInfo',
            body: {"accessToken": token, "userId": loginId}).then((value) {
          final provider = Provider.of<ProfileProvider>(context, listen: false);
          provider.chnageProfile(value);
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Consumer<ProfileProvider>(builder: (context, provider, _) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: const PreferredSize(
                preferredSize: Size.fromHeight(70),
                child: CustomAppBar(isBack: true, isLang: true)),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Center(
                          child: Label(
                              text: "MY ACCOUNT",
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.p2)),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          const Label(
                              text: "Username: ",
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.p2),
                          change
                              ? Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.4,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(color: Colors.white)),
                                  child: TextField(
                                    controller: _userName,
                                    cursorColor: Colors.white,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      suffixIcon: InkWell(
                                          onTap: () {
                                            _userName.clear();
                                            setState(() {
                                              change = false;
                                            });
                                          },
                                          child: const Icon(Icons.close,
                                              color: Colors.white)),
                                      // contentPadding:
                                      //     const EdgeInsets.symmetric(
                                      //         horizontal: 10)
                                    ),
                                  ))
                              : Label(
                                  text: provider.profile['username'].toString(),
                                  fontSize: FontSize.p2),
                          const Spacer(),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            minSize: 0,
                            onPressed: () {
                              if (!change) {
                                setState(() {
                                  change = true;
                                });
                              } else {
                                Prefs.getToken().then((token) {
                                  Prefs.getPrefs('loginId').then((loginId) {
                                    _apiServices.post(
                                        context: context,
                                        endpoint: 'changeUserName',
                                        body: {
                                          "accessToken": token,
                                          "userId": loginId,
                                          "userName": _userName.text
                                        }).then((value) {
                                      setState(() {
                                        change = false;
                                      });
                                      _apiServices.post(
                                          context: context,
                                          endpoint: 'getUserInfo',
                                          body: {
                                            "accessToken": token,
                                            "userId": loginId
                                          }).then((value) {
                                        final provider =
                                            Provider.of<ProfileProvider>(
                                                context,
                                                listen: false);
                                        provider.chnageProfile(value);
                                      });
                                    });
                                  });
                                });
                              }
                            },
                            child: Label(
                                text: change ? "Save" : "Change",
                                fontSize: FontSize.p2,
                                color: AllColors.superLightGreen),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Label(
                              text: "Current plan:",
                              fontWeight: FontWeight.bold,
                              fontSize: FontSize.p2),
                          Label(
                              text: provider.profile['subscriptionstatus'] ==
                                      'none'
                                  ? ' Free'
                                  : ' Premium',
                              fontSize: FontSize.p2),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Label(
                          text:
                              "Remaining games of day: ${provider.profile['gamesleft']}/50",
                          fontSize: FontSize.p2),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ShadowButton(
                      fillColors: const [
                        AllColors.semiLiteGreen,
                        AllColors.shineGreen
                      ],
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SubscriptionPage()));
                      },
                      title: 'UPGRADE'),
                )
              ],
            ),
          );
        }));
  }
}
