// Copyright (c) 2020-2022, tim maffett.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'chalk.dart';

/// Extensions on the String class that allow you to use the Chalk methods
/// directly on Strings, ie.
///    'This will be red italic'.red.italic
///    'This will be red on yellow background'.red.onYellow
/// 
extension ChalkString on String {
  static final Chalk _chalk = Chalk();

  String get black => _chalk.black(this);

  String get red => _chalk.red(this);
  String get green => _chalk.green(this);
  String get yellow => _chalk.yellow(this);
  String get blue => _chalk.blue(this);
  String get magenta => _chalk.magenta(this);
  String get cyan => _chalk.cyan(this);
  String get white => _chalk.white(this);

  String get brightBlack => _chalk.brightBlack(this);
  String get blackBright => _chalk.blackBright(this);
  String get gray => _chalk.gray(this);
  String get grey => _chalk.grey(this);
  String get brightRed => _chalk.brightRed(this);
  String get redBright => _chalk.redBright(this);
  String get brightGreen => _chalk.brightGreen(this);
  String get greenBright => _chalk.greenBright(this);
  String get brightYellow => _chalk.brightYellow(this);
  String get yellowBright => _chalk.yellowBright(this);
  String get brightBlue => _chalk.brightBlue(this);
  String get blueBright => _chalk.blueBright(this);
  String get brightMagenta => _chalk.brightMagenta(this);
  String get magentaBright => _chalk.magentaBright(this);
  String get brightCyan => _chalk.brightCyan(this);
  String get cyanBright => _chalk.cyanBright(this);
  String get brightWhite => _chalk.brightWhite(this);
  String get whiteBright => _chalk.whiteBright(this);
  String get onBlack => _chalk.onBlack(this);
  String get bgBlack => _chalk.bgBlack(this);
  String get onRed => _chalk.onRed(this);
  String get bgRed => _chalk.bgRed(this);
  String get onGreen => _chalk.onGreen(this);
  String get bgGreen => _chalk.bgGreen(this);
  String get onYellow => _chalk.onYellow(this);
  String get bgYellow => _chalk.bgYellow(this);
  String get onBlue => _chalk.onBlue(this);
  String get bgBlue => _chalk.bgBlue(this);
  String get onMagenta => _chalk.onMagenta(this);
  String get bgMagenta => _chalk.bgMagenta(this);
  String get onCyan => _chalk.onCyan(this);
  String get bgCyan => _chalk.bgCyan(this);
  String get onWhite => _chalk.onWhite(this);
  String get bgWhite => _chalk.bgWhite(this);
  String get onBrightBlack => _chalk.onBrightBlack(this);
  String get onGray => _chalk.onGray(this);
  String get onGrey => _chalk.onGrey(this);
  String get bgBrightBlack => _chalk.bgBrightBlack(this);
  String get bgBlackBright => _chalk.bgBlackBright(this);
  String get bgGray => _chalk.bgGray(this);
  String get bgGrey => _chalk.bgGrey(this);
  String get onBrightRed => _chalk.onBrightRed(this);
  String get bgBrightRed => _chalk.bgBrightRed(this);
  String get bgRedBright => _chalk.bgBrightRed(this);
  String get onBrightGreen => _chalk.onBrightGreen(this);
  String get bgBrightGreen => _chalk.bgBrightGreen(this);
  String get bgGreenBright => _chalk.bgGreenBright(this);
  String get onBrightYellow => _chalk.onBrightYellow(this);
  String get bgBrightYellow => _chalk.bgBrightYellow(this);
  String get bgYellowBright => _chalk.bgYellowBright(this);
  String get onBrightBlue => _chalk.onBrightBlue(this);
  String get bgBrightBlue => _chalk.bgBrightBlue(this);
  String get bgBlueBright => _chalk.bgBlueBright(this);
  String get onBrightMagenta => _chalk.onBrightMagenta(this);
  String get bgBrightMagenta => _chalk.bgBrightMagenta(this);
  String get bgMagentaBright => _chalk.bgMagentaBright(this);
  String get onBrightCyan => _chalk.onBrightCyan(this);
  String get bgBrightCyan => _chalk.bgBrightCyan(this);
  String get bgCyanBright => _chalk.bgCyanBright(this);
  String get onBrightWhite => _chalk.onBrightWhite(this);
  String get bgBrightWhite => _chalk.bgBrightWhite(this);
  String get bgWhiteBright => _chalk.bgWhiteBright(this);
  String get reset => _chalk.reset(this);
  String get normal => _chalk.normal(this);
  String get bold => _chalk.bold(this);
  String get dim => _chalk.dim(this);
  String get italic => _chalk.italic(this);
  String get underline => _chalk.underline(this);
  String get underlined => _chalk.underlined(this);
  String get doubleunderline => _chalk.doubleunderline(this);
  String get doubleunderlined => _chalk.doubleunderlined(this);
  String get doubleUnderline => _chalk.doubleUnderline(this);
  String get overline => _chalk.overline(this);
  String get overlined => _chalk.overlined(this);
  String get blink => _chalk.blink(this);
  String get rapidblink => _chalk.rapidblink(this);
  String get inverse => _chalk.inverse(this);
  String get invert => _chalk.invert(this);
  String get hidden => _chalk.hidden(this);
  String get strikethrough => _chalk.strikethrough(this);
  String get superscript => _chalk.superscript(this);
  String get subscript => _chalk.subscript(this);
  String get font1 => _chalk.font1(this);
  String get font2 => _chalk.font2(this);
  String get font3 => _chalk.font3(this);
  String get font4 => _chalk.font4(this);
  String get font5 => _chalk.font5(this);
  String get font6 => _chalk.font6(this);
  String get font7 => _chalk.font7(this);
  String get font8 => _chalk.font8(this);
  String get font9 => _chalk.font9(this);
  String get font10 => _chalk.font10(this);
  String get blackletter => _chalk.blackletter(this);
  String get visible => _chalk.visible(this);
  String get strip => _chalk.strip(this);

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
  String onKeyword(String colorKeyword) => (_chalk.onKeyword(colorKeyword))(this);

