// Copyright (c) 2020-2022, tim maffett.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

/// This ColorUtils library contains the color space conversion methods
/// used by the Chalk class to support alternate colors spaces from
/// RGB.  An attempt is made to be as versitle in input parameters as possible,
/// many routines accept floating point numbers from 0.0-1.0 (for percentages)
/// or alternately integers from 0-255.
/// References with detailed explainations of the various color models included here
///    https://en.wikipedia.org/wiki/HSL_and_HSV
///    https://en.wikipedia.org/wiki/HWB_color_model
/// Complete history of the X11 color names :
///    https://en.wikipedia.org/wiki/X11_color_names
/// and CSS color names (derived from X11 color names):
///    https://www.w3.org/wiki/CSS/Properties/color/keywords
/// Many of these routines are based on work by Heather Arthur and javascript code
/// that I have ported to dart from:
///    https://github.com/Qix-/color-convert/blob/master/conversions.js
///
class ColorUtils {
  static int rgbToAnsi256(int red, int green, int blue) {
    // We use the extended greyscale palette here, with the exception of
    // black and white. normal palette only has 4 greyscale shades.
    if (red == green && green == blue) {
      if (red < 8) {
        return 16;
      }

      if (red > 248) {
        return 231;
      }

      return (((red - 8) / 247) * 24).round() + 232;
    }

    return 16 +
        (36 * (red / 255 * 5).round()) +
        (6 * (green / 255 * 5).round()) +
        (blue / 255 * 5).round();
  }

  static List<int> hsl2rgb(num hue, num saturation, num lightness) {
    if (saturation <= 1 && lightness <= 1) {
      // if both <=1 we assume that are 0-1 range, NOTE that means if REALLT want (0.01 s then you need to pass it like that and not as 1 in to 100 scale)
      saturation *= 100;
      lightness *= 100;
    }
    hue = hue / 360;
    saturation = saturation / 100;
    lightness = lightness / 100;
    num t2;
    num t3;
    num val;

    if (saturation == 0) {
      final iVal = (lightness * 255).round();
      return [iVal, iVal, iVal];
    }

    if (lightness < 0.5) {
      t2 = lightness * (1 + saturation);
    } else {
      t2 = lightness + saturation - lightness * saturation;
    }

    var t1 = 2 * lightness - t2;

    final rgb = [0, 0, 0];
    for (var i = 0; i < 3; i++) {
      t3 = hue + 1 / 3 * -(i - 1);
      if (t3 < 0) {
        t3++;
      }

      if (t3 > 1) {
        t3--;
      }

      if (6 * t3 < 1) {
        val = t1 + (t2 - t1) * 6 * t3;
      } else if (2 * t3 < 1) {
        val = t2;
      } else if (3 * t3 < 2) {
        val = t1 + (t2 - t1) * (2 / 3 - t3) * 6;
      } else {
        val = t1;
      }

      rgb[i] = (val * 255).round();
    }

    return rgb;
  }

  // Alternate hsl algorithm from  http://dev.w3.org/csswg/css-color/#hwb-to-rgb
  static List<int> hslTorgb(num hue, num sat, num light) {
    List<double> rgb1 = hslToRgb1Scale(hue, sat, light);
    return [
      (rgb1[0] * 255).round(),
      (rgb1[1] * 255).round(),
      (rgb1[2] * 255).round()
    ];
  }

  // Alternate hsl algorithm from  http://dev.w3.org/csswg/css-color/#hwb-to-rgb
  static List<double> hslToRgb1Scale(num hue, num sat, num light) {
    hue = hue % 360;

    if (hue < 0) {
      hue += 360;
    }

    sat /= 100;
    light /= 100;

    double f(num n) {
      num k = (n + hue / 30) % 12;
      num a = sat * min(light, 1 - light);
      return (light - a * max(-1, min(k - 3.0, min(9.0 - k, 1.0))));
    }

    return [f(0), f(8), f(4)];
  }

