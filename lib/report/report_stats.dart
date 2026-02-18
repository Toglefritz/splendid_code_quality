part of 'report_generator.dart';

/// Statistics calculated from file metrics.
class _ReportStats {
  _ReportStats(List<FileMetrics> metrics)
    : totalFiles = metrics.length,
      totalLinesOfCode = metrics.fold(0, (sum, m) => sum + m.linesOfCode),
      filesWithIssues = metrics.where((m) => m.overallStatus != 'good').length,
      criticalFiles = metrics.where((m) => m.overallStatus == 'critical').length,
      avgCyclomaticComplexity = metrics.fold(0, (sum, m) => sum + m.cyclomaticComplexity) / metrics.length,
      maxCyclomaticComplexity = metrics.map((m) => m.cyclomaticComplexity).reduce((a, b) => a > b ? a : b),
      avgCognitiveComplexity = metrics.fold(0, (sum, m) => sum + m.cognitiveComplexity) / metrics.length,
      maxCognitiveComplexity = metrics.map((m) => m.cognitiveComplexity).reduce((a, b) => a > b ? a : b),
      avgLinesOfCode = metrics.fold(0, (sum, m) => sum + m.linesOfCode) / metrics.length,
      maxLinesOfCode = metrics.map((m) => m.linesOfCode).reduce((a, b) => a > b ? a : b),
      avgHalsteadVolume = metrics.fold(0.0, (sum, m) => sum + m.halsteadVolume) / metrics.length,
      maxHalsteadVolume = metrics.map((m) => m.halsteadVolume).reduce((a, b) => a > b ? a : b),
      avgDepthOfInheritance = metrics.fold(0, (sum, m) => sum + m.depthOfInheritance) / metrics.length,
      maxDepthOfInheritance = metrics.map((m) => m.depthOfInheritance).reduce((a, b) => a > b ? a : b);

  final int totalFiles;
  final int totalLinesOfCode;
  final int filesWithIssues;
  final int criticalFiles;
  final double avgCyclomaticComplexity;
  final int maxCyclomaticComplexity;
  final double avgCognitiveComplexity;
  final int maxCognitiveComplexity;
  final double avgLinesOfCode;
  final int maxLinesOfCode;
  final double avgHalsteadVolume;
  final double maxHalsteadVolume;
  final double avgDepthOfInheritance;
  final int maxDepthOfInheritance;
}
