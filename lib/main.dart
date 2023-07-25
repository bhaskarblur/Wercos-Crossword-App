import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/providers/leaderboard_provider.dart';
import 'package:mobile_app_word_search/views/splash_screen.dart';
import 'package:provider/provider.dart';

import 'providers/games_provider.dart';
import 'providers/profile_provider.dart';
import 'widget/sahared_prefs.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Prefs.getToken().then((value) {
    debugPrint('token: $value');
  });

  Prefs.getPrefs('loginId').then((value) {
    debugPrint('loginId: $value');
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => GamesProvider()),
        ChangeNotifierProvider(create: (_) => LeaderBoardProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
