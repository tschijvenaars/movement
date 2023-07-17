import 'package:flutter/material.dart';

class AppNavigationNotifier extends ChangeNotifier {
  int get currentPage => _currentPage;

  /// Default current page is 4.
  int _currentPage = 4;

  /// Changes current page variable based on the [page] input.
  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }
}
