import 'dart:io';

import 'package:args/args.dart';
import 'package:pubspec_parse/pubspec_parse.dart';
import 'cognitive_complexity/cognitive_complexity_analyzer.dart';
import 'cyclomatic_complexity/cyclomatic_complexity_analyzer.dart';
import 'lines_of_code/loc_analyzer.dart';

/// Runs the Splendid Code Quality CLI tool.
///
/// This class handles command-line argument parsing, command routing, and execution of quality analysis commands.
class CliRunner {
  /// Creates a new CLI runner.
  CliRunner();

  /// The version of the tool, read from pubspec.yaml.
  late final String version = _loadVersion();

  /// Runs the CLI with the given command-line [arguments].
  ///
  /// Returns an exit code: 0 for success, non-zero for errors.
  Future<int> run(List<String> arguments) async {
    final ArgParser argParser = _buildParser();

    try {
      final ArgResults results = argParser.parse(arguments);

      // Process global flags
      if (results.flag('help')) {
        _printUsage(argParser);
        return 0;
      }
      if (results.flag('version')) {
        print('splendid_code_quality version: $version');
        return 0;
      }

      // Process commands
      if (results.command?.name == 'complexity') {
        return _handleComplexityCommand(results.command!);
      }
      if (results.command?.name == 'loc') {
        return _handleLocCommand(results.command!);
      }
      if (results.command?.name == 'cognitive') {
        return _handleCognitiveCommand(results.command!);
      }

      // No command provided
      _printUsage(argParser);
      return 0;
    } on FormatException catch (e) {
      print(e.message);
      print('');
      _printUsage(argParser);
      return 1;
    }
  }

