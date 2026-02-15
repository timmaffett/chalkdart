// Copyright (c) 2020-2025, tim maffett.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'chalk.dart';
import 'chalkstrings_x11.g.dart';

/// Extensions on the String class that allow you to use the Chalk methods
/// directly on Strings, ie.
///    'This will be red italic'.red.italic
///    'This will be red on yellow background'.red.onYellow
///
extension ChalkString on String {
  static Chalk _chalk = Chalk();

  // Cached Chalk instances for string extension getters.
  // Initialized lazily on first use, cleared on reInitialize.

  // Foreground colors
  static Chalk? _cBlack, _cRed, _cGreen, _cYellow, _cBlue, _cMagenta, _cCyan, _cWhite;
  static Chalk? _cBrightBlack, _cBlackBright, _cGray, _cGrey;
  static Chalk? _cBrightRed, _cRedBright, _cBrightGreen, _cGreenBright;
  static Chalk? _cBrightYellow, _cYellowBright, _cBrightBlue, _cBlueBright;
  static Chalk? _cBrightMagenta, _cMagentaBright, _cBrightCyan, _cCyanBright;
  static Chalk? _cBrightWhite, _cWhiteBright;

  // Background colors
  static Chalk? _cOnBlack, _cBgBlack, _cOnRed, _cBgRed;
  static Chalk? _cOnGreen, _cBgGreen, _cOnYellow, _cBgYellow;
  static Chalk? _cOnBlue, _cBgBlue, _cOnMagenta, _cBgMagenta;
  static Chalk? _cOnCyan, _cBgCyan, _cOnWhite, _cBgWhite;
  static Chalk? _cOnBrightBlack, _cOnGray, _cOnGrey;
  static Chalk? _cBgBrightBlack, _cBgBlackBright, _cBgGray, _cBgGrey;
  static Chalk? _cOnBrightRed, _cBgBrightRed, _cBgRedBright;
  static Chalk? _cOnBrightGreen, _cBgBrightGreen, _cBgGreenBright;
  static Chalk? _cOnBrightYellow, _cBgBrightYellow, _cBgYellowBright;
  static Chalk? _cOnBrightBlue, _cBgBrightBlue, _cBgBlueBright;
  static Chalk? _cOnBrightMagenta, _cBgBrightMagenta, _cBgMagentaBright;
  static Chalk? _cOnBrightCyan, _cBgBrightCyan, _cBgCyanBright;
  static Chalk? _cOnBrightWhite, _cBgBrightWhite, _cBgWhiteBright;

  // Modifiers
  static Chalk? _cReset, _cNormal, _cBold, _cDim, _cItalic;
  static Chalk? _cUnderline, _cUnderlined, _cDoubleunderline, _cDoubleunderlined, _cDoubleUnderline;
  static Chalk? _cOverline, _cOverlined, _cBlink, _cRapidblink;
  static Chalk? _cInverse, _cInvert, _cHidden, _cStrikethrough;
  static Chalk? _cSuperscript, _cSubscript;
  static Chalk? _cFont1, _cFont2, _cFont3, _cFont4, _cFont5;
  static Chalk? _cFont6, _cFont7, _cFont8, _cFont9, _cFont10;
  static Chalk? _cBlackletter, _cVisible;

