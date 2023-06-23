import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../utils/all_colors.dart';
import '../utils/font_size.dart';
import 'labels.dart';

class CustomSwitchButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomSwitchButton({
  super.key,
  required this.isOn,
  required this.onPressed,
  required this.labels,
  });

  final bool isOn;

  final List<String> labels;

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
                  color: AllColors.darkPurple,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AllColors.superLitePurple)),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      height: double.maxFinite,
                      decoration: BoxDecoration(
                        color: AllColors.superLitePurple,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                          child: Label(
                            text: labels.first,
                            fontSize: FontSize.p2,
                            fontWeight: FontWeight.w500,
                          )),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.lock_fill,
                            color: AllColors.liteGreen,
                            size: 28,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Label(
                            text: labels.last,
                            fontSize: FontSize.p2,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 6,
        ),
        CupertinoButton(
            onPressed: () {},
            minSize: 0,
            padding: EdgeInsets.zero,
            child: Icon(
              Icons.info_outline,
              color: AllColors.white,
              size: 36,
            ))
      ],
    );
  }
}
