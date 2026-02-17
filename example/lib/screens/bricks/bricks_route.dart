import 'package:flutter/material.dart';

import 'bricks_controller.dart';

/// Route widget for the bricks game screen.
///
/// This screen demonstrates high cyclomatic complexity for testing the Splendid Code Quality analyzer.
class BricksRoute extends StatefulWidget {
  /// Creates the bricks route widget.
  const BricksRoute({super.key});

  @override
  State<BricksRoute> createState() => BricksController();
}
