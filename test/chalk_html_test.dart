import 'package:chalkdart/chalk.dart';
import 'package:test/test.dart';

void main() {
  // =========================================================================
  // HTML output mode basics
  // =========================================================================
  group('Chalk HTML output mode basics', () {
    late Chalk h;
    setUp(() {
      h = Chalk(outputMode: ChalkOutputMode.html);
    });

    test('produces span tags', () {
      final r = h.red('test');
      expect(r, contains('<span'));
      expect(r, contains('</span>'));
      expect(r, contains('test'));
    });

    test('does not contain ANSI ESC', () {
      final r = h.red.bold('test');
      expect(r.contains('\x1B'), isFalse);
    });

    test('root chalk passes through unstyled', () {
      expect(h('hello'), 'hello');
    });
  });

  // =========================================================================
  // HTML foreground colors
  // =========================================================================
  group('Chalk HTML foreground colors', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('red produces span with color', () {
      final r = h.red('test');
      expect(r, contains('<span'));
      expect(r.toLowerCase(), contains('color'));
    });

    test('green produces span', () {
      expect(h.green('test'), contains('<span'));
    });

    test('blue produces span', () {
      expect(h.blue('test'), contains('<span'));
    });

    test('each basic color produces a span and closes', () {
      for (var color in [h.black, h.red, h.green, h.yellow, h.blue, h.magenta, h.cyan, h.white]) {
        final r = color('test');
        expect(r, contains('<span'));
        expect(r, contains('</span>'));
        expect(r, contains('test'));
      }
    });

    test('bright colors produce spans', () {
      for (var color in [h.brightBlack, h.brightRed, h.brightGreen, h.brightYellow, h.brightBlue, h.brightMagenta, h.brightCyan, h.brightWhite]) {
        final r = color('test');
        expect(r, contains('<span'));
        expect(r, contains('</span>'));
      }
    });
  });

  // =========================================================================
  // HTML background colors
  // =========================================================================
  group('Chalk HTML background colors', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('onRed produces background-color', () {
      final r = h.onRed('test');
      expect(r, contains('background-color'));
    });

    test('onBlue produces background-color', () {
      expect(h.onBlue('test'), contains('background-color'));
    });

    test('each onXxx background produces background-color', () {
      for (var bg in [h.onBlack, h.onRed, h.onGreen, h.onYellow, h.onBlue, h.onMagenta, h.onCyan, h.onWhite]) {
        expect(bg('test'), contains('background-color'));
      }
    });
  });

  // =========================================================================
  // HTML style modifiers
  // =========================================================================
  group('Chalk HTML style modifiers', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('bold uses ansi-bold class', () {
      expect(h.bold('test').toLowerCase(), contains('ansi-bold'));
    });

    test('italic uses ansi-italic class', () {
      expect(h.italic('test').toLowerCase(), contains('ansi-italic'));
    });

    test('underline uses ansi-underline class', () {
      expect(h.underline('test').toLowerCase(), contains('ansi-underline'));
    });

    test('strikethrough produces span', () {
      final r = h.strikethrough('test');
      expect(r, contains('<span'));
      expect(r, contains('test'));
    });

    test('dim produces span', () {
      final r = h.dim('test');
      expect(r, contains('<span'));
    });

    test('inverse produces span', () {
      final r = h.inverse('test');
      expect(r, contains('<span'));
    });

    test('hidden produces span', () {
      final r = h.hidden('test');
      expect(r, contains('<span'));
    });

    test('overline produces span', () {
      final r = h.overline('test');
      expect(r, contains('<span'));
    });
  });

  // =========================================================================
  // HTML RGB/hex/keyword colors
  // =========================================================================
  group('Chalk HTML RGB/hex/keyword', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('rgb() produces color CSS', () {
      final r = h.rgb(255, 0, 0)('test');
      expect(r, contains('<span'));
      expect(r.toLowerCase(), contains('color'));
    });

    test('onRgb() produces background-color CSS', () {
      final r = h.onRgb(0, 255, 0)('test');
      expect(r, contains('background-color'));
    });

    test('hex() produces color span', () {
      final r = h.hex('#FF0000')('test');
      expect(r, contains('<span'));
      expect(r.toLowerCase(), contains('color'));
    });

    test('onHex() produces background-color span', () {
      final r = h.onHex('#00FF00')('test');
      expect(r, contains('background-color'));
    });

    test('keyword() produces color span', () {
      final r = h.keyword('cornflowerblue')('test');
      expect(r, contains('<span'));
    });

    test('onKeyword() produces background-color', () {
      final r = h.onKeyword('tomato')('test');
      expect(r, contains('background-color'));
    });
  });

  // =========================================================================
  // HTML ANSI 256 and greyscale
  // =========================================================================
  group('Chalk HTML ANSI 256 and greyscale', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('ansi256() produces span', () {
      final r = h.ansi256(196)('test');
      expect(r, contains('<span'));
      expect(r, contains('test'));
    });

    test('onAnsi256() produces background span', () {
      final r = h.onAnsi256(46)('test');
      expect(r, contains('background-color'));
    });

    test('greyscale() produces span', () {
      final r = h.greyscale(0.5)('test');
      expect(r, contains('<span'));
    });

    test('onGreyscale() produces background span', () {
      final r = h.onGreyscale(0.5)('test');
      expect(r, contains('background-color'));
    });
  });

  // =========================================================================
  // HTML chaining
  // =========================================================================
  group('Chalk HTML chaining', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('fg + bg + style chains', () {
      final r = h.bold.red.onBlue('test');
      expect(r, contains('<span'));
      expect(r, contains('test'));
      expect(r, contains('</span>'));
      expect(r.contains('\x1B'), isFalse);
    });

    test('multiple styles chain', () {
      final r = h.bold.italic.underline('test');
      expect(r, contains('<span'));
      expect(r, contains('test'));
    });

    test('chained result strips to plain text', () {
      final r = h.bold.red.onBlue('Hello');
      expect(h.strip(r), 'Hello');
    });
  });

  // =========================================================================
  // HTML strip
  // =========================================================================
  group('Chalk HTML strip', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('strip removes HTML tags', () {
      final styled = h.red('hello');
      expect(h.strip(styled), 'hello');
    });

    test('strip on plain text returns same', () {
      expect(h.strip('plain'), 'plain');
    });

    test('stripHtmlTags removes span tags', () {
      expect(h.stripHtmlTags('<span style="color:red;">hello</span>'), 'hello');
    });

    test('stripHtmlTags removes nested tags', () {
      expect(h.stripHtmlTags('<span><span>inner</span></span>'), 'inner');
    });

    test('stripHtmlTags handles empty tags', () {
      expect(h.stripHtmlTags('<span></span>'), '');
    });
  });

  // =========================================================================
  // setOutputMode switching
  // =========================================================================
  group('Chalk setOutputMode switching', () {
    test('switch to HTML', () {
      final c = Chalk();
      c.setOutputMode(ChalkOutputMode.html);
      final r = c.red('test');
      expect(r, contains('<span'));
      expect(r.contains('\x1B'), isFalse);
    });

    test('switch back to ANSI', () {
      final c = Chalk();
      c.setOutputMode(ChalkOutputMode.html);
      c.setOutputMode(ChalkOutputMode.ansi);
      final r = c.red('test');
      expect(r, contains('\x1B'));
      expect(r.contains('<span'), isFalse);
    });
  });

  // =========================================================================
  // Default output mode
  // =========================================================================
  group('Chalk default output mode', () {
    tearDown(() => Chalk.setDefaultOutputMode = ChalkOutputMode.ansi);

    test('setDefaultOutputMode affects new instances', () {
      Chalk.setDefaultOutputMode = ChalkOutputMode.html;
      final c = Chalk();
      expect(c.red('test'), contains('<span'));
    });

    test('setDefaultOutputMode does not affect existing instances', () {
      final c = Chalk();
      Chalk.setDefaultOutputMode = ChalkOutputMode.html;
      expect(c.red('test'), contains('\x1B'));
    });

    test('constructor with explicit outputMode overrides default', () {
      Chalk.setDefaultOutputMode = ChalkOutputMode.html;
      final c = Chalk(outputMode: ChalkOutputMode.ansi);
      expect(c.red('test'), contains('\x1B'));
    });
  });

  // =========================================================================
  // Stylesheet generation
  // =========================================================================
  group('Chalk stylesheet generation', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('stylesheet() returns non-empty CSS', () {
      final css = h.stylesheet();
      expect(css, isA<String>());
      expect(css.length, greaterThan(0));
    });

    test('styleSheet() is alias for stylesheet()', () {
      expect(h.styleSheet(), h.stylesheet());
    });

    test('inlineStylesheet() wraps in style tags', () {
      final css = h.inlineStylesheet();
      expect(css, contains('<style>'));
      expect(css, contains('</style>'));
    });

    test('stylesheet with dark background color set', () {
      final css = h.stylesheet(colorSetToUse: ChalkAnsiColorSet.darkBackground);
      expect(css, isA<String>());
      expect(css.length, greaterThan(0));
    });

    test('stylesheet with light background color set', () {
      final css = h.stylesheet(colorSetToUse: ChalkAnsiColorSet.lightBackground);
      expect(css, isA<String>());
      expect(css.length, greaterThan(0));
    });

    test('stylesheet with high contrast color set', () {
      final css = h.stylesheet(colorSetToUse: ChalkAnsiColorSet.highContrast);
      expect(css, isA<String>());
      expect(css.length, greaterThan(0));
    });
  });

  // =========================================================================
  // HTML color space methods
  // =========================================================================
  group('Chalk HTML color space methods', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('hsl() produces span', () {
      expect(h.hsl(0, 100, 50)('t'), contains('<span'));
    });

    test('onHsl() produces background', () {
      expect(h.onHsl(120, 100, 50)('t'), contains('background-color'));
    });

    test('hsv() produces span', () {
      expect(h.hsv(0, 100, 100)('t'), contains('<span'));
    });

    test('hwb() produces span', () {
      expect(h.hwb(0, 0, 0)('t'), contains('<span'));
    });

    test('xyz() produces span', () {
      expect(h.xyz(50, 50, 50)('t'), contains('<span'));
    });

    test('lab() produces span', () {
      expect(h.lab(50, 25, 0)('t'), contains('<span'));
    });
  });

  // =========================================================================
  // HTML font modifiers
  // =========================================================================
  group('Chalk HTML font modifiers', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('font1-font10 produce spans', () {
      for (var font in [h.font1, h.font2, h.font3, h.font4, h.font5, h.font6, h.font7, h.font8, h.font9, h.font10]) {
        final r = font('t');
        expect(r, contains('<span'));
        expect(r, contains('</span>'));
      }
    });

    test('superscript produces span', () {
      expect(h.superscript('t'), contains('<span'));
    });

    test('subscript produces span', () {
      expect(h.subscript('t'), contains('<span'));
    });

    test('blink produces span', () {
      expect(h.blink('t'), contains('<span'));
    });
  });

  // =========================================================================
  // HTML edge cases
  // =========================================================================
  group('Chalk HTML edge cases', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('empty string', () {
      final r = h.red('');
      expect(r, isA<String>());
    });

    test('text with angle brackets', () {
      // The angle brackets in text are NOT escaped by chalk - user must use htmlSafeGtLt
      final r = h.red('a < b > c');
      expect(r, isA<String>());
    });

    test('multiple arguments in HTML mode', () {
      Chalk red = h.red;
      final r = red('a', 'b', 'c');
      expect(h.strip(r), 'a b c');
    });

    test('null argument in HTML mode', () {
      // _fixArg(null) returns the string 'null'
      final r = h.red(null);
      expect(h.strip(r), 'null');
    });

    test('level 0 in HTML mode returns plain text', () {
      h.level = 0;
      expect(h.red('test'), 'test');
    });
  });

  // =========================================================================
  // HTML underline color
  // =========================================================================
  group('Chalk HTML underline color', () {
    late Chalk h;
    setUp(() => h = Chalk(outputMode: ChalkOutputMode.html));

    test('underlineRgb produces text-decoration-color', () {
      final r = h.underlineRgb(255, 0, 0)('test');
      expect(r, contains('text-decoration-color'));
    });
  });

  // =========================================================================
  // ChalkWhitespaceTreatment enum
  // =========================================================================
  group('ChalkWhitespaceTreatment', () {
    test('preserve returns "pre"', () {
      expect(ChalkWhitespaceTreatment.preserve.css, 'pre');
      expect(ChalkWhitespaceTreatment.preserve.toString(), 'pre');
    });

    test('preserveNoWrap returns "preserve nowrap"', () {
      expect(ChalkWhitespaceTreatment.preserveNoWrap.css, 'preserve nowrap');
    });

    test('preserveWrap returns "pre-wrap"', () {
      expect(ChalkWhitespaceTreatment.preserveWrap.css, 'pre-wrap');
    });

    test('normalHtml returns "normal"', () {
      expect(ChalkWhitespaceTreatment.normalHtml.css, 'normal');
    });
  });
}
