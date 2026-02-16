# Example Flutter Project

A Flutter application used to demonstrate and test the Splendid Code Quality CLI tool.

## Purpose

This example project serves as a test bed for the Splendid Code Quality analyzer. It contains real Flutter code following MVC architecture patterns, providing a realistic codebase for testing quality metrics like cyclomatic complexity and lines of code analysis.

## Testing with Splendid Code Quality

From the root of the splendid_code_quality project, you can analyze this example:

```bash
# Analyze cyclomatic complexity
dart bin/splendid_code_quality.dart complexity example/lib

# Analyze lines of code
dart bin/splendid_code_quality.dart loc example/lib

# Analyze a specific file
dart bin/splendid_code_quality.dart complexity example/lib/main.dart
```
