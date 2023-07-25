import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/api_services.dart';
import 'package:mobile_app_word_search/providers/profile_provider.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/views/dashboard.dart';
import 'package:provider/provider.dart';

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
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(max: 1);
    controller.forward();
    gotoDashboard();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Dashboard2()));
    });

    Prefs.getToken().then((token) {
      if (token == null) {
        _apiServices
            .get(context: context, endpoint: 'getUserName', progressBar: false)
            .then((value) {
          Prefs.setPrefs('token', value['accesstoken']);
          Prefs.setPrefs('loginId', value['id'].toString());
          Prefs.setPrefs('userName', value['username']);
        });
      } else {
        Prefs.getPrefs('loginId').then((loginId) {
          _apiServices
              .post(
                  context: context,
                  endpoint: 'getUserInfo',
                  body: {"accessToken": token, "userId": loginId},
                  progressBar: false)
              .then((value) {
            final provider =
                Provider.of<ProfileProvider>(context, listen: false);
            provider.chnageProfile(value);
          });
        });
      }
    });
  }
}
