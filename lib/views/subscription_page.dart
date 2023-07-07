import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/buttons.dart';
import 'package:mobile_app_word_search/utils/custom_app_bar.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';

class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({Key? key}) : super(key: key);

  List<String> benefits = [
    'Ad free',
    'Unlimited daily matches',
    'Many more topics to choose from',
    'Share your created games withoutlimits',
    '5 levels available instead of only  2',
    'Create dynamic Word searches',
    'Create challenges',
    'Create private word seaches and challenges.'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(70), child: CustomAppBar(isBack: true, isLang: true,)),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: Label(
                      text: "PREMIUM BENEFITS",
                      fontWeight: FontWeight.bold,
                      fontSize: FontSize.p2,
                    )),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children:
                          benefits.map((e) => BenefitsItem(benefit: e)).toList(),
                    ),
                    SizedBox(
                      height: 30,
                    ),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ShadowButton(  fillColors: [
                  AllColors.semiLiteGreen,
                  AllColors.shineGreen
                ],
                    onPressed: () {}, title: 'MONTHLY \$99 / month'),
              ),
              SizedBox(
                height: 14,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ShadowButton(  fillColors: [
                  AllColors.semiLiteGreen,
                  AllColors.shineGreen
                ],
                    onPressed: () {}, title: 'ANNUAL \$89 / month (Save 10%)'),
              ),
            ],
          ),
        ));
  }
}

class BenefitsItem extends StatelessWidget {
  const BenefitsItem({
    super.key,
    required this.benefit,
  });

  final String benefit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.check,
          color: AllColors.superLightGreen,
          size: 36,
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
            child: Label(
          text: benefit,
          fontSize: FontSize.p2,
          fontWeight: FontWeight.bold,
        ))
      ],
    );
  }
}
