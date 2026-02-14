import 'package:chalkdart/chalk.dart';
import 'package:chalkdart/src/ansiutils.dart';
import 'package:test/test.dart';

const ESC = '\x1B';

void main() {
  // =========================================================================
  // Construction and configuration
  // =========================================================================
  group('Chalk construction', () {
    test('Chalk() creates a root instance', () {
      final c = Chalk();
      expect(c, isA<Chalk>());
    });

    test('Chalk.instance() creates a root instance', () {
      final c = Chalk.instance();
      expect(c, isA<Chalk>());
    });

    test('Chalk.Instance() creates a root instance (JS alias)', () {
      final c = Chalk.Instance();
      expect(c, isA<Chalk>());
    });

    test('root Chalk passes text through unstyled', () {
      final c = Chalk();
      expect(c('hello'), 'hello');
    });

    test('default level is 3', () {
      final c = Chalk();
      expect(c.level, 3);
    });

    test('instance with custom level', () {
      final c = Chalk.instance(level: 0);
      expect(c.level, 0);
    });

    test('toString contains Chalk', () {
      final c = Chalk();
      expect(c.toString(), contains('Chalk'));
    });

    test('toStringWalkUp returns debug info', () {
      final c = Chalk();
      final result = c.red.bold.toStringWalkUp();
      expect(result, isA<String>());
      expect(result.length, greaterThan(0));
    });
  });

  // =========================================================================
  // ANSI foreground colors
  // =========================================================================
  group('Chalk ANSI foreground colors', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('black uses SGR 30', () {
      expect(c.black('test'), contains('${ESC}[30m'));
    });

    test('red uses SGR 31', () {
      expect(c.red('test'), contains('${ESC}[31m'));
    });

    test('green uses SGR 32', () {
      expect(c.green('test'), contains('${ESC}[32m'));
    });

    test('yellow uses SGR 33', () {
      expect(c.yellow('test'), contains('${ESC}[33m'));
    });

    test('blue uses SGR 34', () {
      expect(c.blue('test'), contains('${ESC}[34m'));
    });

    test('magenta uses SGR 35', () {
      expect(c.magenta('test'), contains('${ESC}[35m'));
    });

    test('cyan uses SGR 36', () {
      expect(c.cyan('test'), contains('${ESC}[36m'));
    });

    test('white uses SGR 37', () {
      expect(c.white('test'), contains('${ESC}[37m'));
    });

    test('brightBlack uses SGR 90', () {
      expect(c.brightBlack('test'), contains('${ESC}[90m'));
    });

    test('brightRed uses SGR 91', () {
      expect(c.brightRed('test'), contains('${ESC}[91m'));
    });

    test('brightGreen uses SGR 92', () {
      expect(c.brightGreen('test'), contains('${ESC}[92m'));
    });

    test('brightYellow uses SGR 93', () {
      expect(c.brightYellow('test'), contains('${ESC}[93m'));
    });

    test('brightBlue uses SGR 94', () {
      expect(c.brightBlue('test'), contains('${ESC}[94m'));
    });

    test('brightMagenta uses SGR 95', () {
      expect(c.brightMagenta('test'), contains('${ESC}[95m'));
    });

    test('brightCyan uses SGR 96', () {
      expect(c.brightCyan('test'), contains('${ESC}[96m'));
    });

    test('brightWhite uses SGR 97', () {
      expect(c.brightWhite('test'), contains('${ESC}[97m'));
    });

    test('all foreground colors close with SGR 39', () {
      for (var getter in [c.black, c.red, c.green, c.yellow, c.blue, c.magenta, c.cyan, c.white]) {
        expect(getter('test'), contains('${ESC}[39m'));
      }
    });

    test('gray/grey/blackBright are aliases for brightBlack', () {
      final expected = c.brightBlack('test');
      expect(c.gray('test'), expected);
      expect(c.grey('test'), expected);
      expect(c.blackBright('test'), expected);
    });

    test('xxxBright aliases match brightXxx', () {
      expect(c.redBright('t'), c.brightRed('t'));
      expect(c.greenBright('t'), c.brightGreen('t'));
      expect(c.yellowBright('t'), c.brightYellow('t'));
      expect(c.blueBright('t'), c.brightBlue('t'));
      expect(c.magentaBright('t'), c.brightMagenta('t'));
      expect(c.cyanBright('t'), c.brightCyan('t'));
      expect(c.whiteBright('t'), c.brightWhite('t'));
    });
  });

  // =========================================================================
  // ANSI background colors
  // =========================================================================
  group('Chalk ANSI background colors', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('onBlack uses SGR 40', () {
      expect(c.onBlack('test'), contains('${ESC}[40m'));
    });

    test('onRed uses SGR 41', () {
      expect(c.onRed('test'), contains('${ESC}[41m'));
    });

    test('onGreen uses SGR 42', () {
      expect(c.onGreen('test'), contains('${ESC}[42m'));
    });

    test('onYellow uses SGR 43', () {
      expect(c.onYellow('test'), contains('${ESC}[43m'));
    });

    test('onBlue uses SGR 44', () {
      expect(c.onBlue('test'), contains('${ESC}[44m'));
    });

    test('onMagenta uses SGR 45', () {
      expect(c.onMagenta('test'), contains('${ESC}[45m'));
    });

    test('onCyan uses SGR 46', () {
      expect(c.onCyan('test'), contains('${ESC}[46m'));
    });

    test('onWhite uses SGR 47', () {
      expect(c.onWhite('test'), contains('${ESC}[47m'));
    });

    test('onBrightBlack uses SGR 100', () {
      expect(c.onBrightBlack('test'), contains('${ESC}[100m'));
    });

    test('onBrightRed uses SGR 101', () {
      expect(c.onBrightRed('test'), contains('${ESC}[101m'));
    });

    test('onBrightGreen uses SGR 102', () {
      expect(c.onBrightGreen('test'), contains('${ESC}[102m'));
    });

    test('onBrightYellow uses SGR 103', () {
      expect(c.onBrightYellow('test'), contains('${ESC}[103m'));
    });

    test('onBrightBlue uses SGR 104', () {
      expect(c.onBrightBlue('test'), contains('${ESC}[104m'));
    });

    test('onBrightMagenta uses SGR 105', () {
      expect(c.onBrightMagenta('test'), contains('${ESC}[105m'));
    });

    test('onBrightCyan uses SGR 106', () {
      expect(c.onBrightCyan('test'), contains('${ESC}[106m'));
    });

    test('onBrightWhite uses SGR 107', () {
      expect(c.onBrightWhite('test'), contains('${ESC}[107m'));
    });

    test('all background colors close with SGR 49', () {
      for (var getter in [c.onBlack, c.onRed, c.onGreen, c.onYellow, c.onBlue, c.onMagenta, c.onCyan, c.onWhite]) {
        expect(getter('test'), contains('${ESC}[49m'));
      }
    });

    test('bgXxx legacy aliases match onXxx', () {
      expect(c.bgBlack('t'), c.onBlack('t'));
      expect(c.bgRed('t'), c.onRed('t'));
      expect(c.bgGreen('t'), c.onGreen('t'));
      expect(c.bgYellow('t'), c.onYellow('t'));
      expect(c.bgBlue('t'), c.onBlue('t'));
      expect(c.bgMagenta('t'), c.onMagenta('t'));
      expect(c.bgCyan('t'), c.onCyan('t'));
      expect(c.bgWhite('t'), c.onWhite('t'));
    });

    test('onGray/onGrey are aliases for onBrightBlack', () {
      expect(c.onGray('t'), c.onBrightBlack('t'));
      expect(c.onGrey('t'), c.onBrightBlack('t'));
    });

    test('bgBrightXxx/bgXxxBright aliases', () {
      expect(c.bgBrightRed('t'), c.onBrightRed('t'));
      expect(c.bgRedBright('t'), c.onBrightRed('t'));
      expect(c.bgBrightGreen('t'), c.onBrightGreen('t'));
      expect(c.bgGreenBright('t'), c.onBrightGreen('t'));
      expect(c.bgBrightYellow('t'), c.onBrightYellow('t'));
      expect(c.bgYellowBright('t'), c.onBrightYellow('t'));
      expect(c.bgBrightBlue('t'), c.onBrightBlue('t'));
      expect(c.bgBlueBright('t'), c.onBrightBlue('t'));
      expect(c.bgBrightMagenta('t'), c.onBrightMagenta('t'));
      expect(c.bgMagentaBright('t'), c.onBrightMagenta('t'));
      expect(c.bgBrightCyan('t'), c.onBrightCyan('t'));
      expect(c.bgCyanBright('t'), c.onBrightCyan('t'));
      expect(c.bgBrightWhite('t'), c.onBrightWhite('t'));
      expect(c.bgWhiteBright('t'), c.onBrightWhite('t'));
    });
  });

  // =========================================================================
  // Style modifiers
  // =========================================================================
  group('Chalk style modifiers', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('bold uses SGR 1/22', () {
      final r = c.bold('test');
      expect(r, contains('${ESC}[1m'));
      expect(r, contains('${ESC}[22m'));
    });

    test('dim uses SGR 2/22', () {
      final r = c.dim('test');
      expect(r, contains('${ESC}[2m'));
      expect(r, contains('${ESC}[22m'));
    });

    test('italic uses SGR 3/23', () {
      final r = c.italic('test');
      expect(r, contains('${ESC}[3m'));
      expect(r, contains('${ESC}[23m'));
    });

    test('underline uses SGR 4/24', () {
      final r = c.underline('test');
      expect(r, contains('${ESC}[4m'));
      expect(r, contains('${ESC}[24m'));
    });

    test('underlined is alias for underline', () {
      expect(c.underlined('t'), c.underline('t'));
    });

    test('doubleunderline uses SGR 21/24', () {
      final r = c.doubleunderline('test');
      expect(r, contains('${ESC}[21m'));
      expect(r, contains('${ESC}[24m'));
    });

    test('doubleunderlined / doubleUnderline aliases', () {
      expect(c.doubleunderlined('t'), c.doubleunderline('t'));
      expect(c.doubleUnderline('t'), c.doubleunderline('t'));
    });

    test('overline uses SGR 53/55', () {
      final r = c.overline('test');
      expect(r, contains('${ESC}[53m'));
      expect(r, contains('${ESC}[55m'));
    });

    test('overlined is alias for overline', () {
      expect(c.overlined('t'), c.overline('t'));
    });

    test('blink uses SGR 5/25', () {
      final r = c.blink('test');
      expect(r, contains('${ESC}[5m'));
      expect(r, contains('${ESC}[25m'));
    });

    test('rapidblink uses SGR 6/25', () {
      final r = c.rapidblink('test');
      expect(r, contains('${ESC}[6m'));
      expect(r, contains('${ESC}[25m'));
    });

    test('inverse uses SGR 7/27', () {
      final r = c.inverse('test');
      expect(r, contains('${ESC}[7m'));
      expect(r, contains('${ESC}[27m'));
    });

    test('invert is alias for inverse', () {
      expect(c.invert('t'), c.inverse('t'));
    });

    test('hidden uses SGR 8/28', () {
      final r = c.hidden('test');
      expect(r, contains('${ESC}[8m'));
      expect(r, contains('${ESC}[28m'));
    });

    test('strikethrough uses SGR 9/29', () {
      final r = c.strikethrough('test');
      expect(r, contains('${ESC}[9m'));
      expect(r, contains('${ESC}[29m'));
    });

    test('superscript uses SGR 73/75', () {
      final r = c.superscript('test');
      expect(r, contains('${ESC}[73m'));
      expect(r, contains('${ESC}[75m'));
    });

    test('subscript uses SGR 74/75', () {
      final r = c.subscript('test');
      expect(r, contains('${ESC}[74m'));
      expect(r, contains('${ESC}[75m'));
    });

    test('reset uses SGR 0', () {
      expect(c.reset('test'), contains('${ESC}[0m'));
    });

    test('normal uses SGR 0', () {
      expect(c.normal('test'), contains('${ESC}[0m'));
    });

    test('font1-font10 use SGR 11-20', () {
      expect(c.font1('t'), contains('${ESC}[11m'));
      expect(c.font2('t'), contains('${ESC}[12m'));
      expect(c.font3('t'), contains('${ESC}[13m'));
      expect(c.font4('t'), contains('${ESC}[14m'));
      expect(c.font5('t'), contains('${ESC}[15m'));
      expect(c.font6('t'), contains('${ESC}[16m'));
      expect(c.font7('t'), contains('${ESC}[17m'));
      expect(c.font8('t'), contains('${ESC}[18m'));
      expect(c.font9('t'), contains('${ESC}[19m'));
      expect(c.font10('t'), contains('${ESC}[20m'));
    });

    test('blackletter is alias for font10', () {
      expect(c.blackletter('t'), c.font10('t'));
    });

    test('all fonts close with SGR 10', () {
      for (var font in [c.font1, c.font2, c.font3, c.font4, c.font5, c.font6, c.font7, c.font8, c.font9]) {
        expect(font('t'), contains('${ESC}[10m'));
      }
    });
  });

  // =========================================================================
  // Chaining
  // =========================================================================
  group('Chalk chaining', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('foreground + background', () {
      final r = c.red.onBlue('test');
      expect(r, contains('${ESC}[31m'));
      expect(r, contains('${ESC}[44m'));
      expect(r, contains('test'));
    });

    test('multiple styles', () {
      final r = c.bold.italic.underline('test');
      expect(r, contains('${ESC}[1m'));
      expect(r, contains('${ESC}[3m'));
      expect(r, contains('${ESC}[4m'));
    });

    test('color + style', () {
      final r = c.red.bold('test');
      expect(r, contains('${ESC}[31m'));
      expect(r, contains('${ESC}[1m'));
    });

    test('three-way: fg + bg + style', () {
      final r = c.yellow.onBlue.bold('test');
      expect(r, contains('${ESC}[33m'));
      expect(r, contains('${ESC}[44m'));
      expect(r, contains('${ESC}[1m'));
    });

    test('open codes appear in chain order', () {
      final r = c.bold.red('test');
      int boldPos = r.indexOf('${ESC}[1m');
      int redPos = r.indexOf('${ESC}[31m');
      expect(boldPos, lessThan(redPos));
    });

    test('close codes appear in reverse order', () {
      final r = c.bold.red('test');
      int testEnd = r.indexOf('test') + 4;
      String after = r.substring(testEnd);
      int redClose = after.indexOf('${ESC}[39m');
      int boldClose = after.indexOf('${ESC}[22m');
      expect(redClose, lessThan(boldClose));
    });

    test('stripped text preserves content', () {
      final r = c.bold.red.onBlue.italic('Hello, World!');
      expect(AnsiUtils.stripAnsi(r), 'Hello, World!');
    });
  });

  // =========================================================================
  // RGB, Hex, keyword colors
  // =========================================================================
  group('Chalk RGB colors', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('rgb() foreground 16M', () {
      final r = c.rgb(255, 128, 0)('test');
      expect(r, contains('${ESC}[38;2;255;128;0m'));
      expect(r, contains('${ESC}[39m'));
    });

    test('onRgb() background 16M', () {
      final r = c.onRgb(255, 128, 0)('test');
      expect(r, contains('${ESC}[48;2;255;128;0m'));
      expect(r, contains('${ESC}[49m'));
    });

    test('bgRgb() is alias for onRgb()', () {
      expect(c.bgRgb(1, 2, 3)('t'), c.onRgb(1, 2, 3)('t'));
    });

    test('rgb16m() forces 16M', () {
      expect(c.rgb16m(10, 20, 30)('t'), contains('${ESC}[38;2;10;20;30m'));
    });

    test('onRgb16m() background 16M forced', () {
      expect(c.onRgb16m(10, 20, 30)('t'), contains('${ESC}[48;2;10;20;30m'));
    });

    test('bgRgb16m() is alias for onRgb16m()', () {
      expect(c.bgRgb16m(1, 2, 3)('t'), c.onRgb16m(1, 2, 3)('t'));
    });

    test('underlineRgb() underline color', () {
      final r = c.underlineRgb(255, 0, 0)('test');
      expect(r, contains('${ESC}[58;2;255;0;0m'));
      expect(r, contains('${ESC}[59m'));
    });

    test('underlineRgb16m() forced 16M underline', () {
      expect(c.underlineRgb16m(1, 2, 3)('t'), contains('${ESC}[58;2;1;2;3m'));
    });
  });

  group('Chalk hex colors', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('hex() with string', () {
      expect(c.hex('#FF0000')('t'), contains('${ESC}[38;2;255;0;0m'));
    });

    test('hex() with int', () {
      expect(c.hex(0x00FF00)('t'), contains('${ESC}[38;2;0;255;0m'));
    });

    test('onHex() background', () {
      expect(c.onHex('#0000FF')('t'), contains('${ESC}[48;2;0;0;255m'));
    });

    test('bgHex() alias', () {
      expect(c.bgHex('#AB')('t'), c.onHex('#AB')('t'));
    });

    test('hex() with 3-digit code', () {
      expect(c.hex('#F00')('t'), contains('${ESC}[38;2;255;0;0m'));
    });
  });

  group('Chalk keyword colors', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('keyword red', () {
      expect(c.keyword('red')('t'), contains('${ESC}[38;2;255;0;0m'));
    });

    test('onKeyword blue', () {
      expect(c.onKeyword('blue')('t'), contains('${ESC}[48;2;0;0;255m'));
    });

    test('bgKeyword alias', () {
      expect(c.bgKeyword('green')('t'), c.onKeyword('green')('t'));
    });

    test('keyword is case-insensitive', () {
      expect(c.keyword('CornflowerBlue')('t'), c.keyword('cornflowerblue')('t'));
    });

    test('unknown keyword returns black', () {
      expect(c.keyword('nonexistent')('t'), contains('${ESC}[38;2;0;0;0m'));
    });
  });

  // =========================================================================
  // HSL/HSV/HWB/XYZ/LAB
  // =========================================================================
  group('Chalk color space methods', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('hsl() foreground', () {
      expect(c.hsl(0, 100, 50)('t'), contains('${ESC}[38;2;'));
    });

    test('onHsl() background', () {
      expect(c.onHsl(120, 100, 50)('t'), contains('${ESC}[48;2;'));
    });

    test('bgHsl() alias', () {
      expect(c.bgHsl(120, 100, 50)('t'), c.onHsl(120, 100, 50)('t'));
    });

    test('hsv() foreground', () {
      expect(c.hsv(0, 100, 100)('t'), contains('${ESC}[38;2;'));
    });

    test('onHsv() background', () {
      expect(c.onHsv(120, 100, 100)('t'), contains('${ESC}[48;2;'));
    });

    test('bgHsv() alias', () {
      expect(c.bgHsv(60, 100, 100)('t'), c.onHsv(60, 100, 100)('t'));
    });

    test('hwb() foreground', () {
      expect(c.hwb(0, 0, 0)('t'), contains('${ESC}[38;2;'));
    });

    test('onHwb() background', () {
      expect(c.onHwb(0, 0, 0)('t'), contains('${ESC}[48;2;'));
    });

    test('bgHwb() alias', () {
      expect(c.bgHwb(0, 50, 50)('t'), c.onHwb(0, 50, 50)('t'));
    });

    test('xyz() foreground', () {
      expect(c.xyz(95, 100, 109)('t'), contains('${ESC}[38;2;'));
    });

    test('onXyz() background', () {
      expect(c.onXyz(95, 100, 109)('t'), contains('${ESC}[48;2;'));
    });

    test('bgXyz() alias', () {
      expect(c.bgXyz(50, 50, 50)('t'), c.onXyz(50, 50, 50)('t'));
    });

    test('lab() foreground', () {
      expect(c.lab(50, 50, 0)('t'), contains('${ESC}[38;2;'));
    });

    test('onLab() background', () {
      expect(c.onLab(50, 50, 0)('t'), contains('${ESC}[48;2;'));
    });

    test('bgLab() alias', () {
      expect(c.bgLab(50, 0, 50)('t'), c.onLab(50, 0, 50)('t'));
    });
  });

  // =========================================================================
  // ANSI 256 and greyscale
  // =========================================================================
  group('Chalk ANSI 256 and greyscale', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('ansi() foreground 256', () {
      expect(c.ansi(196)('t'), contains('${ESC}[38;5;196m'));
    });

    test('onAnsi() background 256', () {
      expect(c.onAnsi(196)('t'), contains('${ESC}[48;5;196m'));
    });

    test('bgAnsi() alias', () {
      expect(c.bgAnsi(46)('t'), c.onAnsi(46)('t'));
    });

    test('ansi256() foreground', () {
      expect(c.ansi256(46)('t'), contains('${ESC}[38;5;46m'));
    });

    test('onAnsi256() background', () {
      expect(c.onAnsi256(46)('t'), contains('${ESC}[48;5;46m'));
    });

    test('xterm() foreground (default)', () {
      expect(c.xterm(196)('t'), contains('${ESC}[38;5;196m'));
    });

    test('xterm() background with bg=true', () {
      expect(c.xterm(196, true)('t'), contains('${ESC}[48;5;196m'));
    });

    test('greyscale(0.0) dark', () {
      expect(c.greyscale(0.0)('t'), contains('${ESC}[38;5;232m'));
    });

    test('greyscale(1.0) light', () {
      expect(c.greyscale(1.0)('t'), contains('${ESC}[38;5;255m'));
    });

    test('onGreyscale() background', () {
      expect(c.onGreyscale(0.5)('t'), contains('${ESC}[48;5;'));
    });

    test('bgGreyscale() alias', () {
      expect(c.bgGreyscale(0.5)('t'), c.onGreyscale(0.5)('t'));
    });
  });

  // =========================================================================
  // ansiSgr
  // =========================================================================
  group('Chalk ansiSgr', () {
    test('applies custom open/close codes', () {
      final c = Chalk();
      final r = c.ansiSgr(1, 22)('test');
      expect(r, contains('${ESC}[1m'));
      expect(r, contains('${ESC}[22m'));
      expect(r, contains('test'));
    });
  });

  // =========================================================================
  // call() behavior
  // =========================================================================
  group('Chalk call() behavior', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('single string argument', () {
      expect(AnsiUtils.stripAnsi(c.red('hello')), 'hello');
    });

    test('multiple arguments join with space', () {
      Chalk red = c.red;
      expect(AnsiUtils.stripAnsi(red('hello', 'world')), 'hello world');
    });

    test('three arguments', () {
      Chalk red = c.red;
      expect(AnsiUtils.stripAnsi(red('a', 'b', 'c')), 'a b c');
    });

    test('null returns null string', () {
      // _fixArg(null) returns the string 'null'
      expect(AnsiUtils.stripAnsi(c.red(null)), 'null');
    });

    test('number converts to string', () {
      expect(AnsiUtils.stripAnsi(c.red(42)), '42');
    });

    test('list joins elements', () {
      expect(AnsiUtils.stripAnsi(c.red(['a', 'b', 'c'])), 'a b c');
    });

    test('function closure is evaluated', () {
      expect(AnsiUtils.stripAnsi(c.red(() => 'lazy')), 'lazy');
    });

    test('bool converts to string', () {
      expect(AnsiUtils.stripAnsi(c.red(true)), 'true');
    });
  });

  // =========================================================================
  // joinWith
  // =========================================================================
  group('Chalk joinWith', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('changes separator for multiple args', () {
      expect(AnsiUtils.stripAnsi(c.red.joinWith(', ')('a', 'b', 'c')), 'a, b, c');
    });

    test('changes separator for list args', () {
      expect(AnsiUtils.stripAnsi(c.red.joinWith('-')(['x', 'y', 'z'])), 'x-y-z');
    });

    test('empty string separator concatenates', () {
      expect(AnsiUtils.stripAnsi(c.red.joinWith('')('a', 'b')), 'ab');
    });
  });

  // =========================================================================
  // level behavior
  // =========================================================================
  group('Chalk level behavior', () {
    test('level 0 returns unstyled text', () {
      final c = Chalk();
      c.level = 0;
      expect(c.red('test'), 'test');
    });

    test('level 0 with visible returns empty', () {
      final c = Chalk();
      c.level = 0;
      expect(c.visible('test'), '');
    });

    test('level 3 is default and produces styles', () {
      final c = Chalk();
      expect(c.level, 3);
      expect(c.red('test'), contains(ESC));
    });
  });

  // =========================================================================
  // visible modifier
  // =========================================================================
  group('Chalk visible modifier', () {
    test('returns text when level > 0', () {
      final c = Chalk();
      expect(c.visible('test'), 'test');
    });

    test('returns empty when level is 0', () {
      final c = Chalk();
      c.level = 0;
      expect(c.visible('test'), '');
    });
  });

  // =========================================================================
  // equality and hashCode
  // =========================================================================
  group('Chalk equality and hashCode', () {
    test('same style chalks are equal', () {
      expect(Chalk().red, equals(Chalk().red));
    });

    test('different style chalks are not equal', () {
      expect(Chalk().red, isNot(equals(Chalk().blue)));
    });

    test('equal chalks have same hashCode', () {
      expect(Chalk().bold.red.hashCode, Chalk().bold.red.hashCode);
    });

    test('chained chalks with same chain are equal', () {
      expect(Chalk().bold.red.onBlue, equals(Chalk().bold.red.onBlue));
    });

    test('different chains are not equal', () {
      expect(Chalk().bold.red, isNot(equals(Chalk().italic.red)));
    });
  });

  // =========================================================================
  // newline handling
  // =========================================================================
  group('Chalk newline handling', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('newlines get close/open inserted', () {
      final r = c.red('line1\nline2');
      expect(r, contains('${ESC}[39m'));
      expect(r, contains('\n'));
      expect(AnsiUtils.stripAnsi(r), 'line1\nline2');
    });

    test('CRLF handled', () {
      final r = c.red('line1\r\nline2');
      expect(AnsiUtils.stripAnsi(r), 'line1\r\nline2');
    });

    test('multiple newlines all handled', () {
      expect(AnsiUtils.stripAnsi(c.red('a\nb\nc')), 'a\nb\nc');
    });

    test('no newline leaves string as-is', () {
      final r = c.red('no newlines here');
      expect(AnsiUtils.stripAnsi(r), 'no newlines here');
    });
  });

  // =========================================================================
  // strip
  // =========================================================================
  group('Chalk strip', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('removes ANSI codes', () {
      expect(c.strip(c.red.bold('hello')), 'hello');
    });

    test('plain text returns same', () {
      expect(c.strip('plain'), 'plain');
    });
  });

  // =========================================================================
  // wrap
  // =========================================================================
  group('Chalk wrap', () {
    test('wrap before style adds prefix and suffix', () {
      final c = Chalk();
      // wrap() must precede styles so its open/close propagate through _openAll/_closeAll
      final r = c.wrap('<<', '>>').red('test');
      expect(r, contains('<<'));
      expect(r, contains('>>'));
      expect(r, contains('test'));
    });

    test('wrap alone passes through text', () {
      final c = Chalk();
      // wrap() sets _hasStyle=false, so call() returns text as-is
      final r = c.wrap('<<', '>>')('test');
      expect(r, 'test');
    });
  });

  // =========================================================================
  // HTML utility methods
  // =========================================================================
  group('Chalk HTML utilities', () {
    test('htmlSafeGtLt escapes < and >', () {
      expect(Chalk.htmlSafeGtLt('<div>hi</div>'), '&lt;div&gt;hi&lt;/div&gt;');
    });

    test('htmlSafeGtLt with no specials unchanged', () {
      expect(Chalk.htmlSafeGtLt('hello'), 'hello');
    });

    test('htmlSafeSpaces replaces spaces outside tags', () {
      expect(Chalk.htmlSafeSpaces('a b c'), 'a&nbsp;b&nbsp;c');
    });

    test('htmlSafeSpaces preserves spaces inside tags', () {
      final r = Chalk.htmlSafeSpaces('<span style="color: red;">a b</span>');
      expect(r, contains('style="color: red;"'));
      expect(r, contains('a&nbsp;b'));
    });
  });

  // =========================================================================
  // useFullResetToClose
  // =========================================================================
  group('Chalk useFullResetToClose', () {
    tearDown(() => Chalk.useFullResetToClose = false);

    test('when true, close codes use SGR 0', () {
      Chalk.useFullResetToClose = true;
      final c = Chalk();
      expect(c.bold('test'), contains('${ESC}[0m'));
    });
  });

  // =========================================================================
  // noSuchMethod dynamic colors
  // =========================================================================
  group('Chalk noSuchMethod dynamic colors', () {
    test('dynamic color keyword', () {
      dynamic c = Chalk();
      final r = c.cornflowerblue('test');
      expect(r, isA<String>());
      expect(AnsiUtils.stripAnsi(r), 'test');
    });

    test('dynamic onXXX background', () {
      dynamic c = Chalk();
      final r = c.onCornflowerblue('test');
      expect(r, isA<String>());
      expect(r, contains('${ESC}[48;2;'));
    });

    test('dynamic bgXXX background', () {
      dynamic c = Chalk();
      final r = c.bgCornflowerblue('test');
      expect(r, isA<String>());
      expect(r, contains('${ESC}[48;2;'));
    });

    test('color getter -> dynamic keyword', () {
      dynamic c = Chalk();
      final r = c.color.coral('test');
      expect(r, isA<String>());
      expect(AnsiUtils.stripAnsi(r), 'test');
    });

    test('x11 getter -> dynamic keyword', () {
      dynamic c = Chalk();
      final r = c.x11.tomato('test');
      expect(r, isA<String>());
    });

    test('csscolor getter -> dynamic keyword', () {
      dynamic c = Chalk();
      final r = c.csscolor.gold('test');
      expect(r, isA<String>());
    });

    test('dynamic keyword returns Chalk when no args', () {
      dynamic c = Chalk();
      final styler = c.color.tomato;
      expect(styler, isA<Chalk>());
      final r = styler('test');
      expect(r, isA<String>());
      expect(AnsiUtils.stripAnsi(r), 'test');
    });
  });

  // =========================================================================
  // Custom color keywords
  // =========================================================================
  group('Chalk custom color keywords', () {
    test('addColorKeywordRgb', () {
      Chalk.addColorKeywordRgb('chalktest1', 100, 149, 237);
      expect(Chalk().keyword('chalktest1')('t'), contains('${ESC}[38;2;100;149;237m'));
    });

    test('addColorKeywordHex with int', () {
      Chalk.addColorKeywordHex('chalktest2', 0xABCDEF);
      expect(Chalk().keyword('chalktest2')('t'), contains('${ESC}[38;2;171;205;239m'));
    });

    test('addColorKeywordHex with string', () {
      Chalk.addColorKeywordHex('chalktest3', '#112233');
      expect(Chalk().keyword('chalktest3')('t'), contains('${ESC}[38;2;17;34;51m'));
    });
  });

  // =========================================================================
  // Nested ANSI re-opening
  // =========================================================================
  group('Chalk nested ANSI handling', () {
    test('nested styles re-open after inner close', () {
      final c = Chalk();
      final inner = c.blue('inner');
      final outer = c.red(inner);
      expect(outer, contains('${ESC}[31m'));
      expect(AnsiUtils.stripAnsi(outer), 'inner');
    });
  });

  // =========================================================================
  // Multiple instances
  // =========================================================================
  group('Chalk multiple instances', () {
    test('instances are independent', () {
      final c1 = Chalk();
      final c2 = Chalk();
      c1.level = 0;
      expect(c2.red('test'), contains('${ESC}[31m'));
      expect(c1.red('test'), 'test');
    });

    test('ansiColorLevelForNewInstances affects new instances', () {
      final oldLevel = Chalk.ansiColorLevelForNewInstances;
      try {
        Chalk.ansiColorLevelForNewInstances = 0;
        final c = Chalk();
        expect(c.level, 0);
        expect(c.red('test'), 'test');
      } finally {
        Chalk.ansiColorLevelForNewInstances = oldLevel;
      }
    });
  });

  // =========================================================================
  // Edge cases
  // =========================================================================
  group('Edge cases', () {
    late Chalk c;
    setUp(() => c = Chalk());

    test('empty string', () {
      final r = c.red('');
      expect(r, isA<String>());
    });

    test('very long string', () {
      final long = 'x' * 10000;
      expect(AnsiUtils.stripAnsi(c.red(long)), long);
    });

    test('special characters preserved', () {
      final s = 'tab\there\nnewline !@#\$%^&*()';
      expect(AnsiUtils.stripAnsi(c.red(s)), s);
    });

    test('unicode preserved', () {
      final u = 'Hello \u{1F600} \u{1F680} World';
      expect(AnsiUtils.stripAnsi(c.red(u)), u);
    });
  });
}
