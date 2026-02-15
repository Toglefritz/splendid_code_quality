part of 'loc_analyzer.dart';

/// Contains the results of a lines of code analysis.
class LocResult {
  /// Creates a LOC result with the given line counts.
  const LocResult({
    required this.totalLines,
    required this.codeLines,
    required this.commentLines,
    required this.blankLines,
  });

  /// Total number of lines in the file.
  final int totalLines;

  /// Number of lines containing code (non-blank, non-comment).
  final int codeLines;

  /// Number of lines containing only comments.
  final int commentLines;

  /// Number of blank lines.
  final int blankLines;
}
