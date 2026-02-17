part of 'cognitive_complexity_analyzer.dart';

/// Contains the results of a cognitive complexity analysis.
class CognitiveResult {
  /// Creates a cognitive result with the given [complexity] value.
  const CognitiveResult({required this.complexity});

  /// The calculated cognitive complexity value.
  ///
  /// Higher values indicate code that is more difficult to understand. Values above 15 typically indicate code that
  /// should be refactored for better readability.
  final int complexity;
}
