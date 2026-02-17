/// Analyzes Dart source code to calculate Halstead metrics.
library;

import 'dart:math' as math;
import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'halstead_result.dart';
part 'halstead_visitor.dart';

/// Analyzes Dart source code to calculate Halstead complexity metrics.
///
/// Halstead metrics measure program vocabulary and volume based on the number of unique and total operators and
/// operands in the source code. These metrics provide insight into program size and comprehension difficulty.
class HalsteadAnalyzer {
  /// Analyzes the given Dart source code and returns Halstead metrics.
  ///
  /// The [sourceCode] parameter contains the Dart code to analyze. Returns a [HalsteadResult] containing the
  /// calculated metrics including volume, difficulty, and effort.
  HalsteadResult analyze(String sourceCode) {
    final parseResult = parseString(
      content: sourceCode,
      featureSet: FeatureSet.latestLanguageVersion(),
      throwIfDiagnostics: false,
    );

    final _HalsteadVisitor visitor = _HalsteadVisitor();
    parseResult.unit.visitChildren(visitor);

    return visitor.calculateResult();
  }
}