  // Reinitialize the chalk instance. This is useful if you want to change the output mode to html
  static void reInitializeChalkStringExtensionChalkInstance() {
    _chalk = Chalk();
    // Invalidate all cached Chalk instances
    _cBlack = _cRed = _cGreen = _cYellow = _cBlue = _cMagenta = _cCyan = _cWhite = null;
    _cBrightBlack = _cBlackBright = _cGray = _cGrey = null;
    _cBrightRed = _cRedBright = _cBrightGreen = _cGreenBright = null;
    _cBrightYellow = _cYellowBright = _cBrightBlue = _cBlueBright = null;
    _cBrightMagenta = _cMagentaBright = _cBrightCyan = _cCyanBright = null;
    _cBrightWhite = _cWhiteBright = null;
    _cOnBlack = _cBgBlack = _cOnRed = _cBgRed = null;
    _cOnGreen = _cBgGreen = _cOnYellow = _cBgYellow = null;
    _cOnBlue = _cBgBlue = _cOnMagenta = _cBgMagenta = null;
    _cOnCyan = _cBgCyan = _cOnWhite = _cBgWhite = null;
    _cOnBrightBlack = _cOnGray = _cOnGrey = null;
    _cBgBrightBlack = _cBgBlackBright = _cBgGray = _cBgGrey = null;
    _cOnBrightRed = _cBgBrightRed = _cBgRedBright = null;
    _cOnBrightGreen = _cBgBrightGreen = _cBgGreenBright = null;
    _cOnBrightYellow = _cBgBrightYellow = _cBgYellowBright = null;
    _cOnBrightBlue = _cBgBrightBlue = _cBgBlueBright = null;
    _cOnBrightMagenta = _cBgBrightMagenta = _cBgMagentaBright = null;
    _cOnBrightCyan = _cBgBrightCyan = _cBgCyanBright = null;
    _cOnBrightWhite = _cBgBrightWhite = _cBgWhiteBright = null;
    _cReset = _cNormal = _cBold = _cDim = _cItalic = null;
    _cUnderline = _cUnderlined = _cDoubleunderline = _cDoubleunderlined = _cDoubleUnderline = null;
    _cOverline = _cOverlined = _cBlink = _cRapidblink = null;
    _cInverse = _cInvert = _cHidden = _cStrikethrough = null;
    _cSuperscript = _cSubscript = null;
    _cFont1 = _cFont2 = _cFont3 = _cFont4 = _cFont5 = null;
    _cFont6 = _cFont7 = _cFont8 = _cFont9 = _cFont10 = null;
    _cBlackletter = _cVisible = null;
    // Invalidate X11 color cache
    ChalkX11Strings.resetCache();
  }

  /// Set foreground base 16 xterm colors black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get black => (_cBlack ??= _chalk.black)(this);

  /// Set foreground base 16 xterm colors red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get red => (_cRed ??= _chalk.red)(this);

  /// Set foreground base 16 xterm colors green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get green => (_cGreen ??= _chalk.green)(this);

  /// Set foreground base 16 xterm colors yellow
  /// (terminal dependent)![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get yellow => (_cYellow ??= _chalk.yellow)(this);

  /// Set foreground base 16 xterm colors blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get blue => (_cBlue ??= _chalk.blue)(this);

  /// Set foreground base 16 xterm colors magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get magenta => (_cMagenta ??= _chalk.magenta)(this);

  /// Set foreground base 16 xterm colors cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get cyan => (_cCyan ??= _chalk.cyan)(this);

  /// Set foreground base 16 xterm colors white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get white => (_cWhite ??= _chalk.white)(this);

  /// Set foreground base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightBlack => (_cBrightBlack ??= _chalk.brightBlack)(this);

  /// Set foreground base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get blackBright => (_cBlackBright ??= _chalk.blackBright)(this);

  /// Set foreground base 16 xterm colors gray  (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get gray => (_cGray ??= _chalk.gray)(this);

  /// Set foreground base 16 xterm colors grey (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get grey => (_cGrey ??= _chalk.grey)(this);

  /// Set foreground base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightRed => (_cBrightRed ??= _chalk.brightRed)(this);

  /// Set foreground base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get redBright => (_cRedBright ??= _chalk.redBright)(this);

  /// Set foreground base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightGreen => (_cBrightGreen ??= _chalk.brightGreen)(this);

  /// Set foreground base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get greenBright => (_cGreenBright ??= _chalk.greenBright)(this);

  /// Set foreground base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightYellow => (_cBrightYellow ??= _chalk.brightYellow)(this);

  /// Set foreground base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get yellowBright => (_cYellowBright ??= _chalk.yellowBright)(this);

  /// Set foreground base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightBlue => (_cBrightBlue ??= _chalk.brightBlue)(this);

  /// Set foreground base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get blueBright => (_cBlueBright ??= _chalk.blueBright)(this);

  /// Set foreground base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightMagenta => (_cBrightMagenta ??= _chalk.brightMagenta)(this);

  /// Set foreground base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get magentaBright => (_cMagentaBright ??= _chalk.magentaBright)(this);

  /// Set foreground base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightCyan => (_cBrightCyan ??= _chalk.brightCyan)(this);

  /// Set foreground base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get cyanBright => (_cCyanBright ??= _chalk.cyanBright)(this);

