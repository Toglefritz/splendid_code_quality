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
    <button id="theme-toggle" class="theme-toggle" aria-label="Toggle theme">
        <span class="theme-icon">🌙</span>
    </button>
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
    <script>
        ${_generateThemeScript()}
    </script>
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
            padding: 20px;
            border-radius: 8px;
            transition: background-color 0.3s ease;
        }

        .metric-card.good {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
        }

        .metric-card.warning {
            background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
        }

        .metric-card.critical {
            background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
        }

        .metric-name {
            font-weight: 600;
            margin-bottom: 15px;
            color: #2c3e50;
            font-size: 1.1em;
        }

        .metric-value {
            font-size: 2.5em;
            font-weight: bold;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .metric-label {
            font-size: 0.85em;
            color: #5a6c7d;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 5px;
        }

        .metric-stats {
            display: flex;
            justify-content: space-between;
            font-size: 0.9em;
            color: #5a6c7d;
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid rgba(0,0,0,0.1);
        }

        .metric-threshold {
            font-size: 0.8em;
            color: #5a6c7d;
            font-style: italic;
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
            table-layout: fixed;
        }

        .file-table th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #2c3e50;
            border-bottom: 2px solid #e0e0e0;
        }

        .file-table th:first-child {
            width: 40%;
        }

        .file-table th:nth-child(2) {
            width: 10%;
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
            word-break: break-all;
            overflow-wrap: break-word;
        }

        .theme-toggle {
            position: fixed;
            top: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            background: white;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5em;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            z-index: 1000;
        }

        .theme-toggle:hover {
            transform: scale(1.1);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }

        .theme-toggle:active {
            transform: scale(0.95);
        }

        /* Dark theme styles */
        body.dark-theme {
            background: #1a1a1a;
            color: #e0e0e0;
        }

        body.dark-theme .theme-toggle {
            background: #2d2d2d;
        }

        body.dark-theme header,
        body.dark-theme .section {
            background: #2d2d2d;
            box-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        body.dark-theme h1,
        body.dark-theme h2,
        body.dark-theme .metric-name,
        body.dark-theme .hotspot-file,
        body.dark-theme .file-path {
            color: #e0e0e0;
        }

        body.dark-theme .subtitle,
        body.dark-theme .stat-label,
        body.dark-theme .metric-label,
        body.dark-theme .metric-stats,
        body.dark-theme .metric-threshold,
        body.dark-theme .hotspot-metrics {
            color: #a0a0a0;
        }

        body.dark-theme .stat-card {
            background: #1a1a1a;
            border-left-color: #4a9eff;
        }

        body.dark-theme .stat-value {
            color: #e0e0e0;
        }

        body.dark-theme .metric-card.good {
            background: linear-gradient(135deg, #1a4d2e 0%, #2d5f3f 100%);
        }

        body.dark-theme .metric-card.warning {
            background: linear-gradient(135deg, #5c4a1a 0%, #6e5a2d 100%);
        }

        body.dark-theme .metric-card.critical {
            background: linear-gradient(135deg, #5c1a1a 0%, #6e2d2d 100%);
        }

        body.dark-theme .metric-value {
            color: #ffffff;
        }

        body.dark-theme .hotspot-item {
            background: #1a1a1a;
            border-left-color: #e74c3c;
        }

        body.dark-theme .file-table th {
            background: #1a1a1a;
            border-bottom-color: #404040;
            color: #ffffff;
        }

        body.dark-theme .file-table td {
            border-bottom-color: #404040;
        }

        body.dark-theme .file-table tr:hover {
            background: #1a1a1a;
        }

        body.dark-theme .status-badge.good {
            background: #1a4d2e;
            color: #7bed9f;
        }

        body.dark-theme .status-badge.warning {
            background: #5c4a1a;
            color: #ffd93d;
        }

        body.dark-theme .status-badge.critical {
            background: #5c1a1a;
            color: #ff6b6b;
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
    String goodThreshold;

    // Determine status based on average value and appropriate thresholds
    if (name.contains('Cyclomatic')) {
      goodThreshold = '≤10';
      if (avg <= 10) {
        status = 'good';
      } else if (avg <= 20) {
        status = 'warning';
      } else {
        status = 'critical';
      }
    } else if (name.contains('Cognitive')) {
      goodThreshold = '≤15';
      if (avg <= 15) {
        status = 'good';
      } else if (avg <= 25) {
        status = 'warning';
      } else {
        status = 'critical';
      }
    } else if (name.contains('Lines of Code')) {
      goodThreshold = '≤200';
      if (avg <= 200) {
        status = 'good';
      } else if (avg <= 500) {
        status = 'warning';
      } else {
        status = 'critical';
      }
    } else if (name.contains('Halstead')) {
      goodThreshold = '≤1000';
      if (avg <= 1000) {
        status = 'good';
      } else if (avg <= 2000) {
        status = 'warning';
      } else {
        status = 'critical';
      }
    } else {
      // Depth of Inheritance
      goodThreshold = '≤2';
      if (avg <= 2) {
        status = 'good';
      } else if (avg <= 4) {
        status = 'warning';
      } else {
        status = 'critical';
      }
    }

    final String avgDisplay = avg is int ? avg.toString() : avg.toStringAsFixed(1);
    final String maxDisplay = max is int ? max.toString() : max.toStringAsFixed(1);

    return '''
        <div class="metric-card $status">
            <div class="metric-name">$name</div>
            <div class="metric-label">Average</div>
            <div class="metric-value">$avgDisplay</div>
            <div class="metric-stats">
                <span>Max: $maxDisplay</span>
                <span>Good: $goodThreshold</span>
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
                ${top10.map(_generateHotspotItem).join('\n')}
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
                    ${sortedMetrics.map(_generateFileRow).join('\n')}
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

  /// Generates JavaScript for theme toggle functionality.
  static String _generateThemeScript() {
    return '''
        // Theme toggle functionality
        const themeToggle = document.getElementById('theme-toggle');
        const themeIcon = themeToggle.querySelector('.theme-icon');
        const body = document.body;

        // Load saved theme preference
        const savedTheme = localStorage.getItem('code-quality-theme');
        if (savedTheme === 'dark') {
            body.classList.add('dark-theme');
            themeIcon.textContent = '☀️';
        }

        // Toggle theme on button click
        themeToggle.addEventListener('click', () => {
            body.classList.toggle('dark-theme');
            const isDark = body.classList.contains('dark-theme');
            themeIcon.textContent = isDark ? '☀️' : '🌙';
            localStorage.setItem('code-quality-theme', isDark ? 'dark' : 'light');
        });
    ''';
  }
}
