library chalkdart;

/*
  @author: tim maffett
*/

//import 'dart:math';
//import 'package:meta/meta.dart';
import 'ansiutils.dart';
import 'colorutils.dart';

/*
  Documentation of the ANSI code system
      https://en.wikipedia.org/wiki/ANSI_escape_code
*/
/*
  References with detailed explainations of the various color models included here
  https://en.wikipedia.org/wiki/HSL_and_HSV
  https://en.wikipedia.org/wiki/HWB_color_model

  complete history of the X11 color names (later used in css also)
  https://en.wikipedia.org/wiki/X11_color_names
*/


class Chalk {
  static int colorLevel = 3;
  static const int ANSI_BACKGROUND_OFFSET = 10;
  static const int ANSI_UNDERLINE_OFFSET = 20;

  static bool DEBUG_CODES = false;
  static String debugCode(String code) {
    return DEBUG_CODES ? code : '';
  }

  /// Set to true to prevent scaling of rgb values when all 3 fall between 0<=r,g,b<=1.0
  static bool noZeroToOneScaling = false;

  /// Use full resets to close attributes (reset all attributes with SGR 0)
  /// (will reset all attributes but some terminals like VSCode need this because buggy implmentations)
  /// (Update:  I have fixed and extended the VSCode support for ANSI control sequences to be virtually complete
  ///         and bug free.  This is now all available in production version of VSCode - timmaffett)
  static bool useFullResetToClose = false;

  static String _ansiSGRModiferOpen(dynamic code) {
    return '\u001B[${code}m' + debugCode('\\u001B[${code}m');
  }

  static String _ansiSGRModiferClose(dynamic code) {
    if (useFullResetToClose) code = 0;
    return debugCode('\\u001B[${code}m') + '\u001B[${code}m';
  }

  static String Function(int) _wrapAnsi256([int offset = 0]) {
    return (int code) =>
        '\u001B[${38 + offset};5;${code}m' +
        debugCode('\\u001B[${38 + offset};5;${code}m');
  }

  static String Function(int, int, int) _wrapAnsi16m([int offset = 0]) {
    return (int red, int green, int blue) =>
        '\u001B[${38 + offset};2;$red;$green;${blue}m' +
        debugCode('\\u001B[${38 + offset};2;$red;$green;${blue}m');
  }

  static final String _ansiClose = debugCode('\\u001B[39m') + '\u001B[39m';
  static final String _ansiBgClose = debugCode('\\u001B[49m') + '\u001B[49m';
  static final String _ansiUnderlineClose = debugCode('\\u001B[59m') + '\u001B[59m';

  static final String Function(int) _ansi256 = _wrapAnsi256();
  static final String Function(int, int, int) _ansi16m = _wrapAnsi16m();
  static final String Function(int) _bgAnsi256 = _wrapAnsi256(ANSI_BACKGROUND_OFFSET);
  static final String Function(int, int, int) _bgAnsi16m =
      _wrapAnsi16m(ANSI_BACKGROUND_OFFSET);
  static final String Function(int) _underlineAnsi256 =
      _wrapAnsi256(ANSI_UNDERLINE_OFFSET);
  static final String Function(int, int, int) _underlineAnsi16m =
      _wrapAnsi16m(ANSI_UNDERLINE_OFFSET);

  Chalk? parent;
  String open = '';
  String close = '';
  String openAll = '';
  String closeAll = '';
  int level = Chalk.colorLevel;

  /// character that will be used to join multiple arguments and arrays into output string, defaults to single space (' ')
  String joinString = ' ';

  bool _hasStyle =
      true; // most chalks have styles, root chalk object has no style and do nothing
  bool _chalkVisibleModifier =
      false; // this handles .visible() modifier, which if color level is 0 prevents any output

  /// most useful for debugging so dump the guts
  @override
  String toString() {
    return "Chalk(open:'${openAll.replaceAll('\u001B', 'ESC')}',close:'${closeAll.replaceAll('\u001B', 'ESC')}')";
  }

  static Chalk Instance({int level=-1}) {
    final instance = Chalk._internal(null, hasStyle: false);
    if (level != -1) {
      instance.level = level;
    }
    return instance;
  }

