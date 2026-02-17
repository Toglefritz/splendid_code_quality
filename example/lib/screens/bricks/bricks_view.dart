import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'bricks_controller.dart';

/// View widget for the bricks game screen.
///
/// Displays a stack of bricks that can be placed by the user.
class BricksView extends StatelessWidget {
  /// Creates the bricks view with the required controller.
  const BricksView(this.state, {super.key});

  /// Controller instance that manages game state and logic.
  final BricksController state;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => state.updateCursorPosition(event.localPosition),
      child: GestureDetector(
        onTapDown: (details) {
          if (state.currentBrick != null) {
            state.placeBrick();
          }
        },
        child: Stack(
          children: [
            // Placed bricks
            ...state.bricks.map(
              (brick) => Positioned(
                left: brick.x - 15,
                top: brick.y - 15,
                child: Icon(
                  Symbols.brick,
                  size: 30,
                  color: brick.color,
                ),
              ),
            ),
            // Current brick being placed
            if (state.currentBrick != null)
              Positioned(
                left: state.currentBrick!.x - 15,
                top: state.currentBrick!.y - 15,
                child: Icon(
                  Symbols.brick,
                  size: 30,
                  color: state.currentBrick!.color.withValues(alpha: 0.7),
                ),
              ),
            // Score display
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  'Score: ${state.calculateScore()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Brick count display
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Text(
                  'Bricks: ${state.bricks.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Add brick button
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                onPressed: state.currentBrick == null ? state.startPlacingBrick : null,
                backgroundColor: state.currentBrick == null
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).disabledColor,
                child: Icon(Icons.add, color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
