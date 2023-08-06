import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/custom_dialogs.dart';
import 'package:mobile_app_word_search/components/suggestion/model/suggestion.dart';

import '../utils/all_colors.dart';
import '../utils/font_size.dart';
import 'labels.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomSwitchButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomSwitchButton({
    super.key,
    required this.onPressed,
    required this.labels,
    required this.infoButton,
  });

  final List<String> labels;

  final bool infoButton;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoButton(
            onPressed: onPressed,
            minSize: 0,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.maxFinite,
              height: 50,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: AllColors.black.withOpacity(0.8),
                        offset: const Offset(0, 0),
                        blurRadius: 1,
                        spreadRadius: 0),
                    const BoxShadow(
                        color: AllColors.darkPurple,
                        offset: Offset(1, 1),
                        blurRadius: 10,
                        spreadRadius: 0),
                  ],
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AllColors.superLitePurple)),
              child: Row(
                children: [
                  EnabledSwitch(labels: labels),
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.lock_fill,
                              color: AllColors.liteGreen, size: 28),
                          const SizedBox(width: 5),
                          Label(
                              text: labels.last,
                              fontSize: FontSize.p2,
                              fontWeight: FontWeight.w500)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        infoButton
            ? CupertinoButton(
                onPressed: () {
                  CustomDialog.showSuggestionDialog(
                      context: context,
                      suggestions: [
                        Suggestion(
                            AppLocalizations.of(context)!.maximum_word_length,
                            AppLocalizations.of(context)!
                                .maximum_word_length_description),
                        Suggestion(
                            AppLocalizations.of(context)!.dynamic_word_search,
                            AppLocalizations.of(context)!
                                .dynamic_word_search_description),
                        Suggestion(
                            AppLocalizations.of(context)!.what_is_challenge,
                            AppLocalizations.of(context)!
                                .what_is_challenge_description),
                      ]);
                },
                minSize: 0,
                padding: EdgeInsets.zero,
                child: const Icon(Icons.info_outline,
                    color: AllColors.white, size: 36))
            : Container()
      ],
    );
  }
}

class EnabledSwitch extends StatelessWidget {
  const EnabledSwitch({
    super.key,
    required this.labels,
  });

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(50), boxShadow: [
          const BoxShadow(
              color: AllColors.superLitePurple,
              offset: Offset(0, 0),
              blurRadius: 0,
              spreadRadius: 0),
          BoxShadow(
              color: AllColors.white.withOpacity(.4),
              offset: const Offset(-3, 6),
              blurRadius: 8,
              spreadRadius: -13),
          BoxShadow(
              color: AllColors.white.withOpacity(.7),
              offset: const Offset(2, -6),
              blurRadius: 5,
              spreadRadius: -10),
          const BoxShadow(
              color: AllColors.darkLitePurple,
              offset: Offset(-1, -1),
              blurRadius: 10,
              spreadRadius: -3),
        ]),
        child: Center(
            child: Label(
                text: labels.first,
                fontSize: FontSize.p2,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
