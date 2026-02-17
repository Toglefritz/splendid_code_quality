import 'package:flutter/material.dart';

import 'home_route.dart';
import 'home_view.dart';

/// Controller for the home screen wrapper that manages navigation state.
///
/// Extends `State<HomeRoute>` to provide state management for the bottom navigation bar and screen switching logic.
class HomeController extends State<HomeRoute> {
  /// Current selected tab index.
  ///
  /// This value determines which screen is displayed in the IndexedStack.
  int _currentIndex = 0;

  /// Updates the current tab index and triggers a UI rebuild.
  ///
  /// Called when the user taps a different tab in the bottom navigation bar.
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  /// Getter for the current tab index.
  ///
  /// Provides read-only access to the current tab index for the view layer.
  int get currentIndex => _currentIndex;

  @override
  Widget build(BuildContext context) => HomeView(this);
}
