// Copyright (c) 2020-2022, tim maffett.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'ansiutils.dart';
import 'colorutils.dart';

/// Chalk - A Library for printing styled text to the console using ANSI
/// control sequences.
/// Documentation of the ANSI code system:
///    https://en.wikipedia.org/wiki/ANSI_escape_code .
/// References with detailed explainations of the various color models
/// included here:
///    https://en.wikipedia.org/wiki/HSL_and_HSV and
///    https://en.wikipedia.org/wiki/HWB_color_model
/// The complete history of the X11 color names (later used in css/svg also)
///    https://en.wikipedia.org/wiki/X11_color_names .
class Chalk {
  /// ANSI Color level support for terminal - default to 3 (full color) because
  /// IntelliJ/AndroidStudio and VSCode report NOT having full color support
  /// despite supporting level 3.  This is really only here for flexibility.
  static int ansiColorLevelForNewInstances = 3;

  /// This offset can be added to the basic 0-15 ansi color numbers to get background
  /// versions of those colors.
  static const int ansiBackgroundOffset = 10;

  /// This offset can be added to the basic 0-15 ansi color numbers to get underline
  /// versions of those colors.
  static const int ansiUnderlineOffset = 20;

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
    return (int code) => '\u001B[${38 + offset};5;${code}m';
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
  static final String Function(int) _bgAnsi256 =
      _wrapAnsi256(ansiBackgroundOffset);
  static final String Function(int, int, int) _bgAnsi16m =
      _wrapAnsi16m(ansiBackgroundOffset);
  static final String Function(int) _underlineAnsi256 =
      _wrapAnsi256(ansiUnderlineOffset);
  static final String Function(int, int, int) _underlineAnsi16m =
      _wrapAnsi16m(ansiUnderlineOffset);

  Chalk? _parent;
  String _open = '';
  String _close = '';
  String _openAll = '';
  String _closeAll = '';

  /// ANSI Color level support for this chalk instance - this will effect what colors
  /// this chalk instance can use.
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
  String toStringWalkUp({int level = 0}) {
    String thisOne =
        "[$level] Chalk(open:'${_open.replaceAll('\u001B', 'ESC')}',close:'${_close.replaceAll('\u001B', 'ESC')}')";
    if (level == 0) {
      thisOne +=
          "[$level] ALL Chalk(open:'${_openAll.replaceAll('\u001B', 'ESC')}',close:'${_closeAll.replaceAll('\u001B', 'ESC')}')";
    }
    String parentStr = '';
    if (_parent != null) {
      level++;
      parentStr = _parent!.toStringWalkUp(level: level);
    }
    return parentStr + thisOne;
  }

  /// Use to create a new 'root' instance of Chalk, with the option of setting
  /// the ANSI color level (root instances start with no style).
  static Chalk instance({int level = -1}) {
    final instance = Chalk._internal(null, hasStyle: false);
    if (level != -1) {
      instance.level = level;
    }
    return instance;
  }

  // This is alias for [instance()] for users coming from javascript syntax.
  // ignore: non_constant_identifier_names
  static Chalk Instance({int level = -1}) {
    return instance(level: level);
  }

  /// Factory function typically used for creating new 'root' instances of Chalk
  /// (root instances start with no style)
  factory Chalk() {
    return Chalk._internal(null, hasStyle: false);
  }

