/// Analyzes Dart source code to calculate depth of inheritance.
library;

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

part 'inheritance_result.dart';
part 'inheritance_visitor.dart';

/// Analyzes Dart source code to calculate depth of inheritance for classes.
///
/// Depth of inheritance measures how many levels deep a class hierarchy extends. Deeper hierarchies are harder to
/// understand and maintain, as changes to base classes can have cascading effects.
class DepthOfInheritanceAnalyzer {
  /// Analyzes the given Dart source code and returns inheritance depth metrics.
  ///
  /// The [sourceCode] parameter contains the Dart code to analyze. Returns an [InheritanceResult] containing the
  /// maximum depth and per-class depth information.
  InheritanceResult analyze(String sourceCode) {
    final parseResult = parseString(
      content: sourceCode,
      featureSet: FeatureSet.latestLanguageVersion(),
      throwIfDiagnostics: false,
    );

    final _InheritanceVisitor visitor = _InheritanceVisitor();
    parseResult.unit.visitChildren(visitor);

    return visitor.getResult();
  }
}
