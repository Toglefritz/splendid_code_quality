part of 'depth_of_inheritance_analyzer.dart';

/// Contains the results of a depth of inheritance analysis.
class InheritanceResult {
  /// Creates an inheritance result with the calculated metrics.
  const InheritanceResult({
    required this.maxDepth,
    required this.classDepths,
  });

  /// The maximum depth of inheritance found in the analyzed code.
  ///
  /// A depth of 0 means no classes with inheritance were found. A depth of 1 means classes directly extend a base
  /// class. Higher values indicate deeper inheritance hierarchies.
  final int maxDepth;

  /// Map of class names to their inheritance depths.
  ///
  /// Classes with no explicit superclass (or extending Object) have depth 0. Each level of inheritance adds 1 to the
  /// depth.
  final Map<String, int> classDepths;
}
