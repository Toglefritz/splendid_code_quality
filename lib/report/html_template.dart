part of 'report_generator.dart';

/// Generates HTML content for code quality reports.
class _HtmlTemplate {
  /// Generates a complete HTML report from file metrics.
  static String generate(List<FileMetrics> metrics) {
    final _ReportStats stats = _ReportStats(metrics);

    return '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Code Quality Report</title>
    <style>
        ${_generateStyles()}
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>Code Quality Report</h1>
            <p class="subtitle">Generated on ${DateTime.now().toString().split('.')[0]}</p>
        </header>

        ${_generateOverviewSection(stats)}
        ${_generateMetricsSummary(stats)}
        ${_generateHotspotsSection(metrics)}
        ${_generateFileListSection(metrics)}
    </div>
</body>
</html>
''';
  }

  static String _generateStyles() {
    return '''
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: #f5f7fa;
            color: #2c3e50;
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        h1 {
            color: #2c3e50;
            font-size: 2em;
            margin-bottom: 10px;
        }

        .subtitle {
            color: #7f8c8d;
            font-size: 0.9em;
        }

        h2 {
            color: #2c3e50;
            font-size: 1.5em;
            margin-bottom: 20px;
        }

        .section {
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #3498db;
        }

        .stat-label {
            color: #7f8c8d;
            font-size: 0.85em;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .stat-value {
            font-size: 2em;
            font-weight: bold;
            color: #2c3e50;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .metric-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
        }

        .metric-name {
            font-weight: 600;
            margin-bottom: 10px;
            color: #2c3e50;
        }

        .metric-bar {
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
            margin-bottom: 8px;
        }

        .metric-fill {
            height: 100%;
            transition: width 0.3s ease;
        }

        .metric-fill.good { background: #27ae60; }
        .metric-fill.warning { background: #f39c12; }
        .metric-fill.critical { background: #e74c3c; }

        .metric-stats {
            display: flex;
            justify-content: space-between;
            font-size: 0.85em;
            color: #7f8c8d;
        }

        .hotspots-list {
            list-style: none;
        }

        .hotspot-item {
            padding: 15px;
            margin-bottom: 10px;
            background: #f8f9fa;
            border-radius: 6px;
            border-left: 4px solid #e74c3c;
        }

        .hotspot-file {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .hotspot-metrics {
            font-size: 0.9em;
            color: #7f8c8d;
        }

        .file-table {
            width: 100%;
            border-collapse: collapse;
        }

        .file-table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e0e0e0;
        }

        .file-table td {
            padding: 12px;
            border-bottom: 1px solid #e0e0e0;
        }

        .file-table tr:hover {
            background: #f8f9fa;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 0.85em;
            font-weight: 600;
        }

        .status-badge.good {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.warning {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.critical {
            background: #f8d7da;
            color: #721c24;
        }

        .file-path {
            font-family: 'Courier New', monospace;
            font-size: 0.9em;
            color: #2c3e50;
        }
    ''';
  }

  static String _generateOverviewSection(_ReportStats stats) {
    return '''
        <div class="section">
            <h2>Overview</h2>
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-label">Total Files</div>
                    <div class="stat-value">${stats.totalFiles}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Total Lines of Code</div>
                    <div class="stat-value">${stats.totalLinesOfCode}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Files with Issues</div>
                    <div class="stat-value">${stats.filesWithIssues}</div>
                </div>
                <div class="stat-card">
                    <div class="stat-label">Critical Files</div>
                    <div class="stat-value">${stats.criticalFiles}</div>
                </div>
            </div>
        </div>
    ''';
  }

  static String _generateMetricsSummary(_ReportStats stats) {
    return '''
        <div class="section">
            <h2>Metrics Summary</h2>
            <div class="metrics-grid">
                ${_generateMetricCard('Cyclomatic Complexity', stats.avgCyclomaticComplexity, stats.maxCyclomaticComplexity, 20)}
                ${_generateMetricCard('Cognitive Complexity', stats.avgCognitiveComplexity, stats.maxCognitiveComplexity, 25)}
                ${_generateMetricCard('Lines of Code', stats.avgLinesOfCode.toInt(), stats.maxLinesOfCode, 500)}
                ${_generateMetricCard('Halstead Volume', stats.avgHalsteadVolume.toInt(), stats.maxHalsteadVolume.toInt(), 2000)}
                ${_generateMetricCard('Depth of Inheritance', stats.avgDepthOfInheritance.toInt(), stats.maxDepthOfInheritance, 4)}
            </div>
        </div>
    ''';
  }

  static String _generateMetricCard(String name, num avg, num max, num threshold) {
    String status;
    double percentage;

    // Determine status based on max value and appropriate thresholds
    if (name.contains('Cyclomatic')) {
      if (max <= 10) {
        status = 'good';
        percentage = (max / 10 * 50).clamp(0, 50);
      } else if (max <= 20) {
        status = 'warning';
        percentage = 50 + ((max - 10) / 10 * 30);
      } else {
        status = 'critical';
        percentage = 80 + ((max - 20) / 20 * 20).clamp(0, 20);
      }
    } else if (name.contains('Cognitive')) {
      if (max <= 15) {
        status = 'good';
        percentage = (max / 15 * 50).clamp(0, 50);
      } else if (max <= 25) {
        status = 'warning';
        percentage = 50 + ((max - 15) / 10 * 30);
      } else {
        status = 'critical';
        percentage = 80 + ((max - 25) / 25 * 20).clamp(0, 20);
      }
    } else if (name.contains('Lines of Code')) {
      if (max <= 200) {
        status = 'good';
        percentage = (max / 200 * 50).clamp(0, 50);
      } else if (max <= 500) {
        status = 'warning';
        percentage = 50 + ((max - 200) / 300 * 30);
      } else {
        status = 'critical';
        percentage = 80 + ((max - 500) / 500 * 20).clamp(0, 20);
      }
    } else if (name.contains('Halstead')) {
      if (max <= 1000) {
        status = 'good';
        percentage = (max / 1000 * 50).clamp(0, 50);
      } else if (max <= 2000) {
        status = 'warning';
        percentage = 50 + ((max - 1000) / 1000 * 30);
      } else {
        status = 'critical';
        percentage = 80 + ((max - 2000) / 2000 * 20).clamp(0, 20);
      }
    } else {
      // Depth of Inheritance
      if (max <= 2) {
        status = 'good';
        percentage = (max / 2 * 50).clamp(0, 50);
      } else if (max <= 4) {
        status = 'warning';
        percentage = 50 + ((max - 2) / 2 * 30);
      } else {
        status = 'critical';
        percentage = 80 + ((max - 4) / 4 * 20).clamp(0, 20);
      }
    }

    return '''
        <div class="metric-card">
            <div class="metric-name">$name</div>
            <div class="metric-bar">
                <div class="metric-fill $status" style="width: ${percentage.toStringAsFixed(0)}%"></div>
            </div>
            <div class="metric-stats">
                <span>Avg: ${avg is int ? avg : avg.toStringAsFixed(1)}</span>
                <span>Max: ${max is int ? max : max.toStringAsFixed(1)}</span>
            </div>
        </div>
    ''';
  }

  static String _generateHotspotsSection(List<FileMetrics> metrics) {
    final List<FileMetrics> hotspots = List<FileMetrics>.from(metrics)
      ..sort((a, b) {
        final int aScore = _calculateProblemScore(a);
        final int bScore = _calculateProblemScore(b);
        return bScore.compareTo(aScore);
      });

    final List<FileMetrics> top10 = hotspots.take(10).toList();

    return '''
        <div class="section">
            <h2>Top 10 Problem Areas</h2>
            <ul class="hotspots-list">
                ${top10.map((m) => _generateHotspotItem(m)).join('\n')}
            </ul>
        </div>
    ''';
  }

  static String _generateHotspotItem(FileMetrics metrics) {
    final List<String> issues = <String>[];
    if (metrics.cyclomaticComplexityStatus != 'good') {
      issues.add('Cyclomatic: ${metrics.cyclomaticComplexity}');
    }
    if (metrics.cognitiveComplexityStatus != 'good') {
      issues.add('Cognitive: ${metrics.cognitiveComplexity}');
    }
    if (metrics.linesOfCodeStatus != 'good') {
      issues.add('LOC: ${metrics.linesOfCode}');
    }
    if (metrics.halsteadVolumeStatus != 'good') {
      issues.add('Volume: ${metrics.halsteadVolume.toStringAsFixed(0)}');
    }
    if (metrics.depthOfInheritanceStatus != 'good') {
      issues.add('Inheritance: ${metrics.depthOfInheritance}');
    }

    return '''
        <li class="hotspot-item">
            <div class="hotspot-file">${metrics.filePath}</div>
            <div class="hotspot-metrics">${issues.join(' • ')}</div>
        </li>
    ''';
  }

  static String _generateFileListSection(List<FileMetrics> metrics) {
    final List<FileMetrics> sortedMetrics = List<FileMetrics>.from(metrics)
      ..sort((a, b) => a.filePath.compareTo(b.filePath));

    return '''
        <div class="section">
            <h2>All Files</h2>
            <table class="file-table">
                <thead>
                    <tr>
                        <th>File</th>
                        <th>Status</th>
                        <th>Cyclomatic</th>
                        <th>Cognitive</th>
                        <th>LOC</th>
                        <th>Volume</th>
                        <th>Inheritance</th>
                    </tr>
                </thead>
                <tbody>
                    ${sortedMetrics.map((m) => _generateFileRow(m)).join('\n')}
                </tbody>
            </table>
        </div>
    ''';
  }

  static String _generateFileRow(FileMetrics metrics) {
    return '''
        <tr>
            <td class="file-path">${metrics.filePath}</td>
            <td><span class="status-badge ${metrics.overallStatus}">${metrics.overallStatus.toUpperCase()}</span></td>
            <td><span class="status-badge ${metrics.cyclomaticComplexityStatus}">${metrics.cyclomaticComplexity}</span></td>
            <td><span class="status-badge ${metrics.cognitiveComplexityStatus}">${metrics.cognitiveComplexity}</span></td>
            <td><span class="status-badge ${metrics.linesOfCodeStatus}">${metrics.linesOfCode}</span></td>
            <td><span class="status-badge ${metrics.halsteadVolumeStatus}">${metrics.halsteadVolume.toStringAsFixed(0)}</span></td>
            <td><span class="status-badge ${metrics.depthOfInheritanceStatus}">${metrics.depthOfInheritance}</span></td>
        </tr>
    ''';
  }

  static int _calculateProblemScore(FileMetrics metrics) {
    int score = 0;
    if (metrics.cyclomaticComplexityStatus == 'critical') score += 3;
    if (metrics.cyclomaticComplexityStatus == 'warning') score += 1;
    if (metrics.cognitiveComplexityStatus == 'critical') score += 3;
    if (metrics.cognitiveComplexityStatus == 'warning') score += 1;
    if (metrics.linesOfCodeStatus == 'critical') score += 3;
    if (metrics.linesOfCodeStatus == 'warning') score += 1;
    if (metrics.halsteadVolumeStatus == 'critical') score += 3;
    if (metrics.halsteadVolumeStatus == 'warning') score += 1;
    if (metrics.depthOfInheritanceStatus == 'critical') score += 3;
    if (metrics.depthOfInheritanceStatus == 'warning') score += 1;
    return score;
  }
}

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