  factory Chalk() {
    return Chalk._internal(null, hasStyle: false);
  }

  Chalk._internal(Chalk? parent, {bool hasStyle = true}) {
    this.parent = parent;
    if (parent != null) {
      level = parent.level; // inherit level from parent
      joinString = parent.joinString;
    }
    _hasStyle = hasStyle;
  }

  static Chalk _createStyler(String open, String close, [Chalk? parent]) {
    final chalk = Chalk._internal(parent);
    chalk.open = open;
    chalk.close = close;
    if (parent == null) {
      chalk.openAll = open;
      chalk.closeAll = close;
    } else {
      chalk.openAll = parent.openAll + open;
      chalk.closeAll = close + parent.closeAll;
    }
    return chalk;
  }

  Chalk _makeRGBChalk(num nred, num ngreen, num nblue,
                            {bool bg = false, bool force16M = false}) {
    if (nred <= 1.0 && ngreen <= 1.0 && nblue <= 1.0 && !noZeroToOneScaling) {
      // if all 0 to 1.0 then scale to 0-255
      nred *= 255;
      ngreen *= 255;
      nblue *= 255;
    }
    final red = nred.round();
    final green = ngreen.round();
    final blue = nblue.round();
    String open;
    final close = bg ? _ansiBgClose : _ansiClose;
    if (level == 3 || force16M) {
      if (bg) {
        open = _bgAnsi16m(red, green, blue);
      } else {
        open = _ansi16m(red, green, blue);
      }
    } else {
      if (bg) {
        open = _bgAnsi256(ColorUtils.rgbToAnsi256(red, green, blue));
      } else {
        open = _ansi256(ColorUtils.rgbToAnsi256(red, green, blue));
      }
    }
    return _createStyler(open, close, this);
  }

  Chalk _makeAnsiChalk(int code, [bool bg = false]) {
    String open;
    final close = bg ? _ansiBgClose : _ansiClose;

    if (bg) {
      open = _bgAnsi256(code);
    } else {
      open = _ansi256(code);
    }

    return _createStyler(open, close, this);
  }

  Chalk _makeUnderlineChalk(num nred, num ngreen, num nblue,
      {bool force16M=false}) {
    if (nred <= 1.0 && ngreen <= 1.0 && nblue <= 1.0 && !noZeroToOneScaling) {
      // if all 0 to 1.0 then scale to 0-255
      nred *= 255;
      ngreen *= 255;
      nblue *= 255;
    }
    final red = nred.round();
    final green = ngreen.round();
    final blue = nblue.round();
    String open;

    if (level == 3 || force16M) {
      open = _underlineAnsi16m(red, green, blue);
    } else {
      open = _underlineAnsi256(ColorUtils.rgbToAnsi256(red, green, blue));
    }
    return _createStyler(open, _ansiUnderlineClose, this);
  }

  Chalk _makeAnsiGreyscaleChalk(num greyscale, [bool bg = false]) {
    String open;
    final close = bg ? _ansiBgClose : _ansiClose;
    final ansiGreyscale = 232 + (greyscale.clamp(0.0, 1.0) * 23).round();

    if (bg) {
      open = _bgAnsi256(ansiGreyscale);
    } else {
      open = _ansi256(ansiGreyscale);
    }

    return _createStyler(open, close, this);
  }

