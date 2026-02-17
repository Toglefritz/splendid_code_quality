import 'package:flutter/material.dart';

/// Represents a single brick in the game.
class Brick {
  /// Creates a brick with the given position and color.
  Brick({required this.x, required this.y, required this.color});

  /// X coordinate of the brick.
  double x;

  /// Y coordinate of the brick.
  double y;

  /// Color of the brick.
  Color color;
}
