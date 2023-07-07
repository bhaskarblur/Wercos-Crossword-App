import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/views/category_page.dart';
import 'package:mobile_app_word_search/views/create_page.dart';
import 'package:mobile_app_word_search/views/create_word_page.dart';
import 'package:mobile_app_word_search/views/dashboard.dart';

import 'package:mobile_app_word_search/views/language_selection_page.dart';
import 'package:mobile_app_word_search/views/leaderboard_page.dart';
import 'package:mobile_app_word_search/views/level_completion_page.dart';
import 'package:mobile_app_word_search/views/level_page.dart';
import 'package:mobile_app_word_search/views/my_account_page.dart';
import 'package:mobile_app_word_search/views/my_games_page.dart';
import 'package:mobile_app_word_search/views/option_page.dart';

import 'package:mobile_app_word_search/views/play_page.dart';
import 'package:mobile_app_word_search/views/splash_screen.dart';
import 'package:mobile_app_word_search/views/subscription_page.dart';
import 'package:mobile_app_word_search/views/word_related_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  Dashboard(),
    );
  }
}


