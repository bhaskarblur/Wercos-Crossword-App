import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/backend/user_data/model/user/user.dart';
import 'package:mobile_app_word_search/backend/user_data/user_func.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/views/dashboard.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
  with TickerProviderStateMixin {
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

    super.initState();
    gotoDashboard();
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
            Image.asset('assets/images/splash_screen_logo.png', height: 250, width: 250,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LinearProgressIndicator(
                color: AllColors.shineGreen,

                value: controller.value,
                minHeight: 20,


              ),
            ),


          ],
        ),


      ),
    );
  }
  Future<void> gotoDashboard() async {

    User? user= await UserFunc().getUser();
    if(user!=null){

      Future.delayed(Duration(milliseconds: 2250)).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard2()));
      });
    }

  }
}

