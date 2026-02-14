/// Shared benchmark infrastructure for ChalkDart performance tests.
///
/// Provides [BenchmarkResult], [runBenchmark], and [BenchmarkSuite] for
/// consistent, repeatable microbenchmarking across all perf test files.
library;

class BenchmarkResult {
  final String name;
  final int iterations;
  final int warmupIterations;
  final Duration totalTime;
  final Duration warmupTime;

  BenchmarkResult({
    required this.name,
    required this.iterations,
    required this.warmupIterations,
    required this.totalTime,
    required this.warmupTime,
  });

  double get totalMicroseconds => totalTime.inMicroseconds.toDouble();
  double get avgMicroseconds => totalMicroseconds / iterations;
  double get opsPerSecond => iterations / (totalMicroseconds / 1000000);

  String get formattedTotal {
    if (totalTime.inMilliseconds >= 1000) {
      return '${(totalTime.inMilliseconds / 1000).toStringAsFixed(2)}s';
    }
    return '${totalTime.inMilliseconds}ms';
  }

  String get formattedAvg {
    if (avgMicroseconds >= 1000) {
      return '${(avgMicroseconds / 1000).toStringAsFixed(2)}ms';
    }
    return '${avgMicroseconds.toStringAsFixed(2)}\u00b5s';
  }

  String get formattedOps {
    if (opsPerSecond >= 1000000) {
      return '${(opsPerSecond / 1000000).toStringAsFixed(2)}M';
    }
    if (opsPerSecond >= 1000) {
      return '${(opsPerSecond / 1000).toStringAsFixed(1)}K';
    }
    return opsPerSecond.toStringAsFixed(0);
  }
}

/// Runs a benchmark with warmup and measured phases.
///
/// [operation] is called [warmupIterations] times first (default 100),
/// then [iterations] times (default 10000) while timing.
BenchmarkResult runBenchmark({
  required String name,
  required void Function() operation,
  int iterations = 10000,
  int warmupIterations = 100,
}) {
  // Warmup
  final warmupWatch = Stopwatch()..start();
  for (var i = 0; i < warmupIterations; i++) {
    operation();
  }
  warmupWatch.stop();

  // Measured
  final watch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    operation();
  }
  watch.stop();

  return BenchmarkResult(
    name: name,
    iterations: iterations,
    warmupIterations: warmupIterations,
    totalTime: watch.elapsed,
    warmupTime: warmupWatch.elapsed,
  );
}

/// Groups related benchmarks and prints a formatted results table.
class BenchmarkSuite {
  final String name;
  final List<BenchmarkResult> results = [];

  BenchmarkSuite(this.name);

  void add(BenchmarkResult result) {
    results.add(result);
  }

  void printResults() {
    const nameWidth = 48;
    const iterWidth = 12;
    const totalWidth = 10;
    const avgWidth = 12;
    const opsWidth = 12;
    final lineWidth = nameWidth + iterWidth + totalWidth + avgWidth + opsWidth;

    print('');
    print('${'=' * lineWidth}');
    print(name);
    print('${'=' * lineWidth}');
    print(
      '${'Benchmark'.padRight(nameWidth)}'
      '${'Iterations'.padLeft(iterWidth)}'
      '${'Total'.padLeft(totalWidth)}'
      '${'Avg'.padLeft(avgWidth)}'
      '${'Ops/Sec'.padLeft(opsWidth)}',
    );
    print('${'-' * lineWidth}');

    for (final r in results) {
      final iterStr = _formatInt(r.iterations);
      print(
        '${r.name.padRight(nameWidth)}'
        '${iterStr.padLeft(iterWidth)}'
        '${r.formattedTotal.padLeft(totalWidth)}'
        '${r.formattedAvg.padLeft(avgWidth)}'
        '${r.formattedOps.padLeft(opsWidth)}',
      );
    }

    print('${'=' * lineWidth}');
    print('');
  }

  static String _formatInt(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}