  /// Set foreground base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get brightWhite => (_cBrightWhite ??= _chalk.brightWhite)(this);

  /// Set foreground base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get whiteBright => (_cWhiteBright ??= _chalk.whiteBright)(this);

  /// Set background base 16 xterm colors black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBlack => (_cOnBlack ??= _chalk.onBlack)(this);

  /// Legacy api, provided only for backwards compatibility, use onBlack.
  /// Set background base 16 xterm colors black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBlack => (_cBgBlack ??= _chalk.bgBlack)(this);

  /// Set background base 16 xterm colors red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onRed => (_cOnRed ??= _chalk.onRed)(this);

  /// Legacy api, provided only for backwards compatibility, use onRed.
  /// Set background base 16 xterm colors red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgRed => (_cBgRed ??= _chalk.bgRed)(this);

  /// Set background base 16 xterm colors green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onGreen => (_cOnGreen ??= _chalk.onGreen)(this);

  /// Legacy api, provided only for backwards compatibility, use onGreen.
  /// Set background base 16 xterm colors green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgGreen => (_cBgGreen ??= _chalk.bgGreen)(this);

  /// Set background base 16 xterm colors yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onYellow => (_cOnYellow ??= _chalk.onYellow)(this);

  /// Legacy api, provided only for backwards compatibility, use onYellow.
  /// Set background base 16 xterm colors yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgYellow => (_cBgYellow ??= _chalk.bgYellow)(this);

  /// Set background base 16 xterm colors blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBlue => (_cOnBlue ??= _chalk.onBlue)(this);

  /// Legacy api, provided only for backwards compatibility, use onBlue.
  /// Set background base 16 xterm colors blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBlue => (_cBgBlue ??= _chalk.bgBlue)(this);

  /// Set background base 16 xterm colors magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onMagenta => (_cOnMagenta ??= _chalk.onMagenta)(this);

  /// Legacy api, provided only for backwards compatibility, use onMagenta.
  /// Set background base 16 xterm colors magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgMagenta => (_cBgMagenta ??= _chalk.bgMagenta)(this);

  /// Set background base 16 xterm colors cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onCyan => (_cOnCyan ??= _chalk.onCyan)(this);

  /// Legacy api, provided only for backwards compatibility, use onCyan.
  /// Set background base 16 xterm colors cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgCyan => (_cBgCyan ??= _chalk.bgCyan)(this);

  /// Set background base 16 xterm colors white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onWhite => (_cOnWhite ??= _chalk.onWhite)(this);

  /// Legacy api, provided only for backwards compatibility, use onWhite.
  /// Set background base 16 xterm colors white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgWhite => (_cBgWhite ??= _chalk.bgWhite)(this);

  /// Set background base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightBlack => (_cOnBrightBlack ??= _chalk.onBrightBlack)(this);

  /// Set background base 16 xterm colors gray (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onGray => (_cOnGray ??= _chalk.onGray)(this);

  /// Set background base 16 xterm colors grey (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onGrey => (_cOnGrey ??= _chalk.onGrey)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightBlack.
  /// Set background base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightBlack => (_cBgBrightBlack ??= _chalk.bgBrightBlack)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightBlack.
  /// Set background base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBlackBright => (_cBgBlackBright ??= _chalk.bgBlackBright)(this);

  /// Legacy api, provided only for backwards compatibility, use onGray.
  /// Set background base 16 xterm colors gray (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgGray => (_cBgGray ??= _chalk.bgGray)(this);

  /// Legacy api, provided only for backwards compatibility, use onGrey.
  /// Set background base 16 xterm colors grey (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgGrey => (_cBgGrey ??= _chalk.bgGrey)(this);

  /// Set background base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightRed => (_cOnBrightRed ??= _chalk.onBrightRed)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightRed.
  /// Set background base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightRed => (_cBgBrightRed ??= _chalk.bgBrightRed)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightRed.
  /// Set background base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgRedBright => (_cBgRedBright ??= _chalk.bgBrightRed)(this);

  /// Set background base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightGreen => (_cOnBrightGreen ??= _chalk.onBrightGreen)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightGreen.
  /// Set background base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightGreen => (_cBgBrightGreen ??= _chalk.bgBrightGreen)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightGreen.
  /// Set background base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgGreenBright => (_cBgGreenBright ??= _chalk.bgGreenBright)(this);

