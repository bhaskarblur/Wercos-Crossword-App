import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_word_search/utils/all_colors.dart';

import '../app_config/app_details.dart';
import '../app_config/colors.dart';
import '../components/labels.dart';
import '../utils/font_size.dart';

Widget gap(double height) {
  return SizedBox(height: height);
}

Widget horGap(double width) {
  return SizedBox(width: width);
}

Widget fullWidthButton(
    {required String buttonName,
    required void Function() onTap,
    double fontSize = 18,
    double width = double.infinity,
    double height = 50}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 2,
                offset: Offset(0, 2),
                spreadRadius: 2)
          ]),
      child: Center(
          child: Text(buttonName,
              style: TextStyle(
                  color: backgroundColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold))),
    ),
  );
}

Widget borderedButton(
    {required String buttonName, required void Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        height: 45,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: primaryColor),
            borderRadius: BorderRadius.circular(5)),
        child: Center(
            child: Text(buttonName,
                style: TextStyle(color: primaryColor, fontSize: 16)))),
  );
}

Widget customTextField(TextEditingController controller, String hintText,
    {Color fillColor = Colors.white,
    TextInputType keyboard = TextInputType.emailAddress}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(5)),
    child: TextFormField(
        controller: controller,
        cursorColor: primaryTextColor,
        style: TextStyle(color: primaryTextColor),
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: hintText,
          fillColor: fillColor,
          filled: true,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        )),
  );
}

loader(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          contentPadding: const EdgeInsets.all(15),
          content: Row(
            children: [
              const CircularProgressIndicator(color: AllColors.darkLitePurple),
              horGap(20),
              Text('Loading...',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: primaryColor))
            ],
          ),
        );
      });
}

dialog(BuildContext context, String message, void Function()? onok) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(15),
          title: Text(appName),
          content: Text(message, maxLines: 5),
          actions: [
            InkWell(
              onTap: onok,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Ok',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
            ),
          ],
        );
      });
}

internetBanner(BuildContext context, String message, void Function()? onOk) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade900,
          contentPadding: const EdgeInsets.all(15),
          title: const Text('Alert',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 100, color: Colors.white),
              Text(message,
                  maxLines: 5,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: InkWell(
                onTap: onOk,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: primaryColor),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Ok',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white)),
                  ),
                ),
              ),
            ),
          ],
        );
      });
}

showYesNoButton(BuildContext context, String message, void Function()? onYes,
    void Function()? onNo,
    {String button1 = 'Yes', String button2 = 'No'}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(15),
          title: Text(appName, style: TextStyle(color: primaryTextColor)),
          content: Text(message,
              maxLines: 5, style: TextStyle(color: primaryTextColor)),
          actions: [
            InkWell(
              onTap: onYes,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(button1,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: backgroundColor)),
                ),
              ),
            ),
            horGap(10),
            InkWell(
              onTap: onNo,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: primaryColor),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(button2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: backgroundColor)),
                ),
              ),
            ),
          ],
        );
      });
}

dateFormetterFromString(String date) {
  return DateFormat('yyyy-MM-dd').format(DateTime.parse(date)).toString();
}

statusBar(BuildContext context) {
  return SizedBox(height: MediaQuery.of(context).viewPadding.top);
}

Widget customDatePicker(BuildContext context, String text) {
  return InkWell(
    onTap: () {
      showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
      );
    },
    child: Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey.shade200)),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,
                style: const TextStyle(
                    color: Colors.grey, fontWeight: FontWeight.bold)),
            const Icon(Icons.keyboard_arrow_down)
          ],
        ),
      )),
    ),
  );
}

Widget divider() {
  return Container(height: 1, width: double.infinity, color: Colors.grey);
}

Widget dottedDivder() {
  return Row(
    children: List.generate(
        150 ~/ 1.5,
        (index) => Expanded(
              child: Container(
                color: index % 2 == 0 ? Colors.transparent : Colors.grey,
                height: 2,
              ),
            )),
  );
}

Widget serachBar(
  TextEditingController search,
  Function()? onTap, {
  void Function(String)? onChanged,
  void Function()? onEditingComplete,
  bool filter = true,
}) {
  return Row(
    children: [
      Expanded(
          child: TextField(
        controller: search,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, size: 26, color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          hintText: 'Search anything',
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
      )),
      if (filter) horGap(10),
      if (filter)
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset('assets/icons/filter_lines.svg',
                  height: 40, width: 40),
            ),
          ),
        ),
    ],
  );
}

