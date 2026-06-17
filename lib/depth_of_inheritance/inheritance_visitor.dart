part of 'depth_of_inheritance_analyzer.dart';

/// AST visitor that calculates depth of inheritance for each class.
///
/// This visitor traverses the AST and tracks inheritance relationships to determine how deep each class hierarchy
/// extends. Classes without explicit superclasses or extending Object have depth 0.
class _InheritanceVisitor extends RecursiveAstVisitor<void> {
  /// Creates a new inheritance visitor.
  _InheritanceVisitor() : _classDepths = <String, int>{};

  /// Map storing the inheritance depth for each class.
  final Map<String, int> _classDepths;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    final String className = node.namePart.typeName.lexeme;
    final int depth = _calculateDepth(node);
    _classDepths[className] = depth;
    super.visitClassDeclaration(node);
  }

  /// Calculates the inheritance depth for a class declaration.
  ///
  /// Returns 0 if the class has no explicit superclass or extends Object. Returns 1 if it extends a direct base
  /// class, and increments for each additional level of inheritance.
  int _calculateDepth(ClassDeclaration node) {
    final NamedType? extendsClause = node.extendsClause?.superclass;

    if (extendsClause == null) {
      return 0;
    }

    final String superclassName = extendsClause.name.lexeme;

    // Object is the root of all Dart classes, so depth is 0
    if (superclassName == 'Object') {
      return 0;
    }

    // If we've already calculated the depth of the superclass, use it
    if (_classDepths.containsKey(superclassName)) {
      return _classDepths[superclassName]! + 1;
    }

    // Otherwise, this is a reference to an external class or one we haven't seen yet
    // We assume depth 1 (extends a base class)
    return 1;
  }

  /// Returns the inheritance analysis result.
  InheritanceResult getResult() {
    final int maxDepth = _classDepths.values.isEmpty ? 0 : _classDepths.values.reduce((a, b) => a > b ? a : b);

    return InheritanceResult(
      maxDepth: maxDepth,
      classDepths: Map.unmodifiable(_classDepths),
    );
  }
}
