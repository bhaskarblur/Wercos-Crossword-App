import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crossword_flutter/api_services.dart';
import 'package:crossword_flutter/providers/game_screen_provider.dart';
import 'package:crossword_flutter/providers/profile_provider.dart';
import 'package:crossword_flutter/utils/all_colors.dart';
import 'package:crossword_flutter/views/tab_screen.dart';
import 'package:provider/provider.dart';

import '../l10n/l10n.dart';
import '../providers/language_provider.dart';
import '../widget/sahared_prefs.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final ApiServices _apiServices = ApiServices();

  late AnimationController controller;

  @override
  void initState() {
    localization();
    final provider = Provider.of<GameScreenProvider>(context, listen: false);
    provider.changeGameType('random');

    gotoDashboard();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(max: 1);
    controller.forward();

    super.initState();
  }

  localization() {
    Prefs.getPrefs('gameLanguage').then((value) {
      final provider = Provider.of<LanguageProvider>(context, listen: false);
      if (value == null) {
        Prefs.setPrefs('gameLanguage', 'en');
        provider.setLocale(L10n.all.first);
      } else {
        if (value == 'en') {
          provider.setGameLFocale(L10n.all.first);
        }
        if (value == 'es') {
          provider.setGameLFocale(L10n.all.last);
        }
      }
    });

    Prefs.getPrefs('language').then((value) {
      final provider = Provider.of<LanguageProvider>(context, listen: false);
      if (value == null) {
        Prefs.setPrefs('language', 'en');
        provider.setLocale(L10n.all.first);
      } else {
        if (value == 'en') {
          provider.setLocale(L10n.all.first);
        }
        if (value == 'es') {
          provider.setLocale(L10n.all.last);
        }
      }
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
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/splash_screen_logo.png',
                      height: 250, width: 250),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: LinearProgressIndicator(
                          color: AllColors.shineGreen,
                          value: controller.value,
                          minHeight: 20)),
                ],
              ),
            ),
          ))),
    ) :
    Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splash_screen_logo.png',
                height: 250, width: 250),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(
                    color: AllColors.shineGreen,
                    value: controller.value,
                    minHeight: 20)),
          ],
        ),
      ),
    );
  }

  Future<void> gotoDashboard() async {
    Prefs.getToken().then((token) {
      if (token == null) {
        _apiServices
            .get(context: context, endpoint: 'getUserName', progressBar: false)
            .then((value) {
          Prefs.setPrefs('token', value['accesstoken']);
          Prefs.setPrefs('loginId', value['id'].toString());
          Prefs.setPrefs('userName', value['username']);
          getProfile();
        });
      } else {
        getProfile();
      }
    });
  }

  getProfile() {
    Prefs.getToken().then((token) {
      Prefs.getPrefs('loginId').then((loginId) {
        _apiServices
            .post(
                context: context,
                endpoint: 'getUserInfo',
                body: {"accessToken": token, "userId": loginId},
                progressBar: false)
            .then((value) {
          final provider = Provider.of<ProfileProvider>(context, listen: false);
          provider.chnageProfile(value);
          Prefs.setPrefs('subStatus', value['subscriptionstatus']);
          gotoTab();
        });
      });
    });
  }

  gotoTab() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const TabScreen()));
  }
}
