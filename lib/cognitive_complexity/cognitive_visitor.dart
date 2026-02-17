part of 'cognitive_complexity_analyzer.dart';

/// AST visitor that calculates cognitive complexity by tracking nesting depth and control flow breaks.
///
/// This visitor implements the cognitive complexity algorithm which penalizes:
/// - Nested control structures (each level of nesting adds to complexity)
/// - Control flow breaks (break, continue, return, throw)
/// - Sequences of logical operators
///
/// Unlike cyclomatic complexity, cognitive complexity does not increment for:
/// - Shorthand operators that don't affect readability (e.g., null-aware operators in simple contexts)
/// - Switch cases (only the switch statement itself increments)
class _CognitiveVisitor extends RecursiveAstVisitor<void> {
  /// Creates a new cognitive visitor with initial complexity of 0 and nesting depth of 0.
  _CognitiveVisitor() : complexity = 0, _nestingDepth = 0;

  /// The current cognitive complexity count.
  int complexity;

  /// The current nesting depth for tracking nested structures.
  int _nestingDepth;

  /// Tracks whether we're inside a binary expression to avoid double-counting logical operators.
  bool _inBinaryExpression = false;

  @override
  void visitIfStatement(IfStatement node) {
    // +1 for the if statement itself, plus nesting increment
    complexity += 1 + _nestingDepth;
    _nestingDepth++;
    super.visitIfStatement(node);
    _nestingDepth--;
  }

  @override
  void visitForStatement(ForStatement node) {
    // +1 for the for loop, plus nesting increment
    complexity += 1 + _nestingDepth;
    _nestingDepth++;
    super.visitForStatement(node);
    _nestingDepth--;
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    // +1 for the while loop, plus nesting increment
    complexity += 1 + _nestingDepth;
    _nestingDepth++;
    super.visitWhileStatement(node);
    _nestingDepth--;
  }

  @override
  void visitDoStatement(DoStatement node) {
    // +1 for the do-while loop, plus nesting increment
    complexity += 1 + _nestingDepth;
    _nestingDepth++;
    super.visitDoStatement(node);
    _nestingDepth--;
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    // +1 for the switch statement itself, plus nesting increment
    complexity += 1 + _nestingDepth;
    _nestingDepth++;
    super.visitSwitchStatement(node);
    _nestingDepth--;
  }

  @override
  void visitCatchClause(CatchClause node) {
    // +1 for the catch clause, plus nesting increment
    complexity += 1 + _nestingDepth;
    _nestingDepth++;
    super.visitCatchClause(node);
    _nestingDepth--;
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    // +1 for ternary operator, plus nesting increment
    complexity += 1 + _nestingDepth;
    _nestingDepth++;
    super.visitConditionalExpression(node);
    _nestingDepth--;
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    final String operator = node.operator.lexeme;

    // Only count logical operators (&&, ||) and only once per sequence
    if ((operator == '&&' || operator == '||') && !_inBinaryExpression) {
      complexity += 1;
      _inBinaryExpression = true;
      super.visitBinaryExpression(node);
      _inBinaryExpression = false;
    } else {
      super.visitBinaryExpression(node);
    }
  }

  @override
  void visitBreakStatement(BreakStatement node) {
    // +1 for control flow break
    complexity += 1;
    super.visitBreakStatement(node);
  }

  @override
  void visitContinueStatement(ContinueStatement node) {
    // +1 for control flow break
    complexity += 1;
    super.visitContinueStatement(node);
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    // +1 for control flow break, but only if not the last statement in a function
    // For simplicity, we count all returns except those at nesting depth 0
    if (_nestingDepth > 0) {
      complexity += 1;
    }
    super.visitReturnStatement(node);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    // +1 for control flow break
    complexity += 1;
    super.visitThrowExpression(node);
  }
}
