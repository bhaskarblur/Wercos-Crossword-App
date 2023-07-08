import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/components/labels.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';
import 'package:mobile_app_word_search/utils/font_size.dart';

class DrugPage extends StatelessWidget {
  const DrugPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(gradient: AllColors.bg),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50,),
                Label(text: '00:40', fontWeight: FontWeight.w600, fontSize: FontSize.p2,),
                SizedBox(height: 10,),
                Label(text: 'Beach Party', fontWeight: FontWeight.w600, fontSize: FontSize.p1,),
                SizedBox(height: 10,),
                Image.asset('assets/images/shadow_container.png'),
                SizedBox(height: 10,),
                Image.asset('assets/images/white_container.png'),
              ],
            ),
          ),
        )

    );
  }
}