  /// Alternate name for onKeyword() (provided for legacy compatibility with JS Chalk).
  String bgKeyword(String colorKeyword) => (_chalk.bgKeyword(colorKeyword))(this);

  /// Create String with a foreground color with the specified RGB values.
  String rgb(num red, num green, num blue) => (_chalk.rgb(red, green, blue))(this);

  /// Create String with a background color with the specified RGB values.
  String onRgb(num red, num green, num blue) => (_chalk.onRgb(red, green, blue))(this);

  /// Alternate name for onRgb() (provided for legacy compatibility with JS Chalk).
  String bgRgb(num red, num green, num blue) => (_chalk.onRgb(red, green, blue))(this);

  /// Create String with a foreground color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3).
  String rgb16m(num red, num green, num blue) => (_chalk.rgb16m(red, green, blue))(this);

  /// Create String with a background color with the specified RGB values
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3).
  String onRgb16m(num red, num green, num blue) => (_chalk.onRgb16m(red, green, blue))(this);

  /// Alternate name for onRgb16m() (provided for legacy compatibility with JS Chalk).
  String bgRgb16m(num red, num green, num blue) => (_chalk.onRgb16m(red, green, blue))(this);

  /// Create String with an underline of the the specified RGB color
  /// WARNING: on some consoles without support for this, such as Android Studio,
  /// using this will prevent ALL styles of the Chalk from appearing
  String underlineRgb(num red, num green, num blue) => (_chalk.underlineRgb(red, green, blue))(this);

  /// Create String with an underline of the the specified RGB color
  /// (forces using ANSI 16m SGR codes, even if [level] is not 3)
  /// WARNING: on some consoles without support for this, such as Android Studio,
  /// using this will prevent ALL styles of the Chalk from appearing
  String underlineRgb16m(num red, num green, num blue) => (_chalk.underlineRgb16m(red, green, blue))(this);

  /// Creates String with foreground color defined from HSL (Hue, Saturation
  /// and Lightness) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String hsl(num hue, num saturation, num lightness) => (_chalk.hsl(hue, saturation, lightness))(this);

  /// Creates String with background color defined from HSL (Hue, Saturation
  /// and Lightness) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String onHsl(num hue, num saturation, num lightness) => (_chalk.onHsl(hue, saturation, lightness))(this);

  /// Alternate name for onHsl() (provided for legacy compatibility with JS Chalk)
  String bgHsl(num hue, num saturation, num lightness) => (_chalk.onHsl(hue, saturation, lightness))(this);

  /// Creates String with foreground color defined from HSV (Hue, Saturation
  /// and Value) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String hsv(num hue, num saturation, num value) => (_chalk.hsv(hue, saturation, value))(this);

  /// Creates chalk with background color defined from HSV (Hue, Saturation
  /// and Value) color space parameters.
  /// https://en.wikipedia.org/wiki/HSL_and_HSV
  String onHsv(num hue, num saturation, num value) => (_chalk.onHsv(hue, saturation, value))(this);

  /// Alternate name for onHsv() (provided for legacy compatibility with JS Chalk)
  String bgHsv(num hue, num saturation, num value) => (_chalk.onHsv(hue, saturation, value))(this);

  /// Creates String with foreground color defined from HWB (Hue, Whiteness
  /// and Blackness) color space parameters.
  /// https://en.wikipedia.org/wiki/HWB_color_model
  String hwb(num hue, num whiteness, num blackness) => (_chalk.hwb(hue, whiteness, blackness))(this);

  /// Creates String with background color defined from HWB (Hue, Whiteness
  /// and Blackness) color space parameters.
  /// https://en.wikipedia.org/wiki/HWB_color_model
  String onHwb(num hue, num whiteness, num blackness) => (_chalk.onHwb(hue, whiteness, blackness))(this);

  /// Alternate name for onHwb() (provided for legacy compatibility with JS Chalk)
  String bgHwb(num hue, num whiteness, num blackness) => (_chalk.onHwb(hue, whiteness, blackness))(this);

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
  String ansiSgr(dynamic openCode, dynamic closeCode) => (_chalk.ansiSgr(openCode,closeCode))(this);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String ansi256(int ansicode256) => (_chalk.ansi256(ansicode256))(this);

  /// https://en.wikipedia.org/wiki/ANSI_escape_code
  String onAnsi256(int ansicode256) => (_chalk.onAnsi256(ansicode256))(this);

  /// Alternate name for onAnsi256() (provided for legacy compatibility with JS Chalk)
  String bgAnsi256(int ansicode256) => (_chalk.onAnsi256(ansicode256))(this);

  String greyscale(num greyscale) =>  (_chalk.greyscale(greyscale))(this);

  String onGreyscale(num greyscale) => (_chalk.onGreyscale(greyscale))(this);

  /// Alternate name for onGreyscale() (provided for legacy compatibility with JS Chalk)
  String bgGreyscale(num greyscale) => (_chalk.onGreyscale(greyscale))(this);

 /// Wrap this chalk with specified prefix and suffix strings.
  String wrap(String prefix, String suffix) => (_chalk.wrap(prefix,suffix))(this);
}