  /// Set background base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightYellow => (_cOnBrightYellow ??= _chalk.onBrightYellow)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightYellow.
  /// Set background base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightYellow => (_cBgBrightYellow ??= _chalk.bgBrightYellow)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightYellow.
  /// Set background base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgYellowBright => (_cBgYellowBright ??= _chalk.bgYellowBright)(this);

  /// Set background base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightBlue => (_cOnBrightBlue ??= _chalk.onBrightBlue)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightBlue.
  /// Set background base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightBlue => (_cBgBrightBlue ??= _chalk.bgBrightBlue)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightBlue.
  /// Set background base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBlueBright => (_cBgBlueBright ??= _chalk.bgBlueBright)(this);

  /// Set background base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightMagenta => (_cOnBrightMagenta ??= _chalk.onBrightMagenta)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightMagenta.
  /// Set background base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightMagenta => (_cBgBrightMagenta ??= _chalk.bgBrightMagenta)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightMagenta.
  /// Set background base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgMagentaBright => (_cBgMagentaBright ??= _chalk.bgMagentaBright)(this);

  /// Set background base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightCyan => (_cOnBrightCyan ??= _chalk.onBrightCyan)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightCyan.
  /// Set background base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightCyan => (_cBgBrightCyan ??= _chalk.bgBrightCyan)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightCyan.
  /// Set background base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgCyanBright => (_cBgCyanBright ??= _chalk.bgCyanBright)(this);

  /// Set background base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get onBrightWhite => (_cOnBrightWhite ??= _chalk.onBrightWhite)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightWhite.
  /// Set background base 16 xterm colors bright white
  /// (terminal dependent)  ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgBrightWhite => (_cBgBrightWhite ??= _chalk.bgBrightWhite)(this);

  /// Legacy api, provided only for backwards compatibility, use onBrightWhite.
  /// Set background base 16 xterm colors bright white
  /// (terminal dependent)  ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  String get bgWhiteBright => (_cBgWhiteBright ??= _chalk.bgWhiteBright)(this);

  ///reset - Resets the current color chain.
  String get reset => (_cReset ??= _chalk.reset)(this);

  /// normal - Text with all attributes off
  String get normal => (_cNormal ??= _chalk.normal)(this);

  /// bold - Make text bold.
  String get bold => (_cBold ??= _chalk.bold)(this);

  /// dim - Emitting only a small amount of light.
  String get dim => (_cDim ??= _chalk.dim)(this);

  /// italic - Make text italic. (VSCode debug console supports,some other terminals)
  String get italic => (_cItalic ??= _chalk.italic)(this);

  /// underline - Make text underline. (Not as widely supported, supported in VSCode through my PR)
  String get underline => (_cUnderline ??= _chalk.underline)(this);

  /// underlined (alternate name for underline) - Make text underline. (Not as widely supported, supported in VSCode through my PR)
  String get underlined => (_cUnderlined ??= _chalk.underlined)(this);

  /// doubleunderline - Make text double underlined. (Not as widely supported, supported in VSCode through my PR)
  String get doubleunderline => (_cDoubleunderline ??= _chalk.doubleunderline)(this);

  /// doubleunderlined (alternate name for doubleunderline) - Make text double underlined. (Not as widely supported, supported in VSCode through my PR)
  String get doubleunderlined => (_cDoubleunderlined ??= _chalk.doubleunderlined)(this);

  /// doubleUnderline (alternate name for doubleunderline) - alternate for doubleunderline
  String get doubleUnderline => (_cDoubleUnderline ??= _chalk.doubleUnderline)(this);

  /// overline - Make text overlined. (Not as widely supported, supported in VSCode through my PR)
  String get overline => (_cOverline ??= _chalk.overline)(this);

  /// overlined (alternate name for overline) - Make text overlined. (Not as widely supported, supported in VSCode through my PR)
  String get overlined => (_cOverlined ??= _chalk.overlined)(this);

  /// blink - Make text blink. (Not as widely supported, supported in VSCode through my PR)
  String get blink => (_cBlink ??= _chalk.blink)(this);

  /// rapidblink - Make text blink rapidly (>150 times per minute). (Not as widely supported, supported in VSCode through my PR)
  String get rapidblink => (_cRapidblink ??= _chalk.rapidblink)(this);

