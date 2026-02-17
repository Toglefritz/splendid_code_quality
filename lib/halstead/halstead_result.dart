part of 'halstead_analyzer.dart';

/// Contains the results of a Halstead complexity analysis.
class HalsteadResult {
  /// Creates a Halstead result with the calculated metrics.
  const HalsteadResult({
    required this.uniqueOperators,
    required this.uniqueOperands,
    required this.totalOperators,
    required this.totalOperands,
    required this.vocabulary,
    required this.length,
    required this.volume,
    required this.difficulty,
    required this.effort,
  });

  /// Number of unique operators (n1).
  final int uniqueOperators;

  /// Number of unique operands (n2).
  final int uniqueOperands;

  /// Total number of operators (N1).
  final int totalOperators;

  /// Total number of operands (N2).
  final int totalOperands;

  /// Program vocabulary: n1 + n2.
  final int vocabulary;

  /// Program length: N1 + N2.
  final int length;

  /// Program volume: N * log2(n).
  ///
  /// Volume represents the size of the implementation and is measured in bits. Higher volume indicates more complex
  /// or verbose code.
  final double volume;

  /// Program difficulty: (n1 / 2) * (N2 / n2).
  ///
  /// Difficulty estimates how hard the program is to write or understand. Higher difficulty suggests code that is
  /// more error-prone.
  final double difficulty;

  /// Program effort: difficulty * volume.
  ///
  /// Effort estimates the mental effort required to develop or understand the program. Higher effort indicates code
  /// that requires more cognitive resources.
  final double effort;
}
