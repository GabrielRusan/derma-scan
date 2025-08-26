import 'package:derma_scan/pages/input_name_page.dart';
import 'package:flutter/material.dart';

class OnboardingProvider extends ChangeNotifier {
  /// variabbles
  final PageController _pageController = PageController();
  PageController get pageController => _pageController;

  int _currentPageIndex = 0;
  int get currentPageIndex => _currentPageIndex;

  /// update current index when page scroll
  void updatePageIndicator(int index) {
    _currentPageIndex = index;
  }

  /// jump to the specific dot selected page.
  void dotNavigationClick(index) {
    _currentPageIndex = index;
    pageController.jumpTo(index);
  }

  /// Update current Index & jump to next page
  void nextPage(BuildContext context) {
    if (_currentPageIndex == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InputNamePage()),
      );
    } else {
      _currentPageIndex += 1;
      pageController.jumpToPage(_currentPageIndex);
    }
  }

  /// Update current index & jump to last page
  void skipPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InputNamePage()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
