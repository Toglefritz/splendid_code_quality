part of 'halstead_analyzer.dart';

/// AST visitor that collects operators and operands for Halstead metrics calculation.
///
/// This visitor traverses the AST and tracks all operators (keywords, symbols, function calls) and operands
/// (identifiers, literals) to calculate Halstead complexity metrics.
class _HalsteadVisitor extends RecursiveAstVisitor<void> {
  /// Creates a new Halstead visitor.
  _HalsteadVisitor() : _operators = <String>{}, _operands = <String>{}, _operatorCount = 0, _operandCount = 0;

  /// Set of unique operators encountered.
  final Set<String> _operators;

  /// Set of unique operands encountered.
  final Set<String> _operands;

  /// Total count of all operators.
  int _operatorCount;

  /// Total count of all operands.
  int _operandCount;

  @override
  void visitBinaryExpression(BinaryExpression node) {
    _addOperator(node.operator.lexeme);
    super.visitBinaryExpression(node);
  }

  @override
  void visitPrefixExpression(PrefixExpression node) {
    _addOperator(node.operator.lexeme);
    super.visitPrefixExpression(node);
  }

  @override
  void visitPostfixExpression(PostfixExpression node) {
    _addOperator(node.operator.lexeme);
    super.visitPostfixExpression(node);
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    _addOperator(node.operator.lexeme);
    super.visitAssignmentExpression(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    _addOperator('()');
    super.visitMethodInvocation(node);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    _addOperator('()');
    super.visitFunctionExpressionInvocation(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    _addOperator('new');
    super.visitInstanceCreationExpression(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    _addOperator('if');
    super.visitIfStatement(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    _addOperator('for');
    super.visitForStatement(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _addOperator('while');
    super.visitWhileStatement(node);
  }

  @override
  void visitDoStatement(DoStatement node) {
    _addOperator('do');
    super.visitDoStatement(node);
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    _addOperator('switch');
    super.visitSwitchStatement(node);
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    _addOperator('return');
    super.visitReturnStatement(node);
  }

  @override
  void visitBreakStatement(BreakStatement node) {
    _addOperator('break');
    super.visitBreakStatement(node);
  }

  @override
  void visitContinueStatement(ContinueStatement node) {
    _addOperator('continue');
    super.visitContinueStatement(node);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    _addOperator('throw');
    super.visitThrowExpression(node);
  }

  @override
  void visitTryStatement(TryStatement node) {
    _addOperator('try');
    super.visitTryStatement(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    _addOperator('catch');
    super.visitCatchClause(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    _addOperator('?:');
    super.visitConditionalExpression(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    _addOperand(node.name);
    super.visitSimpleIdentifier(node);
  }

  @override
  void visitIntegerLiteral(IntegerLiteral node) {
    _addOperand(node.literal.lexeme);
    super.visitIntegerLiteral(node);
  }

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    _addOperand(node.literal.lexeme);
    super.visitDoubleLiteral(node);
  }

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    _addOperand(node.literal.lexeme);
    super.visitSimpleStringLiteral(node);
  }

  @override
  void visitBooleanLiteral(BooleanLiteral node) {
    _addOperand(node.literal.lexeme);
    super.visitBooleanLiteral(node);
  }

  @override
  void visitNullLiteral(NullLiteral node) {
    _addOperand('null');
    super.visitNullLiteral(node);
  }

  /// Adds an operator to the tracking sets.
  void _addOperator(String operator) {
    _operators.add(operator);
    _operatorCount++;
  }

  /// Adds an operand to the tracking sets.
  void _addOperand(String operand) {
    _operands.add(operand);
    _operandCount++;
  }

  /// Calculates and returns the Halstead metrics based on collected data.
  HalsteadResult calculateResult() {
    final int n1 = _operators.length;
    final int n2 = _operands.length;
    final int N1 = _operatorCount;
    final int N2 = _operandCount;

    final int vocabulary = n1 + n2;
    final int length = N1 + N2;

    final double volume = vocabulary > 0 ? length * (math.log(vocabulary) / math.ln2) : 0.0;
    final double difficulty = n2 > 0 ? (n1 / 2.0) * (N2 / n2) : 0.0;
    final double effort = difficulty * volume;

    return HalsteadResult(
      uniqueOperators: n1,
      uniqueOperands: n2,
      totalOperators: N1,
      totalOperands: N2,
      vocabulary: vocabulary,
      length: length,
      volume: volume,
      difficulty: difficulty,
      effort: effort,
    );
  }
}
