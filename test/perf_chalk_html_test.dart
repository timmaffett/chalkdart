import 'package:chalkdart/chalk.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  final ansi = Chalk();
  final html = Chalk(outputMode: ChalkOutputMode.html);
  const text = 'hello world';

  // Pre-build HTML styled strings for strip tests
  final htmlShort = html.red.bold('short text');
  final htmlLong = List.generate(50, (i) => html.red('segment$i ')).join();

  // Text with special chars for entity encoding
  const angleBrackets = 'a < b > c && d < e > f';
  const spaceyText = 'one two three four five six seven';

  group('Chalk HTML Mode Performance', () {
    test('benchmarks', () {
      final suite = BenchmarkSuite('HTML Mode Operations');

      // --- HTML basic styling ---
      suite.add(runBenchmark(
        name: 'HTML: simple red',
        iterations: 100000,
        operation: () => html.red(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: chain depth 3 (red.bold.italic)',
        iterations: 50000,
        operation: () => html.red.bold.italic(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: chain depth 5',
        iterations: 20000,
        operation: () => html.red.bold.italic.underline.dim(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: background (onRed)',
        iterations: 100000,
        operation: () => html.onRed(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: fg + bg (red.onYellow)',
        iterations: 50000,
        operation: () => html.red.onYellow(text),
      ));

      // --- HTML color methods ---
      suite.add(runBenchmark(
        name: 'HTML: rgb(255, 100, 50)',
        iterations: 50000,
        operation: () => html.rgb(255, 100, 50)(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: hex(\'#FF6432\')',
        iterations: 50000,
        operation: () => html.hex('#FF6432')(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: keyword(\'tomato\')',
        iterations: 50000,
        operation: () => html.keyword('tomato')(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: ansi256(196)',
        iterations: 50000,
        operation: () => html.ansi256(196)(text),
      ));

      // --- ANSI vs HTML side-by-side ---
      suite.add(runBenchmark(
        name: 'ANSI: red (comparison)',
        iterations: 100000,
        operation: () => ansi.red(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: red (comparison)',
        iterations: 100000,
        operation: () => html.red(text),
      ));

      suite.add(runBenchmark(
        name: 'ANSI: red.bold.italic (comparison)',
        iterations: 50000,
        operation: () => ansi.red.bold.italic(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: red.bold.italic (comparison)',
        iterations: 50000,
        operation: () => html.red.bold.italic(text),
      ));

      suite.add(runBenchmark(
        name: 'ANSI: rgb(255,0,0) (comparison)',
        iterations: 50000,
        operation: () => ansi.rgb(255, 0, 0)(text),
      ));

      suite.add(runBenchmark(
        name: 'HTML: rgb(255,0,0) (comparison)',
        iterations: 50000,
        operation: () => html.rgb(255, 0, 0)(text),
      ));

      // --- HTML strip operations ---
      suite.add(runBenchmark(
        name: 'stripHtmlTags - short string',
        iterations: 100000,
        operation: () => html.stripHtmlTags(htmlShort),
      ));

      suite.add(runBenchmark(
        name: 'stripHtmlTags - long string (50 spans)',
        iterations: 10000,
        operation: () => html.stripHtmlTags(htmlLong),
      ));

      suite.add(runBenchmark(
        name: 'html.strip() - short string',
        iterations: 100000,
        operation: () => html.strip(htmlShort),
      ));

      // --- HTML entity encoding ---
      suite.add(runBenchmark(
        name: 'htmlSafeGtLt - text with < >',
        iterations: 100000,
        operation: () => Chalk.htmlSafeGtLt(angleBrackets),
      ));

      suite.add(runBenchmark(
        name: 'htmlSafeSpaces - text with spaces',
        iterations: 50000,
        operation: () => Chalk.htmlSafeSpaces(spaceyText),
      ));

      // --- Stylesheet generation ---
      suite.add(runBenchmark(
        name: 'stylesheet() generation',
        iterations: 1000,
        operation: () => html.stylesheet(),
      ));

      suite.add(runBenchmark(
        name: 'inlineStylesheet() generation',
        iterations: 1000,
        operation: () => html.inlineStylesheet(),
      ));

      suite.add(runBenchmark(
        name: 'stylesheet(darkBackground)',
        iterations: 1000,
        operation: () =>
            html.stylesheet(colorSetToUse: ChalkAnsiColorSet.darkBackground),
      ));

      // --- Pre-built HTML chalk (call only) ---
      final preHtmlRed = html.red;
      suite.add(runBenchmark(
        name: 'HTML: pre-built red (call only)',
        iterations: 100000,
        operation: () => preHtmlRed(text),
      ));

      final preHtmlChain = html.red.bold.italic;
      suite.add(runBenchmark(
        name: 'HTML: pre-built chain (call only)',
        iterations: 100000,
        operation: () => preHtmlChain(text),
      ));

      suite.printResults();
    });
  });
}
