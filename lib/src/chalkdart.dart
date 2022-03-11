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
  /// ANSI Color level support for terminal - default to 3 (full color) because IntelliJ/AndroidStudio and VSCode report NOT having full color
  /// support depsite supporting level 3.  This is really only here for flexibility.
  static int ansiColorLevelForNewInstances = 3;

  static const int _ANSI_BACKGROUND_OFFSET = 10;
  static const int _ANSI_UNDERLINE_OFFSET = 20;

  /// Set to true to prevent scaling of rgb values when all 3 fall between 0<=r,g,b<=1.0
  static bool noZeroToOneScaling = false;

  /// Use full resets to close attributes (reset all attributes with SGR 0) ON EACH call to Chalk()
  /// (Not usually desired, this will reset all attributes, but some terminals, like VSCode,
  /// need this because buggy implementations)
  /// (Update:  I have fixed and extended the VSCode support for ANSI control sequences to be complete
  /// and bug free.  All features of Chalk'Dart are now completely supported.
  /// This is now all available in production version of VSCode - timmaffett)
  static bool useFullResetToClose = false;

  static String _ansiSGRModiferOpen(dynamic code) {
    return '\u001B[${code}m';
  }

  static String _ansiSGRModiferClose(dynamic code) {
    if (useFullResetToClose) code = 0;
    return '\u001B[${code}m';
  }

  static String Function(int) _wrapAnsi256([int offset = 0]) {
    return (int code) =>
    '\u001B[${38 + offset};5;${code}m';
  }

  static String Function(int, int, int) _wrapAnsi16m([int offset = 0]) {
    return (int red, int green, int blue) =>
    '\u001B[${38 + offset};2;$red;$green;${blue}m';
  }

  static const String _ansiClose = '\u001B[39m';
  static const String _ansiBgClose = '\u001B[49m';
  static const String _ansiUnderlineClose = '\u001B[59m';

  static final String Function(int) _ansi256 = _wrapAnsi256();
  static final String Function(int, int, int) _ansi16m = _wrapAnsi16m();
  static final String Function(int) _bgAnsi256 = _wrapAnsi256(_ANSI_BACKGROUND_OFFSET);
  static final String Function(int, int, int) _bgAnsi16m =
    _wrapAnsi16m(_ANSI_BACKGROUND_OFFSET);
  static final String Function(int) _underlineAnsi256 =
    _wrapAnsi256(_ANSI_UNDERLINE_OFFSET);
  static final String Function(int, int, int) _underlineAnsi16m =
    _wrapAnsi16m(_ANSI_UNDERLINE_OFFSET);

  Chalk? _parent;
  String _open = '';
  String _close = '';
  String _openAll = '';
  String _closeAll = '';
  int level = Chalk.ansiColorLevelForNewInstances;

  /// character that will be used to join multiple arguments and arrays into output string, defaults to single space (' ')
  String _joinString = ' ';

  // most chalks have styles, root chalk object has no style and does nothing
  bool _hasStyle = true;

  // this handles .visible() modifier, which if [level] is 0 prevents any output
  bool _chalkVisibleModifier = false;

  /* Method useful for debugging escape sequences - removes escape characters and replaces with '[ESC]'
  static String makePrintableForDebug( String str ) {
    return str.replaceAll('\u001B', '[ESC]');
  }
  */

  /// most useful for debugging to dump the guts
  @override
  String toString() {
    return "Chalk(open:'${_openAll.replaceAll('\u001B', 'ESC')}',close:'${_closeAll.replaceAll('\u001B', 'ESC')}')";
  }

  /// more detailed dump of the guts, following parent links and dumping
  @override
  String toStringAll({int level = 0}) {
    String thisOne = "[$level] Chalk(open:'${_open.replaceAll('\u001B', 'ESC')}',close:'${_close.replaceAll('\u001B', 'ESC')}')";
    if (level == 0) thisOne += "[$level] ALL Chalk(open:'${_openAll.replaceAll('\u001B', 'ESC')}',close:'${_closeAll.replaceAll('\u001B', 'ESC')}')";
    String parentStr = '';
    if (_parent != null) {
      level++;
      parentStr = _parent!.toStringAll(level: level);
    }
    return parentStr + thisOne;
  }

  /// Use to create a new 'root' instance of Chalk, with the option of setting the ANSI color level
  /// (root instances start with no style)
  static Chalk Instance({int level = -1}) {
    final instance = Chalk._internal(null, hasStyle: false);
    if (level != -1) {
      instance.level = level;
    }
    return instance;
  }

  /// Factory function typically used for creating new 'root' instances of Chalk
  /// (root instances start with no style)
  factory Chalk() {
    return Chalk._internal(null, hasStyle: false);
  }

  /// private internal Chalk() constructor
  Chalk._internal(Chalk? parent, {bool hasStyle = true}) {
    this._parent = parent;
    if (parent != null) {
      level = parent.level; // inherit level from parent
      _joinString = parent._joinString;
    }
    _hasStyle = hasStyle;
  }

  static Chalk _createStyler(String open, String close, [Chalk? parent]) {
    final chalk = Chalk._internal(parent);
    chalk._open = open;
    chalk._close = close;
    if (parent == null) {
      chalk._openAll = open;
      chalk._closeAll = close;
    } else {
      chalk._openAll = parent._openAll + open;
      chalk._closeAll = close + parent._closeAll;
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
      {bool force16M = false}) {
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

  /// Returns a Chalk with the foreground color set to the passed in RGB Hex code.
  /// This dynamically accepts color hex codes as integer codes (0xAABBCC) or (0xABC)
  /// or as strings ('#AABBCC') or ('#ABC')
  Chalk hex(dynamic hex) {
    var rgb = ColorUtils.hex2rgb(hex);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// Returns a Chalk with the background color set to the passed in RGB Hex code.
  /// This dynamically accepts color hex codes as integer codes (0xAABBCC) or (0xABC)
  /// or as strings ('#AABBCC') or ('#ABC')
  Chalk onHex(dynamic hex) {
    var rgb = ColorUtils.hex2rgb(hex);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onHex() (provided for legacy compatibility with JS Chalk)
  Chalk bgHex(dynamic hex) => onHex(hex);

  /// Returns a Chalk with the foreground color set to the color represented by the
  /// passed in color keyword.  
  /// This accepts all of the standard X11/CSS color names, and the user can extend the list
  /// of accepted color keywords using the addColorKeywordRgb() and addColorKeywordHex() methods
  Chalk keyword(String colorKeyword) {
    var rgb = ColorUtils.rgbFromKeyword(colorKeyword);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// Returns a Chalk with the background color set to the color represented by the
  /// passed in color keyword.  
  /// This accepts all of the standard X11/CSS color names, and the user can extend the list
  /// of accepted color keywords using the addColorKeywordRgb() and addColorKeywordHex() methods
  Chalk onKeyword(String colorKeyword) {
    var rgb = ColorUtils.rgbFromKeyword(colorKeyword);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onKeyword() (provided for legacy compatibility with JS Chalk)
  Chalk bgKeyword(String keyword) => onKeyword(keyword);

  /// Create Chalk with a foreground color with the specified RGB values
  Chalk rgb(num red, num green, num blue) => _makeRGBChalk(red, green, blue);

  /// Create Chalk with a background color with the specified RGB values
  Chalk onRgb(num red, num green, num blue) => _makeRGBChalk(red, green, blue, bg: true);

  /// Alternate name for onRgb() (provided for legacy compatibility with JS Chalk)
  Chalk bgRgb(num red, num green, num blue) => onRgb(red, green, blue);

  /// Create Chalk with a foreground color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3)
  Chalk rgb16m(num red, num green, num blue) => _makeRGBChalk(red, green, blue, force16M: true);

  /// Create Chalk with a background color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3)
  Chalk onRgb16m(num red, num green, num blue) => _makeRGBChalk(red, green, blue, bg: true, force16M: true);

  /// Alternate name for onRgb16m() (provided for legacy compatibility with JS Chalk)
  Chalk bgRgb16m(num red, num green, num blue) => onRgb16m(red, green, blue);

  /// Create Chalk with an underline of the the specified RGB color
  /// WARNING: on some consoles without support for this, such as Android Studio,
  /// using this will prevent ALL styles of the Chalk from appearing
  Chalk underlineRgb(num red, num green, num blue) =>
      _makeUnderlineChalk(red, green, blue);

  /// Create Chalk with an underline of the the specified RGB color
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3)
  /// WARNING: on some consoles without support for this, such as Android Studio,
  /// using this will prevent ALL styles of the Chalk from appearing
  Chalk underlineRgb16m(num red, num green, num blue) =>
      _makeUnderlineChalk(red, green, blue, force16M: true);

  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  Chalk hsl(num hue, num saturation, num lightness) {
    var rgb = ColorUtils.hsl2rgb(hue, saturation, lightness);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  Chalk onHsl(num hue, num saturation, num lightness) {
    var rgb = ColorUtils.hsl2rgb(hue, saturation, lightness);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onHsl() (provided for legacy compatibility with JS Chalk)
  Chalk bgHsl(num hue, num saturation, num lightness) => onHsl(hue, saturation, lightness);

  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  Chalk hsv(num hue, num saturation, num value) {
    var rgb = ColorUtils.hsv2rgb(hue, saturation, value);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  Chalk onHsv(num hue, num saturation, num value) {
    var rgb = ColorUtils.hsv2rgb(hue, saturation, value);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onHsv() (provided for legacy compatibility with JS Chalk)
  Chalk bgHsv(num hue, num saturation, num value) => onHsv(hue, saturation, value);

  /// https://en.wikipedia.org/wiki/HWB_color_model
  Chalk hwb(num hue, num whiteness, num blackness) {
    var rgb = ColorUtils.hwb2rgb(hue, whiteness, blackness);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// https://en.wikipedia.org/wiki/HWB_color_model
  Chalk onHwb(num hue, num whiteness, num blackness) {
    var rgb = ColorUtils.hwb2rgb(hue, whiteness, blackness);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onHwb() (provided for legacy compatibility with JS Chalk)
  Chalk bgHwb(num hue, num whiteness, num blackness) => onHwb(hue, whiteness, blackness);

  /// https://en.wikipedia.org/wiki/CIE_1931_color_space
  Chalk xyz(num x, num y, num z) {
    var rgb = ColorUtils.xyz2rgb(x, y, z);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// https://en.wikipedia.org/wiki/CIE_1931_color_space
  Chalk onXyz(num x, num y, num z) {
    var rgb = ColorUtils.xyz2rgb(x, y, z);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onXyz() (provided for legacy compatibility with JS Chalk)
  Chalk bgXyz(num x, num y, num z) => onXyz(x, y, z);

  /// https://en.wikipedia.org/wiki/CIELAB_color_space#CIELAB
  Chalk lab(num l, num a, num b) {
    var xyz = ColorUtils.lab2xyz(l, a, b);
    var rgb = ColorUtils.xyz2rgb(xyz[0], xyz[1], xyz[2]);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// https://en.wikipedia.org/wiki/CIELAB_color_space#CIELAB
  Chalk onLab(num l, num a, num b) {
    var xyz = ColorUtils.lab2xyz(l, a, b);
    var rgb = ColorUtils.xyz2rgb(xyz[0], xyz[1], xyz[2]);
    return _makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onLab() (provided for legacy compatibility with JS Chalk)
  Chalk bgLab(num l, num a, num b) => onLab(l, a, b);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  Chalk ansi(int ansicode) => _makeAnsiChalk(ansicode);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  Chalk onAnsi(int ansicode) => _makeAnsiChalk(ansicode, true);

  /// Alternate name for onAnsi() (provided for legacy compatibility with JS Chalk)
  Chalk bgAnsi(int ansicode) => onAnsi(ansicode);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  Chalk ansiSgr(dynamic openCode, dynamic closeCode) {
    // We use _ansiSGRModiferOpen() for both because we dont want useFullResetToClose to affect THESE USER
    // specified open/close SGR's
    return _createStyler(
        _ansiSGRModiferOpen(openCode), _ansiSGRModiferOpen(closeCode), this);
  }

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  Chalk ansi256(int ansicode256) => _makeAnsiChalk(ansicode256);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  Chalk onAnsi256(int ansicode256) => _makeAnsiChalk(ansicode256, true);

  /// Alternate name for onAnsi256() (provided for legacy compatibility with JS Chalk)
  Chalk bgAnsi256(int ansicode256) => onAnsi(ansicode256);

  Chalk greyscale(num greyscale) => _makeAnsiGreyscaleChalk(greyscale);

  Chalk onGreyscale(num greyscale) => _makeAnsiGreyscaleChalk(greyscale, true);

  /// Alternate name for onGreyscale() (provided for legacy compatibility with JS Chalk)
  Chalk bgGreyscale(num greyscale) => onGreyscale(greyscale);

  /// Set foreground color to one of the base 16 xterm colors
  Chalk get black => _createStyler(_ansiSGRModiferOpen(30), _ansiClose, this);

  /// make foreground red <span style="background:red;">&nbsp;&nbsp;&nbsp;</span>
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

  ///italic - Make text italic. (VSCode debug console supports,some other terminals)
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
  Chalk wrap(String prefix, String suffix) {
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
  Chalk joinWith(String joinWith) {
    var chalk = _createStyler('', '', this);
    chalk._hasStyle = false;
    chalk._joinString = joinWith;
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
      outlist[i] = _fixArg(dynlist[i]);
    }
    return outlist.join(_joinString);
  }

  /// handles turning all the dynamic items in the list to strings, and recurses if it finds Lists.
  /// It handles List<> and Function closures
  String _fixArg(dynamic dynarg) {
    var resstr = 'null';
    if (dynarg != null) {
      if (dynarg is List) {
        resstr = _fixList(dynarg);
      } else if (dynarg is Function) {
        dynamic funres = dynarg.call();
        resstr = (funres != null) ? funres.toString() : 'null';
      } else if (dynarg != null) {
        resstr = dynarg.toString();
      }
    }
    return resstr;
  }

  /// handles the generic Chalk(....) calls with up to 10 arguements that can be a mixtured of
  /// pretty much anything.  List<> and Function closures are handled
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
        arg0, // we know arg0 is a string at this point (from call to _fixArg())
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
      ].join(_joinString);
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
        arg0 = StringUtils.stringReplaceAll(arg0, styler._close, styler._open);

        styler = styler._parent;
      }
    }

    // We can move both next actions out of loop, because remaining actions in loop won't have
    // any/visible effect on parts we add here. Close the styling before a linebreak and reopen
    // after next line to fix a bleed issue on macOS: https://github.com/chalk/chalk/pull/92
    var lfIndex = arg0.indexOf('\n');
    if (lfIndex != -1) {
      arg0 = StringUtils.stringEncaseCRLFWithFirstIndex(
          arg0, _closeAll, _openAll, lfIndex);
    }

    return _openAll + arg0 + _closeAll;
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
  static void addColorKeywordRgb(String colorname, int red, int green, int blue) {
    ColorUtils.addColorKeywordRgb(colorname, red, green, blue);
  }

  /// Add Hex color (string or int) to the colorKeywords[] map that is used for dynamic lookup of colors by name.
  /// Colors added thid way can be used directly follwing the Chalk color/csscolor/x11 methods.
  /// ie.
  ///      Chalk.addColorKeywordHex('myfavorite', 0x6495ED ); // using hex int
  ///      chalk.color.myfavorite('This is my favorite color');
  ///      Chalk.addColorKeywordHex('my2ndFavorite', '#6A5ACD' );  // or using string
  ///      chalk.color.my2ndfavorite('This is my 2nd favorite color');
  static void addColorKeywordHex(String colorname, dynamic hex) {
    ColorUtils.addColorKeywordHex(colorname, hex);
  }


// BEGIN GENERATED CODE - DO NOT MODIFY BY HAND - generating code => /examples/makeX11EntryPoints.dart

  /// set foreground color to X11/CSS color aliceBlue <span style='background-color: aliceblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF0F8FF)/rgb(240, 248, 255)
  Chalk get aliceBlue => _makeRGBChalk(240, 248, 255);

  /// set background color to X11/CSS color aliceBlue <span style='background-color: aliceblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF0F8FF)/rgb(240, 248, 255)
  Chalk get onAliceBlue => _makeRGBChalk(240, 248, 255, bg: true);

  /// set foreground color to X11/CSS color antiqueWhite <span style='background-color: antiquewhite;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFAEBD7)/rgb(250, 235, 215)
  Chalk get antiqueWhite => _makeRGBChalk(250, 235, 215);

  /// set background color to X11/CSS color antiqueWhite <span style='background-color: antiquewhite;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFAEBD7)/rgb(250, 235, 215)
  Chalk get onAntiqueWhite => _makeRGBChalk(250, 235, 215, bg: true);

  /// set foreground color to X11/CSS color aqua <span style='background-color: aqua;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FFFF)/rgb(0, 255, 255)
  Chalk get aqua => _makeRGBChalk(0, 255, 255);

  /// set background color to X11/CSS color aqua <span style='background-color: aqua;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FFFF)/rgb(0, 255, 255)
  Chalk get onAqua => _makeRGBChalk(0, 255, 255, bg: true);

  /// set foreground color to X11/CSS color aquamarine <span style='background-color: aquamarine;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x7FFFD4)/rgb(127, 255, 212)
  Chalk get aquamarine => _makeRGBChalk(127, 255, 212);

  /// set background color to X11/CSS color aquamarine <span style='background-color: aquamarine;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x7FFFD4)/rgb(127, 255, 212)
  Chalk get onAquamarine => _makeRGBChalk(127, 255, 212, bg: true);

  /// set foreground color to X11/CSS color azure <span style='background-color: azure;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF0FFFF)/rgb(240, 255, 255)
  Chalk get azure => _makeRGBChalk(240, 255, 255);

  /// set background color to X11/CSS color azure <span style='background-color: azure;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF0FFFF)/rgb(240, 255, 255)
  Chalk get onAzure => _makeRGBChalk(240, 255, 255, bg: true);

  /// set foreground color to X11/CSS color beige <span style='background-color: beige;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF5F5DC)/rgb(245, 245, 220)
  Chalk get beige => _makeRGBChalk(245, 245, 220);

  /// set background color to X11/CSS color beige <span style='background-color: beige;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF5F5DC)/rgb(245, 245, 220)
  Chalk get onBeige => _makeRGBChalk(245, 245, 220, bg: true);

  /// set foreground color to X11/CSS color bisque <span style='background-color: bisque;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFE4C4)/rgb(255, 228, 196)
  Chalk get bisque => _makeRGBChalk(255, 228, 196);

  /// set background color to X11/CSS color bisque <span style='background-color: bisque;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFE4C4)/rgb(255, 228, 196)
  Chalk get onBisque => _makeRGBChalk(255, 228, 196, bg: true);

  /// set foreground color to X11/CSS color blackX11 <span style='background-color: black;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x000000)/rgb(0, 0, 0)
  Chalk get blackX11 => _makeRGBChalk(0, 0, 0);

  /// set background color to X11/CSS color blackX11 <span style='background-color: black;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x000000)/rgb(0, 0, 0)
  Chalk get onBlackX11 => _makeRGBChalk(0, 0, 0, bg: true);

  /// set foreground color to X11/CSS color blanchedAlmond <span style='background-color: blanchedalmond;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFEBCD)/rgb(255, 235, 205)
  Chalk get blanchedAlmond => _makeRGBChalk(255, 235, 205);

  /// set background color to X11/CSS color blanchedAlmond <span style='background-color: blanchedalmond;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFEBCD)/rgb(255, 235, 205)
  Chalk get onBlanchedAlmond => _makeRGBChalk(255, 235, 205, bg: true);

  /// set foreground color to X11/CSS color blueX11 <span style='background-color: blue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x0000FF)/rgb(0, 0, 255)
  Chalk get blueX11 => _makeRGBChalk(0, 0, 255);

  /// set background color to X11/CSS color blueX11 <span style='background-color: blue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x0000FF)/rgb(0, 0, 255)
  Chalk get onBlueX11 => _makeRGBChalk(0, 0, 255, bg: true);

  /// set foreground color to X11/CSS color blueViolet <span style='background-color: blueviolet;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8A2BE2)/rgb(138, 43, 226)
  Chalk get blueViolet => _makeRGBChalk(138, 43, 226);

  /// set background color to X11/CSS color blueViolet <span style='background-color: blueviolet;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8A2BE2)/rgb(138, 43, 226)
  Chalk get onBlueViolet => _makeRGBChalk(138, 43, 226, bg: true);

  /// set foreground color to X11/CSS color brown <span style='background-color: brown;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xA52A2A)/rgb(165, 42, 42)
  Chalk get brown => _makeRGBChalk(165, 42, 42);

  /// set background color to X11/CSS color brown <span style='background-color: brown;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xA52A2A)/rgb(165, 42, 42)
  Chalk get onBrown => _makeRGBChalk(165, 42, 42, bg: true);

  /// set foreground color to X11/CSS color burlywood <span style='background-color: burlywood;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDEB887)/rgb(222, 184, 135)
  Chalk get burlywood => _makeRGBChalk(222, 184, 135);

  /// set background color to X11/CSS color burlywood <span style='background-color: burlywood;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDEB887)/rgb(222, 184, 135)
  Chalk get onBurlywood => _makeRGBChalk(222, 184, 135, bg: true);

  /// set foreground color to X11/CSS color cadetBlue <span style='background-color: cadetblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x5F9EA0)/rgb(95, 158, 160)
  Chalk get cadetBlue => _makeRGBChalk(95, 158, 160);

  /// set background color to X11/CSS color cadetBlue <span style='background-color: cadetblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x5F9EA0)/rgb(95, 158, 160)
  Chalk get onCadetBlue => _makeRGBChalk(95, 158, 160, bg: true);

  /// set foreground color to X11/CSS color chartreuse <span style='background-color: chartreuse;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x7FFF00)/rgb(127, 255, 0)
  Chalk get chartreuse => _makeRGBChalk(127, 255, 0);

  /// set background color to X11/CSS color chartreuse <span style='background-color: chartreuse;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x7FFF00)/rgb(127, 255, 0)
  Chalk get onChartreuse => _makeRGBChalk(127, 255, 0, bg: true);

  /// set foreground color to X11/CSS color chocolate <span style='background-color: chocolate;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD2691E)/rgb(210, 105, 30)
  Chalk get chocolate => _makeRGBChalk(210, 105, 30);

  /// set background color to X11/CSS color chocolate <span style='background-color: chocolate;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD2691E)/rgb(210, 105, 30)
  Chalk get onChocolate => _makeRGBChalk(210, 105, 30, bg: true);

  /// set foreground color to X11/CSS color coral <span style='background-color: coral;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF7F50)/rgb(255, 127, 80)
  Chalk get coral => _makeRGBChalk(255, 127, 80);

  /// set background color to X11/CSS color coral <span style='background-color: coral;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF7F50)/rgb(255, 127, 80)
  Chalk get onCoral => _makeRGBChalk(255, 127, 80, bg: true);

  /// set foreground color to X11/CSS color cornflowerBlue <span style='background-color: cornflowerblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x6495ED)/rgb(100, 149, 237)
  Chalk get cornflowerBlue => _makeRGBChalk(100, 149, 237);

  /// set background color to X11/CSS color cornflowerBlue <span style='background-color: cornflowerblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x6495ED)/rgb(100, 149, 237)
  Chalk get onCornflowerBlue => _makeRGBChalk(100, 149, 237, bg: true);

  /// set foreground color to X11/CSS color cornsilk <span style='background-color: cornsilk;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFF8DC)/rgb(255, 248, 220)
  Chalk get cornsilk => _makeRGBChalk(255, 248, 220);

  /// set background color to X11/CSS color cornsilk <span style='background-color: cornsilk;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFF8DC)/rgb(255, 248, 220)
  Chalk get onCornsilk => _makeRGBChalk(255, 248, 220, bg: true);

  /// set foreground color to X11/CSS color crimson <span style='background-color: crimson;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDC143C)/rgb(220, 20, 60)
  Chalk get crimson => _makeRGBChalk(220, 20, 60);

  /// set background color to X11/CSS color crimson <span style='background-color: crimson;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDC143C)/rgb(220, 20, 60)
  Chalk get onCrimson => _makeRGBChalk(220, 20, 60, bg: true);

  /// set foreground color to X11/CSS color cyanX11 <span style='background-color: cyan;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FFFF)/rgb(0, 255, 255)
  Chalk get cyanX11 => _makeRGBChalk(0, 255, 255);

  /// set background color to X11/CSS color cyanX11 <span style='background-color: cyan;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FFFF)/rgb(0, 255, 255)
  Chalk get onCyanX11 => _makeRGBChalk(0, 255, 255, bg: true);

  /// set foreground color to X11/CSS color darkBlue <span style='background-color: darkblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00008B)/rgb(0, 0, 139)
  Chalk get darkBlue => _makeRGBChalk(0, 0, 139);

  /// set background color to X11/CSS color darkBlue <span style='background-color: darkblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00008B)/rgb(0, 0, 139)
  Chalk get onDarkBlue => _makeRGBChalk(0, 0, 139, bg: true);

  /// set foreground color to X11/CSS color darkCyan <span style='background-color: darkcyan;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x008B8B)/rgb(0, 139, 139)
  Chalk get darkCyan => _makeRGBChalk(0, 139, 139);

  /// set background color to X11/CSS color darkCyan <span style='background-color: darkcyan;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x008B8B)/rgb(0, 139, 139)
  Chalk get onDarkCyan => _makeRGBChalk(0, 139, 139, bg: true);

  /// set foreground color to X11/CSS color darkGoldenrod <span style='background-color: darkgoldenrod;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xB8860B)/rgb(184, 134, 11)
  Chalk get darkGoldenrod => _makeRGBChalk(184, 134, 11);

  /// set background color to X11/CSS color darkGoldenrod <span style='background-color: darkgoldenrod;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xB8860B)/rgb(184, 134, 11)
  Chalk get onDarkGoldenrod => _makeRGBChalk(184, 134, 11, bg: true);

  /// set foreground color to X11/CSS color darkGray <span style='background-color: darkgray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xA9A9A9)/rgb(169, 169, 169)
  Chalk get darkGray => _makeRGBChalk(169, 169, 169);

  /// set background color to X11/CSS color darkGray <span style='background-color: darkgray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xA9A9A9)/rgb(169, 169, 169)
  Chalk get onDarkGray => _makeRGBChalk(169, 169, 169, bg: true);

  /// set foreground color to X11/CSS color darkGreen <span style='background-color: darkgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x006400)/rgb(0, 100, 0)
  Chalk get darkGreen => _makeRGBChalk(0, 100, 0);

  /// set background color to X11/CSS color darkGreen <span style='background-color: darkgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x006400)/rgb(0, 100, 0)
  Chalk get onDarkGreen => _makeRGBChalk(0, 100, 0, bg: true);

  /// set foreground color to X11/CSS color darkGrey <span style='background-color: darkgrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xA9A9A9)/rgb(169, 169, 169)
  Chalk get darkGrey => _makeRGBChalk(169, 169, 169);

  /// set background color to X11/CSS color darkGrey <span style='background-color: darkgrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xA9A9A9)/rgb(169, 169, 169)
  Chalk get onDarkGrey => _makeRGBChalk(169, 169, 169, bg: true);

  /// set foreground color to X11/CSS color darkKhaki <span style='background-color: darkkhaki;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xBDB76B)/rgb(189, 183, 107)
  Chalk get darkKhaki => _makeRGBChalk(189, 183, 107);

  /// set background color to X11/CSS color darkKhaki <span style='background-color: darkkhaki;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xBDB76B)/rgb(189, 183, 107)
  Chalk get onDarkKhaki => _makeRGBChalk(189, 183, 107, bg: true);

  /// set foreground color to X11/CSS color darkMagenta <span style='background-color: darkmagenta;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8B008B)/rgb(139, 0, 139)
  Chalk get darkMagenta => _makeRGBChalk(139, 0, 139);

  /// set background color to X11/CSS color darkMagenta <span style='background-color: darkmagenta;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8B008B)/rgb(139, 0, 139)
  Chalk get onDarkMagenta => _makeRGBChalk(139, 0, 139, bg: true);

  /// set foreground color to X11/CSS color darkOliveGreen <span style='background-color: darkolivegreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x556B2F)/rgb(85, 107, 47)
  Chalk get darkOliveGreen => _makeRGBChalk(85, 107, 47);

  /// set background color to X11/CSS color darkOliveGreen <span style='background-color: darkolivegreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x556B2F)/rgb(85, 107, 47)
  Chalk get onDarkOliveGreen => _makeRGBChalk(85, 107, 47, bg: true);

  /// set foreground color to X11/CSS color darkOrange <span style='background-color: darkorange;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF8C00)/rgb(255, 140, 0)
  Chalk get darkOrange => _makeRGBChalk(255, 140, 0);

  /// set background color to X11/CSS color darkOrange <span style='background-color: darkorange;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF8C00)/rgb(255, 140, 0)
  Chalk get onDarkOrange => _makeRGBChalk(255, 140, 0, bg: true);

  /// set foreground color to X11/CSS color darkOrchid <span style='background-color: darkorchid;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x9932CC)/rgb(153, 50, 204)
  Chalk get darkOrchid => _makeRGBChalk(153, 50, 204);

  /// set background color to X11/CSS color darkOrchid <span style='background-color: darkorchid;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x9932CC)/rgb(153, 50, 204)
  Chalk get onDarkOrchid => _makeRGBChalk(153, 50, 204, bg: true);

  /// set foreground color to X11/CSS color darkRed <span style='background-color: darkred;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8B0000)/rgb(139, 0, 0)
  Chalk get darkRed => _makeRGBChalk(139, 0, 0);

  /// set background color to X11/CSS color darkRed <span style='background-color: darkred;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8B0000)/rgb(139, 0, 0)
  Chalk get onDarkRed => _makeRGBChalk(139, 0, 0, bg: true);

  /// set foreground color to X11/CSS color darkSalmon <span style='background-color: darksalmon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xE9967A)/rgb(233, 150, 122)
  Chalk get darkSalmon => _makeRGBChalk(233, 150, 122);

  /// set background color to X11/CSS color darkSalmon <span style='background-color: darksalmon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xE9967A)/rgb(233, 150, 122)
  Chalk get onDarkSalmon => _makeRGBChalk(233, 150, 122, bg: true);

  /// set foreground color to X11/CSS color darkSeaGreen <span style='background-color: darkseagreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8FBC8F)/rgb(143, 188, 143)
  Chalk get darkSeaGreen => _makeRGBChalk(143, 188, 143);

  /// set background color to X11/CSS color darkSeaGreen <span style='background-color: darkseagreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8FBC8F)/rgb(143, 188, 143)
  Chalk get onDarkSeaGreen => _makeRGBChalk(143, 188, 143, bg: true);

  /// set foreground color to X11/CSS color darkSlateBlue <span style='background-color: darkslateblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x483D8B)/rgb(72, 61, 139)
  Chalk get darkSlateBlue => _makeRGBChalk(72, 61, 139);

  /// set background color to X11/CSS color darkSlateBlue <span style='background-color: darkslateblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x483D8B)/rgb(72, 61, 139)
  Chalk get onDarkSlateBlue => _makeRGBChalk(72, 61, 139, bg: true);

  /// set foreground color to X11/CSS color darkSlateGray <span style='background-color: darkslategray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x2F4F4F)/rgb(47, 79, 79)
  Chalk get darkSlateGray => _makeRGBChalk(47, 79, 79);

  /// set background color to X11/CSS color darkSlateGray <span style='background-color: darkslategray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x2F4F4F)/rgb(47, 79, 79)
  Chalk get onDarkSlateGray => _makeRGBChalk(47, 79, 79, bg: true);

  /// set foreground color to X11/CSS color darkSlateGrey <span style='background-color: darkslategrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x2F4F4F)/rgb(47, 79, 79)
  Chalk get darkSlateGrey => _makeRGBChalk(47, 79, 79);

  /// set background color to X11/CSS color darkSlateGrey <span style='background-color: darkslategrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x2F4F4F)/rgb(47, 79, 79)
  Chalk get onDarkSlateGrey => _makeRGBChalk(47, 79, 79, bg: true);

  /// set foreground color to X11/CSS color darkTurquoise <span style='background-color: darkturquoise;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00CED1)/rgb(0, 206, 209)
  Chalk get darkTurquoise => _makeRGBChalk(0, 206, 209);

  /// set background color to X11/CSS color darkTurquoise <span style='background-color: darkturquoise;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00CED1)/rgb(0, 206, 209)
  Chalk get onDarkTurquoise => _makeRGBChalk(0, 206, 209, bg: true);

  /// set foreground color to X11/CSS color darkViolet <span style='background-color: darkviolet;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x9400D3)/rgb(148, 0, 211)
  Chalk get darkViolet => _makeRGBChalk(148, 0, 211);

  /// set background color to X11/CSS color darkViolet <span style='background-color: darkviolet;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x9400D3)/rgb(148, 0, 211)
  Chalk get onDarkViolet => _makeRGBChalk(148, 0, 211, bg: true);

  /// set foreground color to X11/CSS color deepPink <span style='background-color: deeppink;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF1493)/rgb(255, 20, 147)
  Chalk get deepPink => _makeRGBChalk(255, 20, 147);

  /// set background color to X11/CSS color deepPink <span style='background-color: deeppink;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF1493)/rgb(255, 20, 147)
  Chalk get onDeepPink => _makeRGBChalk(255, 20, 147, bg: true);

  /// set foreground color to X11/CSS color deepSkyBlue <span style='background-color: deepskyblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00BFFF)/rgb(0, 191, 255)
  Chalk get deepSkyBlue => _makeRGBChalk(0, 191, 255);

  /// set background color to X11/CSS color deepSkyBlue <span style='background-color: deepskyblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00BFFF)/rgb(0, 191, 255)
  Chalk get onDeepSkyBlue => _makeRGBChalk(0, 191, 255, bg: true);

  /// set foreground color to X11/CSS color dimGray <span style='background-color: dimgray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x696969)/rgb(105, 105, 105)
  Chalk get dimGray => _makeRGBChalk(105, 105, 105);

  /// set background color to X11/CSS color dimGray <span style='background-color: dimgray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x696969)/rgb(105, 105, 105)
  Chalk get onDimGray => _makeRGBChalk(105, 105, 105, bg: true);

  /// set foreground color to X11/CSS color dimGrey <span style='background-color: dimgrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x696969)/rgb(105, 105, 105)
  Chalk get dimGrey => _makeRGBChalk(105, 105, 105);

  /// set background color to X11/CSS color dimGrey <span style='background-color: dimgrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x696969)/rgb(105, 105, 105)
  Chalk get onDimGrey => _makeRGBChalk(105, 105, 105, bg: true);

  /// set foreground color to X11/CSS color dodgerBlue <span style='background-color: dodgerblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x1E90FF)/rgb(30, 144, 255)
  Chalk get dodgerBlue => _makeRGBChalk(30, 144, 255);

  /// set background color to X11/CSS color dodgerBlue <span style='background-color: dodgerblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x1E90FF)/rgb(30, 144, 255)
  Chalk get onDodgerBlue => _makeRGBChalk(30, 144, 255, bg: true);

  /// set foreground color to X11/CSS color fireBrick <span style='background-color: firebrick;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xB22222)/rgb(178, 34, 34)
  Chalk get fireBrick => _makeRGBChalk(178, 34, 34);

  /// set background color to X11/CSS color fireBrick <span style='background-color: firebrick;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xB22222)/rgb(178, 34, 34)
  Chalk get onFireBrick => _makeRGBChalk(178, 34, 34, bg: true);

  /// set foreground color to X11/CSS color floralWhite <span style='background-color: floralwhite;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFAF0)/rgb(255, 250, 240)
  Chalk get floralWhite => _makeRGBChalk(255, 250, 240);

  /// set background color to X11/CSS color floralWhite <span style='background-color: floralwhite;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFAF0)/rgb(255, 250, 240)
  Chalk get onFloralWhite => _makeRGBChalk(255, 250, 240, bg: true);

  /// set foreground color to X11/CSS color forestGreen <span style='background-color: forestgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x228B22)/rgb(34, 139, 34)
  Chalk get forestGreen => _makeRGBChalk(34, 139, 34);

  /// set background color to X11/CSS color forestGreen <span style='background-color: forestgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x228B22)/rgb(34, 139, 34)
  Chalk get onForestGreen => _makeRGBChalk(34, 139, 34, bg: true);

  /// set foreground color to X11/CSS color fuchsia <span style='background-color: fuchsia;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF00FF)/rgb(255, 0, 255)
  Chalk get fuchsia => _makeRGBChalk(255, 0, 255);

  /// set background color to X11/CSS color fuchsia <span style='background-color: fuchsia;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF00FF)/rgb(255, 0, 255)
  Chalk get onFuchsia => _makeRGBChalk(255, 0, 255, bg: true);

  /// set foreground color to X11/CSS color gainsboro <span style='background-color: gainsboro;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDCDCDC)/rgb(220, 220, 220)
  Chalk get gainsboro => _makeRGBChalk(220, 220, 220);

  /// set background color to X11/CSS color gainsboro <span style='background-color: gainsboro;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDCDCDC)/rgb(220, 220, 220)
  Chalk get onGainsboro => _makeRGBChalk(220, 220, 220, bg: true);

  /// set foreground color to X11/CSS color ghostWhite <span style='background-color: ghostwhite;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF8F8FF)/rgb(248, 248, 255)
  Chalk get ghostWhite => _makeRGBChalk(248, 248, 255);

  /// set background color to X11/CSS color ghostWhite <span style='background-color: ghostwhite;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF8F8FF)/rgb(248, 248, 255)
  Chalk get onGhostWhite => _makeRGBChalk(248, 248, 255, bg: true);

  /// set foreground color to X11/CSS color gold <span style='background-color: gold;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFD700)/rgb(255, 215, 0)
  Chalk get gold => _makeRGBChalk(255, 215, 0);

  /// set background color to X11/CSS color gold <span style='background-color: gold;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFD700)/rgb(255, 215, 0)
  Chalk get onGold => _makeRGBChalk(255, 215, 0, bg: true);

  /// set foreground color to X11/CSS color goldenrod <span style='background-color: goldenrod;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDAA520)/rgb(218, 165, 32)
  Chalk get goldenrod => _makeRGBChalk(218, 165, 32);

  /// set background color to X11/CSS color goldenrod <span style='background-color: goldenrod;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDAA520)/rgb(218, 165, 32)
  Chalk get onGoldenrod => _makeRGBChalk(218, 165, 32, bg: true);

  /// set foreground color to X11/CSS color grayX11 <span style='background-color: gray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x808080)/rgb(128, 128, 128)
  Chalk get grayX11 => _makeRGBChalk(128, 128, 128);

  /// set background color to X11/CSS color grayX11 <span style='background-color: gray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x808080)/rgb(128, 128, 128)
  Chalk get onGrayX11 => _makeRGBChalk(128, 128, 128, bg: true);

  /// set foreground color to X11/CSS color greenX11 <span style='background-color: green;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x008000)/rgb(0, 128, 0)
  Chalk get greenX11 => _makeRGBChalk(0, 128, 0);

  /// set background color to X11/CSS color greenX11 <span style='background-color: green;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x008000)/rgb(0, 128, 0)
  Chalk get onGreenX11 => _makeRGBChalk(0, 128, 0, bg: true);

  /// set foreground color to X11/CSS color greenYellow <span style='background-color: greenyellow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xADFF2F)/rgb(173, 255, 47)
  Chalk get greenYellow => _makeRGBChalk(173, 255, 47);

  /// set background color to X11/CSS color greenYellow <span style='background-color: greenyellow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xADFF2F)/rgb(173, 255, 47)
  Chalk get onGreenYellow => _makeRGBChalk(173, 255, 47, bg: true);

  /// set foreground color to X11/CSS color greyX11 <span style='background-color: grey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x808080)/rgb(128, 128, 128)
  Chalk get greyX11 => _makeRGBChalk(128, 128, 128);

  /// set background color to X11/CSS color greyX11 <span style='background-color: grey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x808080)/rgb(128, 128, 128)
  Chalk get onGreyX11 => _makeRGBChalk(128, 128, 128, bg: true);

  /// set foreground color to X11/CSS color honeydew <span style='background-color: honeydew;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF0FFF0)/rgb(240, 255, 240)
  Chalk get honeydew => _makeRGBChalk(240, 255, 240);

  /// set background color to X11/CSS color honeydew <span style='background-color: honeydew;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF0FFF0)/rgb(240, 255, 240)
  Chalk get onHoneydew => _makeRGBChalk(240, 255, 240, bg: true);

  /// set foreground color to X11/CSS color hotPink <span style='background-color: hotpink;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF69B4)/rgb(255, 105, 180)
  Chalk get hotPink => _makeRGBChalk(255, 105, 180);

  /// set background color to X11/CSS color hotPink <span style='background-color: hotpink;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF69B4)/rgb(255, 105, 180)
  Chalk get onHotPink => _makeRGBChalk(255, 105, 180, bg: true);

  /// set foreground color to X11/CSS color indianRed <span style='background-color: indianred;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xCD5C5C)/rgb(205, 92, 92)
  Chalk get indianRed => _makeRGBChalk(205, 92, 92);

  /// set background color to X11/CSS color indianRed <span style='background-color: indianred;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xCD5C5C)/rgb(205, 92, 92)
  Chalk get onIndianRed => _makeRGBChalk(205, 92, 92, bg: true);

  /// set foreground color to X11/CSS color indigo <span style='background-color: indigo;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x4B0082)/rgb(75, 0, 130)
  Chalk get indigo => _makeRGBChalk(75, 0, 130);

  /// set background color to X11/CSS color indigo <span style='background-color: indigo;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x4B0082)/rgb(75, 0, 130)
  Chalk get onIndigo => _makeRGBChalk(75, 0, 130, bg: true);

  /// set foreground color to X11/CSS color ivory <span style='background-color: ivory;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFFF0)/rgb(255, 255, 240)
  Chalk get ivory => _makeRGBChalk(255, 255, 240);

  /// set background color to X11/CSS color ivory <span style='background-color: ivory;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFFF0)/rgb(255, 255, 240)
  Chalk get onIvory => _makeRGBChalk(255, 255, 240, bg: true);

  /// set foreground color to X11/CSS color khaki <span style='background-color: khaki;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF0E68C)/rgb(240, 230, 140)
  Chalk get khaki => _makeRGBChalk(240, 230, 140);

  /// set background color to X11/CSS color khaki <span style='background-color: khaki;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF0E68C)/rgb(240, 230, 140)
  Chalk get onKhaki => _makeRGBChalk(240, 230, 140, bg: true);

  /// set foreground color to X11/CSS color lavender <span style='background-color: lavender;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xE6E6FA)/rgb(230, 230, 250)
  Chalk get lavender => _makeRGBChalk(230, 230, 250);

  /// set background color to X11/CSS color lavender <span style='background-color: lavender;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xE6E6FA)/rgb(230, 230, 250)
  Chalk get onLavender => _makeRGBChalk(230, 230, 250, bg: true);

  /// set foreground color to X11/CSS color lavenderBlush <span style='background-color: lavenderblush;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFF0F5)/rgb(255, 240, 245)
  Chalk get lavenderBlush => _makeRGBChalk(255, 240, 245);

  /// set background color to X11/CSS color lavenderBlush <span style='background-color: lavenderblush;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFF0F5)/rgb(255, 240, 245)
  Chalk get onLavenderBlush => _makeRGBChalk(255, 240, 245, bg: true);

  /// set foreground color to X11/CSS color lawnGreen <span style='background-color: lawngreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x7CFC00)/rgb(124, 252, 0)
  Chalk get lawnGreen => _makeRGBChalk(124, 252, 0);

  /// set background color to X11/CSS color lawnGreen <span style='background-color: lawngreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x7CFC00)/rgb(124, 252, 0)
  Chalk get onLawnGreen => _makeRGBChalk(124, 252, 0, bg: true);

  /// set foreground color to X11/CSS color lemonChiffon <span style='background-color: lemonchiffon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFACD)/rgb(255, 250, 205)
  Chalk get lemonChiffon => _makeRGBChalk(255, 250, 205);

  /// set background color to X11/CSS color lemonChiffon <span style='background-color: lemonchiffon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFACD)/rgb(255, 250, 205)
  Chalk get onLemonChiffon => _makeRGBChalk(255, 250, 205, bg: true);

  /// set foreground color to X11/CSS color lightBlue <span style='background-color: lightblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xADD8E6)/rgb(173, 216, 230)
  Chalk get lightBlue => _makeRGBChalk(173, 216, 230);

  /// set background color to X11/CSS color lightBlue <span style='background-color: lightblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xADD8E6)/rgb(173, 216, 230)
  Chalk get onLightBlue => _makeRGBChalk(173, 216, 230, bg: true);

  /// set foreground color to X11/CSS color lightCoral <span style='background-color: lightcoral;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF08080)/rgb(240, 128, 128)
  Chalk get lightCoral => _makeRGBChalk(240, 128, 128);

  /// set background color to X11/CSS color lightCoral <span style='background-color: lightcoral;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF08080)/rgb(240, 128, 128)
  Chalk get onLightCoral => _makeRGBChalk(240, 128, 128, bg: true);

  /// set foreground color to X11/CSS color lightCyan <span style='background-color: lightcyan;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xE0FFFF)/rgb(224, 255, 255)
  Chalk get lightCyan => _makeRGBChalk(224, 255, 255);

  /// set background color to X11/CSS color lightCyan <span style='background-color: lightcyan;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xE0FFFF)/rgb(224, 255, 255)
  Chalk get onLightCyan => _makeRGBChalk(224, 255, 255, bg: true);

  /// set foreground color to CSS color lightGoldenrodYellow <span style='background-color: lightgoldenrodyellow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFAFAD2)/rgb(250, 250, 210)
  Chalk get lightGoldenrodYellow => _makeRGBChalk(250, 250, 210);

  /// set background color to CSS color lightGoldenrodYellow <span style='background-color: lightgoldenrodyellow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFAFAD2)/rgb(250, 250, 210)
  Chalk get onLightGoldenrodYellow => _makeRGBChalk(250, 250, 210, bg: true);

  /// set foreground color to X11 color lightGoldenrod <span style='background-color: rgb(250, 250, 210);'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFAFAD2)/rgb(250, 250, 210)
  Chalk get lightGoldenrod => _makeRGBChalk(250, 250, 210);

  /// set background color to X11 color lightGoldenrod <span style='background-color: rgb(250, 250, 210);'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFAFAD2)/rgb(250, 250, 210)
  Chalk get onLightGoldenrod => _makeRGBChalk(250, 250, 210, bg: true);

  /// set foreground color to X11/CSS color lightGray <span style='background-color: lightgray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD3D3D3)/rgb(211, 211, 211)
  Chalk get lightGray => _makeRGBChalk(211, 211, 211);

  /// set background color to X11/CSS color lightGray <span style='background-color: lightgray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD3D3D3)/rgb(211, 211, 211)
  Chalk get onLightGray => _makeRGBChalk(211, 211, 211, bg: true);

  /// set foreground color to X11/CSS color lightGreen <span style='background-color: lightgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x90EE90)/rgb(144, 238, 144)
  Chalk get lightGreen => _makeRGBChalk(144, 238, 144);

  /// set background color to X11/CSS color lightGreen <span style='background-color: lightgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x90EE90)/rgb(144, 238, 144)
  Chalk get onLightGreen => _makeRGBChalk(144, 238, 144, bg: true);

  /// set foreground color to X11/CSS color lightGrey <span style='background-color: lightgrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD3D3D3)/rgb(211, 211, 211)
  Chalk get lightGrey => _makeRGBChalk(211, 211, 211);

  /// set background color to X11/CSS color lightGrey <span style='background-color: lightgrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD3D3D3)/rgb(211, 211, 211)
  Chalk get onLightGrey => _makeRGBChalk(211, 211, 211, bg: true);

  /// set foreground color to X11/CSS color lightPink <span style='background-color: lightpink;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFB6C1)/rgb(255, 182, 193)
  Chalk get lightPink => _makeRGBChalk(255, 182, 193);

  /// set background color to X11/CSS color lightPink <span style='background-color: lightpink;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFB6C1)/rgb(255, 182, 193)
  Chalk get onLightPink => _makeRGBChalk(255, 182, 193, bg: true);

  /// set foreground color to X11/CSS color lightSalmon <span style='background-color: lightsalmon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFA07A)/rgb(255, 160, 122)
  Chalk get lightSalmon => _makeRGBChalk(255, 160, 122);

  /// set background color to X11/CSS color lightSalmon <span style='background-color: lightsalmon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFA07A)/rgb(255, 160, 122)
  Chalk get onLightSalmon => _makeRGBChalk(255, 160, 122, bg: true);

  /// set foreground color to X11/CSS color lightSeaGreen <span style='background-color: lightseagreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x20B2AA)/rgb(32, 178, 170)
  Chalk get lightSeaGreen => _makeRGBChalk(32, 178, 170);

  /// set background color to X11/CSS color lightSeaGreen <span style='background-color: lightseagreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x20B2AA)/rgb(32, 178, 170)
  Chalk get onLightSeaGreen => _makeRGBChalk(32, 178, 170, bg: true);

  /// set foreground color to X11/CSS color lightSkyBlue <span style='background-color: lightskyblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x87CEFA)/rgb(135, 206, 250)
  Chalk get lightSkyBlue => _makeRGBChalk(135, 206, 250);

  /// set background color to X11/CSS color lightSkyBlue <span style='background-color: lightskyblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x87CEFA)/rgb(135, 206, 250)
  Chalk get onLightSkyBlue => _makeRGBChalk(135, 206, 250, bg: true);

  /// set foreground color to X11/CSS color lightSlateGray <span style='background-color: lightslategray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x778899)/rgb(119, 136, 153)
  Chalk get lightSlateGray => _makeRGBChalk(119, 136, 153);

  /// set background color to X11/CSS color lightSlateGray <span style='background-color: lightslategray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x778899)/rgb(119, 136, 153)
  Chalk get onLightSlateGray => _makeRGBChalk(119, 136, 153, bg: true);

  /// set foreground color to X11/CSS color lightSlateGrey <span style='background-color: lightslategrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x778899)/rgb(119, 136, 153)
  Chalk get lightSlateGrey => _makeRGBChalk(119, 136, 153);

  /// set background color to X11/CSS color lightSlateGrey <span style='background-color: lightslategrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x778899)/rgb(119, 136, 153)
  Chalk get onLightSlateGrey => _makeRGBChalk(119, 136, 153, bg: true);

  /// set foreground color to X11/CSS color lightSteelBlue <span style='background-color: lightsteelblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xB0C4DE)/rgb(176, 196, 222)
  Chalk get lightSteelBlue => _makeRGBChalk(176, 196, 222);

  /// set background color to X11/CSS color lightSteelBlue <span style='background-color: lightsteelblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xB0C4DE)/rgb(176, 196, 222)
  Chalk get onLightSteelBlue => _makeRGBChalk(176, 196, 222, bg: true);

  /// set foreground color to X11/CSS color lightYellow <span style='background-color: lightyellow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFFE0)/rgb(255, 255, 224)
  Chalk get lightYellow => _makeRGBChalk(255, 255, 224);

  /// set background color to X11/CSS color lightYellow <span style='background-color: lightyellow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFFE0)/rgb(255, 255, 224)
  Chalk get onLightYellow => _makeRGBChalk(255, 255, 224, bg: true);

  /// set foreground color to X11/CSS color lime <span style='background-color: lime;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FF00)/rgb(0, 255, 0)
  Chalk get lime => _makeRGBChalk(0, 255, 0);

  /// set background color to X11/CSS color lime <span style='background-color: lime;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FF00)/rgb(0, 255, 0)
  Chalk get onLime => _makeRGBChalk(0, 255, 0, bg: true);

  /// set foreground color to X11/CSS color limeGreen <span style='background-color: limegreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x32CD32)/rgb(50, 205, 50)
  Chalk get limeGreen => _makeRGBChalk(50, 205, 50);

  /// set background color to X11/CSS color limeGreen <span style='background-color: limegreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x32CD32)/rgb(50, 205, 50)
  Chalk get onLimeGreen => _makeRGBChalk(50, 205, 50, bg: true);

  /// set foreground color to X11/CSS color linen <span style='background-color: linen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFAF0E6)/rgb(250, 240, 230)
  Chalk get linen => _makeRGBChalk(250, 240, 230);

  /// set background color to X11/CSS color linen <span style='background-color: linen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFAF0E6)/rgb(250, 240, 230)
  Chalk get onLinen => _makeRGBChalk(250, 240, 230, bg: true);

  /// set foreground color to X11/CSS color magentaX11 <span style='background-color: magenta;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF00FF)/rgb(255, 0, 255)
  Chalk get magentaX11 => _makeRGBChalk(255, 0, 255);

  /// set background color to X11/CSS color magentaX11 <span style='background-color: magenta;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF00FF)/rgb(255, 0, 255)
  Chalk get onMagentaX11 => _makeRGBChalk(255, 0, 255, bg: true);

  /// set foreground color to X11/CSS color maroon <span style='background-color: maroon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x800000)/rgb(128, 0, 0)
  Chalk get maroon => _makeRGBChalk(128, 0, 0);

  /// set background color to X11/CSS color maroon <span style='background-color: maroon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x800000)/rgb(128, 0, 0)
  Chalk get onMaroon => _makeRGBChalk(128, 0, 0, bg: true);

  /// set foreground color to X11/CSS color mediumAquamarine <span style='background-color: mediumaquamarine;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x66CDAA)/rgb(102, 205, 170)
  Chalk get mediumAquamarine => _makeRGBChalk(102, 205, 170);

  /// set background color to X11/CSS color mediumAquamarine <span style='background-color: mediumaquamarine;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x66CDAA)/rgb(102, 205, 170)
  Chalk get onMediumAquamarine => _makeRGBChalk(102, 205, 170, bg: true);

  /// set foreground color to X11/CSS color mediumBlue <span style='background-color: mediumblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x0000CD)/rgb(0, 0, 205)
  Chalk get mediumBlue => _makeRGBChalk(0, 0, 205);

  /// set background color to X11/CSS color mediumBlue <span style='background-color: mediumblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x0000CD)/rgb(0, 0, 205)
  Chalk get onMediumBlue => _makeRGBChalk(0, 0, 205, bg: true);

  /// set foreground color to X11/CSS color mediumOrchid <span style='background-color: mediumorchid;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xBA55D3)/rgb(186, 85, 211)
  Chalk get mediumOrchid => _makeRGBChalk(186, 85, 211);

  /// set background color to X11/CSS color mediumOrchid <span style='background-color: mediumorchid;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xBA55D3)/rgb(186, 85, 211)
  Chalk get onMediumOrchid => _makeRGBChalk(186, 85, 211, bg: true);

  /// set foreground color to X11/CSS color mediumPurple <span style='background-color: mediumpurple;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x9370DB)/rgb(147, 112, 219)
  Chalk get mediumPurple => _makeRGBChalk(147, 112, 219);

  /// set background color to X11/CSS color mediumPurple <span style='background-color: mediumpurple;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x9370DB)/rgb(147, 112, 219)
  Chalk get onMediumPurple => _makeRGBChalk(147, 112, 219, bg: true);

  /// set foreground color to X11/CSS color mediumSeaGreen <span style='background-color: mediumseagreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x3CB371)/rgb(60, 179, 113)
  Chalk get mediumSeaGreen => _makeRGBChalk(60, 179, 113);

  /// set background color to X11/CSS color mediumSeaGreen <span style='background-color: mediumseagreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x3CB371)/rgb(60, 179, 113)
  Chalk get onMediumSeaGreen => _makeRGBChalk(60, 179, 113, bg: true);

  /// set foreground color to X11/CSS color mediumSlateBlue <span style='background-color: mediumslateblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x7B68EE)/rgb(123, 104, 238)
  Chalk get mediumSlateBlue => _makeRGBChalk(123, 104, 238);

  /// set background color to X11/CSS color mediumSlateBlue <span style='background-color: mediumslateblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x7B68EE)/rgb(123, 104, 238)
  Chalk get onMediumSlateBlue => _makeRGBChalk(123, 104, 238, bg: true);

  /// set foreground color to X11/CSS color mediumSpringGreen <span style='background-color: mediumspringgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FA9A)/rgb(0, 250, 154)
  Chalk get mediumSpringGreen => _makeRGBChalk(0, 250, 154);

  /// set background color to X11/CSS color mediumSpringGreen <span style='background-color: mediumspringgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FA9A)/rgb(0, 250, 154)
  Chalk get onMediumSpringGreen => _makeRGBChalk(0, 250, 154, bg: true);

  /// set foreground color to X11/CSS color mediumTurquoise <span style='background-color: mediumturquoise;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x48D1CC)/rgb(72, 209, 204)
  Chalk get mediumTurquoise => _makeRGBChalk(72, 209, 204);

  /// set background color to X11/CSS color mediumTurquoise <span style='background-color: mediumturquoise;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x48D1CC)/rgb(72, 209, 204)
  Chalk get onMediumTurquoise => _makeRGBChalk(72, 209, 204, bg: true);

  /// set foreground color to X11/CSS color mediumVioletRed <span style='background-color: mediumvioletred;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xC71585)/rgb(199, 21, 133)
  Chalk get mediumVioletRed => _makeRGBChalk(199, 21, 133);

  /// set background color to X11/CSS color mediumVioletRed <span style='background-color: mediumvioletred;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xC71585)/rgb(199, 21, 133)
  Chalk get onMediumVioletRed => _makeRGBChalk(199, 21, 133, bg: true);

  /// set foreground color to X11/CSS color midnightBlue <span style='background-color: midnightblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x191970)/rgb(25, 25, 112)
  Chalk get midnightBlue => _makeRGBChalk(25, 25, 112);

  /// set background color to X11/CSS color midnightBlue <span style='background-color: midnightblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x191970)/rgb(25, 25, 112)
  Chalk get onMidnightBlue => _makeRGBChalk(25, 25, 112, bg: true);

  /// set foreground color to X11/CSS color mintCream <span style='background-color: mintcream;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF5FFFA)/rgb(245, 255, 250)
  Chalk get mintCream => _makeRGBChalk(245, 255, 250);

  /// set background color to X11/CSS color mintCream <span style='background-color: mintcream;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF5FFFA)/rgb(245, 255, 250)
  Chalk get onMintCream => _makeRGBChalk(245, 255, 250, bg: true);

  /// set foreground color to X11/CSS color mistyRose <span style='background-color: mistyrose;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFE4E1)/rgb(255, 228, 225)
  Chalk get mistyRose => _makeRGBChalk(255, 228, 225);

  /// set background color to X11/CSS color mistyRose <span style='background-color: mistyrose;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFE4E1)/rgb(255, 228, 225)
  Chalk get onMistyRose => _makeRGBChalk(255, 228, 225, bg: true);

  /// set foreground color to X11/CSS color moccasin <span style='background-color: moccasin;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFE4B5)/rgb(255, 228, 181)
  Chalk get moccasin => _makeRGBChalk(255, 228, 181);

  /// set background color to X11/CSS color moccasin <span style='background-color: moccasin;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFE4B5)/rgb(255, 228, 181)
  Chalk get onMoccasin => _makeRGBChalk(255, 228, 181, bg: true);

  /// set foreground color to X11/CSS color navajoWhite <span style='background-color: navajowhite;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFDEAD)/rgb(255, 222, 173)
  Chalk get navajoWhite => _makeRGBChalk(255, 222, 173);

  /// set background color to X11/CSS color navajoWhite <span style='background-color: navajowhite;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFDEAD)/rgb(255, 222, 173)
  Chalk get onNavajoWhite => _makeRGBChalk(255, 222, 173, bg: true);

  /// set foreground color to X11/CSS color navy <span style='background-color: navy;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x000080)/rgb(0, 0, 128)
  Chalk get navy => _makeRGBChalk(0, 0, 128);

  /// set background color to X11/CSS color navy <span style='background-color: navy;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x000080)/rgb(0, 0, 128)
  Chalk get onNavy => _makeRGBChalk(0, 0, 128, bg: true);

  /// set foreground color to X11/CSS color oldLace <span style='background-color: oldlace;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFDF5E6)/rgb(253, 245, 230)
  Chalk get oldLace => _makeRGBChalk(253, 245, 230);

  /// set background color to X11/CSS color oldLace <span style='background-color: oldlace;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFDF5E6)/rgb(253, 245, 230)
  Chalk get onOldLace => _makeRGBChalk(253, 245, 230, bg: true);

  /// set foreground color to X11/CSS color olive <span style='background-color: olive;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x808000)/rgb(128, 128, 0)
  Chalk get olive => _makeRGBChalk(128, 128, 0);

  /// set background color to X11/CSS color olive <span style='background-color: olive;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x808000)/rgb(128, 128, 0)
  Chalk get onOlive => _makeRGBChalk(128, 128, 0, bg: true);

  /// set foreground color to X11/CSS color oliveDrab <span style='background-color: olivedrab;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x6B8E23)/rgb(107, 142, 35)
  Chalk get oliveDrab => _makeRGBChalk(107, 142, 35);

  /// set background color to X11/CSS color oliveDrab <span style='background-color: olivedrab;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x6B8E23)/rgb(107, 142, 35)
  Chalk get onOliveDrab => _makeRGBChalk(107, 142, 35, bg: true);

  /// set foreground color to X11/CSS color orange <span style='background-color: orange;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFA500)/rgb(255, 165, 0)
  Chalk get orange => _makeRGBChalk(255, 165, 0);

  /// set background color to X11/CSS color orange <span style='background-color: orange;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFA500)/rgb(255, 165, 0)
  Chalk get onOrange => _makeRGBChalk(255, 165, 0, bg: true);

  /// set foreground color to X11/CSS color orangeRed <span style='background-color: orangered;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF4500)/rgb(255, 69, 0)
  Chalk get orangeRed => _makeRGBChalk(255, 69, 0);

  /// set background color to X11/CSS color orangeRed <span style='background-color: orangered;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF4500)/rgb(255, 69, 0)
  Chalk get onOrangeRed => _makeRGBChalk(255, 69, 0, bg: true);

  /// set foreground color to X11/CSS color orchid <span style='background-color: orchid;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDA70D6)/rgb(218, 112, 214)
  Chalk get orchid => _makeRGBChalk(218, 112, 214);

  /// set background color to X11/CSS color orchid <span style='background-color: orchid;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDA70D6)/rgb(218, 112, 214)
  Chalk get onOrchid => _makeRGBChalk(218, 112, 214, bg: true);

  /// set foreground color to X11/CSS color paleGoldenrod <span style='background-color: palegoldenrod;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xEEE8AA)/rgb(238, 232, 170)
  Chalk get paleGoldenrod => _makeRGBChalk(238, 232, 170);

  /// set background color to X11/CSS color paleGoldenrod <span style='background-color: palegoldenrod;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xEEE8AA)/rgb(238, 232, 170)
  Chalk get onPaleGoldenrod => _makeRGBChalk(238, 232, 170, bg: true);

  /// set foreground color to X11/CSS color paleGreen <span style='background-color: palegreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x98FB98)/rgb(152, 251, 152)
  Chalk get paleGreen => _makeRGBChalk(152, 251, 152);

  /// set background color to X11/CSS color paleGreen <span style='background-color: palegreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x98FB98)/rgb(152, 251, 152)
  Chalk get onPaleGreen => _makeRGBChalk(152, 251, 152, bg: true);

  /// set foreground color to X11/CSS color paleTurquoise <span style='background-color: paleturquoise;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xAFEEEE)/rgb(175, 238, 238)
  Chalk get paleTurquoise => _makeRGBChalk(175, 238, 238);

  /// set background color to X11/CSS color paleTurquoise <span style='background-color: paleturquoise;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xAFEEEE)/rgb(175, 238, 238)
  Chalk get onPaleTurquoise => _makeRGBChalk(175, 238, 238, bg: true);

  /// set foreground color to X11/CSS color paleVioletRed <span style='background-color: palevioletred;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDB7093)/rgb(219, 112, 147)
  Chalk get paleVioletRed => _makeRGBChalk(219, 112, 147);

  /// set background color to X11/CSS color paleVioletRed <span style='background-color: palevioletred;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDB7093)/rgb(219, 112, 147)
  Chalk get onPaleVioletRed => _makeRGBChalk(219, 112, 147, bg: true);

  /// set foreground color to X11/CSS color papayaWhip <span style='background-color: papayawhip;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFEFD5)/rgb(255, 239, 213)
  Chalk get papayaWhip => _makeRGBChalk(255, 239, 213);

  /// set background color to X11/CSS color papayaWhip <span style='background-color: papayawhip;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFEFD5)/rgb(255, 239, 213)
  Chalk get onPapayaWhip => _makeRGBChalk(255, 239, 213, bg: true);

  /// set foreground color to X11/CSS color peachPuff <span style='background-color: peachpuff;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFDAB9)/rgb(255, 218, 185)
  Chalk get peachPuff => _makeRGBChalk(255, 218, 185);

  /// set background color to X11/CSS color peachPuff <span style='background-color: peachpuff;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFDAB9)/rgb(255, 218, 185)
  Chalk get onPeachPuff => _makeRGBChalk(255, 218, 185, bg: true);

  /// set foreground color to X11/CSS color peru <span style='background-color: peru;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xCD853F)/rgb(205, 133, 63)
  Chalk get peru => _makeRGBChalk(205, 133, 63);

  /// set background color to X11/CSS color peru <span style='background-color: peru;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xCD853F)/rgb(205, 133, 63)
  Chalk get onPeru => _makeRGBChalk(205, 133, 63, bg: true);

  /// set foreground color to X11/CSS color pink <span style='background-color: pink;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFC0CB)/rgb(255, 192, 203)
  Chalk get pink => _makeRGBChalk(255, 192, 203);

  /// set background color to X11/CSS color pink <span style='background-color: pink;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFC0CB)/rgb(255, 192, 203)
  Chalk get onPink => _makeRGBChalk(255, 192, 203, bg: true);

  /// set foreground color to X11/CSS color plum <span style='background-color: plum;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDDA0DD)/rgb(221, 160, 221)
  Chalk get plum => _makeRGBChalk(221, 160, 221);

  /// set background color to X11/CSS color plum <span style='background-color: plum;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xDDA0DD)/rgb(221, 160, 221)
  Chalk get onPlum => _makeRGBChalk(221, 160, 221, bg: true);

  /// set foreground color to X11/CSS color powderBlue <span style='background-color: powderblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xB0E0E6)/rgb(176, 224, 230)
  Chalk get powderBlue => _makeRGBChalk(176, 224, 230);

  /// set background color to X11/CSS color powderBlue <span style='background-color: powderblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xB0E0E6)/rgb(176, 224, 230)
  Chalk get onPowderBlue => _makeRGBChalk(176, 224, 230, bg: true);

  /// set foreground color to X11/CSS color purple <span style='background-color: purple;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x800080)/rgb(128, 0, 128)
  Chalk get purple => _makeRGBChalk(128, 0, 128);

  /// set background color to X11/CSS color purple <span style='background-color: purple;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x800080)/rgb(128, 0, 128)
  Chalk get onPurple => _makeRGBChalk(128, 0, 128, bg: true);

  /// set foreground color to X11 color rebeccaPurple <span style='background-color: rgb(102, 51, 153);'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x663399)/rgb(102, 51, 153)
  Chalk get rebeccaPurple => _makeRGBChalk(102, 51, 153);

  /// set background color to X11 color rebeccaPurple <span style='background-color: rgb(102, 51, 153);'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x663399)/rgb(102, 51, 153)
  Chalk get onRebeccaPurple => _makeRGBChalk(102, 51, 153, bg: true);

  /// set foreground color to X11/CSS color RedX11 <span style='background-color: red;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF0000)/rgb(255, 0, 0)
  Chalk get RedX11 => _makeRGBChalk(255, 0, 0);

  /// set background color to X11/CSS color RedX11 <span style='background-color: red;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF0000)/rgb(255, 0, 0)
  Chalk get onRedX11 => _makeRGBChalk(255, 0, 0, bg: true);

  /// set foreground color to X11/CSS color rosyBrown <span style='background-color: rosybrown;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xBC8F8F)/rgb(188, 143, 143)
  Chalk get rosyBrown => _makeRGBChalk(188, 143, 143);

  /// set background color to X11/CSS color rosyBrown <span style='background-color: rosybrown;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xBC8F8F)/rgb(188, 143, 143)
  Chalk get onRosyBrown => _makeRGBChalk(188, 143, 143, bg: true);

  /// set foreground color to X11/CSS color royalBlue <span style='background-color: royalblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x4169E1)/rgb(65, 105, 225)
  Chalk get royalBlue => _makeRGBChalk(65, 105, 225);

  /// set background color to X11/CSS color royalBlue <span style='background-color: royalblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x4169E1)/rgb(65, 105, 225)
  Chalk get onRoyalBlue => _makeRGBChalk(65, 105, 225, bg: true);

  /// set foreground color to X11/CSS color saddleBrown <span style='background-color: saddlebrown;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8B4513)/rgb(139, 69, 19)
  Chalk get saddleBrown => _makeRGBChalk(139, 69, 19);

  /// set background color to X11/CSS color saddleBrown <span style='background-color: saddlebrown;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x8B4513)/rgb(139, 69, 19)
  Chalk get onSaddleBrown => _makeRGBChalk(139, 69, 19, bg: true);

  /// set foreground color to X11/CSS color salmon <span style='background-color: salmon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFA8072)/rgb(250, 128, 114)
  Chalk get salmon => _makeRGBChalk(250, 128, 114);

  /// set background color to X11/CSS color salmon <span style='background-color: salmon;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFA8072)/rgb(250, 128, 114)
  Chalk get onSalmon => _makeRGBChalk(250, 128, 114, bg: true);

  /// set foreground color to X11/CSS color sandyBrown <span style='background-color: sandybrown;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF4A460)/rgb(244, 164, 96)
  Chalk get sandyBrown => _makeRGBChalk(244, 164, 96);

  /// set background color to X11/CSS color sandyBrown <span style='background-color: sandybrown;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF4A460)/rgb(244, 164, 96)
  Chalk get onSandyBrown => _makeRGBChalk(244, 164, 96, bg: true);

  /// set foreground color to X11/CSS color seaGreen <span style='background-color: seagreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x2E8B57)/rgb(46, 139, 87)
  Chalk get seaGreen => _makeRGBChalk(46, 139, 87);

  /// set background color to X11/CSS color seaGreen <span style='background-color: seagreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x2E8B57)/rgb(46, 139, 87)
  Chalk get onSeaGreen => _makeRGBChalk(46, 139, 87, bg: true);

  /// set foreground color to X11/CSS color seashell <span style='background-color: seashell;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFF5EE)/rgb(255, 245, 238)
  Chalk get seashell => _makeRGBChalk(255, 245, 238);

  /// set background color to X11/CSS color seashell <span style='background-color: seashell;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFF5EE)/rgb(255, 245, 238)
  Chalk get onSeashell => _makeRGBChalk(255, 245, 238, bg: true);

  /// set foreground color to X11/CSS color sienna <span style='background-color: sienna;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xA0522D)/rgb(160, 82, 45)
  Chalk get sienna => _makeRGBChalk(160, 82, 45);

  /// set background color to X11/CSS color sienna <span style='background-color: sienna;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xA0522D)/rgb(160, 82, 45)
  Chalk get onSienna => _makeRGBChalk(160, 82, 45, bg: true);

  /// set foreground color to X11/CSS color silver <span style='background-color: silver;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xC0C0C0)/rgb(192, 192, 192)
  Chalk get silver => _makeRGBChalk(192, 192, 192);

  /// set background color to X11/CSS color silver <span style='background-color: silver;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xC0C0C0)/rgb(192, 192, 192)
  Chalk get onSilver => _makeRGBChalk(192, 192, 192, bg: true);

  /// set foreground color to X11/CSS color skyBlue <span style='background-color: skyblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x87CEEB)/rgb(135, 206, 235)
  Chalk get skyBlue => _makeRGBChalk(135, 206, 235);

  /// set background color to X11/CSS color skyBlue <span style='background-color: skyblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x87CEEB)/rgb(135, 206, 235)
  Chalk get onSkyBlue => _makeRGBChalk(135, 206, 235, bg: true);

  /// set foreground color to X11/CSS color slateBlue <span style='background-color: slateblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x6A5ACD)/rgb(106, 90, 205)
  Chalk get slateBlue => _makeRGBChalk(106, 90, 205);

  /// set background color to X11/CSS color slateBlue <span style='background-color: slateblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x6A5ACD)/rgb(106, 90, 205)
  Chalk get onSlateBlue => _makeRGBChalk(106, 90, 205, bg: true);

  /// set foreground color to X11/CSS color slateGray <span style='background-color: slategray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x708090)/rgb(112, 128, 144)
  Chalk get slateGray => _makeRGBChalk(112, 128, 144);

  /// set background color to X11/CSS color slateGray <span style='background-color: slategray;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x708090)/rgb(112, 128, 144)
  Chalk get onSlateGray => _makeRGBChalk(112, 128, 144, bg: true);

  /// set foreground color to X11/CSS color slateGrey <span style='background-color: slategrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x708090)/rgb(112, 128, 144)
  Chalk get slateGrey => _makeRGBChalk(112, 128, 144);

  /// set background color to X11/CSS color slateGrey <span style='background-color: slategrey;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x708090)/rgb(112, 128, 144)
  Chalk get onSlateGrey => _makeRGBChalk(112, 128, 144, bg: true);

  /// set foreground color to X11/CSS color snow <span style='background-color: snow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFAFA)/rgb(255, 250, 250)
  Chalk get snow => _makeRGBChalk(255, 250, 250);

  /// set background color to X11/CSS color snow <span style='background-color: snow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFAFA)/rgb(255, 250, 250)
  Chalk get onSnow => _makeRGBChalk(255, 250, 250, bg: true);

  /// set foreground color to X11/CSS color springGreen <span style='background-color: springgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FF7F)/rgb(0, 255, 127)
  Chalk get springGreen => _makeRGBChalk(0, 255, 127);

  /// set background color to X11/CSS color springGreen <span style='background-color: springgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x00FF7F)/rgb(0, 255, 127)
  Chalk get onSpringGreen => _makeRGBChalk(0, 255, 127, bg: true);

  /// set foreground color to X11/CSS color steelBlue <span style='background-color: steelblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x4682B4)/rgb(70, 130, 180)
  Chalk get steelBlue => _makeRGBChalk(70, 130, 180);

  /// set background color to X11/CSS color steelBlue <span style='background-color: steelblue;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x4682B4)/rgb(70, 130, 180)
  Chalk get onSteelBlue => _makeRGBChalk(70, 130, 180, bg: true);

  /// set foreground color to X11/CSS color tan <span style='background-color: tan;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD2B48C)/rgb(210, 180, 140)
  Chalk get tan => _makeRGBChalk(210, 180, 140);

  /// set background color to X11/CSS color tan <span style='background-color: tan;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD2B48C)/rgb(210, 180, 140)
  Chalk get onTan => _makeRGBChalk(210, 180, 140, bg: true);

  /// set foreground color to X11/CSS color teal <span style='background-color: teal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x008080)/rgb(0, 128, 128)
  Chalk get teal => _makeRGBChalk(0, 128, 128);

  /// set background color to X11/CSS color teal <span style='background-color: teal;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x008080)/rgb(0, 128, 128)
  Chalk get onTeal => _makeRGBChalk(0, 128, 128, bg: true);

  /// set foreground color to X11/CSS color thistle <span style='background-color: thistle;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD8BFD8)/rgb(216, 191, 216)
  Chalk get thistle => _makeRGBChalk(216, 191, 216);

  /// set background color to X11/CSS color thistle <span style='background-color: thistle;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xD8BFD8)/rgb(216, 191, 216)
  Chalk get onThistle => _makeRGBChalk(216, 191, 216, bg: true);

  /// set foreground color to X11/CSS color tomato <span style='background-color: tomato;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF6347)/rgb(255, 99, 71)
  Chalk get tomato => _makeRGBChalk(255, 99, 71);

  /// set background color to X11/CSS color tomato <span style='background-color: tomato;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFF6347)/rgb(255, 99, 71)
  Chalk get onTomato => _makeRGBChalk(255, 99, 71, bg: true);

  /// set foreground color to X11/CSS color turquoise <span style='background-color: turquoise;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x40E0D0)/rgb(64, 224, 208)
  Chalk get turquoise => _makeRGBChalk(64, 224, 208);

  /// set background color to X11/CSS color turquoise <span style='background-color: turquoise;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x40E0D0)/rgb(64, 224, 208)
  Chalk get onTurquoise => _makeRGBChalk(64, 224, 208, bg: true);

  /// set foreground color to X11/CSS color violet <span style='background-color: violet;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xEE82EE)/rgb(238, 130, 238)
  Chalk get violet => _makeRGBChalk(238, 130, 238);

  /// set background color to X11/CSS color violet <span style='background-color: violet;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xEE82EE)/rgb(238, 130, 238)
  Chalk get onViolet => _makeRGBChalk(238, 130, 238, bg: true);

  /// set foreground color to X11/CSS color wheat <span style='background-color: wheat;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF5DEB3)/rgb(245, 222, 179)
  Chalk get wheat => _makeRGBChalk(245, 222, 179);

  /// set background color to X11/CSS color wheat <span style='background-color: wheat;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF5DEB3)/rgb(245, 222, 179)
  Chalk get onWheat => _makeRGBChalk(245, 222, 179, bg: true);

  /// set foreground color to X11/CSS color whiteX11 <span style='background-color: white;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFFFF)/rgb(255, 255, 255)
  Chalk get whiteX11 => _makeRGBChalk(255, 255, 255);

  /// set background color to X11/CSS color whiteX11 <span style='background-color: white;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFFFF)/rgb(255, 255, 255)
  Chalk get onWhiteX11 => _makeRGBChalk(255, 255, 255, bg: true);

  /// set foreground color to X11/CSS color whiteSmoke <span style='background-color: whitesmoke;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF5F5F5)/rgb(245, 245, 245)
  Chalk get whiteSmoke => _makeRGBChalk(245, 245, 245);

  /// set background color to X11/CSS color whiteSmoke <span style='background-color: whitesmoke;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xF5F5F5)/rgb(245, 245, 245)
  Chalk get onWhiteSmoke => _makeRGBChalk(245, 245, 245, bg: true);

  /// set foreground color to X11/CSS color yellowX11 <span style='background-color: yellow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFF00)/rgb(255, 255, 0)
  Chalk get yellowX11 => _makeRGBChalk(255, 255, 0);

  /// set background color to X11/CSS color yellowX11 <span style='background-color: yellow;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0xFFFF00)/rgb(255, 255, 0)
  Chalk get onYellowX11 => _makeRGBChalk(255, 255, 0, bg: true);

  /// set foreground color to X11/CSS color yellowGreen <span style='background-color: yellowgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x9ACD32)/rgb(154, 205, 50)
  Chalk get yellowGreen => _makeRGBChalk(154, 205, 50);

  /// set background color to X11/CSS color yellowGreen <span style='background-color: yellowgreen;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x9ACD32)/rgb(154, 205, 50)
  Chalk get onYellowGreen => _makeRGBChalk(154, 205, 50, bg: true);

  // END GENERATED CODE - DO NOT MODIFY BY HAND - generating code => /examples/makeX11EntryPoints.dart
}

  /// global instance of chalk used for base call.
/// this can be set to a specific Chalk instance that would then serve as basis for all calls
Chalk chalk = Chalk();

/// This is a paragraph of regular text.
///
/// This sentence has *two* _emphasized_ words (italics) and **two**
/// __strong__ ones (bold).
///
/// A blank line creates a separate paragraph. It has some `inline code`
/// delimited using backticks.
///
/// * Unordered lists.
/// * Look like ASCII bullet lists.
/// * You can also use `-` or `+`.
///
/// 1. Numbered lists.
/// 2. Are, well, numbered.
/// 1. But the values don't matter.
///
///     * You can nest lists too.
///     * They must be indented at least 4 spaces.
///     * (Well, 5 including the space after `///`.)
///
/// Code blocks are fenced in triple backticks:
///
/// ```dart
/// this.code
///     .will
///     .retain(its, formatting);
/// ```
///
/// The code language (for syntax highlighting) defaults to Dart. You can
/// specify it by putting the name of the language after the opening backticks:
///
/// ```html
/// <h1>HTML is magical!</h1>
/// ```
///
/// Links can be:
///
/// * https://www.just-a-bare-url.com
/// * [with the URL inline](https://google.com)
/// * [or separated out][ref link]
///
/// [ref link]: https://google.com
///
/// # A Header
///
/// ## A subheader
///
/// ### A subsubheader
///
/// #### If you need this many levels of headers, you're doing it wrong
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
      returnValue += string.substring(endIndex, index) +
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
              endIndex, (gotCR ? index - 1 : index) ) +
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
