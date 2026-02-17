import 'package:flutter/material.dart';

import 'placeholder_controller.dart';

/// View widget for the placeholder screen.
///
/// This view will be replaced with actual UI in future updates.
class PlaceholderView extends StatelessWidget {
  /// Creates the placeholder view with the required controller.
  const PlaceholderView(this.state, {super.key});

  /// Controller instance that manages state and business logic.
  final PlaceholderController state;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Placeholder Screen'),
    );
  }
}
