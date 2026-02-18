/// Generates HTML reports for code quality metrics.
library;

import 'dart:io';
import '../cognitive_complexity/cognitive_complexity_analyzer.dart';
import '../cyclomatic_complexity/cyclomatic_complexity_analyzer.dart';
import '../depth_of_inheritance/depth_of_inheritance_analyzer.dart';
import '../halstead/halstead_analyzer.dart';
import '../lines_of_code/loc_analyzer.dart';

part 'file_metrics.dart';
part 'html_template.dart';
part 'report_stats.dart';

/// Generates HTML reports summarizing code quality metrics across a codebase.
///
/// This generator analyzes all Dart files in a directory and produces an interactive HTML report showing metrics,
/// trends, and problem areas.
class ReportGenerator {
  /// Generates an HTML report for the given directory path.
  ///
  /// Analyzes all Dart files in [directoryPath] and writes an HTML report to [outputPath]. Returns true if the report
  /// was generated successfully.
  Future<bool> generate(String directoryPath, String outputPath) async {
    final Directory directory = Directory(directoryPath);

    if (!directory.existsSync()) {
      print('Error: Directory does not exist: $directoryPath');
      return false;
    }

    final List<File> dartFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList();

    if (dartFiles.isEmpty) {
      print('Error: No Dart files found in directory: $directoryPath');
      return false;
    }

    print('Analyzing ${dartFiles.length} Dart file(s)...');

    final List<FileMetrics> allMetrics = <FileMetrics>[];

    for (final File file in dartFiles) {
      final String sourceCode = file.readAsStringSync();
      final FileMetrics metrics = _analyzeFile(file.path, sourceCode);
      allMetrics.add(metrics);
    }

    final String html = _HtmlTemplate.generate(allMetrics);
    final File outputFile = File(outputPath);
    await outputFile.writeAsString(html);

    print('Report generated: $outputPath');
    return true;
  }

  /// Analyzes a single file and returns its metrics.
  FileMetrics _analyzeFile(String filePath, String sourceCode) {
    final CyclomaticComplexityAnalyzer complexityAnalyzer = CyclomaticComplexityAnalyzer();
    final ComplexityResult complexityResult = complexityAnalyzer.analyze(sourceCode);

    final CognitiveComplexityAnalyzer cognitiveAnalyzer = CognitiveComplexityAnalyzer();
    final CognitiveResult cognitiveResult = cognitiveAnalyzer.analyze(sourceCode);

    final LocAnalyzer locAnalyzer = LocAnalyzer();
    final LocResult locResult = locAnalyzer.analyze(sourceCode);

    final HalsteadAnalyzer halsteadAnalyzer = HalsteadAnalyzer();
    final HalsteadResult halsteadResult = halsteadAnalyzer.analyze(sourceCode);

    final DepthOfInheritanceAnalyzer inheritanceAnalyzer = DepthOfInheritanceAnalyzer();
    final InheritanceResult inheritanceResult = inheritanceAnalyzer.analyze(sourceCode);

    return FileMetrics(
      filePath: filePath,
      cyclomaticComplexity: complexityResult.complexity,
      cognitiveComplexity: cognitiveResult.complexity,
      linesOfCode: locResult.codeLines,
      halsteadVolume: halsteadResult.volume,
      depthOfInheritance: inheritanceResult.maxDepth,
    );
  }
}
