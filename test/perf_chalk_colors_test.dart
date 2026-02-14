import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/src/colorutils.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  final c = Chalk();
  const text = 'hello world';

  group('Chalk Color Methods Performance', () {
    test('benchmarks', () {
      final suite = BenchmarkSuite('Color Methods & Conversions');

      // --- Styled color application ---
      suite.add(runBenchmark(
        name: 'rgb(255, 100, 50)',
        iterations: 50000,
        operation: () => c.rgb(255, 100, 50)(text),
      ));

      suite.add(runBenchmark(
        name: 'onRgb(0, 128, 255) background',
        iterations: 50000,
        operation: () => c.onRgb(0, 128, 255)(text),
      ));

      suite.add(runBenchmark(
        name: 'hex(\'#FF6432\') string',
        iterations: 50000,
        operation: () => c.hex('#FF6432')(text),
      ));

      suite.add(runBenchmark(
        name: 'hex(0xFF6432) int',
        iterations: 50000,
        operation: () => c.hex(0xFF6432)(text),
      ));

      suite.add(runBenchmark(
        name: 'keyword(\'tomato\')',
        iterations: 50000,
        operation: () => c.keyword('tomato')(text),
      ));

      suite.add(runBenchmark(
        name: 'hsl(120, 50, 50)',
        iterations: 50000,
        operation: () => c.hsl(120, 50, 50)(text),
      ));

      suite.add(runBenchmark(
        name: 'hsv(120, 50, 50)',
        iterations: 50000,
        operation: () => c.hsv(120, 50, 50)(text),
      ));

      suite.add(runBenchmark(
        name: 'hwb(120, 20, 20)',
        iterations: 50000,
        operation: () => c.hwb(120, 20, 20)(text),
      ));

      suite.add(runBenchmark(
        name: 'xyz(50, 50, 50)',
        iterations: 50000,
        operation: () => c.xyz(50, 50, 50)(text),
      ));

      suite.add(runBenchmark(
        name: 'lab(50, 20, -30)',
        iterations: 50000,
        operation: () => c.lab(50, 20, -30)(text),
      ));

      suite.add(runBenchmark(
        name: 'ansi256(196)',
        iterations: 100000,
        operation: () => c.ansi256(196)(text),
      ));

      suite.add(runBenchmark(
        name: 'greyscale(128)',
        iterations: 100000,
        operation: () => c.greyscale(128)(text),
      ));

      // --- Pre-built color chalks (call-only overhead) ---
      final preRgb = c.rgb(255, 100, 50);
      suite.add(runBenchmark(
        name: 'Pre-built rgb chalk (call only)',
        iterations: 100000,
        operation: () => preRgb(text),
      ));

      final preHex = c.hex('#FF6432');
      suite.add(runBenchmark(
        name: 'Pre-built hex chalk (call only)',
        iterations: 100000,
        operation: () => preHex(text),
      ));

      // --- Raw ColorUtils conversions (no styling) ---
      suite.add(runBenchmark(
        name: 'Raw hsl2rgb(120, 50, 50)',
        iterations: 200000,
        operation: () => ColorUtils.hsl2rgb(120, 50, 50),
      ));

      suite.add(runBenchmark(
        name: 'Raw hex2rgb(\'#FF6432\')',
        iterations: 200000,
        operation: () => ColorUtils.hex2rgb('#FF6432'),
      ));

      suite.add(runBenchmark(
        name: 'Raw hex2rgb(0xFF6432)',
        iterations: 200000,
        operation: () => ColorUtils.hex2rgb(0xFF6432),
      ));

      suite.add(runBenchmark(
        name: 'Raw rgbToAnsi256(255, 100, 50)',
        iterations: 200000,
        operation: () => ColorUtils.rgbToAnsi256(255, 100, 50),
      ));

      suite.add(runBenchmark(
        name: 'Raw hsv2rgb(120, 50, 50)',
        iterations: 200000,
        operation: () => ColorUtils.hsv2rgb(120, 50, 50),
      ));

      suite.add(runBenchmark(
        name: 'Raw xyz2rgb(50, 50, 50)',
        iterations: 200000,
        operation: () => ColorUtils.xyz2rgb(50, 50, 50),
      ));

      suite.add(runBenchmark(
        name: 'Raw lab2xyz(50, 20, -30)',
        iterations: 200000,
        operation: () => ColorUtils.lab2xyz(50, 20, -30),
      ));

      suite.add(runBenchmark(
        name: 'Raw colorFromKeyword(\'tomato\')',
        iterations: 200000,
        operation: () => ColorUtils.colorFromKeyword('tomato'),
      ));

      suite.printResults();
    });
  });
}
