import 'dart:io';

import 'package:splendid_code_quality/cli_runner.dart';

/// The entrypoint for the Splendid Code Quality tool.
Future<void> main(List<String> arguments) async {
  final CliRunner runner = CliRunner();
  final int exitCode = await runner.run(arguments);

  exit(exitCode);
}