  static List<int> hsv2rgb(num hue, num saturation, num valueBrightness) {
    if (saturation <= 1 && valueBrightness <= 1) {
      // if both <=1 we assume that are 0-1 range, NOTE that means if REALLT want (0.01 s then you need to pass it like that and not as 1 in to 100 scale)
      saturation *= 100;
      valueBrightness *= 100;
    }
    hue = hue / 60;
    saturation = saturation / 100;
    valueBrightness = valueBrightness / 100;
    var hi = hue.floor() % 6;

    var f = hue - hue.floor();
    int p = (255 * valueBrightness * (1 - saturation)).round();
    int q = (255 * valueBrightness * (1 - (saturation * f))).round();
    int t = (255 * valueBrightness * (1 - (saturation * (1 - f)))).round();
    int iV = (255 * valueBrightness).round();

    switch (hi) {
      case 0:
        return [iV, t, p];
      case 1:
        return [q, iV, p];
      case 2:
        return [p, iV, t];
      case 3:
        return [p, q, iV];
      case 4:
        return [t, p, iV];
      case 5:
      default:
        return [iV, p, q];
    }
  }

  /// hwb2rgb algorithm from http://dev.w3.org/csswg/css-color/#hwb-to-rgb
  static List<int> hwb2rgb(num h, num whiteness, num blackness) {
    if (whiteness <= 1 && blackness <= 1) {
      // if both <=1 we assume that are 0-1 range, NOTE that means
      // if REALLY want (0.01 whiteness AND blackness then you need to pass it like that
      //   and not as 1 in 1-100 scale)
      //  (because passing both as 1 will assume 0 to 1 scale, NOT 1 in the 100 scale)
      whiteness *= 100;
      blackness *= 100;
    }
    h = h / 360;
    var wh = whiteness / 100;
    var bl = blackness / 100;
    var ratio = wh + bl;
    num f;

    // Wh + bl cant be > 1
    if (ratio > 1) {
      wh /= ratio;
      bl /= ratio;
    }

    var i = (6 * h).floor();
    var v = 1 - bl;
    f = 6 * h - i;

    if ((i & 0x01) != 0) {
      f = 1 - f;
    }

    var n = wh + f * (v - wh); // Linear interpolation

    num r;
    num g;
    num b;

    switch (i) {
      case 1:
        r = n;
        g = v;
        b = wh;
        break;
      case 2:
        r = wh;
        g = v;
        b = n;
        break;
      case 3:
        r = wh;
        g = n;
        b = v;
        break;
      case 4:
        r = n;
        g = wh;
        b = v;
        break;
      case 5:
        r = v;
        g = wh;
        b = n;
        break;
      case 6:
      case 0:
      default:
        r = v;
        g = n;
        b = wh;
        break;
    }
    return [(r * 255).round(), (g * 255).round(), (b * 255).round()];
  }

  // Alternate hwb algorithm from
  // algorithm (NOW 3/13/22) from http://dev.w3.org/csswg/css-color/#hwb-to-rgb
  static List<int> hwbTorgb(num hue, num white, num black) {
    white /= 100;
    black /= 100;
    if (white + black >= 1) {
      int gray = (white / (white + black)).round();
      return [gray, gray, gray];
    }
    List<double> rgb1 = hslToRgb1Scale(hue, 100, 50);
    for (int i = 0; i < 3; i++) {
      rgb1[i] *= (1 - white - black);
      rgb1[i] += white;
    }
    return [
      (rgb1[0] * 255).round(),
      (rgb1[1] * 255).round(),
      (rgb1[2] * 255).round()
    ];
  }

  static List<int> cmyk2rgb(num cyan, num magenta, num yellow, num keyBlack) {
    if (cyan <= 1 && magenta <= 1 && yellow <= 1 && keyBlack <= 1) {
      // if both <=1 we assume that are 0-1 range, NOTE that means if REALLY
      // want (0.01 then you need to pass it like that and not as 1 in to 100 scale)
      cyan *= 100;
      magenta *= 100;
      yellow *= 100;
      keyBlack *= 100;
    }
    cyan = cyan / 100;
    magenta = magenta / 100;
    yellow = yellow / 100;
    keyBlack = keyBlack / 100;

    var r = 1 - min(1, cyan * (1 - keyBlack) + keyBlack);
    var g = 1 - min(1, magenta * (1 - keyBlack) + keyBlack);
    var b = 1 - min(1, yellow * (1 - keyBlack) + keyBlack);

    return [(r * 255).round(), (g * 255).round(), (b * 255).round()];
  }

