import 'package:flutter/material.dart';

import 'bricks_route.dart';
import 'bricks_view.dart';
import 'models/brick.dart';

/// Controller for the bricks game screen.
///
/// This controller intentionally contains methods with high cyclomatic complexity to serve as test cases for the code
/// quality analyzer.
class BricksController extends State<BricksRoute> {
  /// List of placed bricks.
  final List<Brick> _bricks = [];

  /// Current brick being placed (follows cursor).
  Brick? _currentBrick;

  /// Current cursor position.
  Offset _cursorPosition = Offset.zero;

  /// Starts placing a new brick.
  void startPlacingBrick() {
    setState(() {
      _currentBrick = Brick(
        x: _cursorPosition.dx,
        y: _cursorPosition.dy,
        color: _generateBrickColor(_bricks.length),
      );
    });
  }

  /// Updates the cursor position and moves the current brick.
  void updateCursorPosition(Offset position) {
    setState(() {
      _cursorPosition = position;
      if (_currentBrick != null) {
        _currentBrick!.x = position.dx;
        _currentBrick!.y = position.dy;
      }
    });
  }

  /// Places the current brick at its current position.
  void placeBrick() {
    if (_currentBrick != null) {
      setState(() {
        _bricks.add(_currentBrick!);
        _currentBrick = null;
      });
    }
  }

  /// Generates a brick color based on the brick count.
  ///
  /// This method intentionally has high cyclomatic complexity for testing purposes. It uses multiple nested conditions
  /// to determine the color.
  Color _generateBrickColor(int count) {
    if (count < 5) {
      if (count == 0) {
        return Colors.red;
      } else if (count == 1) {
        return Colors.blue;
      } else if (count == 2) {
        return Colors.green;
      } else if (count == 3) {
        return Colors.orange;
      } else {
        return Colors.purple;
      }
    } else if (count < 10) {
      if (count == 5) {
        return Colors.teal;
      } else if (count == 6) {
        return Colors.pink;
      } else if (count == 7) {
        return Colors.amber;
      } else if (count == 8) {
        return Colors.cyan;
      } else {
        return Colors.lime;
      }
    } else if (count < 15) {
      if (count == 10) {
        return Colors.indigo;
      } else if (count == 11) {
        return Colors.brown;
      } else if (count == 12) {
        return Colors.deepOrange;
      } else if (count == 13) {
        return Colors.deepPurple;
      } else {
        return Colors.lightBlue;
      }
    } else {
      return Colors.grey;
    }
  }

  /// Validates brick placement with intentionally complex logic.
  ///
  /// This method has high cyclomatic complexity for testing purposes. It checks various conditions to determine if a
  /// brick can be placed.
  bool validateBrickPlacement(Brick brick) {
    if (brick.x < 0 || brick.y < 0) {
      return false;
    }

    if (brick.x > 400 || brick.y > 600) {
      return false;
    }

    for (final Brick existingBrick in _bricks) {
      final double dx = (brick.x - existingBrick.x).abs();
      final double dy = (brick.y - existingBrick.y).abs();

      if (dx < 30 && dy < 30) {
        if (dx < 10 && dy < 10) {
          return false;
        } else if (dx < 15 && dy < 15) {
          if (brick.color == existingBrick.color) {
            return false;
          }
        } else if (dx < 20 && dy < 20) {
          if (brick.color == existingBrick.color) {
            if (_bricks.length > 5) {
              return false;
            }
          }
        } else if (dx < 25 && dy < 25) {
          if (brick.color == existingBrick.color) {
            if (_bricks.length > 10) {
              return false;
            } else if (_bricks.length > 7) {
              if (brick.x > 200) {
                return false;
              }
            }
          }
        }
      }
    }

    return true;
  }

  /// Calculates a score based on brick arrangement.
  ///
  /// This method has high cyclomatic complexity with nested conditions and multiple logical operators for testing
  /// purposes.
  int calculateScore() {
    int score = 0;

    for (int i = 0; i < _bricks.length; i++) {
      final Brick brick = _bricks[i];

      if (brick.color == Colors.red || brick.color == Colors.blue) {
        score += 10;
        if (brick.x > 100 && brick.x < 300) {
          score += 5;
          if (brick.y > 100 && brick.y < 400) {
            score += 5;
          }
        }
      } else if (brick.color == Colors.green || brick.color == Colors.orange) {
        score += 8;
        if (brick.x > 150 && brick.x < 250) {
          score += 3;
        }
      } else if (brick.color == Colors.purple || brick.color == Colors.teal) {
        score += 6;
      }

      for (int j = i + 1; j < _bricks.length; j++) {
        final Brick otherBrick = _bricks[j];
        final double distance =
            ((brick.x - otherBrick.x) * (brick.x - otherBrick.x) + (brick.y - otherBrick.y) * (brick.y - otherBrick.y))
                .abs();

        if (distance < 50) {
          if (brick.color == otherBrick.color) {
            score += 15;
          } else if ((brick.color == Colors.red && otherBrick.color == Colors.blue) ||
              (brick.color == Colors.blue && otherBrick.color == Colors.red)) {
            score += 20;
          } else if ((brick.color == Colors.green && otherBrick.color == Colors.orange) ||
              (brick.color == Colors.orange && otherBrick.color == Colors.green)) {
            score += 18;
          }
        } else if (distance < 100) {
          if (brick.color == otherBrick.color) {
            score += 8;
          }
        } else if (distance < 150) {
          if (brick.color == otherBrick.color) {
            score += 4;
          }
        }
      }
    }

    if (_bricks.length > 5 && _bricks.length < 10) {
      score += 25;
    } else if (_bricks.length >= 10 && _bricks.length < 15) {
      score += 50;
    } else if (_bricks.length >= 15) {
      score += 100;
    }

    return score;
  }

  /// Getter for the list of placed bricks.
  List<Brick> get bricks => _bricks;

  /// Getter for the current brick being placed.
  Brick? get currentBrick => _currentBrick;

  @override
  Widget build(BuildContext context) => BricksView(this);
}