  Chalk hex(dynamic hex) {
    var rgb = ColorUtils.hex2rgb(hex);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  Chalk bgHex(dynamic hex) {
    var rgb = ColorUtils.hex2rgb(hex);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  Chalk onHex(dynamic hex) => bgHex(hex);

  Chalk keyword(String keyword) {
    var rgb = ColorUtils.rgbFromKeyword(keyword);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  Chalk bgKeyword(String keyword) {
    var rgb = ColorUtils.rgbFromKeyword(keyword);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  Chalk onKeyword(String keyword) => bgKeyword(keyword);

  Chalk rgb(num red, num green, num blue) => _makeRGBChalk(red, green, blue);

  Chalk bgRgb(num red, num green, num blue) =>
      _makeRGBChalk(red, green, blue, bg: true);

  Chalk onRgb(num red, num green, num blue) => bgRgb(red, green, blue);

  Chalk rgb16m(num red, num green, num blue) =>
      _makeRGBChalk(red, green, blue, force16M: true);

  Chalk bgRgb16m(num red, num green, num blue) =>
      _makeRGBChalk(red, green, blue, bg: true, force16M: true);

  Chalk onRgb16m(num red, num green, num blue) => bgRgb16m(red, green, blue);

  Chalk underlineRgb(num red, num green, num blue) =>
      _makeUnderlineChalk(red, green, blue);

  Chalk underlineRgb16m(num red, num green, num blue) =>
      _makeUnderlineChalk(red, green, blue, force16M: true);

  Chalk hsl(num hue, num saturation, num lightness) {
    var rgb = ColorUtils.hsl2rgb(hue, saturation, lightness);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  Chalk bgHsl(num hue, num saturation, num lightness) {
    var rgb = ColorUtils.hsl2rgb(hue, saturation, lightness);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  Chalk onHsl(num hue, num saturation, num lightness) =>
      bgHsl(hue, saturation, lightness);

  Chalk hsv(num hue, num saturation, num value) {
    var rgb = ColorUtils.hsv2rgb(hue, saturation, value);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  Chalk bgHsv(num hue, num saturation, num value) {
    var rgb = ColorUtils.hsv2rgb(hue, saturation, value);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  Chalk onHsv(num hue, num saturation, num value) =>
      bgHsv(hue, saturation, value);

  Chalk hwb(num hue, num whiteness, num blackness) {
    var rgb = ColorUtils.hwb2rgb(hue, whiteness, blackness);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  Chalk bgHwb(num hue, num whiteness, num blackness) {
    var rgb = ColorUtils.hwb2rgb(hue, whiteness, blackness);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  Chalk onHwb(num hue, num whiteness, num blackness) =>
      bgHwb(hue, whiteness, blackness);

  Chalk xyz(num x, num y, num z) {
    var rgb = ColorUtils.xyz2rgb(x, y, z);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  Chalk bgXyz(num x, num y, num z) {
    var rgb = ColorUtils.xyz2rgb(x, y, z);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  Chalk onXyz(num x, num y, num z) => bgXyz(x, y, z);

  Chalk lab(num l, num a, num b) {
    var xyz = ColorUtils.lab2xyz(l, a, b);
    var rgb = ColorUtils.xyz2rgb(xyz[0], xyz[1], xyz[2]);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  Chalk bgLab(num l, num a, num b) {
    var xyz = ColorUtils.lab2xyz(l, a, b);
    var rgb = ColorUtils.xyz2rgb(xyz[0], xyz[1], xyz[2]);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  Chalk onLab(num l, num a, num b) => bgLab(l, a, b);

  Chalk ansi(int ansicode) => _makeAnsiChalk(ansicode);

  Chalk bgAnsi(int ansicode) => _makeAnsiChalk(ansicode, true);

  Chalk onAnsi(int ansicode) => bgAnsi(ansicode);

  Chalk ansiSgr(dynamic openCode, dynamic closeCode) {
    // We use _ansiSGRModiferOpen() for both because we dont want useFullResetToClose to affect THESE USER
    // specified open/close SGR's
    return _createStyler(
        _ansiSGRModiferOpen(openCode), _ansiSGRModiferOpen(closeCode), this);
  }

  Chalk ansi256(int ansicode256) => _makeAnsiChalk(ansicode256);
  Chalk bgAnsi256(int ansicode256) => _makeAnsiChalk(ansicode256, true);
  Chalk onAnsi256(int ansicode256) => bgAnsi(ansicode256);

  Chalk greyscale(num greyscale) => _makeAnsiGreyscaleChalk(greyscale);
  Chalk bgGreyscale(num greyscale) => _makeAnsiGreyscaleChalk(greyscale, true);
  Chalk onGreyscale(num greyscale) => bgGreyscale(greyscale);

  /// Set foreground color to one of the base 16 xterm colors
  Chalk get black => _createStyler(_ansiSGRModiferOpen(30), _ansiClose, this);
  Chalk get red => _createStyler(_ansiSGRModiferOpen(31), _ansiClose, this);
  Chalk get green => _createStyler(_ansiSGRModiferOpen(32), _ansiClose, this);
  Chalk get yellow => _createStyler(_ansiSGRModiferOpen(33), _ansiClose, this);
  Chalk get blue => _createStyler(_ansiSGRModiferOpen(34), _ansiClose, this);
  Chalk get magenta => _createStyler(_ansiSGRModiferOpen(35), _ansiClose, this);
  Chalk get cyan => _createStyler(_ansiSGRModiferOpen(36), _ansiClose, this);
  Chalk get white => _createStyler(_ansiSGRModiferOpen(37), _ansiClose, this);

  /// 8 more 'bright' versions of the lower 8 colors
  Chalk get brightBlack =>
      _createStyler(_ansiSGRModiferOpen(90), _ansiClose, this);
  Chalk get blackBright =>
      brightBlack; // original chalk library used 'xxxxxBright' (adjective AFTER the color noun), we include alias for compatibility
  Chalk get gray => brightBlack;
  Chalk get grey => brightBlack;

  Chalk get brightRed =>
      _createStyler(_ansiSGRModiferOpen(91), _ansiClose, this);
  Chalk get redBright => brightRed;
  Chalk get brightGreen =>
      _createStyler(_ansiSGRModiferOpen(92), _ansiClose, this);
  Chalk get greenBright => brightGreen;
  Chalk get brightYellow =>
      _createStyler(_ansiSGRModiferOpen(93), _ansiClose, this);
  Chalk get yellowBright => brightYellow;
  Chalk get brightBlue =>
      _createStyler(_ansiSGRModiferOpen(94), _ansiClose, this);
  Chalk get blueBright => brightBlue;
  Chalk get brightMagenta =>
      _createStyler(_ansiSGRModiferOpen(95), _ansiClose, this);
  Chalk get magentaBright => brightMagenta;
  Chalk get brightCyan =>
      _createStyler(_ansiSGRModiferOpen(96), _ansiClose, this);
  Chalk get cyanBright => brightCyan;
  Chalk get brightWhite =>
      _createStyler(_ansiSGRModiferOpen(97), _ansiClose, this);
  Chalk get whiteBright => brightWhite;

  /// chalkdart favors 'onXXXXX' style of specifying background colors because it makes
  /// chained methods list read better as a sentence (`it's the Dart way`).
  /// We include original Chalk 'bgXXXX' method names for users that prefer that scheme
  /// and for legacy compatability with original JS Chalk.
  Chalk get onBlack =>
      _createStyler(_ansiSGRModiferOpen(40), _ansiBgClose, this);
  Chalk get bgBlack => onBlack;
  Chalk get onRed => _createStyler(_ansiSGRModiferOpen(41), _ansiBgClose, this);
  Chalk get bgRed => onRed;
  Chalk get onGreen =>
      _createStyler(_ansiSGRModiferOpen(42), _ansiBgClose, this);
  Chalk get bgGreen => onGreen;
  Chalk get onYellow =>
      _createStyler(_ansiSGRModiferOpen(43), _ansiBgClose, this);
  Chalk get bgYellow => onYellow;
  Chalk get onBlue =>
      _createStyler(_ansiSGRModiferOpen(44), _ansiBgClose, this);
  Chalk get bgBlue => onBlue;
  Chalk get onMagenta =>
      _createStyler(_ansiSGRModiferOpen(45), _ansiBgClose, this);
  Chalk get bgMagenta => onMagenta;
  Chalk get onCyan =>
      _createStyler(_ansiSGRModiferOpen(46), _ansiBgClose, this);
  Chalk get bgCyan => onCyan;
  Chalk get onWhite =>
      _createStyler(_ansiSGRModiferOpen(47), _ansiBgClose, this);
  Chalk get bgWhite => onWhite;

  Chalk get onBrightBlack =>
      _createStyler(_ansiSGRModiferOpen(100), _ansiBgClose, this);
  Chalk get onGray => onBrightBlack;
  Chalk get onGrey => onBrightBlack;
  Chalk get bgBrightBlack => onBrightBlack;
  Chalk get bgBlackBright => onBrightBlack; // legacy backwards compatability
  Chalk get bgGray => onBrightBlack;
  Chalk get bgGrey => onBrightBlack;
  Chalk get onBrightRed =>
      _createStyler(_ansiSGRModiferOpen(101), _ansiBgClose, this);
  Chalk get bgBrightRed => onBrightRed;
  Chalk get bgRedBright => onBrightRed; // legacy backwards compatability
  Chalk get onBrightGreen =>
      _createStyler(_ansiSGRModiferOpen(102), _ansiBgClose, this);
  Chalk get bgBrightGreen => onBrightGreen;
  Chalk get bgGreenBright => onBrightGreen; // legacy backwards compatability
  Chalk get onBrightYellow =>
      _createStyler(_ansiSGRModiferOpen(103), _ansiBgClose, this);
  Chalk get bgBrightYellow => onBrightYellow;
  Chalk get bgYellowBright => onBrightYellow; // legacy backwards compatability
  Chalk get onBrightBlue =>
      _createStyler(_ansiSGRModiferOpen(104), _ansiBgClose, this);
  Chalk get bgBrightBlue => onBrightBlue;
  Chalk get bgBlueBright => onBrightBlue; // legacy backwards compatability
  Chalk get onBrightMagenta =>
      _createStyler(_ansiSGRModiferOpen(105), _ansiBgClose, this);
  Chalk get bgBrightMagenta => onBrightMagenta;
  Chalk get bgMagentaBright =>
      onBrightMagenta; // legacy backwards compatability
  Chalk get onBrightCyan =>
      _createStyler(_ansiSGRModiferOpen(106), _ansiBgClose, this);
  Chalk get bgBrightCyan => onBrightCyan;
  Chalk get bgCyanBright => onBrightCyan; // legacy backwards compatability
  Chalk get onBrightWhite =>
      _createStyler(_ansiSGRModiferOpen(107), _ansiBgClose, this);
  Chalk get bgBrightWhite => onBrightWhite;
  Chalk get bgWhiteBright => onBrightWhite; // legacy backwards compatability

  ///reset - Resets the current color chain.
  Chalk get reset =>
      _createStyler(_ansiSGRModiferOpen(0), _ansiSGRModiferClose(0), this);

  ///normal - Text with all attributes off
  Chalk get normal =>
      _createStyler(_ansiSGRModiferOpen(0), _ansiSGRModiferClose(0), this);

  ///bold - Make text bold.
  Chalk get bold =>
      _createStyler(_ansiSGRModiferOpen(1), _ansiSGRModiferClose(22), this);

  ///dim - Emitting only a small amount of light.
  Chalk get dim =>
      _createStyler(_ansiSGRModiferOpen(2), _ansiSGRModiferClose(22), this);

  ///italic - Make text italic. (Not widely supported)
  Chalk get italic =>
      _createStyler(_ansiSGRModiferOpen(3), _ansiSGRModiferClose(23), this);

  ///underline - Make text underline. (Not widely supported)
  Chalk get underline =>
      _createStyler(_ansiSGRModiferOpen(4), _ansiSGRModiferClose(24), this);
  Chalk get underlined => underline;

  ///doubleunderline - Make text double underlined. (Not widely supported)
  Chalk get doubleunderline =>
      _createStyler(_ansiSGRModiferOpen(21), _ansiSGRModiferClose(24), this);
  Chalk get doubleunderlined => doubleunderline;

  /// doubleUnderline - alternate for doubleunderline
  Chalk get doubleUnderline => doubleunderline;

  ///overline - Make text overlined. (Not widely supported)
  Chalk get overline =>
      _createStyler(_ansiSGRModiferOpen(53), _ansiSGRModiferClose(55), this);
  Chalk get overlined => overline;

  ///blink - Make text blink. (Not widely supported)
  Chalk get blink =>
      _createStyler(_ansiSGRModiferOpen(5), _ansiSGRModiferClose(25), this);

  ///rapidblink - Make text blink rapidly (>150 times per minute). (Not widely supported)
  Chalk get rapidblink =>
      _createStyler(_ansiSGRModiferOpen(6), _ansiSGRModiferClose(25), this);

  ///inverse- Inverse background and foreground colors.
  Chalk get inverse =>
      _createStyler(_ansiSGRModiferOpen(7), _ansiSGRModiferClose(27), this);
  ///invert- alternate for inverse() - Inverse background and foreground colors.
  Chalk get invert => inverse;

  ///hidden - Prints the text, but makes it invisible. (still copy and pasteable)
  Chalk get hidden =>
      _createStyler(_ansiSGRModiferOpen(8), _ansiSGRModiferClose(28), this);

  ///strikethrough - Puts a horizontal line through the center of the text. (Not widely supported)
  Chalk get strikethrough =>
      _createStyler(_ansiSGRModiferOpen(9), _ansiSGRModiferClose(29), this);

  ///superscript - Superscript text. (Not widely supported)
  Chalk get superscript =>
      _createStyler(_ansiSGRModiferOpen(73), _ansiSGRModiferClose(75), this);

  ///subscript - Subscript text. (Not widely supported)
  Chalk get subscript =>
      _createStyler(_ansiSGRModiferOpen(74), _ansiSGRModiferClose(75), this);

  ///Alternative font 1. (Not widely supported)
  Chalk get font1 =>
      _createStyler(_ansiSGRModiferOpen(11), _ansiSGRModiferClose(10), this);
  ///Alternative font 2. (Not widely supported)
  Chalk get font2 =>
      _createStyler(_ansiSGRModiferOpen(12), _ansiSGRModiferClose(10), this);
  ///Alternative font 3. (Not widely supported)
  Chalk get font3 =>
      _createStyler(_ansiSGRModiferOpen(13), _ansiSGRModiferClose(10), this);
  ///Alternative font 4. (Not widely supported)
  Chalk get font4 =>
      _createStyler(_ansiSGRModiferOpen(14), _ansiSGRModiferClose(10), this);
  ///Alternative font 5. (Not widely supported)
  Chalk get font5 =>
      _createStyler(_ansiSGRModiferOpen(15), _ansiSGRModiferClose(10), this);
  ///Alternative font 6. (Not widely supported)
  Chalk get font6 =>
      _createStyler(_ansiSGRModiferOpen(16), _ansiSGRModiferClose(10), this);
  ///Alternative font 7. (Not widely supported)
  Chalk get font7 =>
      _createStyler(_ansiSGRModiferOpen(17), _ansiSGRModiferClose(10), this);
  ///Alternative font 8. (Not widely supported)
  Chalk get font8 =>
      _createStyler(_ansiSGRModiferOpen(18), _ansiSGRModiferClose(10), this);
  ///Alternative font 9. (Not widely supported)
  Chalk get font9 =>
      _createStyler(_ansiSGRModiferOpen(19), _ansiSGRModiferClose(10), this);
  ///Alternative font 10. (Not widely supported)
  Chalk get font10 =>
      _createStyler(_ansiSGRModiferOpen(20), _ansiSGRModiferClose(23), this);
  /// blackletter - alternate name for font10, ANSI/ECMA-48 spec refers to font10 specifically as a blackletter or Fraktur (Gothic) font.
  /// (Not widely supported)
  Chalk get blackletter => font10; 

  ///Wrap this chalk with specified prefix and suffix strings.
  Chalk wrap( String prefix, String suffix ) {
    var chalk = _createStyler(prefix, suffix, this);
    chalk._hasStyle = false;
    return chalk;
  }

  ///visible - Prints the text only when Chalk has a color level > 0. Can be useful for things that are purely cosmetic.
  Chalk get visible {
    // look at color Level and print ONLY IF >0
    var ck = _createStyler('', '', this);
    ck._chalkVisibleModifier = true;
    return ck;
  }

  /// Follow this method with any standard CSS/X11 color name (remove spaces from name)
  /// The case/capitalizatiom of the color name is not important.
  /// color returns chalk as 'dynamic' so that CSS/X11 color names can 'dynamically' be
  /// accessed as virtual methods.
  /// ie.  `chalk.color.cornflowerblue('works like this')`
  ///   (this is the equivalent of `chalk.keyword('cornflowerblue')('same things using keyword()'`)
  dynamic get color {
    var chalk = _createStyler('', '', this);
    chalk._hasStyle = false;
    return chalk;
  }

  /// Follow this method with any standard CSS/X11 color name (remove spaces from name)
  /// The case/capitalizatiom of the color name is not important.
  /// alias for [color] - alternate method name to use for to get dynamic for virtual color methods
  /// ie.  `chalk.csscolor.cornflowerblue('works like this')`
  ///   (this is the equivalent of `chalk.keyword('cornflowerblue')('same things using keyword()'`)
 dynamic get csscolor => color;

  /// Follow this method with any standard CSS/X11 color name (remove spaces from name)
  /// The case/capitalizatiom of the color name is not important.
  /// alias for [color] - alternate method name to use for to get dynamic for virtual color methods
  /// ie.  `chalk.x11.cornflowerblue('works like this')`
  ///   (this is the equivalent of `chalk.keyword('cornflowerblue')('same things using keyword()'`)
  dynamic get x11 => color;

  ///Specify string to use for joining multiple arguments or Lists. Default is ' ' (single space)
  Chalk joinWith( String joinWith ) {
    var chalk = _createStyler('', '', this);
    chalk._hasStyle = false;
    chalk.joinString = joinWith;
    return chalk;
  }
  
  /// strip all ANSI SGR commands from the target string and return the 'stripped' result string
  String strip(String target) {
    return AnsiUtils.stripAnsi(target);
  }

  // this method handles turning all the dynamic items in the list to strings, and recurses if it finds Lists.
  String _fixList(List<dynamic> dynlist) {
    var outlist = List<String>.filled(dynlist.length, '');
    for (var i = 0; i < dynlist.length; i++) {
      outlist[i] = _fixArg( dynlist[i] );
    } 
    return outlist.join(joinString);
  }

   // this method handles turning all the dynamic items in the list to strings, and recurses if it finds Lists.
  String _fixArg( dynamic dynarg) {
    var resstr = 'null';
    if( dynarg != null ) {
      if (dynarg is List) {
        resstr = _fixList(dynarg);
      } else if (dynarg is Function) {
        dynamic funres = dynarg.call();
        resstr = (funres!=null) ? funres.toString() : 'null';
      } else if (dynarg != null) {
        resstr = dynarg.toString();
      }
    }
    return resstr;
  }

  String call(dynamic arg0,
      [dynamic arg1,
      dynamic arg2,
      dynamic arg3,
      dynamic arg4,
      dynamic arg5,
      dynamic arg6,
      dynamic arg7,
      dynamic arg8,
      dynamic arg9,
      dynamic arg10]) {
    arg0 = _fixArg(arg0);
    if (arg1 != null) {
      arg0 = <dynamic>[
        arg0,  // we know arg0 is a string at this point (from call to _fixArg())
        if (arg1 != null) _fixArg(arg1),
        if (arg2 != null) _fixArg(arg2),
        if (arg3 != null) _fixArg(arg3),
        if (arg4 != null) _fixArg(arg4),
        if (arg5 != null) _fixArg(arg5),
        if (arg6 != null) _fixArg(arg6),
        if (arg7 != null) _fixArg(arg7),
        if (arg8 != null) _fixArg(arg8),
        if (arg9 != null) _fixArg(arg9),
        if (arg10 != null) _fixArg(arg10),
      ].join(joinString);
    }

    if (level <= 0 || arg0 == null) {
      return (arg0 == null || _chalkVisibleModifier) ? '' : arg0;
    }

    Chalk? styler = this;

    if (!styler._hasStyle) {
      return arg0;
    }

    if (arg0!.indexOf('\u001B') != -1) {
      while (styler != null && styler._hasStyle) {
        // Replace any instances already present with a re-opening code
        // otherwise only the part of the string until said closing code
        // will be colored, and the rest will simply be 'plain'.
        arg0 = StringUtils.stringReplaceAll(arg0, styler.close, styler.open);

        styler = styler.parent;
      }
    }

    // We can move both next actions out of loop, because remaining actions in loop won't have
    // any/visible effect on parts we add here. Close the styling before a linebreak and reopen
    // after next line to fix a bleed issue on macOS: https://github.com/chalk/chalk/pull/92
    var lfIndex = arg0.indexOf('\n');
    if (lfIndex != -1) {
      arg0 = StringUtils.stringEncaseCRLFWithFirstIndex(
          arg0, closeAll, openAll, lfIndex);
    }

    return openAll + arg0 + closeAll;
  }

  // https://github.com/dart-lang/sdk/blob/master/docs/language/informal/nosuchmethod-forwarding.md
  //   Good stuff.
  // dynamic chalk2 = Chalk();
  // print(chalk2.orange('Yay for red on yellow colored text!'));
  // print(chalk.csscolor.lightskyblue('Yay for lightskyblue colored text!'));
  @override
  dynamic noSuchMethod(Invocation invocation) {
    // memberName will toString() like 'Symbol("orange")', so just get the name out of it
    String methodName = invocation.memberName.toString();
    methodName = methodName
        .substring('Symbol("'.length, methodName.length - 2)
        .toLowerCase();
    bool backgroundColor = false;
    if (methodName.startsWith('on') || methodName.startsWith('bg')) {
      backgroundColor = true;
      methodName = methodName.substring(2);
    }
    var rgb = ColorUtils.rgbFromKeyword(methodName);

    Chalk thisColor =
        _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: backgroundColor);

    if (invocation.positionalArguments.length > 0) {
      // send all the args in and chalk them up like a other normal methods would with call()
      return thisColor.call(invocation.positionalArguments);
    } else {
      // Just return the chalk we just made
      return thisColor;
    }
  }

  /// Add RGB color to the colorKeywords[] map that is used for dynamic lookup of colors by name.
  /// Colors added thid way can be used directly following the Chalk color/csscolor/x11 methods.
  /// ie.
  ///      Chalk.addColorKeywordRgb('myfavorite', 0x64, 0x95, 0xED );
  ///      chalk.color.myfavorite('This is my favorite color');
  static void addColorKeywordRgb( String colorname, int red, int green, int blue ) {
    ColorUtils.addColorKeywordRgb( colorname, red, green, blue );
  }

  /// Add Hex color (string or int) to the colorKeywords[] map that is used for dynamic lookup of colors by name.
  /// Colors added thid way can be used directly follwing the Chalk color/csscolor/x11 methods.
  /// ie.
  ///      Chalk.addColorKeywordHex('myfavorite', 0x6495ED ); // using hex int
  ///      chalk.color.myfavorite('This is my favorite color');
  ///      Chalk.addColorKeywordHex('my2ndFavorite', '#6A5ACD' );  // or using string
  ///      chalk.color.my2ndfavorite('This is my 2nd favorite color');
  static void addColorKeywordHex( String colorname, dynamic hex ) {
    ColorUtils.addColorKeywordHex( colorname, hex );
  }
}

/// global instance of chalk used for base call.
/// this can be set to a specific Chalk instance that would then serve as basis for all calls
Chalk chalk = Chalk();

class StringUtils {
  static String stringReplaceAll(
      String string, String substring, String replacer) {
    int index = string.indexOf(substring);
    if (index == -1) {
      return string;
    }

    int substringLength = substring.length;
    int endIndex = 0;
    String returnValue = '';
    do {
      returnValue += string.substring(endIndex, index /* - endIndex*/) +
          substring +
          replacer;
      endIndex = index + substringLength;
      index = string.indexOf(substring, endIndex);
    } while (index != -1);

    returnValue += string.substring(endIndex);
    return returnValue;
  }

  static String stringEncaseCRLFWithFirstIndex(
    String string, String prefix, String postfix, int index) {
    int endIndex = 0;
    String returnValue = '';
    do {
      bool gotCR = (index>=1) && (string[index - 1] == '\r');
      returnValue += string.substring(
              endIndex, (gotCR ? index - 1 : index) /* - endIndex*/) +
          prefix +
          (gotCR ? '\r\n' : '\n') +
          postfix;
      endIndex = index + 1;
      index = string.indexOf('\n', endIndex);
    } while (index != -1);

    returnValue += string.substring(endIndex);
    return returnValue;
  }
}