Widget customCard(dynamic data,
    {bool gallery = true, void Function()? byNowOnTap}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          data['profile_logo'] != '' && data['profile_logo'] != null
              ? Image.network(
                  '${baseUrl}images/clients/${data['profile_logo']}',
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover)
              : Image.asset('assets/images/food.png'),

          horGap(10),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(data['gen_company_name'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  data['gen_street'] +
                      ' ' +
                      data['gen_suburb'] +
                      ' ' +
                      data['gen_city'] +
                      ' ' +
                      data['gen_country'],
                  style: const TextStyle(color: Colors.grey),
                ),
                gap(10),
                Text(
                  'Ph : ${data['contact_public']}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ])),
          // Column(children: [
          //   IconButton(
          //       onPressed: () {},
          //       icon: const Icon(Icons.favorite_outline, color: Colors.red)),
          if (data['user_reward'] != "0.00")
            Image.asset('assets/images/reward.png', height: 50, width: 50)
          // ]),
        ]),
      ),
      dottedDivder(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            const Text("This week's maximum reward is: ",
                style: TextStyle(color: Colors.black54)),
            Text(data['user_reward'] + '%',
                style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
      dottedDivder(),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            InkWell(
              onTap: byNowOnTap,
              child: const Text("Buy Now Products",
                  style: TextStyle(color: Colors.black)),
            ),
            if (gallery)
              const Text(" | ", style: TextStyle(color: Colors.black)),
            if (gallery)
              const Text("View Gallery", style: TextStyle(color: Colors.black)),
          ],
        ),
      ),
    ]),
  );
}

Widget customDropdown(
    List<String> items, String dValue, void Function(String?)? onChanged) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.grey.shade300)),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: DropdownButton<String>(
          isExpanded: true,
          underline: gap(0),
          value: dValue,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged),
    ),
  );
}

Widget customSwitch(List<String> words,
    {bool? value,
    void Function()? onTap,
    void Function()? info,
    bool? showInfo = true}) {
  return Row(
    children: [
      Expanded(
        child: GestureDetector(
          onTap: onTap,
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
            child: Row(children: [
              value!
                  ? Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              const BoxShadow(
                                color: AllColors.superLitePurple,
                                offset: Offset(0, 0),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: AllColors.white.withOpacity(.4),
                                offset: const Offset(-3, 6),
                                blurRadius: 8,
                                spreadRadius: -13,
                              ),
                              BoxShadow(
                                color: AllColors.white.withOpacity(.7),
                                offset: const Offset(2, -6),
                                blurRadius: 5,
                                spreadRadius: -10,
                              ),
                              const BoxShadow(
                                color: AllColors.darkLitePurple,
                                offset: Offset(-1, -1),
                                blurRadius: 10,
                                spreadRadius: -3,
                              ),
                            ]),
                        child: Center(
                            child: Label(
                          text: words.first,
                          fontSize: FontSize.p2,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Label(
                                text: words.first,
                                fontSize: FontSize.p2,
                                fontWeight: FontWeight.w500)
                          ],
                        ),
                      ),
                    ),
              value
                  ? Expanded(
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              CupertinoIcons.lock_fill,
                              color: AllColors.liteGreen,
                              size: 20,
                            ),
                            const SizedBox(width: 5),
                            Label(
                              text: words.last,
                              fontSize: FontSize.p2,
                              fontWeight: FontWeight.w500,
                            )
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              const BoxShadow(
                                color: AllColors.superLitePurple,
                                offset: Offset(0, 0),
                                blurRadius: 0,
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: AllColors.white.withOpacity(.4),
                                offset: const Offset(-3, 6),
                                blurRadius: 8,
                                spreadRadius: -13,
                              ),
                              BoxShadow(
                                color: AllColors.white.withOpacity(.7),
                                offset: const Offset(2, -6),
                                blurRadius: 5,
                                spreadRadius: -10,
                              ),
                              const BoxShadow(
                                color: AllColors.darkLitePurple,
                                offset: Offset(-1, -1),
                                blurRadius: 10,
                                spreadRadius: -3,
                              ),
                            ]),
                        child: Center(
                            child: Label(
                          text: words.last,
                          fontSize: FontSize.p2,
                          fontWeight: FontWeight.w500,
                        )),
                      ),
                    ),
            ]),
          ),
        ),
      ),
      if (showInfo!) horGap(10),
      if (showInfo)
        InkWell(
            onTap: info,
            child: const Icon(Icons.info_outline,
                color: AllColors.white, size: 36))
    ],
  );
}
