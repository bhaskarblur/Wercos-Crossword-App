import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  dynamic _categories;
  dynamic get categories => _categories;

  changeCategories(dynamic value) {
    _categories = value;
    notifyListeners();
  }

  dynamic _selectedCategory;
  dynamic get selectedCategory => _selectedCategory;

  changeSelectedCategory(dynamic value) {
    _selectedCategory = value;
    notifyListeners();
  }
}
