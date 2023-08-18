import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobile_app_word_search/providers/category_provider.dart';
import 'package:mobile_app_word_search/providers/home_provider.dart';
import 'package:mobile_app_word_search/providers/language_provider.dart';
import 'package:mobile_app_word_search/providers/leaderboard_provider.dart';
import 'package:mobile_app_word_search/providers/timer_provider.dart';
import 'package:mobile_app_word_search/views/splash_screen.dart';
import 'package:provider/provider.dart';

import 'l10n/l10n.dart';
import 'providers/game_screen_provider.dart';
import 'providers/games_provider.dart';
import 'providers/profile_provider.dart';
import 'widget/sahared_prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

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
      title: 'Flutter Demo',
      builder: (context, child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: child!);
      },
      theme: ThemeData(
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
// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: GridDemo(),
//     );
//   }
// }

// class GridDemo extends StatefulWidget {
//   @override
//   _GridDemoState createState() => _GridDemoState();
// }

// class _GridDemoState extends State<GridDemo> {
//   List<Color> gridColors = List.generate(100, (index) => Colors.grey);
//   Color selectedColor = Colors.blue;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Drag and Mark GridView'),
//       ),
//       body: Column(
//         children: [
//           GridView.builder(
//             shrinkWrap: true,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 10,
//             ),
//             itemCount: gridColors.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onPanUpdate: (details) {
//                   setState(() {
//                     if (details.localPosition.dx >= 0 &&
//                         details.localPosition.dx <=
//                             MediaQuery.of(context).size.width &&
//                         details.localPosition.dy >= 0 &&
//                         details.localPosition.dy <=
//                             MediaQuery.of(context).size.height) {
//                       final gridIndex =
//                           (details.localPosition.dy ~/ 50) * 10 +
//                               (details.localPosition.dx ~/ 50);
//                       if (gridIndex >= 0 && gridIndex < gridColors.length) {
//                         gridColors[gridIndex] = selectedColor;
//                       }
//                     }
//                   });
//                 },
//                 child: Container(
//                   color: gridColors[index],
//                   child: Center(
//                     child: Text('$index'),
//                   ),
//                 ),
//               );
//             },
//           ),
//           Container(
//             margin: EdgeInsets.symmetric(vertical: 20),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ColorButton(Colors.red, selectedColor, setSelectedColor),
//                 ColorButton(Colors.green, selectedColor, setSelectedColor),
//                 ColorButton(Colors.blue, selectedColor, setSelectedColor),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void setSelectedColor(Color color) {
//     setState(() {
//       selectedColor = color;
//     });
//   }
// }

// class ColorButton extends StatelessWidget {
//   final Color color;
//   final Color selectedColor;
//   final Function(Color) onPressed;

//   ColorButton(this.color, this.selectedColor, this.onPressed);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         onPressed(color);
//       },
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: color,
//           border: Border.all(
//             color: color == selectedColor ? Colors.black : Colors.transparent,
//             width: 2,
//           ),
//         ),
//       ),
//     );
//   }
// }