  /// inverse- Inverse background and foreground colors.
  String get inverse => (_cInverse ??= _chalk.inverse)(this);

  /// invert- alternate for inverse() - Inverse background and foreground colors.
  String get invert => (_cInvert ??= _chalk.invert)(this);

  /// hidden - Prints the text, but makes it invisible. (still copy and pasteable)
  String get hidden => (_cHidden ??= _chalk.hidden)(this);
  String get strikethrough => (_cStrikethrough ??= _chalk.strikethrough)(this);

  /// superscript - Superscript text. (Not as widely supported, supported in VSCode through my PR)
  String get superscript => (_cSuperscript ??= _chalk.superscript)(this);

  /// subscript - Subscript text. (Not as widely supported, supported in VSCode through my PR)
  String get subscript => (_cSubscript ??= _chalk.subscript)(this);

  /// Alternative font 1. (Not as widely supported, supported in VSCode through my PR)
  String get font1 => (_cFont1 ??= _chalk.font1)(this);

  /// Alternative font 2. (Not as widely supported, supported in VSCode through my PR)
  String get font2 => (_cFont2 ??= _chalk.font2)(this);

  ///Alternative font 3. (Not as widely supported, supported in VSCode through my PR)
  String get font3 => (_cFont3 ??= _chalk.font3)(this);

  /// Alternative font 4. (Not as widely supported, supported in VSCode through my PR)
  String get font4 => (_cFont4 ??= _chalk.font4)(this);

  /// Alternative font 5. (Not as widely supported, supported in VSCode through my PR)
  String get font5 => (_cFont5 ??= _chalk.font5)(this);

  /// Alternative font 6. (Not as widely supported, supported in VSCode through my PR)
  String get font6 => (_cFont6 ??= _chalk.font6)(this);

  /// Alternative font 7. (Not as widely supported, supported in VSCode through my PR)
  String get font7 => (_cFont7 ??= _chalk.font7)(this);

  /// Alternative font 8. (Not as widely supported, supported in VSCode through my PR)
  String get font8 => (_cFont8 ??= _chalk.font8)(this);

  /// Alternative font 9. (Not as widely supported, supported in VSCode through my PR)
  String get font9 => (_cFont9 ??= _chalk.font9)(this);

  /// Alternative font 10. (Not as widely supported, supported in VSCode through my PR)
  String get font10 => (_cFont10 ??= _chalk.font10)(this);

  /// blackletter - alternate name for font10, ANSI/ECMA-48 spec refers to font10 specifically as a blackletter or Fraktur (Gothic) font.
  /// (Not as widely supported, supported in VSCode through my PR)
  String get blackletter => (_cBlackletter ??= _chalk.blackletter)(this);

  /// visible - Prints the text only when Chalk has a color level > 0. Can be useful for things that are purely cosmetic.
  String get visible => (_cVisible ??= _chalk.visible)(this);

  /// Strips any HTML strings present from the string and returns the result
  String get stripHtmlTags => _chalk.stripHtmlTags(this);

  /// Strip all ANSI SGR commands from the target string and return the 'stripped'
  /// result string.
  /// NOTE:  If HTML mode is activated then this strips all HMTL tags from the input string
  String get strip => _chalk.strip(this);

  /// Replaces and < or > characters found within the string the &lt; and &gt;
  /// so that text is safe for html rendering.
  /// NOTE: When using HTML mode this must be the FIRST method called before
  /// any styling calls so that any HTML created for styling is rendered
  /// invalid by the entity conversion.
  /// ie.
  /// OK:  `'my string with < and > '.safeHtml.red.onWhite;`
  /// versus
  ///      `'my string with < and > '.red.onWhite.safeHtml;`
  /// (The second version will have no styling and instead show all of the html tags
  /// inserted for styling).
  String get htmlSafeGtLt => Chalk.htmlSafeGtLt(this);

  /// Replaces ANY special character that HTML needs a entity for in order to  renderered
  /// correctly.
  String get htmlSafeEntities => Chalk.htmlSafeEntities(this);

  /// Converts all spaces (outside of html tags) in the string with the
  /// html entity `&nbsp;`
  /// This can be useful to preserve spacing when rendering the string in a
  /// browser where all spacing would otherwise be collapsed.
  String get htmlSafeSpaces => Chalk.htmlSafeSpaces(this);

