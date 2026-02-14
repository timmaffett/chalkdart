import 'package:chalkdart/chalk.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  // Prepare test data outside timing
  final shortStr = '0123456789'; // 10 chars
  final mediumStr = 'x' * 1000;
  final largeStr = 'x' * 100000;
  final c = Chalk();

  group('Chalk Basic Operations Performance', () {
    test('benchmarks', () {
      final suite = BenchmarkSuite('Chalk Basic Operations');

      // --- Baseline ---
      suite.add(runBenchmark(
        name: 'Root chalk passthrough (no styles)',
        iterations: 100000,
        operation: () => c('hello world'),
      ));

      // --- String size scaling ---
      suite.add(runBenchmark(
        name: 'Single color - short string (10 chars)',
        iterations: 100000,
        operation: () => c.red(shortStr),
      ));

      suite.add(runBenchmark(
        name: 'Single color - medium string (1K chars)',
        iterations: 10000,
        operation: () => c.red(mediumStr),
      ));

      suite.add(runBenchmark(
        name: 'Single color - large string (100K chars)',
        iterations: 100,
        operation: () => c.red(largeStr),
      ));

      // --- Chain depth scaling ---
      suite.add(runBenchmark(
        name: 'Chain depth 1 (red)',
        iterations: 100000,
        operation: () => c.red('hello'),
      ));

      suite.add(runBenchmark(
        name: 'Chain depth 2 (red.bold)',
        iterations: 100000,
        operation: () => c.red.bold('hello'),
      ));

      suite.add(runBenchmark(
        name: 'Chain depth 3 (red.bold.italic)',
        iterations: 100000,
        operation: () => c.red.bold.italic('hello'),
      ));

      suite.add(runBenchmark(
        name: 'Chain depth 5',
        iterations: 50000,
        operation: () => c.red.bold.italic.underline.dim('hello'),
      ));

      suite.add(runBenchmark(
        name: 'Chain depth 10',
        iterations: 10000,
        operation: () => c.red.bold.italic.underline.dim.onBlue.strikethrough.overline.blink.inverse('hello'),
      ));

      // --- Pre-built chain (no getter overhead) ---
      final prebuilt3 = c.red.bold.italic;
      suite.add(runBenchmark(
        name: 'Pre-built chain depth 3 (call only)',
        iterations: 100000,
        operation: () => prebuilt3('hello'),
      ));

      final prebuilt5 = c.red.bold.italic.underline.dim;
      suite.add(runBenchmark(
        name: 'Pre-built chain depth 5 (call only)',
        iterations: 100000,
        operation: () => prebuilt5('hello'),
      ));

      // --- Background and combined ---
      suite.add(runBenchmark(
        name: 'Background color only (onRed)',
        iterations: 100000,
        operation: () => c.onRed('hello'),
      ));

      suite.add(runBenchmark(
        name: 'Foreground + background (red.onYellow)',
        iterations: 100000,
        operation: () => c.red.onYellow('hello'),
      ));

      suite.add(runBenchmark(
        name: 'Bright foreground (brightRed)',
        iterations: 100000,
        operation: () => c.brightRed('hello'),
      ));

      suite.add(runBenchmark(
        name: 'Bright bg (onBrightCyan)',
        iterations: 100000,
        operation: () => c.onBrightCyan('hello'),
      ));

      suite.printResults();
    });
  });
}
