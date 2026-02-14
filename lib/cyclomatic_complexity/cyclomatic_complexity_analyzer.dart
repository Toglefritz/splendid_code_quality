/// Analyzes Dart source code to calculate cyclomatic complexity.
library;

part 'complexity_result.dart';

/// Analyzes Dart source code to calculate cyclomatic complexity.
///
/// Cyclomatic complexity measures the number of independent paths through a program's source code by counting decision
/// points.
class CyclomaticComplexityAnalyzer {
  /// Analyzes the given Dart source code and returns complexity metrics.
  ///
  /// The [sourceCode] parameter contains the Dart code to analyze. Returns a [ComplexityResult] containing the analysis
  /// results.
  ComplexityResult analyze(String sourceCode) {
    int complexity = 1; // Base complexity starts at 1

    // Count decision points that increase complexity
    complexity += _countOccurrences(sourceCode, 'if');
    complexity += _countOccurrences(sourceCode, 'else if');
    complexity += _countOccurrences(sourceCode, 'for');
    complexity += _countOccurrences(sourceCode, 'while');
    complexity += _countOccurrences(sourceCode, 'case');
    complexity += _countOccurrences(sourceCode, 'catch');
    complexity += _countOccurrences(sourceCode, '&&');
    complexity += _countOccurrences(sourceCode, '||');
    complexity += _countOccurrences(sourceCode, '??');
    complexity += _countOccurrences(sourceCode, '?');

    return ComplexityResult(complexity: complexity);
  }

  /// Counts the number of times a keyword or operator appears in the source code.
  int _countOccurrences(String sourceCode, String pattern) {
    return pattern.allMatches(sourceCode).length;
  }
}
