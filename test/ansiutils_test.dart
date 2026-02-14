import 'package:chalkdart/src/ansiutils.dart';
import 'package:test/test.dart';

const ESC = '\x1B';

void main() {
  group('AnsiUtils.hasAnsi', () {
    test('detects SGR codes', () {
      expect(AnsiUtils.hasAnsi('${ESC}[4mcake${ESC}[0m'), isTrue);
    });

    test('returns false for plain text', () {
      expect(AnsiUtils.hasAnsi('cake'), isFalse);
    });

    test('returns false for empty string', () {
      expect(AnsiUtils.hasAnsi(''), isFalse);
    });

    test('detects bold code', () {
      expect(AnsiUtils.hasAnsi('${ESC}[1mtext${ESC}[22m'), isTrue);
    });

    test('detects 256-color code', () {
      expect(AnsiUtils.hasAnsi('${ESC}[38;5;196mred${ESC}[39m'), isTrue);
    });

    test('detects 16m truecolor code', () {
      expect(AnsiUtils.hasAnsi('${ESC}[38;2;255;0;0mred${ESC}[39m'), isTrue);
    });

    test('detects background color code', () {
      expect(AnsiUtils.hasAnsi('${ESC}[41mtext${ESC}[49m'), isTrue);
    });
  });

  group('AnsiUtils.ansiRegex', () {
    test('matches SGR open and close', () {
      List<RegExpMatch> m = AnsiUtils.ansiRegex.allMatches('${ESC}[4mcake${ESC}[0m').toList();
      expect(m.length, 2);
      expect(m[0].group(0), '${ESC}[4m');
      expect(m[1].group(0), '${ESC}[0m');
    });

    test('matches hyperlink OSC codes', () {
      List<RegExpMatch> m = AnsiUtils.ansiRegex.allMatches('${ESC}]8;;https://github.com\u0007click${ESC}]8;;\u0007').toList();
      expect(m[0].group(0), '${ESC}]8;;https://github.com\u0007');
      expect(m[1].group(0), '${ESC}]8;;\u0007');
    });

    test('matches multiple SGR codes', () {
      final text = '${ESC}[1m${ESC}[31mbold red${ESC}[39m${ESC}[22m';
      List<RegExpMatch> m = AnsiUtils.ansiRegex.allMatches(text).toList();
      expect(m.length, 4);
    });

    test('matches 256-color sequences', () {
      List<RegExpMatch> m = AnsiUtils.ansiRegex.allMatches('${ESC}[38;5;196mtext${ESC}[39m').toList();
      expect(m.length, 2);
    });

    test('matches truecolor sequences', () {
      List<RegExpMatch> m = AnsiUtils.ansiRegex.allMatches('${ESC}[38;2;255;128;0mtext${ESC}[39m').toList();
      expect(m.length, 2);
    });

    test('does not match plain text', () {
      List<RegExpMatch> m = AnsiUtils.ansiRegex.allMatches('plain text').toList();
      expect(m.length, 0);
    });
  });

  group('AnsiUtils.stripAnsi', () {
    test('removes all ANSI codes', () {
      expect(AnsiUtils.stripAnsi('${ESC}[31mhello${ESC}[39m'), 'hello');
    });

    test('returns plain text unchanged', () {
      expect(AnsiUtils.stripAnsi('plain text'), 'plain text');
    });

    test('returns empty string unchanged', () {
      expect(AnsiUtils.stripAnsi(''), '');
    });

    test('handles nested codes', () {
      final nested = '${ESC}[1m${ESC}[31mbold red${ESC}[39m${ESC}[22m';
      expect(AnsiUtils.stripAnsi(nested), 'bold red');
    });

    test('handles 256-color codes', () {
      expect(AnsiUtils.stripAnsi('${ESC}[38;5;196mred${ESC}[39m'), 'red');
    });

    test('handles truecolor codes', () {
      expect(AnsiUtils.stripAnsi('${ESC}[38;2;255;0;0mred${ESC}[39m'), 'red');
    });

    test('strips multiple styles from one string', () {
      final text = '${ESC}[1mbold${ESC}[22m and ${ESC}[3mitalic${ESC}[23m';
      expect(AnsiUtils.stripAnsi(text), 'bold and italic');
    });

    test('preserves special characters', () {
      final text = '${ESC}[31mtab\there\nnewline${ESC}[39m';
      expect(AnsiUtils.stripAnsi(text), 'tab\there\nnewline');
    });
  });

  group('AnsiStringUtils extension', () {
    test('lengthWithoutAnsi returns correct length for styled text', () {
      expect('${ESC}[31mhello${ESC}[39m'.lengthWithoutAnsi, 5);
    });

    test('lengthWithoutAnsi returns correct length for plain text', () {
      expect('plain'.lengthWithoutAnsi, 5);
    });

    test('lengthWithoutAnsi returns 0 for empty string', () {
      expect(''.lengthWithoutAnsi, 0);
    });

    test('lengthWithoutAnsi handles complex styling', () {
      final text = '${ESC}[1m${ESC}[31m${ESC}[44mhello world${ESC}[49m${ESC}[39m${ESC}[22m';
      expect(text.lengthWithoutAnsi, 11);
    });

    test('stripAnsi getter removes codes', () {
      expect('${ESC}[31mhello${ESC}[39m'.stripAnsi, 'hello');
    });

    test('stripAnsi getter returns plain text unchanged', () {
      expect('plain'.stripAnsi, 'plain');
    });
  });
}
