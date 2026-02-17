/// Analyzes Dart source code to calculate cognitive complexity.
library;

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'cognitive_result.dart';
part 'cognitive_visitor.dart';

/// Analyzes Dart source code to calculate cognitive complexity.
///
/// Cognitive complexity measures how difficult code is to understand by penalizing nested structures and control flow
/// breaks more heavily than simple decision points. Unlike cyclomatic complexity, it focuses on human readability.
class CognitiveComplexityAnalyzer {
  /// Analyzes the given Dart source code and returns cognitive complexity metrics.
  ///
  /// The [sourceCode] parameter contains the Dart code to analyze. Returns a [CognitiveResult] containing the analysis
  /// results.
  CognitiveResult analyze(String sourceCode) {
    final parseResult = parseString(
      content: sourceCode,
      featureSet: FeatureSet.latestLanguageVersion(),
      throwIfDiagnostics: false,
    );

    final _CognitiveVisitor visitor = _CognitiveVisitor();
    parseResult.unit.visitChildren(visitor);

    return CognitiveResult(complexity: visitor.complexity);
  }
}