  /// private internal Chalk() constructor
  Chalk._internal(Chalk? parent, {bool hasStyle = true}) {
    _parent = parent;
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

  Chalk makeRGBChalk(num nred, num ngreen, num nblue,
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
    return makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// Returns a Chalk with the background color set to the passed in RGB Hex code.
  /// This dynamically accepts color hex codes as integer codes (0xAABBCC) or (0xABC)
  /// or as strings ('#AABBCC') or ('#ABC')
  Chalk onHex(dynamic hex) {
    var rgb = ColorUtils.hex2rgb(hex);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onHex() (provided for legacy compatibility with JS Chalk).
  Chalk bgHex(dynamic hex) => onHex(hex);

  /// Returns a Chalk with the foreground color set to the color represented by the
  /// passed in color keyword.
  /// This accepts all of the standard X11/CSS/SVG color names, and the user can extend the list
  /// of accepted color keywords using the addColorKeywordRgb() and addColorKeywordHex() methods
  Chalk keyword(String colorKeyword) {
    var rgb = ColorUtils.rgbFromKeyword(colorKeyword);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// Returns a Chalk with the background color set to the color represented by the
  /// passed in color keyword.
  /// This accepts all of the standard X11/CSS/SVG color names, and the user can extend the list
  /// of accepted color keywords using the addColorKeywordRgb() and addColorKeywordHex() methods
  Chalk onKeyword(String colorKeyword) {
    var rgb = ColorUtils.rgbFromKeyword(colorKeyword);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onKeyword() (provided for legacy compatibility with JS Chalk).
  Chalk bgKeyword(String keyword) => onKeyword(keyword);

  /// Create Chalk with a foreground color with the specified RGB values.
  Chalk rgb(num red, num green, num blue) => makeRGBChalk(red, green, blue);

  /// Create Chalk with a background color with the specified RGB values.
  Chalk onRgb(num red, num green, num blue) =>
      makeRGBChalk(red, green, blue, bg: true);

  /// Alternate name for onRgb() (provided for legacy compatibility with JS Chalk).
  Chalk bgRgb(num red, num green, num blue) => onRgb(red, green, blue);

  /// Create Chalk with a foreground color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3).
  Chalk rgb16m(num red, num green, num blue) =>
      makeRGBChalk(red, green, blue, force16M: true);

  /// Create Chalk with a background color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3).
  Chalk onRgb16m(num red, num green, num blue) =>
      makeRGBChalk(red, green, blue, bg: true, force16M: true);

  /// Alternate name for onRgb16m() (provided for legacy compatibility with JS Chalk).
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

  /// Creates chalk with foreground color defined from HSL (Hue, Saturation
  /// and Lightness) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  Chalk hsl(num hue, num saturation, num lightness) {
    var rgb = ColorUtils.hsl2rgb(hue, saturation, lightness);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// Creates chalk with background color defined from HSL (Hue, Saturation
  /// and Lightness) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  Chalk onHsl(num hue, num saturation, num lightness) {
    var rgb = ColorUtils.hslTorgb(hue, saturation, lightness);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onHsl() (provided for legacy compatibility with JS Chalk)
  Chalk bgHsl(num hue, num saturation, num lightness) =>
      onHsl(hue, saturation, lightness);

  /// Creates chalk with foreground color defined from HSV (Hue, Saturation
  /// and Value) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  Chalk hsv(num hue, num saturation, num value) {
    var rgb = ColorUtils.hsv2rgb(hue, saturation, value);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// Creates chalk with background color defined from HSV (Hue, Saturation
  /// and Value) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  Chalk onHsv(num hue, num saturation, num value) {
    var rgb = ColorUtils.hsv2rgb(hue, saturation, value);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onHsv() (provided for legacy compatibility with JS Chalk)
  Chalk bgHsv(num hue, num saturation, num value) =>
      onHsv(hue, saturation, value);

  /// Creates chalk with foreground color defined from HWB (Hue, Whiteness
  /// and Blackness) color space parameters.
  /// https://en.wikipedia.org/wiki/HWB_color_model
  Chalk hwb(num hue, num whiteness, num blackness) {
    var rgb = ColorUtils.hwbTorgb(hue, whiteness, blackness);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// Creates chalk with background color defined from HWB (Hue, Whiteness
  /// and Blackness) color space parameters.
  /// https://en.wikipedia.org/wiki/HWB_color_model
  Chalk onHwb(num hue, num whiteness, num blackness) {
    var rgb = ColorUtils.hwb2rgb(hue, whiteness, blackness);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onHwb() (provided for legacy compatibility with JS Chalk)
  Chalk bgHwb(num hue, num whiteness, num blackness) =>
      onHwb(hue, whiteness, blackness);

  /// Creates chalk with foreground color defined from
  /// XYZ color space parameters.
  /// https://en.wikipedia.org/wiki/CIE_1931_color_space
  Chalk xyz(num x, num y, num z) {
    var rgb = ColorUtils.xyz2rgb(x, y, z);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// Creates chalk with background color defined from
  /// XYZ color space parameters.
  /// https://en.wikipedia.org/wiki/CIE_1931_color_space
  Chalk onXyz(num x, num y, num z) {
    var rgb = ColorUtils.xyz2rgb(x, y, z);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onXyz() (provided for legacy compatibility with JS Chalk)
  Chalk bgXyz(num x, num y, num z) => onXyz(x, y, z);

  /// Creates chalk with foreground color defined from
  /// lab color space parameters.
  /// https://en.wikipedia.org/wiki/CIELAB_color_space#CIELAB
  Chalk lab(num l, num a, num b) {
    var xyz = ColorUtils.lab2xyz(l, a, b);
    var rgb = ColorUtils.xyz2rgb(xyz[0], xyz[1], xyz[2]);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2]);
  }

  /// Creates chalk with background color defined from
  /// lab color space parameters.
  /// https://en.wikipedia.org/wiki/CIELAB_color_space#CIELAB
  Chalk onLab(num l, num a, num b) {
    var xyz = ColorUtils.lab2xyz(l, a, b);
    var rgb = ColorUtils.xyz2rgb(xyz[0], xyz[1], xyz[2]);
    return makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: true);
  }

  /// Alternate name for onLab() (provided for legacy compatibility with JS Chalk)
  Chalk bgLab(num l, num a, num b) => onLab(l, a, b);

  /// Creates chalk with the foreground color specified by
  /// the ansi color escape code.
  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  Chalk ansi(int ansicode) => _makeAnsiChalk(ansicode);

  /// Creates chalk with the background color specified by
  /// the ansi color escape code.
  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  Chalk onAnsi(int ansicode) => _makeAnsiChalk(ansicode, true);

  /// Alternate name for onAnsi() (provided for legacy compatibility with JS Chalk)
  Chalk bgAnsi(int ansicode) => onAnsi(ansicode);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  Chalk ansiSgr(dynamic openCode, dynamic closeCode) {
    // We use _ansiSGRModiferOpen() for both because we dont want
    // useFullResetToClose to affect THESE USER specified open/close SGR's
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

  /// Legacy api, provided only for backwards compatability, use onBlack.
  Chalk get bgBlack => onBlack;

  Chalk get onRed => _createStyler(_ansiSGRModiferOpen(41), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onRed.
  Chalk get bgRed => onRed;

  Chalk get onGreen =>
      _createStyler(_ansiSGRModiferOpen(42), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onGreen.
  Chalk get bgGreen => onGreen;

  Chalk get onYellow =>
      _createStyler(_ansiSGRModiferOpen(43), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onYellow.
  Chalk get bgYellow => onYellow;

  Chalk get onBlue =>
      _createStyler(_ansiSGRModiferOpen(44), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onBlue.
  Chalk get bgBlue => onBlue;

  Chalk get onMagenta =>
      _createStyler(_ansiSGRModiferOpen(45), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onMagenta.
  Chalk get bgMagenta => onMagenta;

  Chalk get onCyan =>
      _createStyler(_ansiSGRModiferOpen(46), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onCyan.
  Chalk get bgCyan => onCyan;

  Chalk get onWhite =>
      _createStyler(_ansiSGRModiferOpen(47), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onWhite.
  Chalk get bgWhite => onWhite;

  Chalk get onBrightBlack =>
      _createStyler(_ansiSGRModiferOpen(100), _ansiBgClose, this);

  Chalk get onGray => onBrightBlack;

  Chalk get onGrey => onBrightBlack;

  /// Legacy api, provided only for backwards compatability, use onBrightBlack.
  Chalk get bgBrightBlack => onBrightBlack;

  /// Legacy api, provided only for backwards compatability, use onBrightBlack.
  Chalk get bgBlackBright => onBrightBlack;

  /// Legacy api, provided only for backwards compatability, use onGray.
  Chalk get bgGray => onBrightBlack;

  /// Legacy api, provided only for backwards compatability, use onGrey.
  Chalk get bgGrey => onBrightBlack;

  Chalk get onBrightRed =>
      _createStyler(_ansiSGRModiferOpen(101), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onBrightRed.
  Chalk get bgBrightRed => onBrightRed;

  /// Legacy api, provided only for backwards compatability, use onBrightRed.
  Chalk get bgRedBright => onBrightRed;

  Chalk get onBrightGreen =>
      _createStyler(_ansiSGRModiferOpen(102), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onBrightGreen.
  Chalk get bgBrightGreen => onBrightGreen;

  /// Legacy api, provided only for backwards compatability, use onBrightGreen.
  Chalk get bgGreenBright => onBrightGreen;

  Chalk get onBrightYellow =>
      _createStyler(_ansiSGRModiferOpen(103), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onBrightYellow.
  Chalk get bgBrightYellow => onBrightYellow;

  /// Legacy api, provided only for backwards compatability, use onBrightYellow.
  Chalk get bgYellowBright => onBrightYellow;

  Chalk get onBrightBlue =>
      _createStyler(_ansiSGRModiferOpen(104), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onBrightBlue.
  Chalk get bgBrightBlue => onBrightBlue;

  /// Legacy api, provided only for backwards compatability, use onBrightBlue.
  Chalk get bgBlueBright => onBrightBlue;

  Chalk get onBrightMagenta =>
      _createStyler(_ansiSGRModiferOpen(105), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onBrightMagenta.
  Chalk get bgBrightMagenta => onBrightMagenta;

  /// Legacy api, provided only for backwards compatability, use onBrightMagenta.
  Chalk get bgMagentaBright => onBrightMagenta;

  Chalk get onBrightCyan =>
      _createStyler(_ansiSGRModiferOpen(106), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onBrightCyan.
  Chalk get bgBrightCyan => onBrightCyan;

  /// Legacy api, provided only for backwards compatability, use onBrightCyan.
  Chalk get bgCyanBright => onBrightCyan;

  Chalk get onBrightWhite =>
      _createStyler(_ansiSGRModiferOpen(107), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatability, use onBrightWhite.
  Chalk get bgBrightWhite => onBrightWhite;

  /// Legacy api, provided only for backwards compatability, use onBrightWhite.
  Chalk get bgWhiteBright => onBrightWhite;

  ///reset - Resets the current color chain.
  Chalk get reset =>
      _createStyler(_ansiSGRModiferOpen(0), _ansiSGRModiferClose(0), this);

  /// normal - Text with all attributes off
  Chalk get normal =>
      _createStyler(_ansiSGRModiferOpen(0), _ansiSGRModiferClose(0), this);

  /// bold - Make text bold.
  Chalk get bold =>
      _createStyler(_ansiSGRModiferOpen(1), _ansiSGRModiferClose(22), this);

  /// dim - Emitting only a small amount of light.
  Chalk get dim =>
      _createStyler(_ansiSGRModiferOpen(2), _ansiSGRModiferClose(22), this);

  /// italic - Make text italic. (VSCode debug console supports,some other terminals)
  Chalk get italic =>
      _createStyler(_ansiSGRModiferOpen(3), _ansiSGRModiferClose(23), this);

  /// underline - Make text underline. (Not widely supported)
  Chalk get underline =>
      _createStyler(_ansiSGRModiferOpen(4), _ansiSGRModiferClose(24), this);

  Chalk get underlined => underline;

  /// doubleunderline - Make text double underlined. (Not widely supported)
  Chalk get doubleunderline =>
      _createStyler(_ansiSGRModiferOpen(21), _ansiSGRModiferClose(24), this);

  Chalk get doubleunderlined => doubleunderline;

  /// doubleUnderline - alternate for doubleunderline
  Chalk get doubleUnderline => doubleunderline;

  /// overline - Make text overlined. (Not widely supported)
  Chalk get overline =>
      _createStyler(_ansiSGRModiferOpen(53), _ansiSGRModiferClose(55), this);

  Chalk get overlined => overline;

  /// blink - Make text blink. (Not widely supported)
  Chalk get blink =>
      _createStyler(_ansiSGRModiferOpen(5), _ansiSGRModiferClose(25), this);

  /// rapidblink - Make text blink rapidly (>150 times per minute). (Not widely supported)
  Chalk get rapidblink =>
      _createStyler(_ansiSGRModiferOpen(6), _ansiSGRModiferClose(25), this);

  /// inverse- Inverse background and foreground colors.
  Chalk get inverse =>
      _createStyler(_ansiSGRModiferOpen(7), _ansiSGRModiferClose(27), this);

  /// invert- alternate for inverse() - Inverse background and foreground colors.
  Chalk get invert => inverse;

  /// hidden - Prints the text, but makes it invisible. (still copy and pasteable)
  Chalk get hidden =>
      _createStyler(_ansiSGRModiferOpen(8), _ansiSGRModiferClose(28), this);

  /// strikethrough - Puts a horizontal line through the center of the text. (Not widely supported)
  Chalk get strikethrough =>
      _createStyler(_ansiSGRModiferOpen(9), _ansiSGRModiferClose(29), this);

  /// superscript - Superscript text. (Not widely supported)
  Chalk get superscript =>
      _createStyler(_ansiSGRModiferOpen(73), _ansiSGRModiferClose(75), this);

  /// subscript - Subscript text. (Not widely supported)
  Chalk get subscript =>
      _createStyler(_ansiSGRModiferOpen(74), _ansiSGRModiferClose(75), this);

  /// Alternative font 1. (Not widely supported)
  Chalk get font1 =>
      _createStyler(_ansiSGRModiferOpen(11), _ansiSGRModiferClose(10), this);

  /// Alternative font 2. (Not widely supported)
  Chalk get font2 =>
      _createStyler(_ansiSGRModiferOpen(12), _ansiSGRModiferClose(10), this);

  ///Alternative font 3. (Not widely supported)
  Chalk get font3 =>
      _createStyler(_ansiSGRModiferOpen(13), _ansiSGRModiferClose(10), this);

  /// Alternative font 4. (Not widely supported)
  Chalk get font4 =>
      _createStyler(_ansiSGRModiferOpen(14), _ansiSGRModiferClose(10), this);

  /// Alternative font 5. (Not widely supported)
  Chalk get font5 =>
      _createStyler(_ansiSGRModiferOpen(15), _ansiSGRModiferClose(10), this);

  /// Alternative font 6. (Not widely supported)
  Chalk get font6 =>
      _createStyler(_ansiSGRModiferOpen(16), _ansiSGRModiferClose(10), this);

  /// Alternative font 7. (Not widely supported)
  Chalk get font7 =>
      _createStyler(_ansiSGRModiferOpen(17), _ansiSGRModiferClose(10), this);

  /// Alternative font 8. (Not widely supported)
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

  /// Wrap this chalk with specified prefix and suffix strings.
  Chalk wrap(String prefix, String suffix) {
    var chalk = _createStyler(prefix, suffix, this);
    chalk._hasStyle = false;
    return chalk;
  }

  /// visible - Prints the text only when Chalk has a color level > 0. Can be useful for things that are purely cosmetic.
  Chalk get visible {
    // look at color Level and print ONLY IF >0
    var ck = _createStyler('', '', this);
    ck._chalkVisibleModifier = true;
    return ck;
  }

  /// Follow this method with any standard CSS/SVG/X11 color name (remove spaces from name)
  /// The case/capitalizatiom of the color name is not important.
  /// color returns chalk as 'dynamic' so that CSS/SVG/X11 color names can 'dynamically' be
  /// accessed as virtual methods.
  /// ie.  `chalk.color.cornflowerblue('works like this')`
  ///   (this is the equivalent of `chalk.keyword('cornflowerblue')('same things using keyword()'`)
  dynamic get color {
    var chalk = _createStyler('', '', this);
    chalk._hasStyle = false;
    return chalk;
  }

  /// Follow this method with any standard CSS/SVG/X11 color name (remove spaces from name)
  /// The case/capitalizatiom of the color name is not important.
  /// alias for [color] - alternate method name to use for to get dynamic for virtual color methods
  /// ie.  `chalk.csscolor.cornflowerblue('works like this')`
  ///   (this is the equivalent of `chalk.keyword('cornflowerblue')('same things using keyword()'`)
  dynamic get csscolor => color;

  /// Follow this method with any standard CSS/SVG/X11 color name (remove spaces from name)
  /// The case/capitalizatiom of the color name is not important.
  /// alias for [color] - alternate method name to use for to get dynamic for virtual color methods
  /// ie.  `chalk.x11.cornflowerblue('works like this')`
  ///   (this is the equivalent of `chalk.keyword('cornflowerblue')('same things using keyword()'`)
  dynamic get x11 => color;

  /// Specify string to use for joining multiple arguments or Lists.
  /// Default is ' ' (single space).
  Chalk joinWith(String joinWith) {
    var chalk = _createStyler('', '', this);
    chalk._hasStyle = false;
    chalk._joinString = joinWith;
    return chalk;
  }

  /// Strip all ANSI SGR commands from the target string and return the 'stripped'
  /// result string.
  String strip(String target) {
    return AnsiUtils.stripAnsi(target);
  }

  // This method handles turning all the dynamic items in the list to strings,
  // and recurses if it finds Lists.
  String _fixList(List<dynamic> dynlist) {
    var outlist = List<String>.filled(dynlist.length, '');
    for (var i = 0; i < dynlist.length; i++) {
      outlist[i] = _fixArg(dynlist[i]);
    }
    return outlist.join(_joinString);
  }

  /// Handles turning all the dynamic items in the list to strings, and
  /// recurses if it finds Lists.  It handles List<>, Iterable types and
  /// Function closures.
  String _fixArg(dynamic dynarg) {
    var resstr = 'null';
    if (dynarg != null) {
      if (dynarg is List) {
        resstr = _fixList(dynarg);
      } else if (dynarg is Function) {
        dynamic funres = dynarg.call();
        resstr = (funres != null) ? funres.toString() : 'null';
      } else if (dynarg is Iterable) {
        resstr = _fixList(dynarg.toList());
      } else if (dynarg != null) {
        resstr = dynarg.toString();
      }
    }
    return resstr;
  }

  /// Handles the generic Chalk(....) calls with up to 15 arguements that can
  /// be a mixtured of pretty much anything.  List<> and Function closures are handled
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
      dynamic arg10,
      dynamic arg11,
      dynamic arg12,
      dynamic arg13,
      dynamic arg14,
      dynamic arg15]) {
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
        if (arg10 != null) _fixArg(arg11),
        if (arg10 != null) _fixArg(arg12),
        if (arg10 != null) _fixArg(arg13),
        if (arg10 != null) _fixArg(arg14),
        if (arg10 != null) _fixArg(arg15),
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
        arg0 = _StringUtils.stringReplaceAll(arg0, styler._close, styler._open);

        styler = styler._parent;
      }
    }

    // We can move both next actions out of loop, because remaining actions in loop won't have
    // any/visible effect on parts we add here. Close the styling before a linebreak and reopen
    // after next line to fix a bleed issue on macOS: https://github.com/chalk/chalk/pull/92
    var lfIndex = arg0.indexOf('\n');
    if (lfIndex != -1) {
      arg0 = _StringUtils.stringEncaseCRLFWithFirstIndex(
          arg0, _closeAll, _openAll, lfIndex);
    }

    return _openAll + arg0 + _closeAll;
  }

  /// This noSuchMethod() handler is called for all unknown methods called
  /// on our Chalk object. Thisd allows using user defined colors and x11
  /// colors as 'pseudo' methods.
  /// dynamic chalk2 = Chalk();
  /// print(chalk2.orange('Yay for red on yellow colored text!'));
  /// print(chalk.csscolor.lightskyblue('Yay for lightskyblue colored text!'));
  /// Background:
  /// https://github.com/dart-lang/sdk/blob/master/docs/language/informal/nosuchmethod-forwarding.md
  ///   Good stuff.
  @override
  dynamic noSuchMethod(Invocation invocation) {
    // memberName will toString() like 'Symbol("orange")', so just get the name
    // out of it
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

    Chalk thisColor = makeRGBChalk(rgb[0], rgb[1], rgb[2], bg: backgroundColor);

    if (invocation.positionalArguments.isNotEmpty) {
      // Send all the args in and chalk them up like a other normal methods
      // would with call().
      return thisColor.call(invocation.positionalArguments);
    } else {
      // Just return the chalk we just made.
      return thisColor;
    }
  }

  /// Add RGB color to the colorKeywords[] map that is used for dynamic lookup of colors by name.
  /// Colors added thid way can be used directly following the Chalk color/csscolor/x11 methods.
  /// ie.
  ///      Chalk.addColorKeywordRgb('myfavorite', 0x64, 0x95, 0xED );
  ///      chalk.color.myfavorite('This is my favorite color');
  static void addColorKeywordRgb(
      String colorname, int red, int green, int blue) {
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
}

/// This _StringUtils class handles heavy lifting for Chalk() on string
/// it's custom operations.
class _StringUtils {
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
      returnValue += string.substring(endIndex, index) + substring + replacer;
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
      bool gotCR = (index >= 1) && (string[index - 1] == '\r');
      returnValue += string.substring(endIndex, (gotCR ? index - 1 : index)) +
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
