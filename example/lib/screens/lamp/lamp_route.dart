import 'package:flutter/material.dart';

import 'lamp_controller.dart';

/// Route widget for the lamp screen.
///
/// Following MVC patterns, this route serves only as the entry point and delegates all logic to the [LampController]
/// through `createState()`.
class LampRoute extends StatefulWidget {
  /// Creates the lamp route widget.
  const LampRoute({super.key});

  @override
  State<LampRoute> createState() => LampController();
}
