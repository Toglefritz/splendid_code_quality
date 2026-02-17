import 'package:flutter/material.dart';

import 'home_controller.dart';

/// Route widget for the home screen wrapper.
///
/// Following MVC patterns, this route serves as the main navigation wrapper for the application, providing access to
/// all main screens through a bottom navigation bar.
class HomeRoute extends StatefulWidget {
  /// Creates the home route widget.
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => HomeController();
}