  ArgParser _buildParser() {
    return ArgParser()
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Print this usage information.',
      )
      ..addFlag(
        'version',
        negatable: false,
        help: 'Print the tool version.',
      )
      ..addCommand('complexity', _buildComplexityParser())
      ..addCommand('loc', _buildLocParser())
      ..addCommand('cognitive', _buildCognitiveParser());
  }

  ArgParser _buildComplexityParser() {
    return ArgParser()..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print usage information for the complexity command.',
    );
  }

  ArgParser _buildLocParser() {
    return ArgParser()..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print usage information for the loc command.',
    );
  }

  ArgParser _buildCognitiveParser() {
    return ArgParser()..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print usage information for the cognitive command.',
    );
  }

  void _printUsage(ArgParser argParser) {
    print('Usage: dart splendid_code_quality.dart <command> [arguments]');
    print('');
    print('Available commands:');
    print('  complexity <file|directory>  Analyze cyclomatic complexity');
    print('  cognitive <file|directory>   Analyze cognitive complexity');
    print('  loc <file|directory>         Analyze lines of code');
    print('');
    print('Global options:');
    print(argParser.usage);
  }

  void _printComplexityUsage() {
    print('Usage: dart splendid_code_quality.dart complexity <file|directory>');
    print('');
    print('Analyzes cyclomatic complexity of Dart source files.');
    print('');
    print('Arguments:');
    print('  <file|directory>  Path to a Dart file or directory to analyze');
  }

  void _printLocUsage() {
    print('Usage: dart splendid_code_quality.dart loc <file|directory>');
    print('');
    print('Analyzes lines of code in Dart source files.');
    print('');
    print('Arguments:');
    print('  <file|directory>  Path to a Dart file or directory to analyze');
  }

  void _printCognitiveUsage() {
    print('Usage: dart splendid_code_quality.dart cognitive <file|directory>');
    print('');
    print('Analyzes cognitive complexity of Dart source files.');
    print('Cognitive complexity measures how difficult code is to understand.');
    print('');
    print('Arguments:');
    print('  <file|directory>  Path to a Dart file or directory to analyze');
  }

  int _handleComplexityCommand(ArgResults results) {
    if (results.flag('help')) {
      _printComplexityUsage();
      return 0;
    }

    if (results.rest.isEmpty) {
      print('Error: No file or directory specified.');
      print('');
      _printComplexityUsage();
      return 1;
    }

    final String path = results.rest[0];
    final FileSystemEntity entity = FileSystemEntity.typeSync(path) == FileSystemEntityType.directory
        ? Directory(path)
        : File(path);

    if (!entity.existsSync()) {
      print('Error: Path does not exist: $path');
      return 1;
    }

    if (entity is File) {
      _analyzeFile(entity);
    } else if (entity is Directory) {
      _analyzeDirectory(entity);
    }

    return 0;
  }

  void _analyzeFile(File file) {
    if (!file.path.endsWith('.dart')) {
      print('Error: File must be a Dart file (.dart extension)');
      exit(1);
    }

    final String sourceCode = file.readAsStringSync();
    final CyclomaticComplexityAnalyzer analyzer = CyclomaticComplexityAnalyzer();
    final ComplexityResult result = analyzer.analyze(sourceCode);

    print('File: ${file.path}');
    print('Cyclomatic Complexity: ${result.complexity}');
  }

  void _analyzeDirectory(Directory directory) {
    final List<File> dartFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList();

    if (dartFiles.isEmpty) {
      print('No Dart files found in directory: ${directory.path}');
      return;
    }

    print('Analyzing ${dartFiles.length} Dart file(s) in ${directory.path}');
    print('');

    final CyclomaticComplexityAnalyzer analyzer = CyclomaticComplexityAnalyzer();
    int totalComplexity = 0;
    int maxComplexity = 0;
    String maxComplexityFile = '';

    for (final File file in dartFiles) {
      final String sourceCode = file.readAsStringSync();
      final ComplexityResult result = analyzer.analyze(sourceCode);
      totalComplexity += result.complexity;

      if (result.complexity > maxComplexity) {
        maxComplexity = result.complexity;
        maxComplexityFile = file.path;
      }

      print('${file.path}: ${result.complexity}');
    }

    print('');
    print('Total files analyzed: ${dartFiles.length}');
    print('Average complexity: ${(totalComplexity / dartFiles.length).toStringAsFixed(1)}');
    print('Maximum complexity: $maxComplexity ($maxComplexityFile)');
  }

  int _handleLocCommand(ArgResults results) {
    if (results.flag('help')) {
      _printLocUsage();
      return 0;
    }

    if (results.rest.isEmpty) {
      print('Error: No file or directory specified.');
      print('');
      _printLocUsage();
      return 1;
    }

    final String path = results.rest[0];
    final FileSystemEntity entity = FileSystemEntity.typeSync(path) == FileSystemEntityType.directory
        ? Directory(path)
        : File(path);

    if (!entity.existsSync()) {
      print('Error: Path does not exist: $path');
      return 1;
    }

    if (entity is File) {
      _analyzeLocFile(entity);
    } else if (entity is Directory) {
      _analyzeLocDirectory(entity);
    }

    return 0;
  }

  void _analyzeLocFile(File file) {
    if (!file.path.endsWith('.dart')) {
      print('Error: File must be a Dart file (.dart extension)');
      exit(1);
    }

    final String sourceCode = file.readAsStringSync();
    final LocAnalyzer analyzer = LocAnalyzer();
    final LocResult result = analyzer.analyze(sourceCode);

    print('File: ${file.path}');
    print('Total lines: ${result.totalLines}');
    print('Code lines: ${result.codeLines}');
    print('Comment lines: ${result.commentLines}');
    print('Blank lines: ${result.blankLines}');
  }

  void _analyzeLocDirectory(Directory directory) {
    final List<File> dartFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList();

    if (dartFiles.isEmpty) {
      print('No Dart files found in directory: ${directory.path}');
      return;
    }

    print('Analyzing ${dartFiles.length} Dart file(s) in ${directory.path}');
    print('');

    final LocAnalyzer analyzer = LocAnalyzer();
    int totalLines = 0;
    int totalCodeLines = 0;
    int totalCommentLines = 0;
    int totalBlankLines = 0;
    int maxCodeLines = 0;
    String maxCodeLinesFile = '';

    for (final File file in dartFiles) {
      final String sourceCode = file.readAsStringSync();
      final LocResult result = analyzer.analyze(sourceCode);

      totalLines += result.totalLines;
      totalCodeLines += result.codeLines;
      totalCommentLines += result.commentLines;
      totalBlankLines += result.blankLines;

      if (result.codeLines > maxCodeLines) {
        maxCodeLines = result.codeLines;
        maxCodeLinesFile = file.path;
      }

      print('${file.path}: ${result.codeLines} code lines');
    }

    print('');
    print('Total files analyzed: ${dartFiles.length}');
    print('Total lines: $totalLines');
    print('Total code lines: $totalCodeLines');
    print('Total comment lines: $totalCommentLines');
    print('Total blank lines: $totalBlankLines');
    print('Average code lines per file: ${(totalCodeLines / dartFiles.length).toStringAsFixed(1)}');
    print('Maximum code lines: $maxCodeLines ($maxCodeLinesFile)');
  }

  String _loadVersion() {
    try {
      final File pubspecFile = File('pubspec.yaml');
      final String pubspecContent = pubspecFile.readAsStringSync();
      final Pubspec pubspec = Pubspec.parse(pubspecContent);
      return pubspec.version?.toString() ?? 'unknown';
    } catch (e) {
      return 'unknown';
    }
  }

  int _handleCognitiveCommand(ArgResults results) {
    if (results.flag('help')) {
      _printCognitiveUsage();
      return 0;
    }

    if (results.rest.isEmpty) {
      print('Error: No file or directory specified.');
      print('');
      _printCognitiveUsage();
      return 1;
    }

    final String path = results.rest[0];
    final FileSystemEntity entity = FileSystemEntity.typeSync(path) == FileSystemEntityType.directory
        ? Directory(path)
        : File(path);

    if (!entity.existsSync()) {
      print('Error: Path does not exist: $path');
      return 1;
    }

    if (entity is File) {
      _analyzeCognitiveFile(entity);
    } else if (entity is Directory) {
      _analyzeCognitiveDirectory(entity);
    }

    return 0;
  }

  void _analyzeCognitiveFile(File file) {
    if (!file.path.endsWith('.dart')) {
      print('Error: File must be a Dart file (.dart extension)');
      exit(1);
    }

    final String sourceCode = file.readAsStringSync();
    final CognitiveComplexityAnalyzer analyzer = CognitiveComplexityAnalyzer();
    final CognitiveResult result = analyzer.analyze(sourceCode);

    print('File: ${file.path}');
    print('Cognitive Complexity: ${result.complexity}');
  }

  void _analyzeCognitiveDirectory(Directory directory) {
    final List<File> dartFiles = directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList();

    if (dartFiles.isEmpty) {
      print('No Dart files found in directory: ${directory.path}');
      return;
    }

    print('Analyzing ${dartFiles.length} Dart file(s) in ${directory.path}');
    print('');

    final CognitiveComplexityAnalyzer analyzer = CognitiveComplexityAnalyzer();
    int totalComplexity = 0;
    int maxComplexity = 0;
    String maxComplexityFile = '';

    for (final File file in dartFiles) {
      final String sourceCode = file.readAsStringSync();
      final CognitiveResult result = analyzer.analyze(sourceCode);
      totalComplexity += result.complexity;

      if (result.complexity > maxComplexity) {
        maxComplexity = result.complexity;
        maxComplexityFile = file.path;
      }

      print('${file.path}: ${result.complexity}');
    }

    print('');
    print('Total files analyzed: ${dartFiles.length}');
    print('Average complexity: ${(totalComplexity / dartFiles.length).toStringAsFixed(1)}');
    print('Maximum complexity: $maxComplexity ($maxComplexityFile)');
  }
}
