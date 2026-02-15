/// In-depth comparison: String extension getters vs Chalk API
///
/// Key difference in behavior:
///   String ext chain: 'text'.red.bold  =>  bold( red(text) )
///     - Each step creates a STYLED STRING, then the next step wraps it.
///     - N steps = N separate call() invocations, N intermediate strings.
///
///   Chalk API chain:  c.red.bold(text)  =>  redBold(text)
///     - Getter chain builds ONE Chalk with accumulated styles.
///     - Single call() applies all styles at once in one string.
///
/// This means for the same visual result the Chalk API does less string
/// work, but the string extension is more convenient. This benchmark
/// quantifies the trade-offs.
import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalkstrings.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  final c = Chalk();
  const text = 'hello world';

  // Longer strings to show how string length interacts with approach
  const medium = 'The quick brown fox jumps over the lazy dog. '
      'Pack my box with five dozen liquor jugs. '
      'How vexingly quick daft zebras jump.';
  final long1k = List.generate(20, (_) => medium).join(' ');

  group('String Extension vs Chalk API — Detailed Comparison', () {
    // ==================================================================
    // 1. Single style — short string
    // ==================================================================
    test('single style - short string', () {
      final suite = BenchmarkSuite('Single Style — Short String (11 chars)');

      suite.add(runBenchmark(
        name: 'EXT: "text".red',
        iterations: 500000,
        operation: () => text.red,
      ));

      suite.add(runBenchmark(
        name: 'API: c.red(text)',
        iterations: 500000,
        operation: () => c.red(text),
      ));

      final preRed = c.red;
      suite.add(runBenchmark(
        name: 'API: prebuilt red(text)',
        iterations: 500000,
        operation: () => preRed(text),
      ));

      suite.add(runBenchmark(
        name: 'EXT: "text".bold',
        iterations: 500000,
        operation: () => text.bold,
      ));

      suite.add(runBenchmark(
        name: 'API: c.bold(text)',
        iterations: 500000,
        operation: () => c.bold(text),
      ));

      suite.add(runBenchmark(
        name: 'EXT: "text".onRed',
        iterations: 500000,
        operation: () => text.onRed,
      ));

      suite.add(runBenchmark(
        name: 'API: c.onRed(text)',
        iterations: 500000,
        operation: () => c.onRed(text),
      ));

      suite.printResults();
    });

    // ==================================================================
    // 2. Chain depth scaling — both approaches
    // ==================================================================
    test('chain depth scaling', () {
      final suite = BenchmarkSuite('Chain Depth Scaling — EXT vs API');

      // --- Depth 1 ---
      suite.add(runBenchmark(
        name: 'EXT depth 1: "text".red',
        iterations: 500000,
        operation: () => text.red,
      ));
      suite.add(runBenchmark(
        name: 'API depth 1: c.red(text)',
        iterations: 500000,
        operation: () => c.red(text),
      ));

      // --- Depth 2 ---
      suite.add(runBenchmark(
        name: 'EXT depth 2: "text".red.bold',
        iterations: 500000,
        operation: () => text.red.bold,
      ));
      suite.add(runBenchmark(
        name: 'API depth 2: c.red.bold(text)',
        iterations: 500000,
        operation: () => c.red.bold(text),
      ));

      // --- Depth 3 ---
      suite.add(runBenchmark(
        name: 'EXT depth 3: "text".red.bold.italic',
        iterations: 200000,
        operation: () => text.red.bold.italic,
      ));
      suite.add(runBenchmark(
        name: 'API depth 3: c.red.bold.italic(text)',
        iterations: 200000,
        operation: () => c.red.bold.italic(text),
      ));

      // --- Depth 4 ---
      suite.add(runBenchmark(
        name: 'EXT depth 4: "text".red.bold.italic.underline',
        iterations: 200000,
        operation: () => text.red.bold.italic.underline,
      ));
      suite.add(runBenchmark(
        name: 'API depth 4: c.red.bold.italic.underline(text)',
        iterations: 200000,
        operation: () => c.red.bold.italic.underline(text),
      ));

      // --- Depth 5 ---
      suite.add(runBenchmark(
        name: 'EXT depth 5: +dim',
        iterations: 200000,
        operation: () => text.red.bold.italic.underline.dim,
      ));
      suite.add(runBenchmark(
        name: 'API depth 5: c.red.bold.italic.underline.dim(text)',
        iterations: 200000,
        operation: () => c.red.bold.italic.underline.dim(text),
      ));

      suite.printResults();
    });

    // ==================================================================
    // 3. Pre-built Chalk chains vs extension chains
    // ==================================================================
    test('pre-built chalk vs extension', () {
      final suite = BenchmarkSuite('Pre-built Chalk (call only) vs Extension');

      final pre1 = c.red;
      final pre2 = c.red.bold;
      final pre3 = c.red.bold.italic;
      final pre4 = c.red.bold.italic.underline;
      final pre5 = c.red.bold.italic.underline.dim;

      suite.add(runBenchmark(
        name: 'EXT depth 1: "text".red',
        iterations: 500000,
        operation: () => text.red,
      ));
      suite.add(runBenchmark(
        name: 'PRE depth 1: preRed(text)',
        iterations: 500000,
        operation: () => pre1(text),
      ));

      suite.add(runBenchmark(
        name: 'EXT depth 2: "text".red.bold',
        iterations: 500000,
        operation: () => text.red.bold,
      ));
      suite.add(runBenchmark(
        name: 'PRE depth 2: preRedBold(text)',
        iterations: 500000,
        operation: () => pre2(text),
      ));

      suite.add(runBenchmark(
        name: 'EXT depth 3: "text".red.bold.italic',
        iterations: 200000,
        operation: () => text.red.bold.italic,
      ));
      suite.add(runBenchmark(
        name: 'PRE depth 3: preRedBoldItalic(text)',
        iterations: 500000,
        operation: () => pre3(text),
      ));

      suite.add(runBenchmark(
        name: 'EXT depth 4: +underline',
        iterations: 200000,
        operation: () => text.red.bold.italic.underline,
      ));
      suite.add(runBenchmark(
        name: 'PRE depth 4: preRBIU(text)',
        iterations: 500000,
        operation: () => pre4(text),
      ));

      suite.add(runBenchmark(
        name: 'EXT depth 5: +dim',
        iterations: 200000,
        operation: () => text.red.bold.italic.underline.dim,
      ));
      suite.add(runBenchmark(
        name: 'PRE depth 5: preRBIUD(text)',
        iterations: 500000,
        operation: () => pre5(text),
      ));

      suite.printResults();
    });

    // ==================================================================
    // 4. Mixed style types: fg + bg + modifier
    // ==================================================================
    test('mixed style types', () {
      final suite = BenchmarkSuite('Mixed Styles: fg + bg + modifier');

      // fg + bg
      suite.add(runBenchmark(
        name: 'EXT: "text".red.onYellow',
        iterations: 500000,
        operation: () => text.red.onYellow,
      ));
      suite.add(runBenchmark(
        name: 'API: c.red.onYellow(text)',
        iterations: 500000,
        operation: () => c.red.onYellow(text),
      ));

      // fg + modifier
      suite.add(runBenchmark(
        name: 'EXT: "text".red.bold',
        iterations: 500000,
        operation: () => text.red.bold,
      ));
      suite.add(runBenchmark(
        name: 'API: c.red.bold(text)',
        iterations: 500000,
        operation: () => c.red.bold(text),
      ));

      // fg + bg + modifier
      suite.add(runBenchmark(
        name: 'EXT: "text".red.onYellow.bold',
        iterations: 200000,
        operation: () => text.red.onYellow.bold,
      ));
      suite.add(runBenchmark(
        name: 'API: c.red.onYellow.bold(text)',
        iterations: 200000,
        operation: () => c.red.onYellow.bold(text),
      ));

      // fg + bg + 2 modifiers
      suite.add(runBenchmark(
        name: 'EXT: "text".red.onBlue.bold.italic',
        iterations: 200000,
        operation: () => text.red.onBlue.bold.italic,
      ));
      suite.add(runBenchmark(
        name: 'API: c.red.onBlue.bold.italic(text)',
        iterations: 200000,
        operation: () => c.red.onBlue.bold.italic(text),
      ));

      // fg + bg + 3 modifiers
      suite.add(runBenchmark(
        name: 'EXT: "text".red.onBlue.bold.italic.underline',
        iterations: 200000,
        operation: () => text.red.onBlue.bold.italic.underline,
      ));
      suite.add(runBenchmark(
        name: 'API: c.red.onBlue.bold.italic.underline(text)',
        iterations: 200000,
        operation: () => c.red.onBlue.bold.italic.underline(text),
      ));

      suite.printResults();
    });

    // ==================================================================
    // 5. String length impact
    // ==================================================================
    test('string length impact', () {
      final suite = BenchmarkSuite('String Length Impact — EXT vs API');

      // Short string (11 chars) — single style
      suite.add(runBenchmark(
        name: 'EXT short (11c): "text".red',
        iterations: 500000,
        operation: () => text.red,
      ));
      suite.add(runBenchmark(
        name: 'API short (11c): c.red(text)',
        iterations: 500000,
        operation: () => c.red(text),
      ));

      // Medium string (~135 chars) — single style
      suite.add(runBenchmark(
        name: 'EXT medium (135c): med.red',
        iterations: 200000,
        operation: () => medium.red,
      ));
      suite.add(runBenchmark(
        name: 'API medium (135c): c.red(med)',
        iterations: 200000,
        operation: () => c.red(medium),
      ));

      // Long string (~1K chars) — single style
      suite.add(runBenchmark(
        name: 'EXT long (1Kc): long.red',
        iterations: 100000,
        operation: () => long1k.red,
      ));
      suite.add(runBenchmark(
        name: 'API long (1Kc): c.red(long)',
        iterations: 100000,
        operation: () => c.red(long1k),
      ));

      // Short string — 3-deep chain
      suite.add(runBenchmark(
        name: 'EXT short chain3: "text".red.bold.italic',
        iterations: 200000,
        operation: () => text.red.bold.italic,
      ));
      suite.add(runBenchmark(
        name: 'API short chain3: c.red.bold.italic(text)',
        iterations: 200000,
        operation: () => c.red.bold.italic(text),
      ));

      // Medium string — 3-deep chain
      suite.add(runBenchmark(
        name: 'EXT medium chain3: med.red.bold.italic',
        iterations: 100000,
        operation: () => medium.red.bold.italic,
      ));
      suite.add(runBenchmark(
        name: 'API medium chain3: c.red.bold.italic(med)',
        iterations: 100000,
        operation: () => c.red.bold.italic(medium),
      ));

      // Long string — 3-deep chain
      suite.add(runBenchmark(
        name: 'EXT long chain3: long.red.bold.italic',
        iterations: 50000,
        operation: () => long1k.red.bold.italic,
      ));
      suite.add(runBenchmark(
        name: 'API long chain3: c.red.bold.italic(long)',
        iterations: 50000,
        operation: () => c.red.bold.italic(long1k),
      ));

      suite.printResults();
    });

    // ==================================================================
    // 6. Output equivalence verification + cost of intermediate strings
    // ==================================================================
    test('intermediate string overhead', () {
      final suite = BenchmarkSuite('Intermediate String Overhead');

      // The EXT chain wraps N times, producing larger intermediate strings.
      // The API chain applies all styles in one call().
      // With deeper chains the EXT approach must scan/replace ESC codes
      // from prior wraps (stringReplaceAll in call()).

      // Verify equivalence first
      final extResult = text.red.bold.italic;
      final apiResult = c.red.bold.italic(text);
      // Note: these are NOT identical. EXT wraps 3 times (3 layers of open/close),
      // API wraps once (single open with all codes, single close stack).
      // Both render the same visually, but the string content differs.

      // Depth 2: EXT produces open+text+close, then open+[open+text+close]+close
      suite.add(runBenchmark(
        name: 'EXT depth 2 (2 intermediate strings)',
        iterations: 500000,
        operation: () => text.red.bold,
      ));
      suite.add(runBenchmark(
        name: 'API depth 2 (0 intermediate strings)',
        iterations: 500000,
        operation: () => c.red.bold(text),
      ));

      // Depth 4: 4 wrappings vs 1
      suite.add(runBenchmark(
        name: 'EXT depth 4 (4 intermediate strings)',
        iterations: 200000,
        operation: () => text.red.bold.italic.underline,
      ));
      suite.add(runBenchmark(
        name: 'API depth 4 (0 intermediate strings)',
        iterations: 200000,
        operation: () => c.red.bold.italic.underline(text),
      ));

      // Depth 6
      suite.add(runBenchmark(
        name: 'EXT depth 6 (6 intermediate strings)',
        iterations: 200000,
        operation: () => text.red.bold.italic.underline.dim.overline,
      ));
      suite.add(runBenchmark(
        name: 'API depth 6 (0 intermediate strings)',
        iterations: 200000,
        operation: () => c.red.bold.italic.underline.dim.overline(text),
      ));

      // Depth 8
      suite.add(runBenchmark(
        name: 'EXT depth 8 (8 intermediate strings)',
        iterations: 100000,
        operation: () =>
            text.red.bold.italic.underline.dim.overline.inverse.blink,
      ));
      suite.add(runBenchmark(
        name: 'API depth 8 (0 intermediate strings)',
        iterations: 100000,
        operation: () =>
            c.red.bold.italic.underline.dim.overline.inverse.blink(text),
      ));

      // Show string length growth from wrapping
      final ext1 = text.red;
      final ext2 = text.red.bold;
      final ext3 = text.red.bold.italic;
      final ext4 = text.red.bold.italic.underline;
      final api4 = c.red.bold.italic.underline(text);
      print('  String length growth (EXT wrapping vs API single-wrap):');
      print('    Original text: ${text.length} chars');
      print('    EXT depth 1:   ${ext1.length} chars');
      print('    EXT depth 2:   ${ext2.length} chars');
      print('    EXT depth 3:   ${ext3.length} chars');
      print('    EXT depth 4:   ${ext4.length} chars');
      print('    API depth 4:   ${api4.length} chars');
      print('    EXT overhead:  ${ext4.length - api4.length} extra chars'
          ' (${((ext4.length / api4.length - 1) * 100).toStringAsFixed(0)}% larger)');

      suite.printResults();
    });

    // ==================================================================
    // 7. Realistic usage patterns
    // ==================================================================
    test('realistic usage patterns', () {
      final suite = BenchmarkSuite('Realistic Usage Patterns');

      // Pattern 1: Log-line coloring (single style, short text)
      const logMsg = 'Request completed in 42ms';
      suite.add(runBenchmark(
        name: 'EXT log: msg.green',
        iterations: 500000,
        operation: () => logMsg.green,
      ));
      suite.add(runBenchmark(
        name: 'API log: c.green(msg)',
        iterations: 500000,
        operation: () => c.green(logMsg),
      ));

      // Pattern 2: Error highlighting (fg + bold)
      const errMsg = 'Error: file not found';
      suite.add(runBenchmark(
        name: 'EXT error: msg.red.bold',
        iterations: 500000,
        operation: () => errMsg.red.bold,
      ));
      suite.add(runBenchmark(
        name: 'API error: c.red.bold(msg)',
        iterations: 500000,
        operation: () => c.red.bold(errMsg),
      ));

      // Pattern 3: Table header (fg + bg + bold)
      const header = 'NAME            STATUS    TIME';
      suite.add(runBenchmark(
        name: 'EXT header: hdr.white.onBlue.bold',
        iterations: 200000,
        operation: () => header.white.onBlue.bold,
      ));
      suite.add(runBenchmark(
        name: 'API header: c.white.onBlue.bold(hdr)',
        iterations: 200000,
        operation: () => c.white.onBlue.bold(header),
      ));

      // Pattern 4: Composite line (mixed styles via concat)
      const label = 'Status:';
      const value = 'OK';
      suite.add(runBenchmark(
        name: 'EXT composite: label.bold + " " + value.green',
        iterations: 200000,
        operation: () => '${label.bold} ${value.green}',
      ));
      suite.add(runBenchmark(
        name: 'API composite: c.bold(label) + " " + c.green(value)',
        iterations: 200000,
        operation: () => '${c.bold(label)} ${c.green(value)}',
      ));

      // Pattern 5: Pre-built reusable styles
      final errorStyle = c.red.bold;
      final successStyle = c.green;
      final headerStyle = c.white.onBlue.bold;
      suite.add(runBenchmark(
        name: 'PRE error: errorStyle(msg)',
        iterations: 500000,
        operation: () => errorStyle(errMsg),
      ));
      suite.add(runBenchmark(
        name: 'PRE success: successStyle(msg)',
        iterations: 500000,
        operation: () => successStyle(logMsg),
      ));
      suite.add(runBenchmark(
        name: 'PRE header: headerStyle(hdr)',
        iterations: 500000,
        operation: () => headerStyle(header),
      ));

      // Pattern 6: Loop styling (style same text many times)
      final items = List.generate(10, (i) => 'item_$i');
      suite.add(runBenchmark(
        name: 'EXT loop 10x: items.map((s) => s.red)',
        iterations: 50000,
        operation: () {
          for (final s in items) {
            s.red;
          }
        },
      ));
      suite.add(runBenchmark(
        name: 'API loop 10x: items.map((s) => c.red(s))',
        iterations: 50000,
        operation: () {
          for (final s in items) {
            c.red(s);
          }
        },
      ));
      final preLoop = c.red;
      suite.add(runBenchmark(
        name: 'PRE loop 10x: items.map((s) => preRed(s))',
        iterations: 50000,
        operation: () {
          for (final s in items) {
            preLoop(s);
          }
        },
      ));

      suite.printResults();
    });

    // ==================================================================
    // 8. Cost breakdown per approach
    // ==================================================================
    test('cost breakdown per approach', () {
      final suite = BenchmarkSuite('Cost Breakdown — Where Time Goes');

      // EXT approach: cached null-check + call()
      // API approach: getter chain (N Chalk constructors) + call()

      // Just the getter costs (no call)
      suite.add(runBenchmark(
        name: 'API getter 1: c.red',
        iterations: 500000,
        operation: () => c.red,
      ));
      suite.add(runBenchmark(
        name: 'API getter 3: c.red.bold.italic',
        iterations: 500000,
        operation: () => c.red.bold.italic,
      ));
      suite.add(runBenchmark(
        name: 'API getter 5: c.red.bold.italic.underline.dim',
        iterations: 200000,
        operation: () => c.red.bold.italic.underline.dim,
      ));

      // Just the call() cost on pre-built Chalk
      final pre1 = c.red;
      final pre3 = c.red.bold.italic;
      final pre5 = c.red.bold.italic.underline.dim;
      suite.add(runBenchmark(
        name: 'API call on pre1: pre1(text)',
        iterations: 500000,
        operation: () => pre1(text),
      ));
      suite.add(runBenchmark(
        name: 'API call on pre3: pre3(text)',
        iterations: 500000,
        operation: () => pre3(text),
      ));
      suite.add(runBenchmark(
        name: 'API call on pre5: pre5(text)',
        iterations: 500000,
        operation: () => pre5(text),
      ));

      // EXT approach decomposes into: cached call * N steps
      // Each EXT step = null-check (near-zero) + call() on growing string
      // Step 1: call(text) — original text
      // Step 2: call(styled1) — text + ANSI codes from step 1
      // Step 3: call(styled2) — text + codes from steps 1+2
      // Each subsequent call scans for ESC in input → more work
      suite.add(runBenchmark(
        name: 'EXT step 1: text.red (call on 11-char plain)',
        iterations: 500000,
        operation: () => text.red,
      ));

      final step1 = text.red;
      suite.add(runBenchmark(
        name: 'EXT step 2: step1.bold (call on ${step1.length}-char styled)',
        iterations: 500000,
        operation: () => step1.bold,
      ));

      final step2 = step1.bold;
      suite.add(runBenchmark(
        name: 'EXT step 3: step2.italic (call on ${step2.length}-char styled)',
        iterations: 500000,
        operation: () => step2.italic,
      ));

      final step3 = step2.italic;
      suite.add(runBenchmark(
        name: 'EXT step 4: step3.underline (call on ${step3.length}-char)',
        iterations: 500000,
        operation: () => step3.underline,
      ));

      final step4 = step3.underline;
      suite.add(runBenchmark(
        name: 'EXT step 5: step4.dim (call on ${step4.length}-char)',
        iterations: 500000,
        operation: () => step4.dim,
      ));

      suite.printResults();
    });
  });
}
