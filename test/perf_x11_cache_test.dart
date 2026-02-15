/// Quick benchmark: X11 string extension cost, current vs cached potential
import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalkstrings.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  final c = Chalk();
  const text = 'hello world';

  group('X11 String Extension Cache Analysis', () {
    test('benchmarks', () {
      final suite = BenchmarkSuite('X11 Extension: Current vs Cached Potential');

      // Current X11 string extension (uncached — creates Chalk each call)
      suite.add(runBenchmark(
        name: 'EXT: "text".cornflowerBlue',
        iterations: 500000,
        operation: () => text.cornflowerBlue,
      ));

      suite.add(runBenchmark(
        name: 'EXT: "text".tomato',
        iterations: 500000,
        operation: () => text.tomato,
      ));

      suite.add(runBenchmark(
        name: 'EXT: "text".onCornflowerBlue',
        iterations: 500000,
        operation: () => text.onCornflowerBlue,
      ));

      // Chalk API equivalent (also uncached)
      suite.add(runBenchmark(
        name: 'API: c.cornflowerBlue(text)',
        iterations: 500000,
        operation: () => c.cornflowerBlue(text),
      ));

      // Simulated cached: pre-build the Chalk, just call
      final cachedCornflower = c.cornflowerBlue;
      final cachedTomato = c.tomato;
      final cachedOnCornflower = c.onCornflowerBlue;

      suite.add(runBenchmark(
        name: 'CACHED: cachedCornflower(text)',
        iterations: 500000,
        operation: () => cachedCornflower(text),
      ));

      suite.add(runBenchmark(
        name: 'CACHED: cachedTomato(text)',
        iterations: 500000,
        operation: () => cachedTomato(text),
      ));

      suite.add(runBenchmark(
        name: 'CACHED: cachedOnCornflower(text)',
        iterations: 500000,
        operation: () => cachedOnCornflower(text),
      ));

      // Chain: X11 fg + modifier
      suite.add(runBenchmark(
        name: 'EXT: "text".cornflowerBlue.bold',
        iterations: 500000,
        operation: () => text.cornflowerBlue.bold,
      ));

      // Compare to base16 extension (already cached)
      suite.add(runBenchmark(
        name: 'EXT: "text".red (base16, cached)',
        iterations: 500000,
        operation: () => text.red,
      ));

      suite.printResults();
    });
  });
}
