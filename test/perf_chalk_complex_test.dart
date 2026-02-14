import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/chalkstrings.dart';
import 'package:chalkdart/src/ansiutils.dart';
import 'package:test/test.dart';

import 'perf_benchmark_harness.dart';

void main() {
  final c = Chalk();
  const text = 'hello world';

  // Pre-build nested strings at various depths
  final nested1 = c.red('outer ${c.bold("inner")} outer');
  final nested3 = c.red('a ${c.green("b ${c.blue("c ${c.yellow("d")} c")} b")} a');
  final nested5text = _buildNested(c, 5);
  final nested10text = _buildNested(c, 10);

  // Pre-build multi-line strings
  final lines10 = List.generate(10, (i) => 'line $i').join('\n');
  final lines100 = List.generate(100, (i) => 'line $i').join('\n');
  final lines1000 = List.generate(1000, (i) => 'line $i').join('\n');

  // For multi-arg tests, assign getter to variable so call() receives all args
  final Chalk red = c.red;

  // For noSuchMethod comparison
  // ignore: unused_local_variable
  dynamic dynChalk = Chalk();

  group('Chalk Complex Operations Performance', () {
    test('benchmarks', () {
      final suite = BenchmarkSuite('Complex Operations');

      // --- Nested styling ---
      suite.add(runBenchmark(
        name: 'Nested depth 1',
        iterations: 50000,
        operation: () => c.red('outer ${c.bold("inner")} outer'),
      ));

      suite.add(runBenchmark(
        name: 'Nested depth 3',
        iterations: 20000,
        operation: () =>
            c.red('a ${c.green("b ${c.blue("c ${c.yellow("d")} c")} b")} a'),
      ));

      suite.add(runBenchmark(
        name: 'Nested depth 5 (pre-built input)',
        iterations: 10000,
        operation: () => c.white(nested5text),
      ));

      suite.add(runBenchmark(
        name: 'Nested depth 10 (pre-built input)',
        iterations: 5000,
        operation: () => c.white(nested10text),
      ));

      // --- Apply style to pre-nested text (tests close-code replacement) ---
      final preNested1 = nested1;
      suite.add(runBenchmark(
        name: 'Style over pre-nested text (depth 1)',
        iterations: 50000,
        operation: () => c.underline(preNested1),
      ));

      suite.add(runBenchmark(
        name: 'Style over pre-nested text (depth 3)',
        iterations: 20000,
        operation: () => c.underline(nested3),
      ));

      // --- Multi-line text ---
      suite.add(runBenchmark(
        name: 'Multi-line 10 lines',
        iterations: 20000,
        operation: () => c.red(lines10),
      ));

      suite.add(runBenchmark(
        name: 'Multi-line 100 lines',
        iterations: 2000,
        operation: () => c.red(lines100),
      ));

      suite.add(runBenchmark(
        name: 'Multi-line 1000 lines',
        iterations: 200,
        operation: () => c.red(lines1000),
      ));

      // --- Multi-argument calls ---
      suite.add(runBenchmark(
        name: 'Multi-arg 2 args',
        iterations: 100000,
        operation: () => red('hello', 'world'),
      ));

      suite.add(runBenchmark(
        name: 'Multi-arg 5 args',
        iterations: 50000,
        operation: () => red('a', 'b', 'c', 'd', 'e'),
      ));

      suite.add(runBenchmark(
        name: 'Multi-arg 10 args',
        iterations: 20000,
        operation: () => red('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'),
      ));

      suite.add(runBenchmark(
        name: 'Multi-arg 15 args',
        iterations: 10000,
        operation: () =>
            red('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o'),
      ));

      // --- Mixed styled segments in one line ---
      suite.add(runBenchmark(
        name: 'Mixed 5 styled segments (concat)',
        iterations: 50000,
        operation: () =>
            c.red('one') +
            c.blue(' two') +
            c.green(' three') +
            c.yellow(' four') +
            c.magenta(' five'),
      ));

      suite.add(runBenchmark(
        name: 'Mixed 10 styled segments (concat)',
        iterations: 20000,
        operation: () =>
            c.red('1') + c.blue('2') + c.green('3') + c.yellow('4') +
            c.magenta('5') + c.cyan('6') + c.white('7') + c.brightRed('8') +
            c.brightGreen('9') + c.brightBlue('0'),
      ));

      // --- String extension vs direct Chalk API ---
      suite.add(runBenchmark(
        name: 'Direct API: chalk.red(text)',
        iterations: 100000,
        operation: () => c.red(text),
      ));

      suite.add(runBenchmark(
        name: 'String extension: text.red',
        iterations: 100000,
        operation: () => text.red,
      ));

      suite.add(runBenchmark(
        name: 'Direct API: chalk.red.bold(text)',
        iterations: 100000,
        operation: () => c.red.bold(text),
      ));

      suite.add(runBenchmark(
        name: 'String extension: text.red.bold',
        iterations: 100000,
        operation: () => text.red.bold,
      ));

      // --- Dynamic noSuchMethod vs X11 getter ---
      suite.add(runBenchmark(
        name: 'X11 getter: chalk.cornflowerBlue',
        iterations: 50000,
        operation: () => c.cornflowerBlue(text),
      ));

      suite.add(runBenchmark(
        name: 'noSuchMethod: dynamic chalk.cornflowerblue',
        iterations: 50000,
        operation: () => dynChalk.cornflowerblue(text),
      ));

      // --- List argument processing ---
      final listArg = ['item1', 'item2', 'item3', 'item4', 'item5'];
      suite.add(runBenchmark(
        name: 'List argument (5 items)',
        iterations: 50000,
        operation: () => c.red(listArg),
      ));

      // --- Function argument processing ---
      suite.add(runBenchmark(
        name: 'Function argument (closure)',
        iterations: 50000,
        operation: () => c.red(() => 'computed value'),
      ));

      // --- joinWith ---
      final joinChalk = c.red.joinWith(', ');
      suite.add(runBenchmark(
        name: 'joinWith(\', \') + 5 args',
        iterations: 50000,
        operation: () => joinChalk('a', 'b', 'c', 'd', 'e'),
      ));

      // --- Strip on styled output ---
      final styledOutput = c.red.bold.italic('hello world, styled text here');
      suite.add(runBenchmark(
        name: 'stripAnsi on styled output',
        iterations: 100000,
        operation: () => AnsiUtils.stripAnsi(styledOutput),
      ));

      suite.printResults();
    });
  });
}

/// Build a nested styled string at the given depth.
String _buildNested(Chalk c, int depth) {
  final colors = [c.red, c.green, c.blue, c.yellow, c.magenta, c.cyan, c.white, c.brightRed, c.brightGreen, c.brightBlue];
  String result = 'core';
  for (var i = 0; i < depth; i++) {
    final color = colors[i % colors.length];
    result = color('wrap$i $result wrap$i');
  }
  return result;
}
