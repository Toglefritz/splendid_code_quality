/// Analyzes Dart source code to count lines of code.
library;

part 'loc_result.dart';

/// Analyzes Dart source code to count lines of code.
///
/// This analyzer counts total lines, code lines (non-blank, non-comment), comment lines, and blank lines in Dart source
/// files.
class LocAnalyzer {
  /// Analyzes the given Dart source code and returns line count metrics.
  ///
  /// The [sourceCode] parameter contains the Dart code to analyze. Returns a [LocResult] containing the line count
  /// analysis.
  LocResult analyze(String sourceCode) {
    final List<String> lines = sourceCode.split('\n');
    int codeLines = 0;
    int commentLines = 0;
    int blankLines = 0;
    bool inBlockComment = false;

    for (final String line in lines) {
      final String trimmedLine = line.trim();

      // Check for blank lines
      if (trimmedLine.isEmpty) {
        blankLines++;
        continue;
      }

      // Check for block comment start/end
      if (trimmedLine.startsWith('/*')) {
        inBlockComment = true;
      }

      // Check if we're in a block comment
      if (inBlockComment) {
        commentLines++;
        if (trimmedLine.endsWith('*/')) {
          inBlockComment = false;
        }
        continue;
      }

      // Check for single-line comments
      if (trimmedLine.startsWith('//') || trimmedLine.startsWith('///')) {
        commentLines++;
        continue;
      }

      // If we get here, it's a code line
      codeLines++;
    }

    return LocResult(
      totalLines: lines.length,
      codeLines: codeLines,
      commentLines: commentLines,
      blankLines: blankLines,
    );
  }
}