  static List<int> xyz2rgb(num x, num y, num z) {
    if (x <= 1 && y <= 1 && z <= 1) {
      // if both <=1 we assume that are 0-1 range, NOTE that means if
      // you REALLY want (0.01 then you need to pass it like that and
      // not as 1 in to 100 scale)
      x *= 100;
      y *= 100;
      z *= 100;
    }
    x = x / 100;
    y = y / 100;
    z = z / 100;
    num r;
    num g;
    num b;

    r = (x * 3.2404542) + (y * -1.5371385) + (z * -0.4985314);
    g = (x * -0.969266) + (y * 1.8760108) + (z * 0.041556);
    b = (x * 0.0556434) + (y * -0.2040259) + (z * 1.0572252);

    // Assume sRGB
    r = (r > 0.0031308) ? ((1.055 * pow(r, (1.0 / 2.4))) - 0.055) : r * 12.92;

    g = g > 0.0031308 ? ((1.055 * pow(g, (1.0 / 2.4))) - 0.055) : g * 12.92;

    b = b > 0.0031308 ? ((1.055 * pow(b, (1.0 / 2.4))) - 0.055) : b * 12.92;

    r = min(max(0, r), 1);
    g = min(max(0, g), 1);
    b = min(max(0, b), 1);

    return [(r * 255).round(), (g * 255).round(), (b * 255).round()];
  }

  static List<num> lab2xyz(num l, num a, num b) {
    double y = (l + 16) / 116;
    double x = a / 500 + y;
    double z = y - b / 200;

    double y3 = y * y * y;
    double x3 = x * x * x;
    double z3 = z * z * z;
    y = y3 > 0.008856 ? y3 : (y - 16 / 116) / 7.787;
    x = x3 > 0.008856 ? x3 : (x - 16 / 116) / 7.787;
    z = z3 > 0.008856 ? z3 : (z - 16 / 116) / 7.787;

    x *= 95.047;
    y *= 100;
    z *= 108.883;

    return [x, y, z];
  }

  static List<int> rgb2hsl(List<num> rgb) {
    final num r = rgb[0] / 255.0;
    final num g = rgb[1] / 255.0;
    final num b = rgb[2] / 255.0;
    final num minC = min(r, min(g, b));
    final num maxC = max(r, max(g, b));
    final num delta = maxC - minC;
    num h = 0;
    num s;

    if (maxC == minC) {
      h = 0;
    } else if (r == maxC) {
      h = (g - b) / delta;
    } else if (g == maxC) {
      h = 2 + (b - r) / delta;
    } else if (b == maxC) {
      h = 4 + (r - g) / delta;
    }

    h = min(h * 60, 360);

    if (h < 0) {
      h += 360;
    }

    final num l = (minC + maxC) / 2;

    if (maxC == minC) {
      s = 0;
    } else if (l <= 0.5) {
      s = delta / (maxC + minC);
    } else {
      s = delta / (2 - maxC - minC);
    }

    return [h.round(), (s * 100).round(), (l * 100).round()];
  }

  // This handles any incoming types and trys to get a hex string out of it..
  // (quick attempt to do equivalent of js code) this goes the 'long' way..
  static List<num> hex2rgb(dynamic arg) {
    if (arg is num || arg is int) {
      int intval = arg.floor();
      num r = (intval >> 16) & 0xFF;
      num g = (intval >> 8) & 0xFF;
      num b = intval & 0xFF;

      return [r, g, b];
    }
    var str = arg.toString();
    var hexstuff = RegExp('[a-f0-9]{6}|[a-f0-9]{3}', caseSensitive: false);
    var match = hexstuff.firstMatch(str);
    if (match == null) {
      return [0, 0, 0];
    }

    var colorString = match[0]!;

    if (colorString.length == 3) {
      colorString = colorString.split('').map((ch) {
        return ch + ch;
      }).join('');
    }
    int intval = int.parse(colorString, radix: 16);

    num r = (intval >> 16) & 0xFF;
    num g = (intval >> 8) & 0xFF;
    num b = intval & 0xFF;

    return [r, g, b];
  }

  /// Add RGB color to the colorKeywords[] map that is used for dynamic lookup of colors by name.
  static void addColorKeywordRgb(
      String colorname, int red, int green, int blue) {
    int colorInt = 0xff000000 |
        ((red & 0xff) << 16) |
        ((green & 0xff) << 8) |
        (blue & 0xff);
    colorKeywords[colorname.toLowerCase().replaceAll(' ', '')] = colorInt;
  }

