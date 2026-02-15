/// Targeted micro-benchmarks to isolate where time is spent in the
/// critical Chalk code paths.
import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/src/ansiutils.dart';
import 'package:chalkdart/src/colorutils.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  final c = Chalk();
  const text = 'hello';

  group('Hotspot Analysis', () {
    // =====================================================================
    // 1. Decompose c.red('hello') into its constituent costs
    // =====================================================================
    test('decompose single getter+call', () {
      final suite = BenchmarkSuite('Decompose: c.red("hello")');

      // A) Total cost: getter + call
      suite.add(runBenchmark(
        name: 'c.red("hello") [getter+call]',
        iterations: 200000,
        operation: () => c.red(text),
      ));

      // B) Just the call() on a pre-built chalk
      final preRed = c.red;
      suite.add(runBenchmark(
        name: 'preRed("hello") [call only]',
        iterations: 200000,
        operation: () => preRed(text),
      ));

      // C) Just the getter (don't call)
      suite.add(runBenchmark(
        name: 'c.red [getter only, discard]',
        iterations: 200000,
        operation: () => c.red,
      ));

      // D) _ansiSGRModiferOpen equivalent: string interpolation
      suite.add(runBenchmark(
        name: 'String interp: "\x1B[\${code}m"',
        iterations: 200000,
        operation: () => '\x1B[31m',
      ));

      // E) Chalk._internal() cost (constructor)
      suite.add(runBenchmark(
        name: 'Chalk() constructor (root, no style)',
        iterations: 200000,
        operation: () => Chalk(),
      ));

      // F) String concat: openAll + text + closeAll
      const open = '\x1B[31m';
      const close = '\x1B[39m';
      suite.add(runBenchmark(
        name: 'String concat: open + text + close',
        iterations: 200000,
        operation: () => open + text + close,
      ));

      suite.printResults();
    });

    // =====================================================================
    // 2. Decompose chain overhead: where does the time go per getter?
    // =====================================================================
    test('chain depth overhead', () {
      final suite = BenchmarkSuite('Chain Depth: Getter vs Call Cost');

      // Measure just getter chain costs (no call)
      suite.add(runBenchmark(
        name: 'Getter chain 1: c.red',
        iterations: 200000,
        operation: () => c.red,
      ));

      suite.add(runBenchmark(
        name: 'Getter chain 2: c.red.bold',
        iterations: 200000,
        operation: () => c.red.bold,
      ));

      suite.add(runBenchmark(
        name: 'Getter chain 3: c.red.bold.italic',
        iterations: 200000,
        operation: () => c.red.bold.italic,
      ));

      suite.add(runBenchmark(
        name: 'Getter chain 5: r.b.i.u.dim',
        iterations: 200000,
        operation: () => c.red.bold.italic.underline.dim,
      ));

      // Now measure call() on pre-built chains of increasing depth
      final pre1 = c.red;
      final pre2 = c.red.bold;
      final pre3 = c.red.bold.italic;
      final pre5 = c.red.bold.italic.underline.dim;

      suite.add(runBenchmark(
        name: 'Call on depth 1 chain',
        iterations: 200000,
        operation: () => pre1(text),
      ));

      suite.add(runBenchmark(
        name: 'Call on depth 2 chain',
        iterations: 200000,
        operation: () => pre2(text),
      ));

      suite.add(runBenchmark(
        name: 'Call on depth 3 chain',
        iterations: 200000,
        operation: () => pre3(text),
      ));

      suite.add(runBenchmark(
        name: 'Call on depth 5 chain',
        iterations: 200000,
        operation: () => pre5(text),
      ));

      suite.printResults();
    });

    // =====================================================================
    // 3. Constructor internals: what's expensive in Chalk._internal()?
    // =====================================================================
    test('constructor internals', () {
      final suite = BenchmarkSuite('Constructor Internals');

      // Root constructor (hasStyle=false)
      suite.add(runBenchmark(
        name: 'Chalk() root constructor',
        iterations: 200000,
        operation: () => Chalk(),
      ));

      // _setAllWrapperFunctionsAccordingToMode creates 6 closures each time
      // We can't call it directly, but we can measure the whole _createStyler
      // by timing one getter call on a pre-existing chalk:
      suite.add(runBenchmark(
        name: 'c.red (getter = _createStyler)',
        iterations: 200000,
        operation: () => c.red,
      ));

      // Compare: building the open string (_ansiSGRModiferOpen)
      // On ANSI mode this is just '$ESC[${code}m'
      // We can approximate it:
      var code = 31;
      suite.add(runBenchmark(
        name: 'String interp "\x1B[\${31}m"',
        iterations: 200000,
        operation: () => '\x1B[${code}m',
      ));

      suite.printResults();
    });

    // =====================================================================
    // 4. call() internals: _fixArg, indexOf(ESC), indexOf('\n'), concat
    // =====================================================================
    test('call() internals', () {
      final suite = BenchmarkSuite('call() Internals');

      final preRed = c.red;
      final styledInput = c.bold('inner');
      final multiLine = 'line1\nline2\nline3';

      // Plain text call (no ESC, no newline - fastest path)
      suite.add(runBenchmark(
        name: 'call(plain text) - fast path',
        iterations: 200000,
        operation: () => preRed(text),
      ));

      // Text with ESC codes (triggers stringReplaceAll loop)
      suite.add(runBenchmark(
        name: 'call(styled input) - ESC replacement',
        iterations: 200000,
        operation: () => preRed(styledInput),
      ));

      // Text with newlines (triggers stringEncaseCRLF)
      suite.add(runBenchmark(
        name: 'call(multiline) - newline handling',
        iterations: 200000,
        operation: () => preRed(multiLine),
      ));

      // Text with both ESC and newlines
      final styledMultiline = c.bold('line1\nline2');
      suite.add(runBenchmark(
        name: 'call(styled+multiline) - both paths',
        iterations: 200000,
        operation: () => preRed(styledMultiline),
      ));

      // Just the indexOf checks (baseline string scanning)
      const esc = '\x1B';
      suite.add(runBenchmark(
        name: 'text.indexOf(ESC) - no match',
        iterations: 200000,
        operation: () => text.indexOf(esc),
      ));

      suite.add(runBenchmark(
        name: 'text.indexOf("\\n") - no match',
        iterations: 200000,
        operation: () => text.indexOf('\n'),
      ));

      suite.add(runBenchmark(
        name: 'styledInput.indexOf(ESC) - match',
        iterations: 200000,
        operation: () => styledInput.indexOf(esc),
      ));

      suite.printResults();
    });

    // =====================================================================
    // 5. HTML mode constructor vs ANSI mode constructor
    // =====================================================================
    test('HTML vs ANSI constructor cost', () {
      final suite = BenchmarkSuite('HTML vs ANSI Mode Constructor Cost');

      final htmlC = Chalk(outputMode: ChalkOutputMode.html);

      // ANSI getter
      suite.add(runBenchmark(
        name: 'ANSI: c.red (getter)',
        iterations: 200000,
        operation: () => c.red,
      ));

      // HTML getter
      suite.add(runBenchmark(
        name: 'HTML: h.red (getter)',
        iterations: 200000,
        operation: () => htmlC.red,
      ));

      // ANSI call
      final ansiRed = c.red;
      suite.add(runBenchmark(
        name: 'ANSI: preRed(text) (call)',
        iterations: 200000,
        operation: () => ansiRed(text),
      ));

      // HTML call
      final htmlRed = htmlC.red;
      suite.add(runBenchmark(
        name: 'HTML: preRed(text) (call)',
        iterations: 200000,
        operation: () => htmlRed(text),
      ));

      // ANSI chain getter
      suite.add(runBenchmark(
        name: 'ANSI: c.red.bold.italic (getters)',
        iterations: 200000,
        operation: () => c.red.bold.italic,
      ));

      // HTML chain getter
      suite.add(runBenchmark(
        name: 'HTML: h.red.bold.italic (getters)',
        iterations: 200000,
        operation: () => htmlC.red.bold.italic,
      ));

      suite.printResults();
    });

    // =====================================================================
    // 6. Color method overhead: conversion vs chalk creation
    // =====================================================================
    test('color method decomposition', () {
      final suite = BenchmarkSuite('Color Method: Conversion vs Chalk Creation');

      // Full rgb() call including conversion + _createStyler
      suite.add(runBenchmark(
        name: 'c.rgb(255,100,50) [full]',
        iterations: 200000,
        operation: () => c.rgb(255, 100, 50),
      ));

      // Just the conversion (no chalk)
      suite.add(runBenchmark(
        name: 'rgbToAnsi256 only',
        iterations: 200000,
        operation: () => ColorUtils.rgbToAnsi256(255, 100, 50),
      ));

      // Full hex() call
      suite.add(runBenchmark(
        name: 'c.hex("#FF6432") [full]',
        iterations: 200000,
        operation: () => c.hex('#FF6432'),
      ));

      // Just hex parsing
      suite.add(runBenchmark(
        name: 'hex2rgb("#FF6432") only',
        iterations: 200000,
        operation: () => ColorUtils.hex2rgb('#FF6432'),
      ));

      // Full keyword() call
      suite.add(runBenchmark(
        name: 'c.keyword("tomato") [full]',
        iterations: 200000,
        operation: () => c.keyword('tomato'),
      ));

      // Just keyword lookup
      suite.add(runBenchmark(
        name: 'colorFromKeyword("tomato") only',
        iterations: 200000,
        operation: () => ColorUtils.colorFromKeyword('tomato'),
      ));

      // Full hsl() call
      suite.add(runBenchmark(
        name: 'c.hsl(120,50,50) [full]',
        iterations: 200000,
        operation: () => c.hsl(120, 50, 50),
      ));

      // Just hsl conversion
      suite.add(runBenchmark(
        name: 'hsl2rgb(120,50,50) only',
        iterations: 200000,
        operation: () => ColorUtils.hsl2rgb(120, 50, 50),
      ));

      suite.printResults();
    });

    // =====================================================================
    // 7. noSuchMethod overhead breakdown
    // =====================================================================
    test('noSuchMethod overhead', () {
      final suite = BenchmarkSuite('noSuchMethod Overhead');

      // Static X11 getter (compiled, no reflection)
      suite.add(runBenchmark(
        name: 'c.cornflowerBlue (X11 getter)',
        iterations: 200000,
        operation: () => c.cornflowerBlue,
      ));

      // noSuchMethod via dynamic
      dynamic dynC = c;
      suite.add(runBenchmark(
        name: 'dynC.cornflowerblue (noSuchMethod)',
        iterations: 200000,
        operation: () => dynC.cornflowerblue,
      ));

      // noSuchMethod with args (calls + styles in one go)
      suite.add(runBenchmark(
        name: 'dynC.cornflowerblue(text) (noSuchMethod+call)',
        iterations: 200000,
        operation: () => dynC.cornflowerblue(text),
      ));

      // Static getter + call (two-step)
      suite.add(runBenchmark(
        name: 'c.cornflowerBlue(text) (getter+call)',
        iterations: 200000,
        operation: () => c.cornflowerBlue(text),
      ));

      // Keyword path for comparison (also does map lookup)
      suite.add(runBenchmark(
        name: 'c.keyword("cornflowerblue")(text)',
        iterations: 200000,
        operation: () => c.keyword('cornflowerblue')(text),
      ));

      suite.printResults();
    });

    // =====================================================================
    // 8. stripAnsi regex cost analysis
    // =====================================================================
    test('strip regex analysis', () {
      final suite = BenchmarkSuite('Strip/Regex Cost Analysis');

      final styled = c.red.bold('hello world');
      final plain = 'hello world';

      // hasAnsi checks (regex hasMatch - early exit)
      suite.add(runBenchmark(
        name: 'hasAnsi(styled) - positive',
        iterations: 500000,
        operation: () => AnsiUtils.hasAnsi(styled),
      ));

      suite.add(runBenchmark(
        name: 'hasAnsi(plain) - negative',
        iterations: 500000,
        operation: () => AnsiUtils.hasAnsi(plain),
      ));

      // stripAnsi (regex replaceAll)
      suite.add(runBenchmark(
        name: 'stripAnsi(styled)',
        iterations: 500000,
        operation: () => AnsiUtils.stripAnsi(styled),
      ));

      suite.add(runBenchmark(
        name: 'stripAnsi(plain) - no-op',
        iterations: 500000,
        operation: () => AnsiUtils.stripAnsi(plain),
      ));

      // String.replaceAll with compiled regex (what stripAnsi does)
      suite.add(runBenchmark(
        name: 'regex.replaceAll on styled',
        iterations: 500000,
        operation: () => styled.replaceAll(AnsiUtils.ansiRegex, ''),
      ));

      suite.add(runBenchmark(
        name: 'regex.replaceAll on plain',
        iterations: 500000,
        operation: () => plain.replaceAll(AnsiUtils.ansiRegex, ''),
      ));

      suite.printResults();
    });
  });
}
