/// Benchmark cache lookup strategies for X11 getters:
/// 1. Individual static Chalk? fields (current base16 approach)
/// 2. Map<String, Chalk> lookup
/// 3. List<Chalk?> with integer index
import 'package:chalkdart/chalk.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  final c = Chalk();
  const text = 'hello world';

  // Simulate the three caching strategies

  // Strategy 1: Individual static field (current base16 approach)
  Chalk? _cField;

  // Strategy 2: Map cache
  final Map<String, Chalk> _mapCache = {};

  // Strategy 3: List cache with int index
  final List<Chalk?> _listCache = List.filled(300, null);
  const int cornflowerIdx = 42; // arbitrary index

  // Pre-build the chalk we'll cache
  final cornflowerChalk = c.cornflowerBlue;

  group('Cache Strategy Comparison', () {
    test('lookup cost - warm cache', () {
      final suite = BenchmarkSuite('Cache Lookup Cost — Warm Cache');

      // Prime all caches
      _cField = cornflowerChalk;
      _mapCache['cornflowerBlue'] = cornflowerChalk;
      _listCache[cornflowerIdx] = cornflowerChalk;

      // Strategy 1: null-check on static field + call
      suite.add(runBenchmark(
        name: 'Field: (_cField ??= ...)(text)',
        iterations: 1000000,
        operation: () => (_cField ??= cornflowerChalk)(text),
      ));

      // Strategy 2: map lookup + null-check + call
      suite.add(runBenchmark(
        name: 'Map: (_map[key] ??= ...)(text)',
        iterations: 1000000,
        operation: () =>
            (_mapCache['cornflowerBlue'] ??= cornflowerChalk)(text),
      ));

      // Strategy 3: list index + null-check + call
      suite.add(runBenchmark(
        name: 'List: (_list[idx] ??= ...)(text)',
        iterations: 1000000,
        operation: () =>
            (_listCache[cornflowerIdx] ??= cornflowerChalk)(text),
      ));

      // Baseline: direct call on pre-built chalk (no cache lookup at all)
      suite.add(runBenchmark(
        name: 'Direct: cornflowerChalk(text)',
        iterations: 1000000,
        operation: () => cornflowerChalk(text),
      ));

      // Current uncached: _chalk.cornflowerBlue(this) — getter + call
      suite.add(runBenchmark(
        name: 'Uncached: _chalk.cornflowerBlue(text)',
        iterations: 1000000,
        operation: () => c.cornflowerBlue(text),
      ));

      suite.printResults();
    });

    test('lookup cost - cold then warm', () {
      final suite = BenchmarkSuite('Cache Lookup — Cold Start + Warm Steady State');

      // Show that first-call cost is negligible over many iterations
      // Reset caches
      Chalk? field2;
      final map2 = <String, Chalk>{};
      final list2 = List<Chalk?>.filled(300, null);

      suite.add(runBenchmark(
        name: 'Field: cold start then warm',
        iterations: 1000000,
        operation: () => (field2 ??= c.cornflowerBlue)(text),
      ));

      suite.add(runBenchmark(
        name: 'Map: cold start then warm',
        iterations: 1000000,
        operation: () =>
            (map2['cornflowerBlue'] ??= c.cornflowerBlue)(text),
      ));

      suite.add(runBenchmark(
        name: 'List: cold start then warm',
        iterations: 1000000,
        operation: () =>
            (list2[cornflowerIdx] ??= c.cornflowerBlue)(text),
      ));

      suite.printResults();
    });

    test('map lookup overhead isolation', () {
      final suite = BenchmarkSuite('Map Lookup Overhead Isolation');

      // Isolate just the lookup cost (no call)
      _mapCache['cornflowerBlue'] = cornflowerChalk;
      _listCache[cornflowerIdx] = cornflowerChalk;
      _cField = cornflowerChalk;

      // Field: just null-check
      suite.add(runBenchmark(
        name: 'Field null-check only',
        iterations: 2000000,
        operation: () => _cField ??= cornflowerChalk,
      ));

      // Map: bracket lookup
      suite.add(runBenchmark(
        name: 'Map[key] lookup only',
        iterations: 2000000,
        operation: () => _mapCache['cornflowerBlue'],
      ));

      // Map: putIfAbsent
      suite.add(runBenchmark(
        name: 'Map putIfAbsent only',
        iterations: 2000000,
        operation: () =>
            _mapCache.putIfAbsent('cornflowerBlue', () => cornflowerChalk),
      ));

      // List: index lookup
      suite.add(runBenchmark(
        name: 'List[idx] lookup only',
        iterations: 2000000,
        operation: () => _listCache[cornflowerIdx],
      ));

      // List: null-coalesce assign
      suite.add(runBenchmark(
        name: 'List[idx] ??= only',
        iterations: 2000000,
        operation: () => _listCache[cornflowerIdx] ??= cornflowerChalk,
      ));

      suite.printResults();
    });

    test('map with varying key lengths', () {
      final suite = BenchmarkSuite('Map Key Length Impact');

      // Short key
      _mapCache['red'] = cornflowerChalk;
      suite.add(runBenchmark(
        name: 'Map["red"] (3 chars)',
        iterations: 2000000,
        operation: () => (_mapCache['red'] ??= cornflowerChalk)(text),
      ));

      // Medium key
      _mapCache['cornflowerBlue'] = cornflowerChalk;
      suite.add(runBenchmark(
        name: 'Map["cornflowerBlue"] (14 chars)',
        iterations: 2000000,
        operation: () =>
            (_mapCache['cornflowerBlue'] ??= cornflowerChalk)(text),
      ));

      // Long key
      _mapCache['lightGoldenrodYellow'] = cornflowerChalk;
      suite.add(runBenchmark(
        name: 'Map["lightGoldenrodYellow"] (20 chars)',
        iterations: 2000000,
        operation: () =>
            (_mapCache['lightGoldenrodYellow'] ??= cornflowerChalk)(text),
      ));

      // Compare: list index for all
      suite.add(runBenchmark(
        name: 'List[idx] (constant cost)',
        iterations: 2000000,
        operation: () =>
            (_listCache[cornflowerIdx] ??= cornflowerChalk)(text),
      ));

      suite.printResults();
    });
  });
}
