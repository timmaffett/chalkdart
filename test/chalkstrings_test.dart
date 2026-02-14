import 'package:chalkdart/chalkstrings.dart';
import 'package:chalkdart/chalkstrings_x11.dart';
import 'package:chalkdart/src/ansiutils.dart';
import 'package:test/test.dart';

const ESC = '\x1B';

void main() {
  // =========================================================================
  // String extension - foreground colors
  // =========================================================================
  group('String extension foreground colors', () {
    test('.black applies SGR 30', () {
      expect('test'.black, contains('${ESC}[30m'));
    });

    test('.red applies SGR 31', () {
      expect('test'.red, contains('${ESC}[31m'));
    });

    test('.green applies SGR 32', () {
      expect('test'.green, contains('${ESC}[32m'));
    });

    test('.yellow applies SGR 33', () {
      expect('test'.yellow, contains('${ESC}[33m'));
    });

    test('.blue applies SGR 34', () {
      expect('test'.blue, contains('${ESC}[34m'));
    });

    test('.magenta applies SGR 35', () {
      expect('test'.magenta, contains('${ESC}[35m'));
    });

    test('.cyan applies SGR 36', () {
      expect('test'.cyan, contains('${ESC}[36m'));
    });

    test('.white applies SGR 37', () {
      expect('test'.white, contains('${ESC}[37m'));
    });

    test('.brightBlack applies SGR 90', () {
      expect('test'.brightBlack, contains('${ESC}[90m'));
    });

    test('.brightRed applies SGR 91', () {
      expect('test'.brightRed, contains('${ESC}[91m'));
    });

    test('.brightGreen applies SGR 92', () {
      expect('test'.brightGreen, contains('${ESC}[92m'));
    });

    test('.brightYellow applies SGR 93', () {
      expect('test'.brightYellow, contains('${ESC}[93m'));
    });

    test('.brightBlue applies SGR 94', () {
      expect('test'.brightBlue, contains('${ESC}[94m'));
    });

    test('.brightMagenta applies SGR 95', () {
      expect('test'.brightMagenta, contains('${ESC}[95m'));
    });

    test('.brightCyan applies SGR 96', () {
      expect('test'.brightCyan, contains('${ESC}[96m'));
    });

    test('.brightWhite applies SGR 97', () {
      expect('test'.brightWhite, contains('${ESC}[97m'));
    });

    test('.gray == .brightBlack', () {
      expect('test'.gray, 'test'.brightBlack);
    });

    test('.grey == .brightBlack', () {
      expect('test'.grey, 'test'.brightBlack);
    });

    test('.blackBright == .brightBlack', () {
      expect('test'.blackBright, 'test'.brightBlack);
    });

    test('.redBright == .brightRed', () {
      expect('test'.redBright, 'test'.brightRed);
    });

    test('.greenBright == .brightGreen', () {
      expect('test'.greenBright, 'test'.brightGreen);
    });

    test('.yellowBright == .brightYellow', () {
      expect('test'.yellowBright, 'test'.brightYellow);
    });

    test('.blueBright == .brightBlue', () {
      expect('test'.blueBright, 'test'.brightBlue);
    });

    test('.magentaBright == .brightMagenta', () {
      expect('test'.magentaBright, 'test'.brightMagenta);
    });

    test('.cyanBright == .brightCyan', () {
      expect('test'.cyanBright, 'test'.brightCyan);
    });

    test('.whiteBright == .brightWhite', () {
      expect('test'.whiteBright, 'test'.brightWhite);
    });

    test('all foreground colors close with SGR 39', () {
      expect('t'.black, contains('${ESC}[39m'));
      expect('t'.red, contains('${ESC}[39m'));
      expect('t'.green, contains('${ESC}[39m'));
      expect('t'.yellow, contains('${ESC}[39m'));
      expect('t'.blue, contains('${ESC}[39m'));
      expect('t'.magenta, contains('${ESC}[39m'));
      expect('t'.cyan, contains('${ESC}[39m'));
      expect('t'.white, contains('${ESC}[39m'));
    });
  });

  // =========================================================================
  // String extension - background colors
  // =========================================================================
  group('String extension background colors', () {
    test('.onBlack applies SGR 40', () {
      expect('test'.onBlack, contains('${ESC}[40m'));
    });

    test('.onRed applies SGR 41', () {
      expect('test'.onRed, contains('${ESC}[41m'));
    });

    test('.onGreen applies SGR 42', () {
      expect('test'.onGreen, contains('${ESC}[42m'));
    });

    test('.onYellow applies SGR 43', () {
      expect('test'.onYellow, contains('${ESC}[43m'));
    });

    test('.onBlue applies SGR 44', () {
      expect('test'.onBlue, contains('${ESC}[44m'));
    });

    test('.onMagenta applies SGR 45', () {
      expect('test'.onMagenta, contains('${ESC}[45m'));
    });

    test('.onCyan applies SGR 46', () {
      expect('test'.onCyan, contains('${ESC}[46m'));
    });

    test('.onWhite applies SGR 47', () {
      expect('test'.onWhite, contains('${ESC}[47m'));
    });

    test('.onBrightBlack applies SGR 100', () {
      expect('test'.onBrightBlack, contains('${ESC}[100m'));
    });

    test('.onBrightRed applies SGR 101', () {
      expect('test'.onBrightRed, contains('${ESC}[101m'));
    });

    test('.onBrightGreen applies SGR 102', () {
      expect('test'.onBrightGreen, contains('${ESC}[102m'));
    });

    test('.onBrightYellow applies SGR 103', () {
      expect('test'.onBrightYellow, contains('${ESC}[103m'));
    });

    test('.onBrightBlue applies SGR 104', () {
      expect('test'.onBrightBlue, contains('${ESC}[104m'));
    });

    test('.onBrightMagenta applies SGR 105', () {
      expect('test'.onBrightMagenta, contains('${ESC}[105m'));
    });

    test('.onBrightCyan applies SGR 106', () {
      expect('test'.onBrightCyan, contains('${ESC}[106m'));
    });

    test('.onBrightWhite applies SGR 107', () {
      expect('test'.onBrightWhite, contains('${ESC}[107m'));
    });

    test('legacy bg* aliases', () {
      expect('t'.bgBlack, 't'.onBlack);
      expect('t'.bgRed, 't'.onRed);
      expect('t'.bgGreen, 't'.onGreen);
      expect('t'.bgYellow, 't'.onYellow);
      expect('t'.bgBlue, 't'.onBlue);
      expect('t'.bgMagenta, 't'.onMagenta);
      expect('t'.bgCyan, 't'.onCyan);
      expect('t'.bgWhite, 't'.onWhite);
    });

    test('.onGray == .onBrightBlack', () {
      expect('t'.onGray, 't'.onBrightBlack);
    });

    test('.onGrey == .onBrightBlack', () {
      expect('t'.onGrey, 't'.onBrightBlack);
    });

    test('legacy bgBrightXxx / bgXxxBright aliases', () {
      expect('t'.bgBrightBlack, 't'.onBrightBlack);
      expect('t'.bgBlackBright, 't'.onBrightBlack);
      expect('t'.bgGray, 't'.onBrightBlack);
      expect('t'.bgGrey, 't'.onBrightBlack);
      expect('t'.bgBrightRed, 't'.onBrightRed);
      expect('t'.bgRedBright, 't'.onBrightRed);
      expect('t'.bgBrightGreen, 't'.onBrightGreen);
      expect('t'.bgGreenBright, 't'.onBrightGreen);
      expect('t'.bgBrightYellow, 't'.onBrightYellow);
      expect('t'.bgYellowBright, 't'.onBrightYellow);
      expect('t'.bgBrightBlue, 't'.onBrightBlue);
      expect('t'.bgBlueBright, 't'.onBrightBlue);
      expect('t'.bgBrightMagenta, 't'.onBrightMagenta);
      expect('t'.bgMagentaBright, 't'.onBrightMagenta);
      expect('t'.bgBrightCyan, 't'.onBrightCyan);
      expect('t'.bgCyanBright, 't'.onBrightCyan);
      expect('t'.bgBrightWhite, 't'.onBrightWhite);
      expect('t'.bgWhiteBright, 't'.onBrightWhite);
    });

    test('all background colors close with SGR 49', () {
      expect('t'.onBlack, contains('${ESC}[49m'));
      expect('t'.onRed, contains('${ESC}[49m'));
      expect('t'.onGreen, contains('${ESC}[49m'));
      expect('t'.onYellow, contains('${ESC}[49m'));
      expect('t'.onBlue, contains('${ESC}[49m'));
      expect('t'.onMagenta, contains('${ESC}[49m'));
      expect('t'.onCyan, contains('${ESC}[49m'));
      expect('t'.onWhite, contains('${ESC}[49m'));
    });
  });

  // =========================================================================
  // String extension - style modifiers
  // =========================================================================
  group('String extension style modifiers', () {
    test('.bold applies SGR 1', () {
      expect('test'.bold, contains('${ESC}[1m'));
    });

    test('.dim applies SGR 2', () {
      expect('test'.dim, contains('${ESC}[2m'));
    });

    test('.italic applies SGR 3', () {
      expect('test'.italic, contains('${ESC}[3m'));
    });

    test('.underline applies SGR 4', () {
      expect('test'.underline, contains('${ESC}[4m'));
    });

    test('.underlined == .underline', () {
      expect('test'.underlined, 'test'.underline);
    });

    test('.doubleunderline applies SGR 21', () {
      expect('test'.doubleunderline, contains('${ESC}[21m'));
    });

    test('.doubleunderlined == .doubleunderline', () {
      expect('t'.doubleunderlined, 't'.doubleunderline);
    });

    test('.doubleUnderline == .doubleunderline', () {
      expect('t'.doubleUnderline, 't'.doubleunderline);
    });

    test('.overline applies SGR 53', () {
      expect('test'.overline, contains('${ESC}[53m'));
    });

    test('.overlined == .overline', () {
      expect('t'.overlined, 't'.overline);
    });

    test('.blink applies SGR 5', () {
      expect('test'.blink, contains('${ESC}[5m'));
    });

    test('.rapidblink applies SGR 6', () {
      expect('test'.rapidblink, contains('${ESC}[6m'));
    });

    test('.inverse applies SGR 7', () {
      expect('test'.inverse, contains('${ESC}[7m'));
    });

    test('.invert == .inverse', () {
      expect('t'.invert, 't'.inverse);
    });

    test('.hidden applies SGR 8', () {
      expect('test'.hidden, contains('${ESC}[8m'));
    });

    test('.strikethrough applies SGR 9', () {
      expect('test'.strikethrough, contains('${ESC}[9m'));
    });

    test('.superscript applies SGR 73', () {
      expect('test'.superscript, contains('${ESC}[73m'));
    });

    test('.subscript applies SGR 74', () {
      expect('test'.subscript, contains('${ESC}[74m'));
    });

    test('.reset applies SGR 0', () {
      expect('test'.reset, contains('${ESC}[0m'));
    });

    test('.normal applies SGR 0', () {
      expect('test'.normal, contains('${ESC}[0m'));
    });

    test('.visible passes text through', () {
      expect('test'.visible, 'test');
    });

    test('.font1 through .font10', () {
      expect('t'.font1, contains('${ESC}[11m'));
      expect('t'.font2, contains('${ESC}[12m'));
      expect('t'.font3, contains('${ESC}[13m'));
      expect('t'.font4, contains('${ESC}[14m'));
      expect('t'.font5, contains('${ESC}[15m'));
      expect('t'.font6, contains('${ESC}[16m'));
      expect('t'.font7, contains('${ESC}[17m'));
      expect('t'.font8, contains('${ESC}[18m'));
      expect('t'.font9, contains('${ESC}[19m'));
      expect('t'.font10, contains('${ESC}[20m'));
    });

    test('.blackletter == .font10', () {
      expect('t'.blackletter, 't'.font10);
    });
  });

  // =========================================================================
  // String extension - color methods (parameterized)
  // =========================================================================
  group('String extension parameterized color methods', () {
    test('.hex() foreground', () {
      expect('test'.hex('#FF0000'), contains('${ESC}[38;2;255;0;0m'));
    });

    test('.onHex() background', () {
      expect('test'.onHex('#00FF00'), contains('${ESC}[48;2;0;255;0m'));
    });

    test('.bgHex() == .onHex()', () {
      expect('t'.bgHex('#AABB00'), 't'.onHex('#AABB00'));
    });

    test('.rgb() foreground', () {
      expect('test'.rgb(255, 128, 0), contains('${ESC}[38;2;255;128;0m'));
    });

    test('.onRgb() background', () {
      expect('test'.onRgb(255, 128, 0), contains('${ESC}[48;2;255;128;0m'));
    });

    test('.bgRgb() == .onRgb()', () {
      expect('t'.bgRgb(1, 2, 3), 't'.onRgb(1, 2, 3));
    });

    test('.rgb16m() foreground', () {
      expect('t'.rgb16m(10, 20, 30), contains('${ESC}[38;2;10;20;30m'));
    });

    test('.onRgb16m() background', () {
      expect('t'.onRgb16m(10, 20, 30), contains('${ESC}[48;2;10;20;30m'));
    });

    test('.bgRgb16m() == .onRgb16m()', () {
      expect('t'.bgRgb16m(1, 2, 3), 't'.onRgb16m(1, 2, 3));
    });

    test('.underlineRgb() underline color', () {
      expect('t'.underlineRgb(255, 0, 0), contains('${ESC}[58;2;255;0;0m'));
    });

    test('.underlineRgb16m() forced', () {
      expect('t'.underlineRgb16m(1, 2, 3), contains('${ESC}[58;2;1;2;3m'));
    });

    test('.keyword() foreground', () {
      expect('t'.keyword('red'), contains('${ESC}[38;2;255;0;0m'));
    });

    test('.onKeyword() background', () {
      expect('t'.onKeyword('blue'), contains('${ESC}[48;2;0;0;255m'));
    });

    test('.bgKeyword() == .onKeyword()', () {
      expect('t'.bgKeyword('green'), 't'.onKeyword('green'));
    });

    test('.hsl() foreground', () {
      expect('t'.hsl(0, 100, 50), contains('${ESC}[38;2;'));
    });

    test('.onHsl() background', () {
      expect('t'.onHsl(120, 100, 50), contains('${ESC}[48;2;'));
    });

    test('.bgHsl() == .onHsl()', () {
      expect('t'.bgHsl(60, 100, 50), 't'.onHsl(60, 100, 50));
    });

    test('.hsv() foreground', () {
      expect('t'.hsv(0, 100, 100), contains('${ESC}[38;2;'));
    });

    test('.onHsv() background', () {
      expect('t'.onHsv(120, 100, 100), contains('${ESC}[48;2;'));
    });

    test('.bgHsv() == .onHsv()', () {
      expect('t'.bgHsv(60, 100, 100), 't'.onHsv(60, 100, 100));
    });

    test('.hwb() foreground', () {
      expect('t'.hwb(0, 0, 0), contains('${ESC}[38;2;'));
    });

    test('.onHwb() background', () {
      expect('t'.onHwb(0, 0, 0), contains('${ESC}[48;2;'));
    });

    test('.bgHwb() == .onHwb()', () {
      expect('t'.bgHwb(0, 50, 50), 't'.onHwb(0, 50, 50));
    });

    test('.xyz() foreground', () {
      expect('t'.xyz(50, 50, 50), contains('${ESC}[38;2;'));
    });

    test('.onXyz() background', () {
      expect('t'.onXyz(50, 50, 50), contains('${ESC}[48;2;'));
    });

    test('.bgXyz() == .onXyz()', () {
      expect('t'.bgXyz(50, 50, 50), 't'.onXyz(50, 50, 50));
    });

    test('.lab() foreground', () {
      expect('t'.lab(50, 25, 0), contains('${ESC}[38;2;'));
    });

    test('.onLab() background', () {
      expect('t'.onLab(50, 25, 0), contains('${ESC}[48;2;'));
    });

    test('.bgLab() == .onLab()', () {
      expect('t'.bgLab(50, 0, 50), 't'.onLab(50, 0, 50));
    });

    test('.ansi() foreground 256', () {
      expect('t'.ansi(196), contains('${ESC}[38;5;196m'));
    });

    test('.onAnsi() background 256', () {
      expect('t'.onAnsi(196), contains('${ESC}[48;5;196m'));
    });

    test('.bgAnsi() == .onAnsi()', () {
      expect('t'.bgAnsi(46), 't'.onAnsi(46));
    });

    test('.ansi256()', () {
      expect('t'.ansi256(46), contains('${ESC}[38;5;46m'));
    });

    test('.onAnsi256()', () {
      expect('t'.onAnsi256(46), contains('${ESC}[48;5;46m'));
    });

    test('.bgAnsi256() == .onAnsi256()', () {
      expect('t'.bgAnsi256(100), 't'.onAnsi256(100));
    });

    test('.greyscale() foreground', () {
      expect('t'.greyscale(0.5), contains('${ESC}[38;5;'));
    });

    test('.onGreyscale() background', () {
      expect('t'.onGreyscale(0.5), contains('${ESC}[48;5;'));
    });

    test('.bgGreyscale() == .onGreyscale()', () {
      expect('t'.bgGreyscale(0.5), 't'.onGreyscale(0.5));
    });

    test('.ansiSgr() custom codes', () {
      final r = 't'.ansiSgr(1, 22);
      expect(r, contains('${ESC}[1m'));
      expect(r, contains('${ESC}[22m'));
    });
  });

  // =========================================================================
  // String extension - chaining
  // =========================================================================
  group('String extension chaining', () {
    test('fg + bg', () {
      final r = 'test'.red.onBlue;
      expect(r, contains('${ESC}[31m'));
      expect(r, contains('${ESC}[44m'));
    });

    test('color + style', () {
      final r = 'test'.red.bold;
      expect(r, contains('${ESC}[31m'));
      expect(r, contains('${ESC}[1m'));
    });

    test('multiple styles', () {
      final r = 'test'.bold.italic.underline;
      expect(r, contains('${ESC}[1m'));
      expect(r, contains('${ESC}[3m'));
      expect(r, contains('${ESC}[4m'));
    });

    test('three-way: fg + bg + style', () {
      final r = 'test'.yellow.onBlue.bold;
      expect(r, contains('${ESC}[33m'));
      expect(r, contains('${ESC}[44m'));
      expect(r, contains('${ESC}[1m'));
    });

    test('stripped text preserves content', () {
      expect(AnsiUtils.stripAnsi('hello world'.red.bold.onBlue), 'hello world');
    });
  });

  // =========================================================================
  // String extension - strip, wrap, htmlSafe
  // =========================================================================
  group('String extension strip/wrap/htmlSafe', () {
    test('.strip removes ANSI', () {
      expect('test'.red.strip, 'test');
    });

    test('.strip on plain text', () {
      expect('plain'.strip, 'plain');
    });

    test('.wrap without styles passes through text', () {
      // wrap() sets _hasStyle=false, so call() returns text as-is
      final r = 'test'.wrap('<<', '>>');
      expect(r, 'test');
    });

    test('.htmlSafeGtLt escapes angle brackets', () {
      expect('<b>test</b>'.htmlSafeGtLt, '&lt;b&gt;test&lt;/b&gt;');
    });

    test('.htmlSafeSpaces converts spaces', () {
      expect('a b c'.htmlSafeSpaces, 'a&nbsp;b&nbsp;c');
    });

    test('.stripHtmlTags removes HTML', () {
      expect('<span>test</span>'.stripHtmlTags, 'test');
    });
  });

  // =========================================================================
  // String X11 color extensions
  // =========================================================================
  group('String X11 color extensions', () {
    test('.cornflowerBlue foreground', () {
      expect('test'.cornflowerBlue, contains('${ESC}[38;2;100;149;237m'));
    });

    test('.onCornflowerBlue background', () {
      expect('test'.onCornflowerBlue, contains('${ESC}[48;2;100;149;237m'));
    });

    test('.tomato foreground', () {
      expect('test'.tomato, contains('${ESC}[38;2;255;99;71m'));
    });

    test('.onTomato background', () {
      expect('test'.onTomato, contains('${ESC}[48;2;255;99;71m'));
    });

    test('.gold foreground', () {
      expect('test'.gold, contains('${ESC}[38;2;255;215;0m'));
    });

    test('.coral foreground', () {
      expect('test'.coral, contains('${ESC}[38;2;255;127;80m'));
    });

    test('.rebeccaPurple foreground', () {
      expect('test'.rebeccaPurple, contains('${ESC}[38;2;102;51;153m'));
    });

    test('X11 chaining with styles', () {
      final r = 'test'.tomato.bold;
      expect(r, contains('${ESC}[1m'));
      expect(AnsiUtils.stripAnsi(r), 'test');
    });

    test('X11 chaining fg + bg', () {
      final r = 'test'.tomato.onCornflowerBlue;
      expect(r, contains('${ESC}[38;2;255;99;71m'));
      expect(r, contains('${ESC}[48;2;100;149;237m'));
    });
  });

  // =========================================================================
  // Edge cases
  // =========================================================================
  group('String extension edge cases', () {
    test('empty string', () {
      final r = ''.red;
      expect(r, isA<String>());
    });

    test('long string preserved', () {
      final long = 'x' * 10000;
      expect(AnsiUtils.stripAnsi(long.red), long);
    });

    test('unicode preserved', () {
      final u = '\u{1F600} emoji';
      expect(AnsiUtils.stripAnsi(u.red), u);
    });

    test('newlines in string preserved', () {
      expect(AnsiUtils.stripAnsi('line1\nline2'.red), 'line1\nline2');
    });

    test('tabs preserved', () {
      expect(AnsiUtils.stripAnsi('col1\tcol2'.red), 'col1\tcol2');
    });
  });
}
