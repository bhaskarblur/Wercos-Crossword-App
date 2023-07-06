import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';


class LevelCompletionPage extends StatelessWidget {
   const LevelCompletionPage({Key? key}) : super(key: key);

  final isCompleted=false;


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AllColors.bg),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Label(
                  text: 'RATE THIS WORD SEARCH',
                  fontSize: FontSize.p2,
                ),
                SizedBox(
                  height: 10,
                ),
                RatingBarIndicator(
                  rating: 5,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: AllColors.superLightGreen,
                  ),
                  itemCount: 5,
                  itemPadding: EdgeInsets.all(4),
                  unratedColor: AllColors.grey,
                  itemSize: 30.0,
                ),
                SizedBox(
                  height: 24,
                ),
               isCompleted?Label(
                 text: 'Game',
                 fontSize: FontSize.h4,
                 fontWeight: FontWeight.bold,
               ): Label(
                  text: 'CONGRATULATIONS!',
                  fontSize: FontSize.h4,
                ),
                SizedBox(
                  height: 4,
                ),
                isCompleted?Label(
                  text: 'NOT COMPLETED',
                  fontSize: FontSize.h4,
                  color: AllColors.liteRed,
                  fontWeight: FontWeight.bold,
                ):Label(
                  text: 'COMPLETED',
                  fontSize: FontSize.h4,
                  color: AllColors.liteGreen,
                  fontWeight: FontWeight.bold,
                ),

                SizedBox(
                  height: 40,
                ),

                Label(text: 'HITS', fontSize: FontSize.p1, fontWeight: FontWeight.w600,),
                SizedBox(
                  height: 10,
                ),
                Label(text: '18 de 18', fontSize: FontSize.p1, fontWeight: FontWeight.w600,),
                SizedBox(
                  height: 40,
                ),
                Label(text: 'TIME', fontSize: FontSize.p1, fontWeight: FontWeight.w600,),
                SizedBox(
                  height: 10,
                ),
                Label(text: '1 minute 32 seconds', fontSize: FontSize.p1, fontWeight: FontWeight.w600,),
                SizedBox(
                  height: 60,
                ),
                GreenShadowButton(onPressed: (){}, title: 'Back'),
                SizedBox(
                  height: 16,
                ),
                OrangeShadowButton(onPressed: (){}, title: 'See leaderboard'),
                SizedBox(
                  height: 16,
                ),
                isCompleted? SizedBox():GreenShadowButton(onPressed: (){}, title: 'Starr new game'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