  /// Add hex color (string or int) to the colorKeywords[] map that is used for
  /// dynamic lookup of colors by name.
  static void addColorKeywordHex(String colorname, dynamic hex) {
    var rgb = hex2rgb(hex);
    int colorInt = 0xff000000 |
        ((rgb[0].toInt() & 0xff) << 16) |
        ((rgb[1].toInt() & 0xff) << 8) |
        (rgb[2].toInt() & 0xff);
    colorKeywords[colorname.toLowerCase().replaceAll(' ', '')] = colorInt;
  }

  /// Lookup colorname keyword in colorKeywords map and return BLACK if the
  /// color is not found.
  /// Returns color as RGB int.
  static int colorFromKeyword(String keyword) {
    keyword = keyword.toLowerCase().replaceAll(' ', '');
    return colorKeywords.containsKey(keyword)
        ? colorKeywords[keyword]!
        : colorKeywords['black']!;
  }

  /// Lookup colorname keyword in colorKeywords map and return BLACK if the
  /// color is not found.
  /// Returns color as a num array of `[red,green,blue]`.
  static List<num> rgbFromKeyword(String keyword) {
    keyword = keyword.toLowerCase().replaceAll(' ', '');
    var rgb = colorKeywords.containsKey(keyword)
        ? colorKeywords[keyword]!
        : colorKeywords['black']!;
    return [(rgb >> 16) & 0xff, (rgb >> 8) & 0xff, rgb & 0xff];
  }

