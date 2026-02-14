/// Analyzes Dart source code to calculate cyclomatic complexity.
library;

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'complexity_result.dart';
part 'complexity_visitor.dart';

/// Analyzes Dart source code to calculate cyclomatic complexity.
///
/// Cyclomatic complexity measures the number of independent paths through a program's source code by counting decision
/// points using AST analysis.
class CyclomaticComplexityAnalyzer {
  /// Analyzes the given Dart source code and returns complexity metrics.
  ///
  /// The [sourceCode] parameter contains the Dart code to analyze. Returns a [ComplexityResult] containing the analysis
  /// results.
  ComplexityResult analyze(String sourceCode) {
    final parseResult = parseString(
      content: sourceCode,
      featureSet: FeatureSet.latestLanguageVersion(),
      throwIfDiagnostics: false,
    );

    final _ComplexityVisitor visitor = _ComplexityVisitor();
    parseResult.unit.visitChildren(visitor);

    return ComplexityResult(complexity: visitor.complexity);
  }
}
