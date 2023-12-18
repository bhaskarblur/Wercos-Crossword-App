import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  dynamic _profile;
  dynamic get profile => _profile;

  chnageProfile(dynamic value) {
    _profile = value;
    notifyListeners();
  }

}
