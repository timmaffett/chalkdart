/// Measures the potential gain from caching styled Chalk instances
/// in the ChalkString extension.
import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalkstrings.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  final c = Chalk();
  const text = 'hello world';

  group('String Extension Cache Potential', () {
    test('benchmarks', () {
      final suite = BenchmarkSuite('String Extension: Current vs Cached');

      // --- Current behavior: getter creates new Chalk each time ---
      suite.add(runBenchmark(
        name: 'CURRENT: "text".red',
        iterations: 500000,
        operation: () => text.red,
      ));

      suite.add(runBenchmark(
        name: 'CURRENT: "text".bold',
        iterations: 500000,
        operation: () => text.bold,
      ));

      suite.add(runBenchmark(
        name: 'CURRENT: "text".red.bold (chain 2)',
        iterations: 500000,
        operation: () => text.red.bold,
      ));

      suite.add(runBenchmark(
        name: 'CURRENT: "text".red.bold.italic (chain 3)',
        iterations: 200000,
        operation: () => text.red.bold.italic,
      ));

      suite.add(runBenchmark(
        name: 'CURRENT: chalk.red(text) [equiv]',
        iterations: 500000,
        operation: () => c.red(text),
      ));

      // --- Simulated cached behavior: pre-built Chalk, call only ---
      final cachedRed = c.red;
      final cachedBold = c.bold;
      final cachedRedBold = c.red.bold;
      final cachedRedBoldItalic = c.red.bold.italic;

      suite.add(runBenchmark(
        name: 'CACHED:  cachedRed(text)',
        iterations: 500000,
        operation: () => cachedRed(text),
      ));

      suite.add(runBenchmark(
        name: 'CACHED:  cachedBold(text)',
        iterations: 500000,
        operation: () => cachedBold(text),
      ));

      suite.add(runBenchmark(
        name: 'CACHED:  cachedRedBold(text)',
        iterations: 500000,
        operation: () => cachedRedBold(text),
      ));

      suite.add(runBenchmark(
        name: 'CACHED:  cachedRedBoldItalic(text)',
        iterations: 500000,
        operation: () => cachedRedBoldItalic(text),
      ));

      // --- String extension chaining: deeper analysis ---
      // Each .red in a chain is TWO getters: _chalk.red (Chalk getter) then call()
      // followed by the next .bold which is _chalk.bold on the OUTPUT string,
      // i.e., ANOTHER _chalk.bold getter + call()
      // So "text".red.bold = _chalk.red(text) then _chalk.bold(result)
      //   = 2 getter+call pairs

      // What if each step were cached?
      suite.add(runBenchmark(
        name: 'CURRENT: "text".red.bold.italic.underline',
        iterations: 200000,
        operation: () => text.red.bold.italic.underline,
      ));

      suite.add(runBenchmark(
        name: 'CACHED:  cachedRBIU(text) [single call]',
        iterations: 500000,
        operation: () {
          // This is what a COMBINED cached chalk would do:
          // one call instead of 4 getter+call pairs
          final cached = c.red.bold.italic.underline;
          cached(text);
        },
      ));

      // Pre-built combined for pure call cost
      final cachedRBIU = c.red.bold.italic.underline;
      suite.add(runBenchmark(
        name: 'CACHED:  prebuilt RBIU(text) [call only]',
        iterations: 500000,
        operation: () => cachedRBIU(text),
      ));

      suite.printResults();
    });
  });
}
