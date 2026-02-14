part of 'cyclomatic_complexity_analyzer.dart';

/// AST visitor that counts decision points to calculate cyclomatic complexity.
///
/// This visitor traverses the AST and increments complexity for each decision point encountered in the code.
class _ComplexityVisitor extends RecursiveAstVisitor<void> {
  /// Creates a new complexity visitor with base complexity of 1.
  _ComplexityVisitor() : complexity = 1;

  /// The current cyclomatic complexity count.
  int complexity;

  @override
  void visitIfStatement(IfStatement node) {
    complexity++;
    super.visitIfStatement(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    complexity++;
    super.visitForStatement(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    complexity++;
    super.visitWhileStatement(node);
  }

  @override
  void visitDoStatement(DoStatement node) {
    complexity++;
    super.visitDoStatement(node);
  }

  @override
  void visitSwitchCase(SwitchCase node) {
    complexity++;
    super.visitSwitchCase(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    complexity++;
    super.visitCatchClause(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    complexity++;
    super.visitConditionalExpression(node);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    final String operator = node.operator.lexeme;
    if (operator == '&&' || operator == '||' || operator == '??') {
      complexity++;
    }
    super.visitBinaryExpression(node);
  }
}