  /// Returns a String with the foreground color set to the passed in RGB Hex code.
  /// This dynamically accepts color hex codes as integer codes (0xAABBCC) or (0xABC)
  /// or as strings ('#AABBCC') or ('#ABC')
  String hex(dynamic hex) => (_chalk.hex(hex))(this);

  /// Returns a String with the background color set to the passed in RGB Hex code.
  /// This dynamically accepts color hex codes as integer codes (0xAABBCC) or (0xABC)
  /// or as strings ('#AABBCC') or ('#ABC')
  String onHex(dynamic hex) => (_chalk.onHex(hex))(this);

  /// Alternate name for onHex() (provided for legacy compatibility with JS Chalk).
  String bgHex(dynamic hex) => (_chalk.onHex(hex))(this);

  /// Returns a String with the foreground color set to the color represented by the
  /// passed in color keyword.
  /// This accepts all of the standard X11/CSS/SVG color names, and the user can extend the list
  /// of accepted color keywords using the addColorKeywordRgb() and addColorKeywordHex() methods
  String keyword(String colorKeyword) => (_chalk.keyword(colorKeyword))(this);

  /// Returns a String with the background color set to the color represented by the
  /// passed in color keyword.
  /// This accepts all of the standard X11/CSS/SVG color names, and the user can extend the list
  /// of accepted color keywords using the addColorKeywordRgb() and addColorKeywordHex() methods
  String onKeyword(String colorKeyword) =>
      (_chalk.onKeyword(colorKeyword))(this);

  /// Alternate name for onKeyword() (provided for legacy compatibility with JS Chalk).
  String bgKeyword(String colorKeyword) =>
      (_chalk.bgKeyword(colorKeyword))(this);

  /// Create String with a foreground color with the specified RGB values.
  String rgb(num red, num green, num blue) =>
      (_chalk.rgb(red, green, blue))(this);

  /// Create String with a background color with the specified RGB values.
  String onRgb(num red, num green, num blue) =>
      (_chalk.onRgb(red, green, blue))(this);

  /// Alternate name for onRgb() (provided for legacy compatibility with JS Chalk).
  String bgRgb(num red, num green, num blue) =>
      (_chalk.onRgb(red, green, blue))(this);

  /// Create String with a foreground color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3).
  String rgb16m(num red, num green, num blue) =>
      (_chalk.rgb16m(red, green, blue))(this);

  /// Create String with a background color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3).
  String onRgb16m(num red, num green, num blue) =>
      (_chalk.onRgb16m(red, green, blue))(this);

  /// Alternate name for onRgb16m() (provided for legacy compatibility with JS Chalk).
  String bgRgb16m(num red, num green, num blue) =>
      (_chalk.onRgb16m(red, green, blue))(this);

  /// Create String with an underline of the the specified RGB color
  /// WARNING: on some consoles without support for this, such as Android Studio,
  /// using this will prevent ALL styles of the Chalk from appearing
  String underlineRgb(num red, num green, num blue) =>
      (_chalk.underlineRgb(red, green, blue))(this);

