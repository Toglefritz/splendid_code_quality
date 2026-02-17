import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../l10n/app_localizations.dart';
import '../bricks/bricks_route.dart';
import '../lamp/lamp_route.dart';
import '../placeholder/placeholder_route.dart';
import 'home_controller.dart';

/// View widget for the home screen wrapper that handles UI presentation.
///
/// This [StatelessWidget] provides the main navigation structure with a bottom navigation bar and an [IndexedStack] to
/// switch between screens.
class HomeView extends StatelessWidget {
  /// Creates the home view with the required controller.
  const HomeView(this.state, {super.key});

  /// Controller instance that manages navigation state.
  final HomeController state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(AppLocalizations.of(context)!.appTitle),
      ),
      body: IndexedStack(
        index: state.currentIndex,
        children: const [
          LampRoute(),
          BricksRoute(),
          PlaceholderRoute(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: state.currentIndex,
        onTap: state.onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.lightbulb_outline),
            label: AppLocalizations.of(context)!.lamp,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Symbols.brick),
            label: AppLocalizations.of(context)!.bricks,
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Screen 3',
          ),
        ],
      ),
    );
  }
}
