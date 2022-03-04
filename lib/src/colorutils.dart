library chalkdart;
/*
  @author: tim maffett
*/
import 'dart:math';

/*
  References with detailed explainations of the various color models included here
  https://en.wikipedia.org/wiki/HSL_and_HSV
  https://en.wikipedia.org/wiki/HWB_color_model

  complete history of the X11 color names (later used in css also)
  https://en.wikipedia.org/wiki/X11_color_names
*/
// Most of these routines are based on javascript code that I have ported to dart
// (from https://www.npmjs.com/package/color-convert )
//  github: https://github.com/Qix-/color-convert/
//   and more specifically 
//          https://github.com/Qix-/color-convert/blob/master/conversions.js
//
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

  static List<int> hsl2rgb(num h, num s, num l) {
    if( s<=1 && l<=1 ) {
      s *=100; // if both <=1 we assume that are 0-1 range, NOTE that means if REALLT want (0.01 s then you need to pass it like that and not as 1 in to 100 scale)
      l *=100; 
    }
    h = h / 360;
    s = s / 100;
    l = l / 100;
    var t2;
    var t3;
    var val;

    if (s == 0) {
      final i_val = (l * 255).round();
      return [i_val, i_val, i_val];
    }

    if (l < 0.5) {
      t2 = l * (1 + s);
    } else {
      t2 = l + s - l * s;
    }

    var t1 = 2 * l - t2;

    final rgb = [0, 0, 0];
    for (var i = 0; i < 3; i++) {
      t3 = h + 1 / 3 * -(i - 1);
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

  static List<int> hsv2rgb(num h, num s, num v) {
    if( s<=1 && v<=1 ) {
      s *=100; // if both <=1 we assume that are 0-1 range, NOTE that means if REALLT want (0.01 s then you need to pass it like that and not as 1 in to 100 scale)
      v *=100; 
    }
    h = h / 60;
    s = s / 100;
    v = v / 100;
    var hi = h.floor() % 6;

    var f = h - h.floor();
    int p = (255 * v * (1 - s)).round();
    int q = (255 * v * (1 - (s * f))).round();
    int t = (255 * v * (1 - (s * (1 - f)))).round();
    int i_v = (255 * v).round();

    switch (hi) {
      case 0:
        return [i_v, t, p];
      case 1:
        return [q, i_v, p];
      case 2:
        return [p, i_v, t];
      case 3:
        return [p, q, i_v];
      case 4:
        return [t, p, i_v];
      case 5:
      default:
        return [i_v, p, q];
    }
  }

  // http://dev.w3.org/csswg/css-color/#hwb-to-rgb
  static List<int> hwb2rgb(num h, num whiteness, num blackness) {
    if( whiteness<=1 && blackness<=1 ) {
      whiteness *=100; // if both <=1 we assume that are 0-1 range, NOTE that means if REALLT want (0.01 whiteness then you need to pass it like that and not as 1 in to 100 scale)
      blackness *=100; 
    }
    h = h / 360;
    var wh = whiteness / 100;
    var bl = blackness / 100;
    var ratio = wh + bl;
    var f;

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

    var r;
    var g;
    var b;

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

  static List<int> cmyk2rgb(num c, num m, num y, num k) {
    if( c<=1 && m<=1 && y<=1 && k<=1  ) {
      c *=100; // if both <=1 we assume that are 0-1 range, NOTE that means if REALLT want (0.01 then you need to pass it like that and not as 1 in to 100 scale)
      m *=100; 
      y *=100; 
      k *=100; 
    }
    c = c / 100;
    m = m / 100;
    y = y / 100;
    k = k / 100;

    var r = 1 - min(1, c * (1 - k) + k);
    var g = 1 - min(1, m * (1 - k) + k);
    var b = 1 - min(1, y * (1 - k) + k);

    return [(r * 255).round(), (g * 255).round(), (b * 255).round()];
  }

  static List<int> xyz2rgb(num x, num y, num z) {
    if( x<=1 && y<=1 && z<=1  ) {
      x *=100; // if both <=1 we assume that are 0-1 range, NOTE that means if REALLT want (0.01 then you need to pass it like that and not as 1 in to 100 scale)
      y *=100; 
      z *=100; 
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

  // this handles any incoming types and trys to get a hex string out of it.. (quick attempt to do equivalent of js code)
  // this goes the 'long' way..
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
    if (match == null ) {
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
  static void addColorKeywordRgb( String colorname, int red, int green, int blue ) {
    int colorInt = 0xff000000 | ((red&0xff)<<16) | ((green&0xff)<<8) | (blue&0xff);
    colorKeywords[colorname] = colorInt;
  }

  /// Add hex color (string or int) to the colorKeywords[] map that is used for dynamic lookup of colors by name.
  static void addColorKeywordHex( String colorname, dynamic hex ) {
    var rgb = hex2rgb(hex);
    int colorInt = 0xff000000 | ((rgb[0].toInt()&0xff)<<16) | ((rgb[1].toInt()&0xff)<<8) | (rgb[2].toInt()&0xff);
    colorKeywords[colorname] = colorInt;
  }

  ///Lookup colorname keyword in colorKeywords map and return BLACK if the color is not found
  ///returns color as RGB int
  static int colorFromKeyword(String keyword) {
    keyword = keyword.toLowerCase();
    return colorKeywords.containsKey(keyword)
        ? colorKeywords[keyword]!
        : colorKeywords['black']!;
  }

  ///Lookup colorname keyword in colorKeywords map and return BLACK if the color is not found
  ///returns color as a num array of [red,green,blue]
  static List<num> rgbFromKeyword(String keyword) {
    keyword = keyword.toLowerCase();
    var rgb = colorKeywords.containsKey(keyword)
        ? colorKeywords[keyword]!
        : colorKeywords['black']!;
    return [(rgb >> 16) & 0xff, (rgb >> 8) & 0xff, rgb & 0xff];
  }

  // x11 colors appear again here: https://www.w3.org/wiki/CSS/Properties/color/keywords
  // colorKeywords array code from https://github.com/alex-myznikov/from_css_color/blob/master/lib/from_css_color.dart
  // A map of X11 color keywords and their 8-digit hexadecimal forms (alpha set to 0xFF).
  static final Map<String, int> colorKeywords = <String, int>{
    'transparent': 0x00000000,
    'aliceblue': 0xFFF0F8FF,
    'antiquewhite': 0xFFFAEBD7,
    'aqua': 0xFF00FFFF,
    'aquamarine': 0xFF7FFFD4,
    'azure': 0xFFF0FFFF,
    'beige': 0xFFF5F5DC,
    'bisque': 0xFFFFE4C4,
    'black': 0xFF000000,
    'blanchedalmond': 0xFFFFEBCD,
    'blue': 0xFF0000FF,
    'blueviolet': 0xFF8A2BE2,
    'brown': 0xFFA52A2A,
    'burlywood': 0xFFDEB887,
    'cadetblue': 0xFF5F9EA0,
    'chartreuse': 0xFF7FFF00,
    'chocolate': 0xFFD2691E,
    'coral': 0xFFFF7F50,
    'cornflowerblue': 0xFF6495ED,
    'cornsilk': 0xFFFFF8DC,
    'crimson': 0xFFDC143C,
    'cyan': 0xFF00FFFF,
    'darkblue': 0xFF00008B,
    'darkcyan': 0xFF008B8B,
    'darkgoldenrod': 0xFFB8860B,
    'darkgray': 0xFFA9A9A9,
    'darkgreen': 0xFF006400,
    'darkgrey': 0xFFA9A9A9,
    'darkkhaki': 0xFFBDB76B,
    'darkmagenta': 0xFF8B008B,
    'darkolivegreen': 0xFF556B2F,
    'darkorange': 0xFFFF8C00,
    'darkorchid': 0xFF9932CC,
    'darkred': 0xFF8B0000,
    'darksalmon': 0xFFE9967A,
    'darkseagreen': 0xFF8FBC8F,
    'darkslateblue': 0xFF483D8B,
    'darkslategray': 0xFF2F4F4F,
    'darkslategrey': 0xFF2F4F4F,
    'darkturquoise': 0xFF00CED1,
    'darkviolet': 0xFF9400D3,
    'deeppink': 0xFFFF1493,
    'deepskyblue': 0xFF00BFFF,
    'dimgray': 0xFF696969,
    'dimgrey': 0xFF696969,
    'dodgerblue': 0xFF1E90FF,
    'firebrick': 0xFFB22222,
    'floralwhite': 0xFFFFFAF0,
    'forestgreen': 0xFF228B22,
    'fuchsia': 0xFFFF00FF,
    'gainsboro': 0xFFDCDCDC,
    'ghostwhite': 0xFFF8F8FF,
    'gold': 0xFFFFD700,
    'goldenrod': 0xFFDAA520,
    'gray': 0xFF808080,
    'green': 0xFF008000,
    'greenyellow': 0xFFADFF2F,
    'grey': 0xFF808080,
    'honeydew': 0xFFF0FFF0,
    'hotpink': 0xFFFF69B4,
    'indianred': 0xFFCD5C5C,
    'indigo': 0xFF4B0082,
    'ivory': 0xFFFFFFF0,
    'khaki': 0xFFF0E68C,
    'lavender': 0xFFE6E6FA,
    'lavenderblush': 0xFFFFF0F5,
    'lawngreen': 0xFF7CFC00,
    'lemonchiffon': 0xFFFFFACD,
    'lightblue': 0xFFADD8E6,
    'lightcoral': 0xFFF08080,
    'lightcyan': 0xFFE0FFFF,
    'lightgoldenrodyellow': 0xFFFAFAD2,
    'lightgray': 0xFFD3D3D3,
    'lightgreen': 0xFF90EE90,
    'lightgrey': 0xFFD3D3D3,
    'lightpink': 0xFFFFB6C1,
    'lightsalmon': 0xFFFFA07A,
    'lightseagreen': 0xFF20B2AA,
    'lightskyblue': 0xFF87CEFA,
    'lightslategray': 0xFF778899,
    'lightslategrey': 0xFF778899,
    'lightsteelblue': 0xFFB0C4DE,
    'lightyellow': 0xFFFFFFE0,
    'lime': 0xFF00FF00,
    'limegreen': 0xFF32CD32,
    'linen': 0xFFFAF0E6,
    'magenta': 0xFFFF00FF,
    'maroon': 0xFF800000,
    'mediumaquamarine': 0xFF66CDAA,
    'mediumblue': 0xFF0000CD,
    'mediumorchid': 0xFFBA55D3,
    'mediumpurple': 0xFF9370DB,
    'mediumseagreen': 0xFF3CB371,
    'mediumslateblue': 0xFF7B68EE,
    'mediumspringgreen': 0xFF00FA9A,
    'mediumturquoise': 0xFF48D1CC,
    'mediumvioletred': 0xFFC71585,
    'midnightblue': 0xFF191970,
    'mintcream': 0xFFF5FFFA,
    'mistyrose': 0xFFFFE4E1,
    'moccasin': 0xFFFFE4B5,
    'navajowhite': 0xFFFFDEAD,
    'navy': 0xFF000080,
    'oldlace': 0xFFFDF5E6,
    'olive': 0xFF808000,
    'olivedrab': 0xFF6B8E23,
    'orange': 0xFFFFA500,
    'orangered': 0xFFFF4500,
    'orchid': 0xFFDA70D6,
    'palegoldenrod': 0xFFEEE8AA,
    'palegreen': 0xFF98FB98,
    'paleturquoise': 0xFFAFEEEE,
    'palevioletred': 0xFFDB7093,
    'papayawhip': 0xFFFFEFD5,
    'peachpuff': 0xFFFFDAB9,
    'peru': 0xFFCD853F,
    'pink': 0xFFFFC0CB,
    'plum': 0xFFDDA0DD,
    'powderblue': 0xFFB0E0E6,
    'purple': 0xFF800080,
    'red': 0xFFFF0000,
    'rosybrown': 0xFFBC8F8F,
    'royalblue': 0xFF4169E1,
    'saddlebrown': 0xFF8B4513,
    'salmon': 0xFFFA8072,
    'sandybrown': 0xFFF4A460,
    'seagreen': 0xFF2E8B57,
    'seashell': 0xFFFFF5EE,
    'sienna': 0xFFA0522D,
    'silver': 0xFFC0C0C0,
    'skyblue': 0xFF87CEEB,
    'slateblue': 0xFF6A5ACD,
    'slategray': 0xFF708090,
    'slategrey': 0xFF708090,
    'snow': 0xFFFFFAFA,
    'springgreen': 0xFF00FF7F,
    'steelblue': 0xFF4682B4,
    'tan': 0xFFD2B48C,
    'teal': 0xFF008080,
    'thistle': 0xFFD8BFD8,
    'tomato': 0xFFFF6347,
    'turquoise': 0xFF40E0D0,
    'violet': 0xFFEE82EE,
    'wheat': 0xFFF5DEB3,
    'white': 0xFFFFFFFF,
    'whitesmoke': 0xFFF5F5F5,
    'yellow': 0xFFFFFF00,
    'yellowgreen': 0xFF9ACD32,
  };
}
