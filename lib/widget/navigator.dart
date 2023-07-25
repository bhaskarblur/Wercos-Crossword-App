import 'package:flutter/material.dart';

class Nav {
  static push(BuildContext context, dynamic page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return page;
    }));
  }

  static pushReplace(BuildContext context, dynamic page) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return page;
    }));
  }

  static pushAndRemoveAll(BuildContext context, dynamic page) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return page;
    }), (route) => false);
  }

  static pop(BuildContext context) {
    Navigator.of(context).pop();
  }
}
