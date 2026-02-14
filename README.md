# Splendid Code Quality

A Dart CLI tool for analyzing and measuring code quality in Dart projects.

## Overview

Splendid Code Quality helps software engineers understand and improve the quality of their Dart codebases through industry-standard quality metrics and analysis techniques. The tool focuses on measurement and insight rather than automatic code modification, empowering developers to make informed decisions about code improvements.

## Key Features

- **Quality Metrics Analysis**: Measure code quality using established industry-standard metrics
- **Flexible Usage**: Run as a standalone CLI tool or integrate as a Dart analyzer plugin
- **Clear Reporting**: Generate easy-to-understand analysis reports with aesthetic design
- **CI/CD Integration**: Use in automated pipelines for continuous quality monitoring

## Supported Quality Metrics

### Cyclomatic Complexity

Cyclomatic complexity measures the number of independent paths through a program's source code by counting decision points (if statements, loops, case statements, etc.). A function with no branching has a complexity of 1, while each additional decision point increases the complexity.

**How to use this metric:**
- Functions with high complexity (typically >10) are harder to test, understand, and maintain
- Identify candidates for refactoring by breaking complex functions into smaller, focused units
- Set complexity thresholds in CI/CD pipelines to prevent overly complex code from being merged
- Track complexity trends over time to ensure code maintainability doesn't degrade

### Lines of Code (LOC)

Lines of Code measures the size of code units (functions, classes, files) by counting non-blank, non-comment source lines. This metric provides insight into code volume and potential maintenance burden.

**How to use this metric:**
- Long functions (typically >50 LOC) often indicate multiple responsibilities and refactoring opportunities
- Large files (typically >500 LOC) may benefit from being split into smaller, more focused modules
- Compare LOC across similar components to identify inconsistencies in implementation approach
- Monitor LOC growth in specific areas to detect feature creep or architectural drift

### Code Duplication

Code duplication identifies repeated or nearly identical code blocks across the codebase. Duplication increases maintenance burden since changes must be applied in multiple locations and raises the risk of inconsistent bug fixes.

**How to use this metric:**
- Extract duplicated logic into shared functions, classes, or utilities
- Identify copy-paste patterns that suggest missing abstractions
- Prioritize refactoring high-duplication areas where bugs are likely to require multiple fixes
- Set duplication thresholds to maintain DRY (Don't Repeat Yourself) principles
