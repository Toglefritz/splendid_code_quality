part of 'cyclomatic_complexity_analyzer.dart';

/// Contains the results of a cyclomatic complexity analysis.
class ComplexityResult {
  /// Creates a complexity result with the given [complexity] value.
  const ComplexityResult({required this.complexity});

  /// The calculated cyclomatic complexity value.
  final int complexity;
}