  /// A map of X11/CSS color keywords and their 6-digit hexadecimal RGB values
  /// x11 colors appear again here:
  ///    https://www.w3.org/wiki/CSS/Properties/color/keywords
  /// complete history of the X11 color names :
  ///    https://en.wikipedia.org/wiki/X11_color_names
  /// and CSS color names (derived from X11 color names):
  ///    https://www.w3.org/wiki/CSS/Properties/color/keywords
  /// (these are the same as the css color list (except for X11 has 'rebeccapurple'
  ///      and css colors used 'lightGoldenrodYellow' and X11 uses 'lightGoldenrod'))
  /// - so we include both
  static final Map<String, int> colorKeywords = <String, int>{
    'aliceblue': 0xF0F8FF,
    'antiquewhite': 0xFAEBD7,
    'aqua': 0x00FFFF,
    'aquamarine': 0x7FFFD4,
    'azure': 0xF0FFFF,
    'beige': 0xF5F5DC,
    'bisque': 0xFFE4C4,
    'black': 0x000000,
    'blanchedalmond': 0xFFEBCD,
    'blue': 0x0000FF,
    'blueviolet': 0x8A2BE2,
    'brown': 0xA52A2A,
    'burlywood': 0xDEB887,
    'cadetblue': 0x5F9EA0,
    'chartreuse': 0x7FFF00,
    'chocolate': 0xD2691E,
    'coral': 0xFF7F50,
    'cornflowerblue': 0x6495ED,
    'cornsilk': 0xFFF8DC,
    'crimson': 0xDC143C,
    'cyan': 0x00FFFF,
    'darkblue': 0x00008B,
    'darkcyan': 0x008B8B,
    'darkgoldenrod': 0xB8860B,
    'darkgray': 0xA9A9A9,
    'darkgreen': 0x006400,
    'darkgrey': 0xA9A9A9,
    'darkkhaki': 0xBDB76B,
    'darkmagenta': 0x8B008B,
    'darkolivegreen': 0x556B2F,
    'darkorange': 0xFF8C00,
    'darkorchid': 0x9932CC,
    'darkred': 0x8B0000,
    'darksalmon': 0xE9967A,
    'darkseagreen': 0x8FBC8F,
    'darkslateblue': 0x483D8B,
    'darkslategray': 0x2F4F4F,
    'darkslategrey': 0x2F4F4F,
    'darkturquoise': 0x00CED1,
    'darkviolet': 0x9400D3,
    'deeppink': 0xFF1493,
    'deepskyblue': 0x00BFFF,
    'dimgray': 0x696969,
    'dimgrey': 0x696969,
    'dodgerblue': 0x1E90FF,
    'firebrick': 0xB22222,
    'floralwhite': 0xFFFAF0,
    'forestgreen': 0x228B22,
    'fuchsia': 0xFF00FF,
    'gainsboro': 0xDCDCDC,
    'ghostwhite': 0xF8F8FF,
    'gold': 0xFFD700,
    'goldenrod': 0xDAA520,
    'gray': 0x808080,
    'green': 0x008000,
    'greenyellow': 0xADFF2F,
    'grey': 0x808080,
    'honeydew': 0xF0FFF0,
    'hotpink': 0xFF69B4,
    'indianred': 0xCD5C5C,
    'indigo': 0x4B0082,
    'ivory': 0xFFFFF0,
    'khaki': 0xF0E68C,
    'lavender': 0xE6E6FA,
    'lavenderblush': 0xFFF0F5,
    'lawngreen': 0x7CFC00,
    'lemonchiffon': 0xFFFACD,
    'lightblue': 0xADD8E6,
    'lightcoral': 0xF08080,
    'lightcyan': 0xE0FFFF,
    'lightgoldenrod': 0xFAFAD2, //x11 name
    'lightgoldenrodyellow': 0xFAFAD2, // css name
    'lightgray': 0xD3D3D3,
    'lightgreen': 0x90EE90,
    'lightgrey': 0xD3D3D3,
    'lightpink': 0xFFB6C1,
    'lightsalmon': 0xFFA07A,
    'lightseagreen': 0x20B2AA,
    'lightskyblue': 0x87CEFA,
    'lightslategray': 0x778899,
    'lightslategrey': 0x778899,
    'lightsteelblue': 0xB0C4DE,
    'lightyellow': 0xFFFFE0,
    'lime': 0x00FF00,
    'limegreen': 0x32CD32,
    'linen': 0xFAF0E6,
    'magenta': 0xFF00FF,
    'maroon': 0x800000,
    'mediumaquamarine': 0x66CDAA,
    'mediumblue': 0x0000CD,
    'mediumorchid': 0xBA55D3,
    'mediumpurple': 0x9370DB,
    'mediumseagreen': 0x3CB371,
    'mediumslateblue': 0x7B68EE,
    'mediumspringgreen': 0x00FA9A,
    'mediumturquoise': 0x48D1CC,
    'mediumvioletred': 0xC71585,
    'midnightblue': 0x191970,
    'mintcream': 0xF5FFFA,
    'mistyrose': 0xFFE4E1,
    'moccasin': 0xFFE4B5,
    'navajowhite': 0xFFDEAD,
    'navy': 0x000080,
    'oldlace': 0xFDF5E6,
    'olive': 0x808000,
    'olivedrab': 0x6B8E23,
    'orange': 0xFFA500,
    'orangered': 0xFF4500,
    'orchid': 0xDA70D6,
    'palegoldenrod': 0xEEE8AA,
    'palegreen': 0x98FB98,
    'paleturquoise': 0xAFEEEE,
    'palevioletred': 0xDB7093,
    'papayawhip': 0xFFEFD5,
    'peachpuff': 0xFFDAB9,
    'peru': 0xCD853F,
    'pink': 0xFFC0CB,
    'plum': 0xDDA0DD,
    'powderblue': 0xB0E0E6,
    'purple': 0x800080,
    'rebeccapurple': 0x663399,
    'red': 0xFF0000,
    'rosybrown': 0xBC8F8F,
    'royalblue': 0x4169E1,
    'saddlebrown': 0x8B4513,
    'salmon': 0xFA8072,
    'sandybrown': 0xF4A460,
    'seagreen': 0x2E8B57,
    'seashell': 0xFFF5EE,
    'sienna': 0xA0522D,
    'silver': 0xC0C0C0,
    'skyblue': 0x87CEEB,
    'slateblue': 0x6A5ACD,
    'slategray': 0x708090,
    'slategrey': 0x708090,
    'snow': 0xFFFAFA,
    'springgreen': 0x00FF7F,
    'steelblue': 0x4682B4,
    'tan': 0xD2B48C,
    'teal': 0x008080,
    'thistle': 0xD8BFD8,
    'tomato': 0xFF6347,
    'turquoise': 0x40E0D0,
    'violet': 0xEE82EE,
    'wheat': 0xF5DEB3,
    'white': 0xFFFFFF,
    'whitesmoke': 0xF5F5F5,
    'yellow': 0xFFFF00,
    'yellowgreen': 0x9ACD32,
  };
}
