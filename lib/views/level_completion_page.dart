import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LevelCompletionPage extends StatelessWidget {
  const LevelCompletionPage({Key? key}) : super(key: key);

  final isCompleted = false;

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
                const SizedBox(height: 100),
                const Label(
                    text: 'RATE THIS WORD SEARCH', fontSize: FontSize.p2),
                const SizedBox(height: 10),
                RatingBarIndicator(
                  rating: 5,
                  itemBuilder: (context, index) =>
                      const Icon(Icons.star, color: AllColors.superLightGreen),
                  itemCount: 5,
                  itemPadding: const EdgeInsets.all(4),
                  unratedColor: AllColors.grey,
                  itemSize: 30.0,
                ),
                const SizedBox(height: 24),
                isCompleted
                    ? const Label(
                        text: 'Game',
                        fontSize: FontSize.h4,
                        fontWeight: FontWeight.bold)
                    : const Label(
                        text: 'CONGRATULATIONS!', fontSize: FontSize.h4),
                const SizedBox(height: 4),
                isCompleted
                    ? const Label(
                        text: 'NOT COMPLETED',
                        fontSize: FontSize.h4,
                        color: AllColors.liteRed,
                        fontWeight: FontWeight.bold)
                    : const Label(
                        text: 'COMPLETED',
                        fontSize: FontSize.h4,
                        color: AllColors.liteGreen,
                        fontWeight: FontWeight.bold),
                const SizedBox(height: 40),
                const Label(
                  text: 'HITS',
                  fontSize: FontSize.p1,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 10),
                const Label(
                  text: '18 de 18',
                  fontSize: FontSize.p1,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 40),
                const Label(
                  text: 'TIME',
                  fontSize: FontSize.p1,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Label(
                  text: '1 minute 32 seconds',
                  fontSize: FontSize.p1,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 60),
                ShadowButton(fillColors: const [
                  AllColors.semiLiteGreen,
                  AllColors.shineGreen
                ], onPressed: () {}, title: 'Back'),
                const SizedBox(height: 16),
                ShadowButton(
                    fillColors: const [AllColors.liteOrange, AllColors.orange],
                    onPressed: () {},
                    title: 'See leaderboard'),
                const SizedBox(height: 16),
                isCompleted
                    ? const SizedBox()
                    : ShadowButton(fillColors: const [
                        AllColors.semiLiteGreen,
                        AllColors.shineGreen
                      ], onPressed: () {}, title: 'Starr new game'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
