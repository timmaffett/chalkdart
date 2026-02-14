import 'package:chalkdart/colorutils.dart';
import 'package:test/test.dart';

void main() {
  group('ColorUtils.rgbToAnsi256', () {
    test('black maps to 16', () {
      expect(ColorUtils.rgbToAnsi256(0, 0, 0), 16);
    });

    test('white maps to 231', () {
      expect(ColorUtils.rgbToAnsi256(255, 255, 255), 231);
    });

    test('mid grey maps to extended greyscale palette', () {
      int code = ColorUtils.rgbToAnsi256(128, 128, 128);
      expect(code, greaterThanOrEqualTo(232));
      expect(code, lessThanOrEqualTo(255));
    });

    test('pure red maps to 196', () {
      expect(ColorUtils.rgbToAnsi256(255, 0, 0), 196);
    });

    test('pure green maps to 46', () {
      expect(ColorUtils.rgbToAnsi256(0, 255, 0), 46);
    });

    test('pure blue maps to 21', () {
      expect(ColorUtils.rgbToAnsi256(0, 0, 255), 21);
    });

    test('near-black grey maps to 232 range', () {
      int code = ColorUtils.rgbToAnsi256(10, 10, 10);
      expect(code, greaterThanOrEqualTo(232));
    });

    test('near-white grey maps to 231 range', () {
      int code = ColorUtils.rgbToAnsi256(250, 250, 250);
      expect(code, 231);
    });
  });

  group('ColorUtils.hex2rgb', () {
    test('parses 6-digit hex string with #', () {
      expect(ColorUtils.hex2rgb('#FF0000'), [255, 0, 0]);
      expect(ColorUtils.hex2rgb('#00FF00'), [0, 255, 0]);
      expect(ColorUtils.hex2rgb('#0000FF'), [0, 0, 255]);
    });

    test('parses 3-digit hex string with #', () {
      expect(ColorUtils.hex2rgb('#F00'), [255, 0, 0]);
      expect(ColorUtils.hex2rgb('#0F0'), [0, 255, 0]);
      expect(ColorUtils.hex2rgb('#00F'), [0, 0, 255]);
    });

    test('parses hex integer', () {
      expect(ColorUtils.hex2rgb(0xFF0000), [255, 0, 0]);
      expect(ColorUtils.hex2rgb(0x00FF00), [0, 255, 0]);
      expect(ColorUtils.hex2rgb(0x0000FF), [0, 0, 255]);
    });

    test('returns black for invalid input', () {
      expect(ColorUtils.hex2rgb('invalid'), [0, 0, 0]);
    });

    test('parses without # prefix', () {
      expect(ColorUtils.hex2rgb('FF8800'), [255, 136, 0]);
    });

    test('parses mixed case hex', () {
      expect(ColorUtils.hex2rgb('#aAbBcC'), [0xAA, 0xBB, 0xCC]);
    });

    test('parses 3-digit shorthand correctly (expands digits)', () {
      expect(ColorUtils.hex2rgb('#ABC'), [0xAA, 0xBB, 0xCC]);
    });

    test('parses integer 0 as black', () {
      expect(ColorUtils.hex2rgb(0), [0, 0, 0]);
    });

    test('parses white hex int', () {
      expect(ColorUtils.hex2rgb(0xFFFFFF), [255, 255, 255]);
    });
  });

  group('ColorUtils.hsl2rgb', () {
    test('red (0, 100, 50)', () {
      var rgb = ColorUtils.hsl2rgb(0, 100, 50);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('green (120, 100, 50)', () {
      var rgb = ColorUtils.hsl2rgb(120, 100, 50);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('blue (240, 100, 50)', () {
      var rgb = ColorUtils.hsl2rgb(240, 100, 50);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(255, 1));
    });

    test('white (0, 0, 100)', () {
      var rgb = ColorUtils.hsl2rgb(0, 0, 100);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(255, 1));
    });

    test('black (0, 0, 0)', () {
      var rgb = ColorUtils.hsl2rgb(0, 0, 0);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('accepts 0-1 scale for saturation and lightness', () {
      var rgb = ColorUtils.hsl2rgb(0, 1, 0.5);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('grey (0, 0, 50)', () {
      var rgb = ColorUtils.hsl2rgb(0, 0, 50);
      expect(rgb[0], closeTo(128, 1));
      expect(rgb[1], closeTo(128, 1));
      expect(rgb[2], closeTo(128, 1));
    });

    test('cyan (180, 100, 50)', () {
      var rgb = ColorUtils.hsl2rgb(180, 100, 50);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(255, 1));
    });

    test('magenta (300, 100, 50)', () {
      var rgb = ColorUtils.hsl2rgb(300, 100, 50);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(255, 1));
    });

    test('yellow (60, 100, 50)', () {
      var rgb = ColorUtils.hsl2rgb(60, 100, 50);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(0, 1));
    });
  });

  group('ColorUtils.hslTorgb (alternate algorithm)', () {
    test('red (0, 100, 50)', () {
      var rgb = ColorUtils.hslTorgb(0, 100, 50);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('green (120, 100, 50)', () {
      var rgb = ColorUtils.hslTorgb(120, 100, 50);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('blue (240, 100, 50)', () {
      var rgb = ColorUtils.hslTorgb(240, 100, 50);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(255, 1));
    });
  });

  group('ColorUtils.hslToRgb1Scale', () {
    test('returns values in 0-1 range', () {
      var rgb = ColorUtils.hslToRgb1Scale(0, 100, 50);
      expect(rgb[0], closeTo(1.0, 0.01));
      expect(rgb[1], closeTo(0.0, 0.01));
      expect(rgb[2], closeTo(0.0, 0.01));
    });

    test('handles negative hue by wrapping', () {
      var rgb = ColorUtils.hslToRgb1Scale(-60, 100, 50);
      // -60 degrees wraps to 300 degrees (magenta)
      expect(rgb[0], closeTo(1.0, 0.01));
      expect(rgb[1], closeTo(0.0, 0.01));
      expect(rgb[2], closeTo(1.0, 0.01));
    });

    test('handles hue > 360 by wrapping', () {
      var rgb1 = ColorUtils.hslToRgb1Scale(0, 100, 50);
      var rgb2 = ColorUtils.hslToRgb1Scale(360, 100, 50);
      expect(rgb1[0], closeTo(rgb2[0], 0.01));
      expect(rgb1[1], closeTo(rgb2[1], 0.01));
      expect(rgb1[2], closeTo(rgb2[2], 0.01));
    });
  });

  group('ColorUtils.hsv2rgb', () {
    test('red (0, 100, 100)', () {
      var rgb = ColorUtils.hsv2rgb(0, 100, 100);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('green (120, 100, 100)', () {
      var rgb = ColorUtils.hsv2rgb(120, 100, 100);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('blue (240, 100, 100)', () {
      var rgb = ColorUtils.hsv2rgb(240, 100, 100);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(255, 1));
    });

    test('white (0, 0, 100)', () {
      var rgb = ColorUtils.hsv2rgb(0, 0, 100);
      expect(rgb, [255, 255, 255]);
    });

    test('black (0, 100, 0)', () {
      var rgb = ColorUtils.hsv2rgb(0, 100, 0);
      expect(rgb, [0, 0, 0]);
    });

    test('yellow (60, 100, 100)', () {
      var rgb = ColorUtils.hsv2rgb(60, 100, 100);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('cyan (180, 100, 100)', () {
      var rgb = ColorUtils.hsv2rgb(180, 100, 100);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(255, 1));
    });

    test('magenta (300, 100, 100)', () {
      var rgb = ColorUtils.hsv2rgb(300, 100, 100);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(255, 1));
    });

    test('accepts 0-1 scale for saturation and value', () {
      var rgb = ColorUtils.hsv2rgb(0, 1, 1);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(0, 1));
    });
  });

  group('ColorUtils.hwb2rgb', () {
    test('red (0, 0, 0) - no whiteness or blackness', () {
      var rgb = ColorUtils.hwb2rgb(0, 0, 0);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('white (0, 100, 0)', () {
      var rgb = ColorUtils.hwb2rgb(0, 100, 0);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(255, 1));
    });

    test('black (0, 0, 100)', () {
      var rgb = ColorUtils.hwb2rgb(0, 0, 100);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('green (120, 0, 0)', () {
      var rgb = ColorUtils.hwb2rgb(120, 0, 0);
      expect(rgb[0], closeTo(0, 1));
      expect(rgb[1], closeTo(255, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('accepts 0-1 scale', () {
      var rgb = ColorUtils.hwb2rgb(0, 0, 0);
      expect(rgb[0], closeTo(255, 1));
    });

    test('when whiteness + blackness > 100, normalizes', () {
      // Should not crash and should return valid values
      var rgb = ColorUtils.hwb2rgb(0, 80, 80);
      expect(rgb[0], greaterThanOrEqualTo(0));
      expect(rgb[0], lessThanOrEqualTo(255));
    });
  });

  group('ColorUtils.hwbTorgb (alternate algorithm)', () {
    test('red (0, 0, 0)', () {
      var rgb = ColorUtils.hwbTorgb(0, 0, 0);
      expect(rgb[0], closeTo(255, 1));
      expect(rgb[1], closeTo(0, 1));
      expect(rgb[2], closeTo(0, 1));
    });

    test('grey when whiteness + blackness >= 100', () {
      var rgb = ColorUtils.hwbTorgb(0, 50, 50);
      expect(rgb[0], rgb[1]);
      expect(rgb[1], rgb[2]);
    });

    test('white (0, 100, 0) triggers grey branch', () {
      // white+black >= 1, so gray = (white/(white+black)).round()
      var rgb = ColorUtils.hwbTorgb(0, 100, 0);
      expect(rgb[0], rgb[1]);
      expect(rgb[1], rgb[2]);
    });
  });

  group('ColorUtils.cmyk2rgb', () {
    test('red (0, 100, 100, 0)', () {
      var rgb = ColorUtils.cmyk2rgb(0, 100, 100, 0);
      expect(rgb, [255, 0, 0]);
    });

    test('green (100, 0, 100, 0)', () {
      var rgb = ColorUtils.cmyk2rgb(100, 0, 100, 0);
      expect(rgb, [0, 255, 0]);
    });

    test('blue (100, 100, 0, 0)', () {
      var rgb = ColorUtils.cmyk2rgb(100, 100, 0, 0);
      expect(rgb, [0, 0, 255]);
    });

    test('white (0, 0, 0, 0)', () {
      var rgb = ColorUtils.cmyk2rgb(0, 0, 0, 0);
      expect(rgb, [255, 255, 255]);
    });

    test('black (0, 0, 0, 100)', () {
      var rgb = ColorUtils.cmyk2rgb(0, 0, 0, 100);
      expect(rgb, [0, 0, 0]);
    });

    test('accepts 0-1 scale', () {
      var rgb = ColorUtils.cmyk2rgb(0, 1, 1, 0);
      expect(rgb, [255, 0, 0]);
    });

    test('partial values produce intermediate colors', () {
      var rgb = ColorUtils.cmyk2rgb(0, 0, 0, 50);
      // 50% key = grey
      expect(rgb[0], closeTo(128, 1));
      expect(rgb[1], closeTo(128, 1));
      expect(rgb[2], closeTo(128, 1));
    });
  });

  group('ColorUtils.xyz2rgb', () {
    test('D65 white point produces white', () {
      var rgb = ColorUtils.xyz2rgb(95.047, 100.0, 108.883);
      expect(rgb[0], closeTo(255, 2));
      expect(rgb[1], closeTo(255, 2));
      expect(rgb[2], closeTo(255, 2));
    });

    test('origin produces black', () {
      var rgb = ColorUtils.xyz2rgb(0, 0, 0);
      expect(rgb, [0, 0, 0]);
    });

    test('D65 white produces near white', () {
      // D65 illuminant in 0-100 scale
      var rgb = ColorUtils.xyz2rgb(95.047, 100.0, 108.883);
      expect(rgb[0], closeTo(255, 2));
      expect(rgb[1], closeTo(255, 2));
      expect(rgb[2], closeTo(255, 2));
    });

    test('clamps output to 0-255 range', () {
      var rgb = ColorUtils.xyz2rgb(200, 200, 200);
      for (var v in rgb) {
        expect(v, greaterThanOrEqualTo(0));
        expect(v, lessThanOrEqualTo(255));
      }
    });
  });

  group('ColorUtils.lab2xyz', () {
    test('L=100, a=0, b=0 produces D65 white point', () {
      var xyz = ColorUtils.lab2xyz(100, 0, 0);
      expect(xyz[0], closeTo(95.047, 0.1));
      expect(xyz[1], closeTo(100.0, 0.1));
      expect(xyz[2], closeTo(108.883, 0.1));
    });

    test('L=0, a=0, b=0 produces near-black', () {
      var xyz = ColorUtils.lab2xyz(0, 0, 0);
      expect(xyz[0], closeTo(0, 0.5));
      expect(xyz[1], closeTo(0, 0.5));
      expect(xyz[2], closeTo(0, 0.5));
    });

    test('L=50, a=0, b=0 produces mid-grey XYZ', () {
      var xyz = ColorUtils.lab2xyz(50, 0, 0);
      expect(xyz[1], closeTo(18.4, 0.5)); // Y for L*=50
    });
  });

  group('ColorUtils.rgb2hsl', () {
    test('red -> (0, 100, 50)', () {
      var hsl = ColorUtils.rgb2hsl([255, 0, 0]);
      expect(hsl[0], 0);
      expect(hsl[1], 100);
      expect(hsl[2], 50);
    });

    test('green -> (120, 100, 50)', () {
      var hsl = ColorUtils.rgb2hsl([0, 255, 0]);
      expect(hsl[0], 120);
      expect(hsl[1], 100);
      expect(hsl[2], 50);
    });

    test('blue -> (240, 100, 50)', () {
      var hsl = ColorUtils.rgb2hsl([0, 0, 255]);
      expect(hsl[0], 240);
      expect(hsl[1], 100);
      expect(hsl[2], 50);
    });

    test('white -> (0, 0, 100)', () {
      var hsl = ColorUtils.rgb2hsl([255, 255, 255]);
      expect(hsl[0], 0);
      expect(hsl[1], 0);
      expect(hsl[2], 100);
    });

    test('black -> (0, 0, 0)', () {
      var hsl = ColorUtils.rgb2hsl([0, 0, 0]);
      expect(hsl[0], 0);
      expect(hsl[1], 0);
      expect(hsl[2], 0);
    });

    test('yellow -> (60, 100, 50)', () {
      var hsl = ColorUtils.rgb2hsl([255, 255, 0]);
      expect(hsl[0], 60);
      expect(hsl[1], 100);
      expect(hsl[2], 50);
    });

    test('cyan -> (180, 100, 50)', () {
      var hsl = ColorUtils.rgb2hsl([0, 255, 255]);
      expect(hsl[0], 180);
      expect(hsl[1], 100);
      expect(hsl[2], 50);
    });

    test('magenta -> (300, 100, 50)', () {
      var hsl = ColorUtils.rgb2hsl([255, 0, 255]);
      expect(hsl[0], 300);
      expect(hsl[1], 100);
      expect(hsl[2], 50);
    });

    test('grey -> saturation 0', () {
      var hsl = ColorUtils.rgb2hsl([128, 128, 128]);
      expect(hsl[1], 0);
    });
  });

  group('ColorUtils color keyword methods', () {
    test('colorFromKeyword returns known color int', () {
      expect(ColorUtils.colorFromKeyword('red'), 0xFF0000);
      expect(ColorUtils.colorFromKeyword('blue'), 0x0000FF);
      expect(ColorUtils.colorFromKeyword('green'), 0x008000);
    });

    test('colorFromKeyword is case-insensitive', () {
      expect(ColorUtils.colorFromKeyword('Red'), ColorUtils.colorFromKeyword('red'));
      expect(ColorUtils.colorFromKeyword('RED'), ColorUtils.colorFromKeyword('red'));
      expect(ColorUtils.colorFromKeyword('rEd'), ColorUtils.colorFromKeyword('red'));
    });

    test('colorFromKeyword ignores spaces', () {
      expect(ColorUtils.colorFromKeyword('alice blue'), ColorUtils.colorFromKeyword('aliceblue'));
      expect(ColorUtils.colorFromKeyword('cornflower blue'), ColorUtils.colorFromKeyword('cornflowerblue'));
    });

    test('colorFromKeyword returns black for unknown keyword', () {
      expect(ColorUtils.colorFromKeyword('nonexistent'), ColorUtils.colorFromKeyword('black'));
    });

    test('rgbFromKeyword returns RGB list', () {
      expect(ColorUtils.rgbFromKeyword('red'), [255, 0, 0]);
      expect(ColorUtils.rgbFromKeyword('blue'), [0, 0, 255]);
    });

    test('rgbFromKeyword for cornflowerblue', () {
      expect(ColorUtils.rgbFromKeyword('cornflowerblue'), [100, 149, 237]);
    });

    test('rgbFromKeyword for tomato', () {
      expect(ColorUtils.rgbFromKeyword('tomato'), [255, 99, 71]);
    });

    test('addColorKeywordRgb registers new color', () {
      ColorUtils.addColorKeywordRgb('customtest1', 11, 22, 33);
      expect(ColorUtils.rgbFromKeyword('customtest1'), [11, 22, 33]);
    });

    test('addColorKeywordHex registers from hex int', () {
      ColorUtils.addColorKeywordHex('customtest2', 0xAABBCC);
      expect(ColorUtils.rgbFromKeyword('customtest2'), [0xAA, 0xBB, 0xCC]);
    });

    test('addColorKeywordHex registers from hex string', () {
      ColorUtils.addColorKeywordHex('customtest3', '#DDEEFF');
      expect(ColorUtils.rgbFromKeyword('customtest3'), [0xDD, 0xEE, 0xFF]);
    });

    test('addColorKeywordRgb normalizes name to lowercase', () {
      ColorUtils.addColorKeywordRgb('MyColor', 1, 2, 3);
      expect(ColorUtils.rgbFromKeyword('mycolor'), [1, 2, 3]);
    });

    test('colorKeywords map contains standard X11 colors', () {
      expect(ColorUtils.colorKeywords.containsKey('aliceblue'), isTrue);
      expect(ColorUtils.colorKeywords.containsKey('cornflowerblue'), isTrue);
      expect(ColorUtils.colorKeywords.containsKey('tomato'), isTrue);
      expect(ColorUtils.colorKeywords.containsKey('rebeccapurple'), isTrue);
    });

    test('grey and gray are both present', () {
      expect(ColorUtils.colorKeywords.containsKey('grey'), isTrue);
      expect(ColorUtils.colorKeywords.containsKey('gray'), isTrue);
      expect(ColorUtils.colorKeywords['grey'], ColorUtils.colorKeywords['gray']);
    });
  });

  group('ColorUtils round-trip conversions', () {
    test('HSL -> RGB -> HSL roundtrip for primary colors', () {
      // Red
      var rgb = ColorUtils.hsl2rgb(0, 100, 50);
      var hsl = ColorUtils.rgb2hsl(rgb);
      expect(hsl[0], closeTo(0, 1));
      expect(hsl[1], closeTo(100, 1));
      expect(hsl[2], closeTo(50, 1));
    });

    test('HSL -> RGB -> HSL roundtrip for green', () {
      var rgb = ColorUtils.hsl2rgb(120, 100, 50);
      var hsl = ColorUtils.rgb2hsl(rgb);
      expect(hsl[0], closeTo(120, 1));
      expect(hsl[1], closeTo(100, 1));
      expect(hsl[2], closeTo(50, 1));
    });

    test('LAB -> XYZ -> RGB produces valid RGB for L*=50 a*=50 b*=0', () {
      var xyz = ColorUtils.lab2xyz(50, 50, 0);
      var rgb = ColorUtils.xyz2rgb(xyz[0], xyz[1], xyz[2]);
      for (var v in rgb) {
        expect(v, greaterThanOrEqualTo(0));
        expect(v, lessThanOrEqualTo(255));
      }
    });
  });
}
