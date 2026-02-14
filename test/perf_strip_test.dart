import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/src/ansiutils.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  final c = Chalk();

  // Build styled strings of various sizes and code densities
  // Short: ~50 visible chars, 2 ANSI code pairs
  final shortStyled = c.red('hello ') + c.blue('world, this is a short test string!!');

  // Medium: ~500 visible chars, ~10 ANSI code pairs
  final mediumParts = <String>[];
  for (var i = 0; i < 10; i++) {
    final colors = [c.red, c.green, c.blue, c.yellow, c.magenta, c.cyan, c.white, c.brightRed, c.brightGreen, c.brightBlue];
    mediumParts.add(colors[i % colors.length]('segment $i ' + 'x' * 40));
  }
  final mediumStyled = mediumParts.join();

  // Long: ~5000 visible chars, ~50 ANSI code pairs
  final longParts = <String>[];
  for (var i = 0; i < 50; i++) {
    final colors = [c.red, c.green, c.blue, c.yellow, c.magenta];
    longParts.add(colors[i % colors.length]('segment $i ' + 'x' * 90));
  }
  final longStyled = longParts.join();

  // Heavily styled: ~100 visible chars but 50 code pairs (high density)
  final heavyParts = <String>[];
  for (var i = 0; i < 50; i++) {
    heavyParts.add(c.red('ab'));
  }
  final heavyStyled = heavyParts.join();

  // Plain text (no ANSI codes at all)
  final plainShort = 'hello world, this is a plain test string!!';
  final plainMedium = 'x' * 500;
  final plainLong = 'x' * 5000;

  // Deeply nested styled text
  String nested = 'core';
  final colors = [c.red, c.green, c.blue, c.yellow, c.magenta, c.cyan, c.white, c.brightRed, c.brightGreen, c.brightBlue];
  for (var i = 0; i < 10; i++) {
    nested = colors[i % colors.length]('w$i $nested w$i');
  }
  final deepNested = nested;

  group('Strip & Utility Operations Performance', () {
    test('benchmarks', () {
      final suite = BenchmarkSuite('Strip & Utility Operations');

      // --- stripAnsi by size ---
      suite.add(runBenchmark(
        name: 'stripAnsi - short (50 chars, 2 codes)',
        iterations: 100000,
        operation: () => AnsiUtils.stripAnsi(shortStyled),
      ));

      suite.add(runBenchmark(
        name: 'stripAnsi - medium (500 chars, 10 codes)',
        iterations: 50000,
        operation: () => AnsiUtils.stripAnsi(mediumStyled),
      ));

      suite.add(runBenchmark(
        name: 'stripAnsi - long (5K chars, 50 codes)',
        iterations: 10000,
        operation: () => AnsiUtils.stripAnsi(longStyled),
      ));

      // --- stripAnsi by code density ---
      suite.add(runBenchmark(
        name: 'stripAnsi - heavy (100 chars, 50 codes)',
        iterations: 50000,
        operation: () => AnsiUtils.stripAnsi(heavyStyled),
      ));

      suite.add(runBenchmark(
        name: 'stripAnsi - deeply nested (10 levels)',
        iterations: 50000,
        operation: () => AnsiUtils.stripAnsi(deepNested),
      ));

      // --- stripAnsi on plain text (no codes) ---
      suite.add(runBenchmark(
        name: 'stripAnsi - plain short (no codes)',
        iterations: 100000,
        operation: () => AnsiUtils.stripAnsi(plainShort),
      ));

      suite.add(runBenchmark(
        name: 'stripAnsi - plain medium (no codes)',
        iterations: 100000,
        operation: () => AnsiUtils.stripAnsi(plainMedium),
      ));

      suite.add(runBenchmark(
        name: 'stripAnsi - plain long (no codes)',
        iterations: 50000,
        operation: () => AnsiUtils.stripAnsi(plainLong),
      ));

      // --- chalk.strip() instance method ---
      suite.add(runBenchmark(
        name: 'chalk.strip() - short styled',
        iterations: 100000,
        operation: () => c.strip(shortStyled),
      ));

      suite.add(runBenchmark(
        name: 'chalk.strip() - medium styled',
        iterations: 50000,
        operation: () => c.strip(mediumStyled),
      ));

      // --- hasAnsi detection ---
      suite.add(runBenchmark(
        name: 'hasAnsi - styled (positive)',
        iterations: 200000,
        operation: () => AnsiUtils.hasAnsi(shortStyled),
      ));

      suite.add(runBenchmark(
        name: 'hasAnsi - plain (negative)',
        iterations: 200000,
        operation: () => AnsiUtils.hasAnsi(plainShort),
      ));

      suite.add(runBenchmark(
        name: 'hasAnsi - long styled (positive)',
        iterations: 200000,
        operation: () => AnsiUtils.hasAnsi(longStyled),
      ));

      suite.add(runBenchmark(
        name: 'hasAnsi - long plain (negative)',
        iterations: 200000,
        operation: () => AnsiUtils.hasAnsi(plainLong),
      ));

      // --- ansiRegex direct matching ---
      suite.add(runBenchmark(
        name: 'ansiRegex.hasMatch - styled',
        iterations: 200000,
        operation: () => AnsiUtils.ansiRegex.hasMatch(shortStyled),
      ));

      suite.add(runBenchmark(
        name: 'ansiRegex.hasMatch - plain',
        iterations: 200000,
        operation: () => AnsiUtils.ansiRegex.hasMatch(plainShort),
      ));

      // --- lengthWithoutAnsi extension ---
      suite.add(runBenchmark(
        name: 'lengthWithoutAnsi - short styled',
        iterations: 100000,
        operation: () => shortStyled.lengthWithoutAnsi,
      ));

      suite.add(runBenchmark(
        name: 'lengthWithoutAnsi - medium styled',
        iterations: 50000,
        operation: () => mediumStyled.lengthWithoutAnsi,
      ));

      suite.add(runBenchmark(
        name: 'lengthWithoutAnsi - long styled',
        iterations: 10000,
        operation: () => longStyled.lengthWithoutAnsi,
      ));

      // --- String .stripAnsi extension ---
      suite.add(runBenchmark(
        name: '.stripAnsi extension - short styled',
        iterations: 100000,
        operation: () => shortStyled.stripAnsi,
      ));

      suite.add(runBenchmark(
        name: '.stripAnsi extension - plain (no codes)',
        iterations: 100000,
        operation: () => plainShort.stripAnsi,
      ));

      suite.printResults();
    });
  });
}
