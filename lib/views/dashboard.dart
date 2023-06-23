import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app_word_search/views/home_page.dart';
import 'package:mobile_app_word_search/views/language_selection_page.dart';
import 'package:mobile_app_word_search/views/option_page.dart';

class Dashboard extends StatelessWidget {
   Dashboard({Key? key}) : super(key: key);

  int currentIndex=0;

  final List<Widget> pages=[
    HomePage(),
    LanguageSelectionPage(),
    HomePage(),
    OptionPage(),


  ];
  final PageStorageBucket bucket= PageStorageBucket();
  Widget currentPage= HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentPage,
        bucket: bucket,
      ),

      floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50)
          ),
        child: Icon(Icons.play_arrow),

        onPressed: () {  },),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),

        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                ],
              )
            ],
          ),
        ),
      ),
    );


  }
}