  /// Create String with an underline of the the specified RGB color
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3)
  /// WARNING: on some consoles without support for this, such as Android Studio,
  /// using this will prevent ALL styles of the Chalk from appearing
  String underlineRgb16m(num red, num green, num blue) =>
      (_chalk.underlineRgb16m(red, green, blue))(this);

  /// Creates String with foreground color defined from HSL (Hue, Saturation
  /// and Lightness) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String hsl(num hue, num saturation, num lightness) =>
      (_chalk.hsl(hue, saturation, lightness))(this);

  /// Creates String with background color defined from HSL (Hue, Saturation
  /// and Lightness) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String onHsl(num hue, num saturation, num lightness) =>
      (_chalk.onHsl(hue, saturation, lightness))(this);

  /// Alternate name for onHsl() (provided for legacy compatibility with JS Chalk)
  String bgHsl(num hue, num saturation, num lightness) =>
      (_chalk.onHsl(hue, saturation, lightness))(this);

  /// Creates String with foreground color defined from HSV (Hue, Saturation
  /// and Value) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String hsv(num hue, num saturation, num value) =>
      (_chalk.hsv(hue, saturation, value))(this);

  /// Creates chalk with background color defined from HSV (Hue, Saturation
  /// and Value) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String onHsv(num hue, num saturation, num value) =>
      (_chalk.onHsv(hue, saturation, value))(this);

  /// Alternate name for onHsv() (provided for legacy compatibility with JS Chalk)
  String bgHsv(num hue, num saturation, num value) =>
      (_chalk.onHsv(hue, saturation, value))(this);

  /// Creates String with foreground color defined from HWB (Hue, Whiteness
  /// and Blackness) color space parameters.
  /// https://en.wikipedia.org/wiki/HWB_color_model
  String hwb(num hue, num whiteness, num blackness) =>
      (_chalk.hwb(hue, whiteness, blackness))(this);

  /// Creates String with background color defined from HWB (Hue, Whiteness
  /// and Blackness) color space parameters.
  /// https://en.wikipedia.org/wiki/HWB_color_model
  String onHwb(num hue, num whiteness, num blackness) =>
      (_chalk.onHwb(hue, whiteness, blackness))(this);

  /// Alternate name for onHwb() (provided for legacy compatibility with JS Chalk)
  String bgHwb(num hue, num whiteness, num blackness) =>
      (_chalk.onHwb(hue, whiteness, blackness))(this);

  /// Creates String with foreground color defined from
  /// XYZ color space parameters.
  /// https://en.wikipedia.org/wiki/CIE_1931_color_space
  String xyz(num x, num y, num z) => (_chalk.xyz(x, y, z))(this);

  /// Creates String with background color defined from
  /// XYZ color space parameters.
  /// https://en.wikipedia.org/wiki/CIE_1931_color_space
  String onXyz(num x, num y, num z) => (_chalk.onXyz(x, y, z))(this);

  /// Alternate name for onXyz() (provided for legacy compatibility with JS Chalk)
  String bgXyz(num x, num y, num z) => (_chalk.onXyz(x, y, z))(this);

  /// Creates String with foreground color defined from
  /// lab color space parameters.
  /// https://en.wikipedia.org/wiki/CIELAB_color_space#CIELAB
  String lab(num l, num a, num b) => (_chalk.lab(l, a, b))(this);

  /// Creates String with background color defined from
  /// lab color space parameters.
  /// https://en.wikipedia.org/wiki/CIELAB_color_space#CIELAB
  String onLab(num l, num a, num b) => (_chalk.onLab(l, a, b))(this);

  /// Alternate name for onLab() (provided for legacy compatibility with JS Chalk)
  String bgLab(num l, num a, num b) => onLab(l, a, b);

  /// Creates String with the foreground color specified by
  /// the ansi color escape code.
  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String ansi(int ansicode) => (_chalk.ansi(ansicode))(this);

  /// Creates String with the background color specified by
  /// the ansi color escape code.
  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String onAnsi(int ansicode) => (_chalk.onAnsi(ansicode))(this);

  /// Alternate name for onAnsi() (provided for legacy compatibility with JS Chalk)
  String bgAnsi(int ansicode) => (_chalk.onAnsi(ansicode))(this);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String ansiSgr(dynamic openCode, dynamic closeCode) =>
      (_chalk.ansiSgr(openCode, closeCode))(this);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String ansi256(int ansicode256) => (_chalk.ansi256(ansicode256))(this);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String onAnsi256(int ansicode256) => (_chalk.onAnsi256(ansicode256))(this);

  /// Alternate name for onAnsi256() (provided for legacy compatibility with JS Chalk)
  String bgAnsi256(int ansicode256) => (_chalk.onAnsi256(ansicode256))(this);

  String greyscale(num greyscale) => (_chalk.greyscale(greyscale))(this);

  String onGreyscale(num greyscale) => (_chalk.onGreyscale(greyscale))(this);

  /// Alternate name for onGreyscale() (provided for legacy compatibility with JS Chalk)
  String bgGreyscale(num greyscale) => (_chalk.onGreyscale(greyscale))(this);

  /// Wrap this chalk with specified prefix and suffix strings.
  String wrap(String prefix, String suffix) =>
      (_chalk.wrap(prefix, suffix))(this);
}


 // Reinitialize the chalk instance. Called when changing the default output mode
void reInitializeChalkStringExtensionChalkInstance() {
  ChalkString.reInitializeChalkStringExtensionChalkInstance();
}
