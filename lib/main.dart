import 'package:werkos/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:werkos/providers/category_provider.dart';
import 'package:werkos/providers/home_provider.dart';
import 'package:werkos/providers/language_provider.dart';
import 'package:werkos/providers/leaderboard_provider.dart';
import 'package:werkos/providers/timer_provider.dart';
import 'package:werkos/views/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:werkos/providers/leaderboard_provider.dart';
import 'dart:io' show Platform;
import 'l10n/l10n.dart';
import 'providers/game_screen_provider.dart';
import 'providers/games_provider.dart';
import 'providers/profile_provider.dart';
import 'widget/sahared_prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  Prefs.getToken().then((value) {
    debugPrint('token: $value');
  });

  Prefs.getPrefs('loginId').then((value) {
    debugPrint('loginId: $value');

  });

  Prefs.getPrefs('wordLimit').then((value) {
    if (value == null) {
      Prefs.setPrefs('wordLimit', '6');
    }
  });


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => GamesProvider()),
        ChangeNotifierProvider(create: (_) => LeaderBoardProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => GameScreenProvider()),
        ChangeNotifierProvider(create: (_) => TimerProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageProvider>(context);
    return MaterialApp(
      title: 'Werkos',
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: child!);
      },
      theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true),
      locale: provider.locale,
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const SplashScreen(),
    );
  }
}