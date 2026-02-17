part of 'report_generator.dart';

/// Contains all quality metrics for a single file.
class FileMetrics {
  /// Creates file metrics with the given values.
  const FileMetrics({
    required this.filePath,
    required this.cyclomaticComplexity,
    required this.cognitiveComplexity,
    required this.linesOfCode,
    required this.halsteadVolume,
    required this.depthOfInheritance,
  });

  /// The file path.
  final String filePath;

  /// Cyclomatic complexity score.
  final int cyclomaticComplexity;

  /// Cognitive complexity score.
  final int cognitiveComplexity;

  /// Lines of code (non-blank, non-comment).
  final int linesOfCode;

  /// Halstead volume.
  final double halsteadVolume;

  /// Maximum depth of inheritance.
  final int depthOfInheritance;

  /// Returns the health status for cyclomatic complexity.
  String get cyclomaticComplexityStatus {
    if (cyclomaticComplexity <= 10) return 'good';
    if (cyclomaticComplexity <= 20) return 'warning';
    return 'critical';
  }

  /// Returns the health status for cognitive complexity.
  String get cognitiveComplexityStatus {
    if (cognitiveComplexity <= 15) return 'good';
    if (cognitiveComplexity <= 25) return 'warning';
    return 'critical';
  }

  /// Returns the health status for lines of code.
  String get linesOfCodeStatus {
    if (linesOfCode <= 200) return 'good';
    if (linesOfCode <= 500) return 'warning';
    return 'critical';
  }

  /// Returns the health status for Halstead volume.
  String get halsteadVolumeStatus {
    if (halsteadVolume <= 1000) return 'good';
    if (halsteadVolume <= 2000) return 'warning';
    return 'critical';
  }

  /// Returns the health status for depth of inheritance.
  String get depthOfInheritanceStatus {
    if (depthOfInheritance <= 2) return 'good';
    if (depthOfInheritance <= 4) return 'warning';
    return 'critical';
  }

  /// Returns the overall health status (worst of all metrics).
  String get overallStatus {
    final List<String> statuses = <String>[
      cyclomaticComplexityStatus,
      cognitiveComplexityStatus,
      linesOfCodeStatus,
      halsteadVolumeStatus,
      depthOfInheritanceStatus,
    ];

    if (statuses.contains('critical')) return 'critical';
    if (statuses.contains('warning')) return 'warning';
    return 'good';
  }
}
