// This file contains the utility class for handling transformation of ANSI codes to HTML styles or classes


import 'package:chalkdart/chalkdart.dart';

class ChalkHTMLStyleInfo {
  List<String>? styleNames;
  String? customFgColor;
  String? customBgColor;
  String? customUnderlineColor;
  bool colorsInverted;
  ChalkHTMLStyleInfo({this.styleNames, this.customFgColor, this.customBgColor, this.customUnderlineColor, this.colorsInverted = false } );

  @override
  String toString() {
    return 'styleNames=${styleNames!=null? styleNames.toString() : 'null'} customFgColor="$customFgColor" customBgColor="$customBgColor" customUnderlineColor="$customUnderlineColor" colorsInverted=$colorsInverted';
  }
}

class ChalkHTML {

  /// Dark mode basic ansi colors 0-15.
  static const List<int> darkModeAnsiColors = [
    0x000000, // black
    0xcd3131, // red
    0x0DBC79, // green
    0xe5e510, // yellow
    0x2472c8, // blue
    0xbc3fbc, // magenta
    0x11a8cd, // cyan
    0xe5e5e5, // white
    0x666666, // bright black
    0xf14c4c, // bright red
    0x23d18b, // bright green
    0xf5f543, // bright yellow
    0x3b8eea, // bright blue
    0xd670d6, // bright magenta
    0x29b8db, // bright cyan
    0xe5e5e5, // bright white
  ];

  /// Light mode basic ansi colors 0-15.
  static const List<int> lightModeAnsiColors = [
    0x000000, // black
    0xcd3131, // red
    0x00BC00, // green
    0x949800, // yellow
    0x0451a5, // blue
    0xbc05bc, // magenta
    0x0598bc, // cyan
    0x555555, // white
    0x666666, // bright black
    0xcd3131, // bright red
    0x14CE14, // bright green
    0xb5ba00, // bright yellow
    0x0451a5, // bright blue
    0xbc05bc, // bright magenta
    0x0598bc, // bright cyan
    0xa5a5a5, // bright white
  ];

  /// HighContrast mode basic ansi colors 0-15.
  static const List<int> highContrastModeAnsiColors = [
    0x000000, // black
    0xcd0000, // red
    0x00cd00, // green
    0xcdcd00, // yellow
    0x0000ee, // blue
    0xcd00cd, // magenta
    0x00cdcd, // cyan
    0xe5e5e5, // white
    0x7f7f7f, // bright black
    0xff0000, // bright red
    0x00ff00, // bright green
    0xffff00, // bright yellow
    0x5c5cff, // bright blue
    0xff00ff, // bright magenta
    0x00ffff, // bright cyan
    0xffffff, // bright white
  ];

  static const _useShortColors = true;

  // Return string with color in #aa00bb format
  static String _rgbToCssHex(int red, int green, int blue) {
    // Combine the hexadecimal components into a CSS hex color.
    return '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
  }

  /// Calculate the color for [ansiColorNumber] from the color set defined in
  /// the ANSI 8-bit standard.
  /// [ansiColorNumber] should be a number ranging from 16 to 255 otherwise it
  /// is considered an invalid color and 'null' will be returned.
  /// Essentialy the value indexes into a 6x6x6 color space.
  /// See  https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit for more info.
  static String calcAnsi8bitColor(num ansiColorNumber) {
    //print('calcAnsi8bitColor() ansiColorNumber = $ansiColorNumber');

    if(ansiColorNumber >=0 && ansiColorNumber<16) {
      int colorIndex = ansiColorNumber.toInt();
      //const colorName = darkModeAnsiColors[colorIndex];
      int? colorRGBAInt;
      if(ansiColorNumber<darkModeAnsiColors.length) {
          colorRGBAInt = switch(Chalk.defaultHtmlBasicANSIColorSet) {
                              ChalkAnsiColorSet.darkBackground => darkModeAnsiColors[colorIndex],
                              ChalkAnsiColorSet.lightBackground => lightModeAnsiColors[colorIndex],
                              ChalkAnsiColorSet.highContrast => highContrastModeAnsiColors[colorIndex] };
          return makeCSSColorString(rgbAsInt:colorRGBAInt) ?? 'cyan';
      }
      return 'orange';
    } else if (ansiColorNumber >= 16 && ansiColorNumber <= 231) {
      // Converts to one of 216 RGB colors.
      ansiColorNumber -= 16;

      num blue = ansiColorNumber % 6;
      ansiColorNumber = (ansiColorNumber - blue) / 6;
      num green = ansiColorNumber % 6;
      ansiColorNumber = (ansiColorNumber - green) / 6;
      num red = ansiColorNumber;

      // Red, green, blue now range on [0, 5], need to map to [0,255].
      const num convFactor = 255 / 5;
      blue = (blue * convFactor).round();
      green = (green * convFactor).round();
      red = (red * convFactor).round();

      return _useShortColors ? _rgbToCssHex(red.toInt(),green.toInt(),blue.toInt())
                                : 'rgb(${red.toInt()}, ${green.toInt()}, ${blue.toInt()})';
    } else if (ansiColorNumber >= 232 && ansiColorNumber <= 255) {
      // Converts to a grayscale value.
      ansiColorNumber -= 232;
      final int colorLevel = (ansiColorNumber / 23 * 255).round();
      return _useShortColors ? _rgbToCssHex(colorLevel, colorLevel, colorLevel)
                                : 'rgb($colorLevel, $colorLevel, $colorLevel)';
    } else {
      return 'purple';  // RETURN CSS 'red' when we have a erroneous value
    }
  }

  static String set24BitAnsiColor(int red, int green, int blue) {
     return _useShortColors ? _rgbToCssHex(red,green,blue)
                              : 'rgb($red, $green, $blue)';
  }

/// Convert the passed in rgbcolor int value to a CSS 'rgb(r,g,b)' string.
  /// The passed [rgbcolor] int can be null, in which case the fallback
  /// passed in [colorAsString] is returned (this could also be null,
  /// but in cases of swapping foreground/background colors for the inverse
  /// operation is is the previously computed rgb string for the colors).
  static String? makeCSSColorString({int? rgbAsInt, String? colorAsString}) {
    if (rgbAsInt == null) {
      return colorAsString ?? 'red'; // Caller may have passed color as string - not indicate ERROR by returning red
    }
    return _useShortColors ? _rgbToCssHex((rgbAsInt >> 16) & 0xFF,(rgbAsInt >> 8) & 0xFF,rgbAsInt & 0xFF)
                    : 'rgb(${(rgbAsInt >> 16) & 0xFF},${(rgbAsInt >> 8) & 0xFF},${rgbAsInt & 0xFF})';
  }


  static ChalkHTMLStyleInfo getHTMLStyleFromANSICode( List<int> codes ) {
    List<String> styleNames = [];
    String? customFgColor;
    String? customBgColor;
    String? customUnderlineColor;
    bool colorsInverted = false;

    //
    // * Change the foreground or background color by clearing the current color
    // * and adding the new one.
    // * @param colorType If `'foreground'`, will change the foreground color, if
    // * 	`'background'`, will change the background color, and if `'underline'`
    // * will set the underline color.
    // * @param color Color to change to. If `undefined` or not provided,
    // * will clear current color without adding a new one.
    //
    void changeColor(String colorType, String? color) {
      if (colorType == 'foreground') {
        customFgColor = color;
      } else if (colorType == 'background') {
        customBgColor = color;
      } else if (colorType == 'underline') {
        customUnderlineColor = color;
      }
      styleNames.remove('ansi-$colorType-colored');
      if (color != null) {
        styleNames.add('ansi-$colorType-colored');
      }
    }

    //
    // * Calculate and set styling for basic bright and dark ANSI color codes. Uses
    // * theme colors if available. Automatically distinguishes between foreground
    // * and background colors; does not support color-clearing codes 39 and 49.
    // * @param styleCode Integer color code on one of the following ranges:
    // * [30-37, 90-97, 40-47, 100-107]. If not on one of these ranges, will do
    // * nothing.
    //
    void setBasicColor(int styleCode) {
      String? colorType;//: 'foreground' | 'background' | undefined;
      int? colorIndex; //: number | undefined;

      if (styleCode >= 30 && styleCode <= 37) {
        colorIndex = styleCode - 30;
        colorType = 'foreground';
      } else if (styleCode >= 90 && styleCode <= 97) {
        colorIndex = (styleCode - 90) + 8; // High-intensity (bright)
        colorType = 'foreground';
      } else if (styleCode >= 40 && styleCode <= 47) {
        colorIndex = styleCode - 40;
        colorType = 'background';
      } else if (styleCode >= 100 && styleCode <= 107) {
        colorIndex = (styleCode - 100) + 8; // High-intensity (bright)
        colorType = 'background';
      }

      if (colorIndex != null && colorType != null) {
        //const colorName = darkModeAnsiColors[colorIndex];
        int? colorRGBAInt;
        if(colorIndex>=0 && colorIndex<darkModeAnsiColors.length) {
          colorRGBAInt = switch(Chalk.defaultHtmlBasicANSIColorSet) {
                              ChalkAnsiColorSet.darkBackground => darkModeAnsiColors[colorIndex],
                              ChalkAnsiColorSet.lightBackground => lightModeAnsiColors[colorIndex],
                              ChalkAnsiColorSet.highContrast => highContrastModeAnsiColors[colorIndex] };
        }
        changeColor(colorType, makeCSSColorString(rgbAsInt:colorRGBAInt));
      }
    }


    for(int code in codes) {
      switch (code) {
        case 0: {  // reset (everything)
          // Add our `SPECIALFLAG-reset-everything` class to signal to Chalk parent/child style combiner that parent
          // style list and all colors and EVERYTHING needs to be ignored
          styleNames.remove('SPECIALFLAG-reset-everything');
					styleNames.add('SPECIALFLAG-reset-everything');

          styleNames = [];
          customFgColor = null;
          customBgColor = null;
          break;
        }
        case 1: { // bold
          styleNames.remove('ansi-bold');
          styleNames.add('ansi-bold');
          break;
        }
        case 2: { // dim
          styleNames.remove('ansi-dim');
          styleNames.add('ansi-dim');
          break;
        }
        case 3: { // italic
          styleNames.remove('ansi-italic');
          styleNames.add('ansi-italic');
          break;
        }
				case 4: { // underline
          styleNames.remove('ansi-underline');
          styleNames.remove('ansi-double-underline');
					styleNames.add('ansi-underline');
					break;
				}
				case 5: { // blink
					styleNames.remove('ansi-blink');
					styleNames.add('ansi-blink');
					break;
				}
				case 6: { // rapid blink
					styleNames.remove('ansi-rapid-blink');
					styleNames.add('ansi-rapid-blink');
					break;
				}
				case 7: { // invert foreground and background
          // Add our `ansi-invert-colors` class - This will use our custom CSS variables to invert the colors
          styleNames.remove('ansi-invert-colors');
					styleNames.add('ansi-invert-colors');
          // WE DONT ACTUALLY SWAP/INVERT the colors now - Chalk will do it AFTER it merges parent and child
					//WE DONT DO CAUSE Chalk WILL SWAP/INVERT AFTER MERGING WITH PARENT//KLUDGE WE WILL NEED THIS IF WE ARE USING TO MAKE ANSI PARSER//if (!colorsInverted) {
					//WE DONT DO CAUSE Chalk WILL SWAP/INVERT AFTER MERGING WITH PARENT//KLUDGE WE WILL NEED THIS IF WE ARE USING TO MAKE ANSI PARSER//	colorsInverted = true;
					//WE DONT DO CAUSE Chalk WILL SWAP/INVERT AFTER MERGING WITH PARENT//KLUDGE WE WILL NEED THIS IF WE ARE USING TO MAKE ANSI PARSER//	reverseForegroundAndBackgroundColors();
					//WE DONT DO CAUSE Chalk WILL SWAP/INVERT AFTER MERGING WITH PARENT//KLUDGE WE WILL NEED THIS IF WE ARE USING TO MAKE ANSI PARSER//}
					break;
				}
				case 8: { // hidden
					styleNames.remove('ansi-hidden');
					styleNames.add('ansi-hidden');
					break;
				}
				case 9: { // strike-through/crossed-out
					styleNames.remove('ansi-strike-through');
					styleNames.add('ansi-strike-through');
					break;
				}
				case 10: { // normal default font
          styleNames.removeWhere((entry) => entry.startsWith('ansi-font'));
          // Add our `SPECIALFLAG-font-reset` class to signal to Chalk parent/child style combiner that parent
          // style list needs to have all fonts removed.
          styleNames.remove('SPECIALFLAG-font-reset');
					styleNames.add('SPECIALFLAG-font-reset');
					break;
				}
				case 11: case 12: case 13: case 14: case 15: case 16: case 17: case 18: case 19: case 20: { // font codes (and 20 is 'blackletter' font code)
          styleNames.removeWhere((entry) => entry.startsWith('ansi-font'));
					styleNames.add('ansi-font-${code - 10}');
					break;
				}
				case 21: { // double underline
           styleNames.removeWhere((entry) => (entry=='ansi-underline' || entry=='ansi-double-underline'));
					styleNames.add('ansi-double-underline');
					break;
				}
				case 22: { // normal intensity (bold off and dim off)
          styleNames.removeWhere((entry) => (entry=='ansi-bold' || entry=='ansi-dim'));
          // Add our `SPECIALFLAG-normal-intensity` class to signal to Chalk parent/child style combiner that parent
          // style list needs to have all 'ansi-bold' and entry=='ansi-dim' removed.
					styleNames.remove('SPECIALFLAG-normal-intensity');
					styleNames.add('SPECIALFLAG-normal-intensity');
					break;
				}
				case 23: { // Neither italic or blackletter (font 10)
          styleNames.removeWhere((entry) => (entry=='ansi-italic' || entry=='ansi-font-10'));
          // Add our `SPECIALFLAG-neither-italic-or-font-10` class to signal to Chalk parent/child style combiner that parent
          // style list needs to have 'ansi-italic' and 'ansi-font-10' removed.
					styleNames.remove('SPECIALFLAG-neither-italic-or-font-10');
					styleNames.add('SPECIALFLAG-neither-italic-or-font-10');
					break;
				}
				case 24: { // not underlined (Neither singly nor doubly underlined)
          styleNames.removeWhere((entry) => (entry=='ansi-underline' || entry=='ansi-double-underline'));
          // Add our `SPECIALFLAG-underline-reset` class to signal to Chalk parent/child style combiner that parent
          // style list needs to have 'ansi-underline' and 'ansi-double-underline' removed.
					styleNames.remove('SPECIALFLAG-underline-reset');
					styleNames.add('SPECIALFLAG-underline-reset');
					break;
				}
				case 25: { // not blinking
          styleNames.removeWhere((entry) => (entry=='ansi-blink' || entry=='ansi-rapid-blink'));
          // Add our `SPECIALFLAG-not-blinking` class to signal to Chalk parent/child style combiner that parent
          // style list needs to have 'ansi-blink' and 'ansi-rapid-blink' removed.
					styleNames.remove('SPECIALFLAG-not-blinking');
					styleNames.add('SPECIALFLAG-not-blinking');
					break;
				}
				case 27: { // not reversed/inverted
          // Add our `ansi-invert-colors` class to signal to Chalk parent/child style combiner that
          // colors should NOT be inverted
					styleNames.remove('SPECIALFLAG-not-invert-colors');
					styleNames.add('SPECIALFLAG-not-invert-colors');
          // WE DONT ACTUALLY SWAP/INVERT the colors now - Chalk will do it AFTER it merges parent and child
					//WE DONT DO CAUSE Chalk WILL SWAP/INVERT AFTER MERGING WITH PARENT//KLUDGE WE WILL NEED THIS IF WE ARE USING TO MAKE ANSI PARSER//if (colorsInverted) {
					//WE DONT DO CAUSE Chalk WILL SWAP/INVERT AFTER MERGING WITH PARENT//KLUDGE WE WILL NEED THIS IF WE ARE USING TO MAKE ANSI PARSER//	colorsInverted = false;
					//WE DONT DO CAUSE Chalk WILL SWAP/INVERT AFTER MERGING WITH PARENT//KLUDGE WE WILL NEED THIS IF WE ARE USING TO MAKE ANSI PARSER//	reverseForegroundAndBackgroundColors();
					//WE DONT DO CAUSE Chalk WILL SWAP/INVERT AFTER MERGING WITH PARENT//KLUDGE WE WILL NEED THIS IF WE ARE USING TO MAKE ANSI PARSER//}
					break;
				}
				case 28: { // not hidden (reveal)
					styleNames.remove('ansi-hidden');
          // Add our `SPECIALFLAG-not-hidden` class to signal to Chalk parent/child style combiner
					styleNames.remove('SPECIALFLAG-not-hidden');
					styleNames.add('SPECIALFLAG-not-hidden');
					break;
				}
				case 29: { // not crossed-out
					styleNames.remove('ansi-strike-through');
          // Add our `SPECIALFLAG-not-strike-through` class to signal to Chalk parent/child style combiner
					styleNames.remove('SPECIALFLAG-not-strike-through');
					styleNames.add('SPECIALFLAG-not-strike-through');
					break;
				}
				case 53: { // overlined
					styleNames.remove('ansi-overline');
					styleNames.add('ansi-overline');
					break;
				}
				case 55: { // not overlined
					styleNames.remove('ansi-overline');
          // Add our `SPECIALFLAG-not-overline` class to signal to Chalk parent/child style combiner to remove 'ansi-overline'
					styleNames.remove('SPECIALFLAG-not-overline');
					styleNames.add('SPECIALFLAG-not-overline');
					break;
				}
				case 39: {  // default foreground color
					styleNames.remove('SPECIALFLAG-default-foreground');
					styleNames.add('SPECIALFLAG-default-foreground');
					changeColor('foreground', null);
					break;
				}
				case 49: {  // default background color
					styleNames.remove('SPECIALFLAG-default-background');
					styleNames.add('SPECIALFLAG-default-background');
					changeColor('background', null);
					break;
				}
				case 59: {  // default underline color
					styleNames.remove('SPECIALFLAG-default-underlinecolor');
					styleNames.add('SPECIALFLAG-default-underlinecolor');
					changeColor('underline', null);
					break;
				}
				case 73: { // superscript
          styleNames.removeWhere((entry) => (entry=='ansi-superscript' || entry=='ansi-subscript'));
					styleNames.add('ansi-superscript');
					break;
				}
				case 74: { // subscript
          styleNames.removeWhere((entry) => (entry=='ansi-superscript' || entry=='ansi-subscript'));
					styleNames.add('ansi-subscript');
					break;
				}
				case 75: { // neither superscript or subscript
          styleNames.removeWhere((entry) => (entry=='ansi-superscript' || entry=='ansi-subscript'));
          // Add our `SPECIALFLAG-reset-super-subscript` class to signal to Chalk parent/child style combiner to
          // remove 'ansi-superscript' and entry=='ansi-subscript'
					styleNames.remove('SPECIALFLAG-reset-super-subscript');
					styleNames.add('SPECIALFLAG-reset-super-subscript');
					break;
				}
				default: {
					setBasicColor(code);
					break;
				}
			}
		}
    return ChalkHTMLStyleInfo(styleNames:styleNames, customFgColor:customFgColor, customBgColor:customBgColor, customUnderlineColor:customUnderlineColor, colorsInverted:colorsInverted );
  }

  /// Returns a <span class="..." style="...."> open tag which renders the style specified by the ChalkHTMLStyleInfo
  static String makeHTMLSpanFromInfo( ChalkHTMLStyleInfo info ) {
    String outStyle = '';
    String outFGBGCssVariables = ''; // these are use to track fg/bg color across all spans so that we can handle INVERT
    if(info.customFgColor!=null) {
      outStyle += 'color:${info.customFgColor};';
      outFGBGCssVariables += '--fg:${info.customFgColor};';
    }
    if(info.customBgColor!=null) {
      outStyle += 'background-color:${info.customBgColor};';
      outFGBGCssVariables += '--bg:${info.customBgColor};';
    }
    if(info.customUnderlineColor!=null) {
      outStyle += 'text-decoration-color:${info.customUnderlineColor};';
    }

    String classAttrib='';
    if(info.styleNames!=null && info.styleNames!.isNotEmpty) {
      classAttrib = ' class="ansi ${info.styleNames!.join(' ')}"';
    } else {
      classAttrib = ' class="ansi"';
    }
    
    return '<span$classAttrib style="$outStyle$outFGBGCssVariables">';
  }


  static final RegExp _extractSpanRegex = RegExp(r'style="([^"]*)"');
  static final RegExp _extractClassRegex = RegExp(r'class="([^"]*)"');

/* OBSOLETE
  final RegExp replaceSpanClassRegex = RegExp(r'(?<=class=")[^"]*(?=")');
  final RegExp replaceSpanStyleRegex = RegExp(r'(?<=style=")[^"]*(?=")');
OBSOLETE */
/*OBSOLETE
  String removeCssAttributes(String styleString, List<String> attributesToRemove) {
    String result = styleString;
    for (String attribute in attributesToRemove) {
      String regExStr = '(?<!-)$attribute\\s*:\\s*[^;]+;+\\s*';
      final RegExp removeCSSAttributeRegex = RegExp(regExStr);
      result = result.replaceAll(removeCSSAttributeRegex, '');
    }
    return result.trim().replaceAll(RegExp(r';+$'), ''); // Remove trailing semicolons
  }
OBSOLETE*/

  static String? _extractCssAttribute(String styleString, String attributeName, {bool includeSemicolonInReturn = false}) {

    String regExStr='(?<!-)$attributeName\\s*:\\s*([^;]+)(;|\$)';

//print('extractCssAttribute() styleString=`$styleString` regExStr=`$regExStr`');

    final RegExp extractCSSAttributerRegex = RegExp(regExStr);
    final Match? match = extractCSSAttributerRegex.firstMatch(styleString);

//print('match=$match');
    if (match != null) {
      final p1 = match.group(1)?.trim();
      if( includeSemicolonInReturn ) {
        final p2 = match.group(2)?.trim(); // this is the semicolor on not..
        return (p1 ?? '')+(p2 ?? '');
      } else {
        return (p1 ?? '');
      }
    }
    return null;
  }

/* OBSOLETE
  String replaceCssAttribute(String styleString, String attributeName, String newValue) {


    //print('replaceCssAttribute(styleString=$styleString  attributeName=$attributeName   newValue=$newValue');

    String regExStr = '(?<!-)$attributeName\\s*:\\s*([^;]+)(;|\$)';
    final RegExp extractCSSAttributerRegex = RegExp(regExStr);
    final Match? match = extractCSSAttributerRegex.firstMatch(styleString);

    if (match != null) {
      return styleString.replaceRange(
        match.start,
        match.end,
        '$attributeName: $newValue',
      );
    } else {
      if (styleString.isNotEmpty) {
        return '$styleString $attributeName: $newValue';
      } else {
        return '$attributeName: $newValue';
      }
    }
  }
OBSOLETE */

  static String _extractSpanStyle(String htmlSpan) {
    final Match? match = _extractSpanRegex.firstMatch(htmlSpan);

    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    } else {
      return '';
    }
  }

  static String _extractSpanClass(String htmlSpan) {
    final Match? match = _extractClassRegex.firstMatch(htmlSpan);

    if (match != null && match.groupCount > 0) {
      return match.group(1)?.trim() ?? '';
    } else {
      return '';
    }
  }


/* USING SMARTER VERSIONS that can insert style/class also...
  String? extractAndReplaceSpanStyle(String htmlSpan, String replacement) {
    final Match? match = replaceSpanStyleRegex.firstMatch(htmlSpan);

    if (match != null) {
      return htmlSpan.replaceRange(match.start, match.end, replacement);
    } else {
      return null;
    }
  }

String? extractAndReplaceSpanClass(String htmlSpan, String replacement) {
  final Match? match = replaceSpanClassRegex.firstMatch(htmlSpan);

  if (match != null) {
    return htmlSpan.replaceRange(match.start, match.end, replacement);
  } else {
    return null;
  }
}
*/
/* OBSOLETE

  String extractAndReplaceSpanStyle(String htmlSpan, String replacement) {
    final Match? existingStyleMatch = replaceSpanStyleRegex.firstMatch(htmlSpan);

    if (existingStyleMatch != null) {
      return htmlSpan.replaceRange(existingStyleMatch.start, existingStyleMatch.end, replacement);
    } else {
      final RegExp spanTagRegex = RegExp(r'<span(?=[ >])');
      final Match? spanTagMatch = spanTagRegex.firstMatch(htmlSpan);

      if (spanTagMatch != null) {
        return htmlSpan.replaceRange(spanTagMatch.end, spanTagMatch.end, ' style="$replacement"');
      } else {
        return htmlSpan; // Return original if no span tag is found.
      }
    }
  }

  String extractAndReplaceSpanClass(String htmlSpan, String replacement) {
    final Match? existingClassMatch = replaceSpanClassRegex.firstMatch(htmlSpan);

    if (existingClassMatch != null) {
      return htmlSpan.replaceRange(existingClassMatch.start, existingClassMatch.end, replacement);
    } else {
      final RegExp spanTagRegex = RegExp(r'<span(?=[ >])');
      final Match? spanTagMatch = spanTagRegex.firstMatch(htmlSpan);

      if (spanTagMatch != null) {
        return htmlSpan.replaceRange(spanTagMatch.end, spanTagMatch.end, ' class="$replacement"');
      } else {
        return htmlSpan; // Return original if no span tag is found.
      }
    }
  }

  String extractAndAddSpanStyle(String htmlSpan, String newStyle) {
    final Match? existingStyleMatch = replaceSpanStyleRegex.firstMatch(htmlSpan);

    if (existingStyleMatch != null) {
      final existingStyle = existingStyleMatch.group(0);
      return htmlSpan.replaceRange(
        existingStyleMatch.start,
        existingStyleMatch.end,
        '$existingStyle; $newStyle',
      );
    } else {
      final RegExp spanTagRegex = RegExp(r'<span(?=[ >])');
      final Match? spanTagMatch = spanTagRegex.firstMatch(htmlSpan);

      if (spanTagMatch != null) {
        return htmlSpan.replaceRange(
          spanTagMatch.end,
          spanTagMatch.end,
          ' style="$newStyle"',
        );
      } else {
        return htmlSpan;
      }
    }
  }

  String extractAndAddSpanClass(String htmlSpan, String newClassList) {
    final Match? existingClassMatch = replaceSpanClassRegex.firstMatch(htmlSpan);

    //print('extractAndAddSpanClas  htmlSpan=$htmlSpan     newClass=$newClassList');
    if (existingClassMatch != null) {
      final existingClass = existingClassMatch.group(0) ?? '';


      List<String> existingClasses = existingClass.split(spacesRegEx);
      List<String> newClasses = newClassList.split(spacesRegEx);

//print('existingClasses=$existingClasses');
//print('newClasses=$newClasses');

      for(var newclass in newClasses) {
        newclass = newclass.trim();
        if(newclass.isNotEmpty && !existingClasses.contains(newclass)) {
          existingClasses.add(newclass);
        }
      }
      String combinedClasses = existingClasses.join(' ');

      //print('extractAndAddSpanClass  combinedClasses=$combinedClasses');

      final out = htmlSpan.replaceRange(
        existingClassMatch.start,
        existingClassMatch.end,
        combinedClasses,
      );

      //print('extractAndAddSpanClass() out=`$out`');
      return out;
    } else {
      final RegExp spanTagRegex = RegExp(r'<span(?=[ >])');
      final Match? spanTagMatch = spanTagRegex.firstMatch(htmlSpan);

      if (spanTagMatch != null) {
        String out = htmlSpan.replaceRange(
          spanTagMatch.end,
          spanTagMatch.end,
          ' class="$newClassList"',
        );

        //print('extractAndAddSpanClass() out=`$out`');
        return out;

      } else {
        return htmlSpan;
      }
    }
  }
OBSOLETE */
/*OBSOLETE
  String setUnderlineColor(String styleString, String color) {
      // text-decoration-color only works if text-decoration is set.
      // so we will add text-decoration: underline; if it does not exist.
      if (extractCssAttribute(styleString, 'text-decoration') == null){
          styleString = replaceCssAttribute(styleString, 'text-decoration', 'underline');
      }
    return replaceCssAttribute(styleString, 'text-decoration-color', color);
  }
OBSOLETE */
/* OBS
  /// Custom Ansi foreground color (or null if none).
  String? _customFgColor;

  /// Custom Ansi background color (or null if none).
  String? _customBgColor;

  /// Custom Ansi underline color (or null if none).
  String? _customUnderlineColor;

  /// Have foreground and background colors been reversed ?
  bool _colorsInverted = false;

  List<String> _customStyles = [];
OBS*/

/*OBSOLETE
  /// Set the member variable corresponding to [colorType] to the css
  /// 'rgb(...)' color string computed from [rgbcolor] (or specified by
  /// [colorAsString]).
  /// [colorType] can be `'foreground'`,`'background'` or `'underline'`
  /// if [rgbcolor] is null then [colorAsString] will attempt to be used, if both
  /// are null then the corresponding color will be reset/cleared.
  void changeSpecifiedCustomColor(String colorType, int? rgbcolor,
      [String? colorAsString]) {
    if (colorType == 'foreground') {
      _customFgColor = ChalkHTML.makeCSSColorString(rgbAsInt:rgbcolor, colorAsString:colorAsString);
    } else if (colorType == 'background') {
      _customBgColor = ChalkHTML.makeCSSColorString(rgbAsInt:rgbcolor, colorAsString:colorAsString);
    } else if (colorType == 'underline') {
      _customUnderlineColor = ChalkHTML.makeCSSColorString(rgbAsInt:rgbcolor, colorAsString:colorAsString);
    }
  }
OBSOLETE */
/* OBSOLETE?????
  /// Swap foregfrouned and background colors.  Used for color inversion.
  /// Caller should check [_colorsInverted] flag to make sure it is appropriate
  /// to turn ON or OFF (if it is already inverted don't call.
  void reverseForegroundAndBackgroundColors() {
    final String? oldFgColor = _customFgColor;
    changeSpecifiedCustomColor('foreground', null,
        _customBgColor); // We have strings already, so pass those.
    changeSpecifiedCustomColor('background', null, oldFgColor);
  }
OBSOLETE?? */
  //OBSOLETEstatic bool doneit=false;

  static RegExp spacesRegEx = RegExp(r'\s+');

  static ChalkHTMLStyleInfo convertHTMLSpanToChalkHTMLStyleInfo( String thisSpan ) {
    String? thisForeground;
    String? thisBackground; 
    String? thisUnderline; 

    String existingStyle = _extractSpanStyle(thisSpan);
    //print('   EXTRACT existingStyle=`$existingStyle`');
    if(existingStyle.isNotEmpty) {
      thisForeground = _extractCssAttribute( existingStyle, 'color' );
      thisBackground = _extractCssAttribute( existingStyle, 'background-color' );
      thisUnderline = _extractCssAttribute( existingStyle, 'text-decoration-color' );
      //print('thisForeground=`$thisForeground` thisBackground=`$thisBackground` thisUnderline=`$thisUnderline`');
    }

    final String thisClassesRawClassList = _extractSpanClass(thisSpan);
    List<String> thisClassesStyleNames = thisClassesRawClassList.split(spacesRegEx);

    // remove any space or empty entries
    thisClassesStyleNames.remove('');
    thisClassesStyleNames.remove(' ');

    return ChalkHTMLStyleInfo(styleNames:thisClassesStyleNames, customFgColor:thisForeground,
                                    customBgColor:thisBackground, customUnderlineColor:thisUnderline );
  }

  /// Add styleClass to existing class list 
  /// returns THE COMBINED ChalkHTMLStyleInfo of the parent and child
  static ChalkHTMLStyleInfo combineParentHtmlInfoAndThisInfo( ChalkHTMLStyleInfo? parentInfo, ChalkHTMLStyleInfo childInfo ) {
    late ChalkHTMLStyleInfo combinedChildPresidentInfo;
    if(parentInfo!=null) {
      combinedChildPresidentInfo = ChalkHTMLStyleInfo(styleNames: [... (parentInfo.styleNames ?? []) ],  // COPY THE LIST HERE
                                                        customFgColor:parentInfo.customFgColor,
                                                        customBgColor:parentInfo.customBgColor,
                                                        customUnderlineColor:parentInfo.customUnderlineColor,
                                                        colorsInverted:parentInfo.colorsInverted );
    } else {
      // should never happen in practice, but could if they switched to html mode late...
      combinedChildPresidentInfo = ChalkHTMLStyleInfo(styleNames:[]);
    }

    // we start with the state of the parent INVERSION - if the child inverts the colors and the PARENT already had them inverted then THAT IS A NO-OP
    // and likewise if the parent has them NOTINVERTED and the child turns INVESION OFF then THAT is a NO-OP
    bool childShouldInvertedColors = combinedChildPresidentInfo.colorsInverted;  

    // we start with the parent style names
    List<String> styleNames = combinedChildPresidentInfo.styleNames ?? [];
    // remove any SPECIALFLAG-xxx entries from parent list, we don't care about those
    /*  ASKJKLJKLJSDstyleNames.remove  Where((entry) => entry.startsWith('SPECIALFLAG')); */

    styleNames.remove('ansi'); // we always add this first
    // to make things smaller remove these NO-OP classes for foreground and background
    styleNames.remove('ansi-foreground-colored');
    styleNames.remove('ansi-background-colored');


    if(childInfo.styleNames!=null || childInfo.styleNames!.isNotEmpty) {
      for(final addStyleClassName in childInfo.styleNames!) {
        switch( addStyleClassName ) {
          case 'ansi' || 'ansi-foreground-colored' || 'ansi-background-colored':
            // WE DO NOTHING WITH THESE, we don't want them in our new list (we just removed them above) - `ansi` will get inserted automatically when making span
            break;
          case 'SPECIALFLAG-reset-everything':
            // so right now, at this POINT, we RESET EVERYTHING in our combined list - and then possibly continue to add to it
            // we also reset all of the combined colors (which currently are really only the parents colors)
            styleNames.clear();
            combinedChildPresidentInfo.customFgColor = null;
            combinedChildPresidentInfo.customBgColor = null;
            combinedChildPresidentInfo.customUnderlineColor = null;
            styleNames.add(addStyleClassName);
            break;

          case 'ansi-bold' || 'ansi-dim' || 'ansi-italic' || 'ansi-blink' || 'ansi-rapid-blink' || 'ansi-hidden' ||
                  'ansi-strike-through' || 'ansi-overline':
            styleNames.remove(addStyleClassName);  // remove it if it is already there
            styleNames.add(addStyleClassName);   // and add it to the end.
            break;
          case 'ansi-underline' || 'ansi-double-underline':
            styleNames.remove('ansi-underline');
            styleNames.remove('ansi-double-underline');
            styleNames.add(addStyleClassName);
            break;
          case 'SPECIALFLAG-font-reset': // normal default font
            // This is just a flag to REMOVE all fonts from parent class list, we don't actually add this class to our list
            styleNames.removeWhere((entry) => entry.startsWith('ansi-font'));
            styleNames.add(addStyleClassName);
            break;
          case 'ansi-font-1' || 'ansi-font-2' || 'ansi-font-3' || 'ansi-font-4' || 'ansi-font-5' || 'ansi-font-6' ||
                  'ansi-font-7' || 'ansi-font-8' || 'ansi-font-9' || 'ansi-font-10':
            styleNames.removeWhere((entry) => entry.startsWith('ansi-font'));
            styleNames.add(addStyleClassName);
            break;
          case 'SPECIALFLAG-normal-intensity':  // normal intensity (bold off and dim off)
            // This is just a flag to REMOVE 'ansi-bold' and entry=='ansi-dim' from parent class list, we don't actually add this class to our list
            styleNames.removeWhere((entry) => (entry=='ansi-bold' || entry=='ansi-dim'));
            styleNames.add(addStyleClassName);
            break;
          case 'SPECIALFLAG-neither-italic-or-font-10': // Neither italic or blackletter (font 10)
            // This is just a flag to REMOVE 'ansi-italic' and entry=='ansi-font-10' from parent class list, we don't actually add this class to our list
            styleNames.removeWhere((entry) => (entry=='ansi-italic' || entry=='ansi-font-10'));
            styleNames.add(addStyleClassName);
            break;
          case 'ansi-invert-colors':
            // Our special flag to signal to invert colors - we return this flag as our RETURN value to signal to caller to swap colors
            // after combining child and parent
            if (!childShouldInvertedColors) {
              childShouldInvertedColors = true;
            }
            styleNames.add(addStyleClassName);
            break;
          case 'SPECIALFLAG-underline-reset': // not underlined (Neither singly nor doubly underlined)
            // Our special flag to signal to remove 'ansi-underline' and 'ansi-double-underline', we don't actually add this class to our list
            styleNames.removeWhere((entry) => (entry=='ansi-underline' || entry=='ansi-double-underline'));
            styleNames.add(addStyleClassName);
            break;
          case 'SPECIALFLAG-not-blinking': // not blinking
            // Our special flag to signal to remove 'ansi-blink' and 'ansi-blink', we don't actually add this class to our list
            styleNames.removeWhere((entry) => (entry=='ansi-blink' || entry=='ansi-blink'));
            styleNames.add(addStyleClassName);
            break;
          case 'SPECIALFLAG-not-invert-colors':
            // Our special flag to signal to NOT invert colors - we return this flag as our RETURN value to signal to caller to NOT invert/swap colors
            // after combining child and parent
            if (childShouldInvertedColors) {
              childShouldInvertedColors = false;
            }
            styleNames.add(addStyleClassName);

          case 'SPECIALFLAG-not-hidden': // not hidden (reveal)
            // Our special flag to signal to remove 'ansi-hidden', we don't actually add this class to our list
            styleNames.remove('ansi-hidden');
            styleNames.add(addStyleClassName);
            break;
          case 'SPECIALFLAG-not-strike-through': // not crossed-out
            // Our special flag to signal to remove 'ansi-strike-through', we don't actually add this class to our list
            styleNames.remove('ansi-strike-through');
            styleNames.add(addStyleClassName);
            break;
          case 'SPECIALFLAG-not-overline': // not overlined
            // Our special flag to signal to remove 'ansi-overline', we don't actually add this class to our list
            styleNames.remove('ansi-overline');
            styleNames.add(addStyleClassName);
  					break;
          case 'SPECIALFLAG-default-foreground':// default foreground color
            // special flag to reset foreground color
            combinedChildPresidentInfo.customFgColor = null;
            styleNames.add(addStyleClassName);
  					break;
          case 'SPECIALFLAG-default-background': // default background color
            // special flag to reset background color
            combinedChildPresidentInfo.customBgColor = null;
            styleNames.add(addStyleClassName);
  					break;
          case 'SPECIALFLAG-default-underlinecolor': // default underline color
            // special flag to reset underline color
            combinedChildPresidentInfo.customUnderlineColor = null;
            styleNames.add(addStyleClassName);
  					break;
  				case 'ansi-superscript' || 'ansi-subscript': // superscript/subscript
            styleNames.removeWhere((entry) => (entry=='ansi-superscript' || entry=='ansi-subscript'));
            styleNames.add(addStyleClassName);
            break;
         case 'SPECIALFLAG-reset-super-subscript':
            // Our special flag to reset 'ansi-superscript' and entry=='ansi-subscript'
            styleNames.removeWhere((entry) => (entry=='ansi-superscript' || entry=='ansi-subscript'));
					  break;
          case _: 
            // and if nothing else we pass the class along
            styleNames.remove(addStyleClassName);  // remove it if it is already there
            styleNames.add(addStyleClassName);  
            break;
        }
      }
    }

    // set them back
    combinedChildPresidentInfo.styleNames = styleNames;

    // Now we need to COMBINE the parent and child colors...
    if(childInfo.customFgColor!=null) {
      combinedChildPresidentInfo.customFgColor = childInfo.customFgColor;
    }
    if(childInfo.customBgColor!=null) {
      combinedChildPresidentInfo.customBgColor = childInfo.customBgColor;
    }
    if(childInfo.customUnderlineColor!=null) {
      combinedChildPresidentInfo.customUnderlineColor = childInfo.customUnderlineColor;
    }

    if( childShouldInvertedColors ) {
      // INVERT the colors as we have them now
      String? oldFg = combinedChildPresidentInfo.customFgColor;
      combinedChildPresidentInfo.customFgColor = combinedChildPresidentInfo.customBgColor;
      combinedChildPresidentInfo.customBgColor = oldFg;
    }
    combinedChildPresidentInfo.colorsInverted = childShouldInvertedColors;

    return combinedChildPresidentInfo;
  }





/*


	/**
	 * Calculate and set styling for complicated 24-bit ANSI color codes.
	 * @param styleCodes Full list of integer codes that make up the full ANSI
	 * sequence, including the two defining codes and the three RGB codes.
	 * @param colorType If `'foreground'`, will set foreground color, if
	 * `'background'`, will set background color, and if it is `'underline'`
	 * will set the underline color.
	 * @see {@link https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit }
	 */
	function set24BitColor(styleCodes: number[], colorType: 'foreground' | 'background' | 'underline'): void {
		if (styleCodes.length >= 5 &&
			styleCodes[2] >= 0 && styleCodes[2] <= 255 &&
			styleCodes[3] >= 0 && styleCodes[3] <= 255 &&
			styleCodes[4] >= 0 && styleCodes[4] <= 255) {
			const customColor = new RGBA(styleCodes[2], styleCodes[3], styleCodes[4]);
			changeColor(colorType, customColor);
		}
	}

	/**
	 * Calculate and set styling for advanced 8-bit ANSI color codes.
	 * @param styleCodes Full list of integer codes that make up the ANSI
	 * sequence, including the two defining codes and the one color code.
	 * @param colorType If `'foreground'`, will set foreground color, if
	 * `'background'`, will set background color and if it is `'underline'`
	 * will set the underline color.
	 * @see {@link https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit }
	 */
	function set8BitColor(styleCodes: number[], colorType: 'foreground' | 'background' | 'underline'): void {
		let colorNumber = styleCodes[2];
		const color = calcANSI8bitColor(colorNumber);

		if (color) {
			changeColor(colorType, color);
		} else if (colorNumber >= 0 && colorNumber <= 15) {
			if (colorType === 'underline') {
				// for underline colors we just decode the 0-15 color number to theme color, set and return
				const theme = themeService.getColorTheme();
				const colorName = ansiColorIdentifiers[colorNumber];
				const color = theme.getColor(colorName);
				if (color) {
					changeColor(colorType, color.rgba);
				}
				return;
			}
			// Need to map to one of the four basic color ranges (30-37, 90-97, 40-47, 100-107)
			colorNumber += 30;
			if (colorNumber >= 38) {
				// Bright colors
				colorNumber += 52;
			}
			if (colorType === 'background') {
				colorNumber += 10;
			}
			setBasicColor(colorNumber);
		}
	}
*/


  // Returns the style sheet for our HTML output mode support.  Allows customizing 
  static String getHTMLStyleSheetIncludingColors({required ChalkAnsiColorSet htmlBasicANSIColorSet,
        String? whiteSpaceTreatment, String? foregroundColor, String? backgroundColor,
        String? font1, String? font2, String? font3, String? font4, String? font5,
        String? font6, String? font7, String? font8, String? font9, String? font10} ) {
    // Get the default foreground/background colors based on the current `htmlBasicANSIColorSet`
    //  (if they are not specified we use the values or BLACK and BRIGHT WHITE  based on the current `htmlBasicANSIColorSet`)
    if( foregroundColor==null || backgroundColor==null ) {
      const int blackColorIndex = 0; // ANSI 0 is black we use to index into our ChalkHTML.lightModeAnsiColors/darkModeAnsiColors/highContrastModeAnsiColors tables
      const int whiteColorIndex = 15; // ANSI 15 is bright white (ANSI 7 would be white (dim white)
      switch(htmlBasicANSIColorSet) {
        case ChalkAnsiColorSet.lightBackground:
          foregroundColor ??= ChalkHTML.makeCSSColorString(rgbAsInt:ChalkHTML.lightModeAnsiColors[blackColorIndex]);
          backgroundColor ??= ChalkHTML.makeCSSColorString(rgbAsInt:ChalkHTML.lightModeAnsiColors[whiteColorIndex]);      
        case ChalkAnsiColorSet.darkBackground:
          foregroundColor ??= ChalkHTML.makeCSSColorString(rgbAsInt:ChalkHTML.darkModeAnsiColors[blackColorIndex]);
          backgroundColor ??= ChalkHTML.makeCSSColorString(rgbAsInt:ChalkHTML.darkModeAnsiColors[whiteColorIndex]);      
        case ChalkAnsiColorSet.highContrast:
          foregroundColor ??= ChalkHTML.makeCSSColorString(rgbAsInt:ChalkHTML.highContrastModeAnsiColors[blackColorIndex]);
          backgroundColor ??= ChalkHTML.makeCSSColorString(rgbAsInt:ChalkHTML.highContrastModeAnsiColors[whiteColorIndex]);      
      }
    }
    whiteSpaceTreatment ??= ChalkWhitespaceTreatment.preserve.css;

    return '''  span.ansi { white-space:$whiteSpaceTreatment; }

  /* We always keep these `--bg` and `--fg` CSS variables updated it with current color and background-color
     (since we can't read those from CSS unfortunately). They are only used to allow us to handle the 
     .ansi-invert-colors class.  For systems which may not support css variables the .ansi-invert-colors
     that is the only functionality that will be lost.
  */
  @property --bg {syntax: "<color>";inherits: true;initial-value: $backgroundColor;}
  @property --fg {syntax: "<color>";inherits: true;initial-value: $foregroundColor;}

  .ansi-invert-colors {
    background-color: var(--fg);
    color: var(--bg);
  }

  /* ANSI Codes */
  .ansi-bold	{ font-weight: bold; }
  .ansi-italic	{ font-style: italic; }
  .ansi-underline { text-decoration: underline;  text-decoration-style:solid; }
  .ansi-double-underline { text-decoration: underline;  text-decoration-style:double; }
  .ansi-strike-through { text-decoration:line-through;  text-decoration-style:solid; }
  .ansi-overline { text-decoration:overline;  text-decoration-style:solid; }
  /* because they can exist at same time we need all the possible underline(or double-underline),overline and strike-through combinations */
  .ansi-overline.ansi-underline.ansi-strike-through { text-decoration: overline underline line-through; text-decoration-style:solid; }
  .ansi-overline.ansi-underline { text-decoration: overline underline; text-decoration-style:solid; }
  .ansi-overline.ansi-strike-through { text-decoration: overline line-through; text-decoration-style:solid; }
  .ansi-underline.ansi-strike-through { text-decoration: underline line-through; text-decoration-style:solid; }
  .ansi-overline.ansi-double-underline.ansi-strike-through { text-decoration: overline underline line-through; text-decoration-style:double; }
  .ansi-overline.ansi-double-underline { text-decoration: overline underline; text-decoration-style:double; }
  .ansi-double-underline.ansi-strike-through { text-decoration: underline line-through; text-decoration-style:double; }
  .ansi-dim	{ opacity: 0.4; }
  .ansi-hidden { opacity: 0; }
  .ansi-blink { animation: ansi-blink-key 1s cubic-bezier(1, 0, 0, 1) infinite alternate; }
  .ansi-rapid-blink { animation: ansi-blink-key 0.3s cubic-bezier(1, 0, 0, 1) infinite alternate; }
  @keyframes ansi-blink-key {
    to { opacity: 0.4; }
  }
  .ansi-subscript { vertical-align: sub; font-size: smaller; line-height: normal; }
  .ansi-superscript { vertical-align: super; font-size: smaller; line-height: normal; }
  /**
   * Alternate ansi-font-# classes, note the font-family stacks here are somewhat arbitrary but will resolve to different 'standard' css fonts.
   * ansi-font-10 is called the 'blackletter' font within ANSI SGR docs so attempt is made to resolve a blackletter font on users system.
   * ('F25 BlackletterTypewriter' is monospaced Blackletter font used or recommended by other terminal emulators (ie. mintty, etc.)
   * None of these fonts are required and all font-family stacks will resolve to some font.
   * 
   * These defaults match what I used in the ANSI support I added to the DartPad console.
   */
  .ansi-font-1 { font-family: ${font1 ?? 'Verdana,Arial,sans-serif'}; }
  .ansi-font-2 { font-family: ${font2 ?? 'Georgia,"Times New Roman",serif'}; }
  .ansi-font-3 { font-family: ${font3 ?? 'Papyrus,Impact,fantasy'}; }
  .ansi-font-4 { font-family: ${font4 ?? '"Apple Chancery","Lucida Calligraphy",cursive'}; }
  .ansi-font-5 { font-family: ${font5 ?? '"Courier New", Courier, monospace'}; }
  .ansi-font-6 { font-family: ${font6 ?? '"Segoe WPC", "Segoe UI",-apple-system, BlinkMacSystemFont, system-ui, "Ubuntu", "Droid Sans", sans-serif'}; }
  .ansi-font-7 { font-family: ${font7 ?? 'Menlo, Monaco, Consolas,"Droid Sans Mono", "Inconsolata", "Courier New", monospace, "Droid Sans Fallback"'}; }
  .ansi-font-8 { font-family: ${font8 ?? '"SF Mono", Monaco, Menlo, Consolas, "Ubuntu Mono", "Liberation Mono", "DejaVu Sans Mono", "Courier New", monospace'}; }
  .ansi-font-9 { font-family: ${font9 ?? '"SF Mono", Monaco, Menlo, Consolas, "Ubuntu Mono", "Liberation Mono", "DejaVu Sans Mono", "Courier New", monospace'}; }
  .ansi-font-10 { font-family:${font10 ?? '"F25 BlackletterTypewriter", UnifrakturCook, Luminari, Apple Chancery, fantasy, Papyrus'}; }''';

  }
}

/// A utility class containing a map, [characters], of key/value pairs for
/// every HTML 4.01 character entity, including ASCII codes, and a method,
/// [parse], to parse strings for those character entities.
class HtmlCharacterEntities {
  HtmlCharacterEntities._();

  /// Parses a [string] and replaces all valid HTML character
  /// entities with their respective characters.
  static String decode(String string) {
    var charCodeIndex = 0;

    Match? findNextCharCode() {
      final Iterable<Match> charCodes =
          RegExp(r'&(#?)([a-zA-Z0-9]+?);').allMatches(string);

      if (charCodes.length <= charCodeIndex) return null;

      return charCodes.elementAt(charCodeIndex);
    }

    var nextCharCode = findNextCharCode();

    while (nextCharCode != null) {
      var charCode = string.substring(nextCharCode.start, nextCharCode.end);

      if (charCode.startsWith(RegExp(r'&#[x0]'))) {
        while (charCode.startsWith(RegExp(r'&#x?0'))) {
          charCode = charCode.replaceFirst('0', '');
        }

        charCode = charCode.toLowerCase();
      }

      if (characters.containsKey(charCode)) {
        string = string.replaceRange(
            nextCharCode.start, nextCharCode.end, characters[charCode]!);
      } else {
        charCodeIndex++;
      }

      nextCharCode = findNextCharCode();
    }

    return string;
  }

  /// Parses a [string] and replaces every character included in the
  /// [characters] string with their corresponding character entity.
  ///
  /// [characters] defaults to the 5 characters reserved in both HTML
  /// and XML: less-than (`<`), greater-than (`>`), ampersand (`&`),
  /// apostrophe or single quote (`'`), and double-quote (`"`).
  ///
  /// If [characters] is `null`, every single character included in
  /// the characters map will be encoded if found in [string].
  ///
  /// If [defaultToAsciiCode] is `true`, the ASCII number will be
  /// used to encode the character, if one exists, otherwise the
  /// alphabetical character code will be used.
  ///
  /// If [defaultToHexCode] is `true`, the hex code will be used
  /// to encode the character, if one exists, otherwise the
  /// alphabetical character code will be used.
  ///
  /// [defaultToAsciiCode] and [defaultToHexCode] must not both be `true`.
  ///
  /// If [checkAmpsForEntities] is `true`, when encoding [string] for
  /// the `&` character, each `&` will be checked to see if it's part of
  /// a character entity (`RegExp(r'&(#?)\w*;')`), and will not be encoded
  /// if it is.
  static String encode(
    String string, {
    String? characters = '&<>"\'',
    bool defaultToAsciiCode = false,
    bool defaultToHexCode = false,
    bool checkAmpsForEntities = true,
  }) {
    assert(!(defaultToAsciiCode && defaultToHexCode));

    final encodingMap = <String, String>{};

    final encodingCharacters = characters?.split('') ??
        HtmlCharacterEntities.characters.values.toSet();

    for (var i = 0; i < encodingCharacters.length; i++) {
      final character = encodingCharacters.elementAt(i);
      if (character.isEmpty) continue;

      final hasCharacterEntity = entities.containsKey(character);

      String characterEntity;

      if (defaultToAsciiCode || defaultToHexCode || !hasCharacterEntity) {
        if (defaultToHexCode) {
          characterEntity = hexCodes[character]!;
        } else {
          characterEntity = asciiCodes[character]!;
        }
      } else {
        characterEntity = entities[character]!;
      }

      encodingMap.addAll({
        character: characterEntity,
      });
    }

    final encodedCharacters = string.split('');

    final encodingMapCharacters = encodingMap.keys.toList();

    for (var i = 0; i < encodingMapCharacters.length; i++) {
      final character = encodingMapCharacters[i];

      if (character == '&' && checkAmpsForEntities) {
        var ampIndex = 0;

        while (true) {
          ampIndex = encodedCharacters.indexOf('&', ampIndex);

          if (ampIndex == -1) break;

          final stringAtAmp = string.substring(ampIndex);

          if (!stringAtAmp.startsWith(RegExp(r'&(#?)\w*;'))) {
            encodedCharacters[ampIndex] = encodingMap['&']!;
          }

          ampIndex++;
        }

        continue;
      }

      while (encodedCharacters.contains(character)) {
        encodedCharacters[encodedCharacters.indexOf(character)] =
            encodingMap[character]!;
      }
    }

    return encodedCharacters.join();
  }

  /// A map of all HTML 4.01 character entities
  /// and their corresponding characters.
  static const Map<String, String> characters = <String, String>{
    // space
    '&#32;': ' ',
    '&#x20;': ' ',
    // exclamation mark
    '&#33;': '!',
    '&#x21;': '!',
    // double quote
    '&#34;': '"',
    '&quot;': '"',
    '&#x22;': '"',
    // number sign
    '&#35;': '#',
    '&#x23;': '#',
    // dollar sign
    '&#36;': '\$',
    '&#x24;': '\$',
    // percent sign
    '&#37;': '%',
    '&#x25;': '%',
    // ampersand
    '&#38;': '&',
    '&amp;': '&',
    '&#x26': '&',
    // apostrophe (single quote)
    '&#39;': '\'',
    '&apos;': '\'',
    '&#x27;': '\'',
    // opening parenthesis
    '&#40;': '(',
    '&#x28;': '(',
    // closing parenthesis
    '&#41;': ')',
    '&#x29;': ')',
    // asterisk
    '&#42;': '*',
    '&#x2a;': '*',
    // plus sign
    '&#43;': '+',
    '&#x2b;': '+',
    // comma
    '&#44;': ',',
    '&#x2c': ',',
    // minus sign (hyphen)
    '&#45;': '-',
    '&#x2d': '-',
    // period
    '&#46;': '.',
    '&#x2e;': '.',
    // slash
    '&#47;': '/',
    '&#x2f;': '/',
    // zero
    '&#48;': '0',
    '&#x30;': '0',
    // one
    '&#49;': '1',
    '&#x31;': '1',
    // two
    '&#50;': '2',
    '&#x32;': '2',
    // three
    '&#51;': '3',
    '&#x33': '3',
    // four
    '&#52;': '4',
    '&#x34': '4',
    // five
    '&#53;': '5',
    '&#x35': '5',
    // six
    '&#54;': '6',
    '&#x36': '6',
    // seven
    '&#55;': '7',
    '&#x37': '7',
    // eight
    '&#56;': '8',
    '&#x38': '8',
    // nine
    '&#57;': '9',
    '&#x39': '9',
    // colon
    '&#58;': ':',
    '&#x3a;': ':',
    // semicolon
    '&#59;': ';',
    '&#x3b;': ';',
    // less-than
    '&#60;': '<',
    '&#x3c;': '<',
    '&lt;': '<',
    // equal sign
    '&#61;': '=',
    '&#x3d;': '=',
    // greater-than
    '&#62;': '>',
    '&#x3e;': '>',
    '&gt;': '>',
    // question mark
    '&#63;': '?',
    '&#x3f;': '?',
    // at symbol
    '&#64;': '@',
    '&#x40;': '@',
    // uppercase a
    '&#65;': 'A',
    '&#x41;': 'A',
    // uppercase b
    '&#66;': 'B',
    '&#x42;': 'B',
    // uppercase c
    '&#67;': 'C',
    '&#x43;': 'C',
    // uppercase d
    '&#68;': 'D',
    '&#x44;': 'D',
    // uppercase e
    '&#69;': 'E',
    '&#x45;': 'E',
    // uppercase f
    '&#70;': 'F',
    '&#x46;': 'F',
    // uppercase g
    '&#71;': 'G',
    '&#x47;': 'G',
    // uppercase h
    '&#72;': 'H',
    '&#x48;': 'H',
    // uppercase i
    '&#73;': 'I',
    '&#x49;': 'I',
    // uppercase j
    '&#74;': 'J',
    '&#x4a;': 'J',
    // uppercase k
    '&#75;': 'K',
    '&#x4b;': 'K',
    // uppercase l
    '&#76;': 'L',
    '&#x4c;': 'L',
    // uppercase m
    '&#77;': 'M',
    '&#x4d;': 'M',
    // uppercase n
    '&#78;': 'N',
    '&#x4e;': 'N',
    // uppercase o
    '&#79;': 'O',
    '&#x4f;': 'O',
    // uppercase p
    '&#80;': 'P',
    '&#x50;': 'P',
    // uppercase q
    '&#81;': 'Q',
    '&#x51;': 'Q',
    // uppercase r
    '&#82;': 'R',
    '&#x52;': 'R',
    // uppercase s
    '&#83;': 'S',
    '&#x53;': 'S',
    // uppercase t
    '&#84;': 'T',
    '&#x54;': 'T',
    // uppercase u
    '&#85;': 'U',
    '&#x55;': 'U',
    // uppercase v
    '&#86;': 'V',
    '&#x56;': 'V',
    // uppercase w
    '&#87;': 'W',
    '&#x57;': 'W',
    // uppercase x
    '&#88;': 'X',
    '&#x58;': 'X',
    // uppercase y
    '&#89;': 'Y',
    '&#x59;': 'Y',
    // uppercase z
    '&#90;': 'Z',
    '&#x5a;': 'Z',
    // opening bracket
    '&#91;': '[',
    '&#x5b;': '[',
    // backslash
    '&#92;': '\\',
    '&#x5c;': '\\',
    // closing bracket
    '&#93;': ']',
    '&#x5d;': ']',
    // caret (circumflex)
    '&#94;': '^',
    '&#x5e;': '^',
    // underscore
    '&#95;': '_',
    '&#x5f;': '_',
    // grave accent
    '&#96;': '`',
    '&#x60;': '`',
    // lowercase a
    '&#97;': 'a',
    '&#x61;': 'a',
    // lowercase b
    '&#98;': 'b',
    '&#x62;': 'b',
    // lowercase c
    '&#99;': 'c',
    '&#x63;': 'c',
    // lowercase d
    '&#100;': 'd',
    '&#x64;': 'd',
    // lowercase e
    '&#101;': 'e',
    '&#x65;': 'e',
    // lowercase f
    '&#102;': 'f',
    '&#x66;': 'f',
    // lowercase g
    '&#103;': 'g',
    '&#x67;': 'g',
    // lowercase h
    '&#104;': 'h',
    '&#x68;': 'h',
    // lowercase i
    '&#105;': 'i',
    '&#x69;': 'i',
    // lowercase j
    '&#106;': 'j',
    '&#x6a;': 'j',
    // lowercase k
    '&#107;': 'k',
    '&#x6b;': 'k',
    // lowercase l
    '&#108;': 'l',
    '&#x6c;': 'l',
    // lowercase m
    '&#109;': 'm',
    '&#x6d;': 'm',
    // lowercase n
    '&#110;': 'n',
    '&#x6e;': 'n',
    // lowercase o
    '&#111;': 'o',
    '&#x6f;': 'o',
    // lowercase p
    '&#112;': 'p',
    '&#x70;': 'p',
    // lowercase q
    '&#113;': 'q',
    '&#x71;': 'q',
    // lowercase r
    '&#114;': 'r',
    '&#x72;': 'r',
    // lowercase s
    '&#115;': 's',
    '&#x73;': 's',
    // lowercase t
    '&#116;': 't',
    '&#x74;': 't',
    // lowercase u
    '&#117;': 'u',
    '&#x75;': 'u',
    // lowercase v
    '&#118;': 'v',
    '&#x76;': 'v',
    // lowercase w
    '&#119;': 'w',
    '&#x77;': 'w',
    // lowercase x
    '&#120;': 'x',
    '&#x78;': 'x',
    // lowercase y
    '&#121;': 'y',
    '&#x79;': 'y',
    // lowercase z
    '&#122;': 'z',
    '&#x7a;': 'z',
    // opening brace
    '&#123;': '{',
    '&#x7b;': '{',
    // vertical bar
    '&#124;': '|',
    '&#x7c;': '|',
    // closing brace
    '&#125;': '}',
    '&#x7d;': '}',
    // equivalency sign (tilde)
    '&#126;': '~',
    '&#x7e;': '~',
    // non-breaking space
    '&#160;': ' ',
    '&#xa0;': ' ',
    '&nbsp;': ' ',
    // inverted exclamation mark
    '&#161;': '¡',
    '&#xa1;': '¡',
    '&iexcl;': '¡',
    // cent sign
    '&#162;': '¢',
    '&#xa2;': '¢',
    '&cent;': '¢',
    // pound sign
    '&#163;': '£',
    '&#xa3;': '£',
    '&pound;': '£',
    // currency sign
    '&#164;': '¤',
    '&#xa4;': '¤',
    '&curren;': '¤',
    // yen sign (yuan sign)
    '&#165;': '¥',
    '&#xa5;': '¥',
    '&yen;': '¥',
    // broken bar (broken vertical bar)
    '&#166;': '¦',
    '&#xa6;': '¦',
    '&brvbar;': '¦',
    // section sign
    '&#167;': '§',
    '&#xa7;': '§',
    '&sect;': '§',
    // diaeresis (spacing diaeresis)
    '&#168;': '¨',
    '&#xa8;': '¨',
    '&uml;': '¨',
    // copyright symbol
    '&#169;': '©',
    '&#xa9;': '©',
    '&copy;': '©',
    // feminine ordinal indicator
    '&#170;': 'ª',
    '&#xaa;': 'ª',
    '&ordf;': 'ª',
    // left-pointing double angle quotation mark (left pointing guillemet)
    '&#171;': '«',
    '&#xab;': '«',
    '&laquo;': '«',
    // not sign
    '&#172;': '¬',
    '&#xac;': '¬',
    '&not;': '¬',
    // soft hyphen (discretionary hyphen)
    '&#173;': '',
    '&#xad;': '',
    '&shy;': '',
    // registered sign (registered trademark symbol)
    '&#174;': '®',
    '&#xae;': '®',
    '&reg;': '®',
    // macron (spacing macron, overline, APL overbar)
    '&#175;': '¯',
    '&#xaf;': '¯',
    '&macr;': '¯',
    // degree symbol
    '&#176;': '°',
    '&#xb0;': '°',
    '&deg;': '°',
    // plus-minus sign (plus-or-minus sign)
    '&#177;': '±',
    '&#xb1;': '±',
    '&plusmn;': '±',
    // superscript two (superscript digit two, squared)
    '&#178;': '²',
    '&#xb2;': '²',
    '&sup2;': '²',
    // superscript three (superscript digit three, cubed)
    '&#179;': '³',
    '&#xb3;': '³',
    '&sup3;': '³',
    // acute accent (spacing acute)
    '&#180;': '´',
    '&#xb4;': '´',
    '&acute;': '´',
    // micro sign
    '&#181;': 'µ',
    '&#xb5;': 'µ',
    '&micro;': 'µ',
    // pilcrow sign (paragraph sign)
    '&#182;': '¶',
    '&#xb6;': '¶',
    '&para;': '¶',
    // middle dot (Georgian comma, Greek middle dot)
    '&#183;': '·',
    '&#xb7;': '·',
    '&middot;': '·',
    // cedilla (spacing cedilla)
    '&#184;': '¸',
    '&#xb8;': '¸',
    '&cedil;': '¸',
    // superscript one (superscript digit one)
    '&#185;': '¹',
    '&#xb9;': '¹',
    '&sup1;': '¹',
    // masculine ordinal indicator
    '&#186;': 'º',
    '&#xba;': 'º',
    '&ordm;': 'º',
    // right-pointing double angle quotation mark (right pointing guillemet)
    '&#187;': '»',
    '&#xbb;': '»',
    '&raquo;': '»',
    // vulgar fraction one quarter (fraction one quarter)
    '&#188;': '¼',
    '&#xbc;': '¼',
    '&frac14;': '¼',
    // vulgar fraction one half (fraction one half)
    '&#189;': '½',
    '&#xbd;': '½',
    '&frac12;': '½',
    // vulgar fraction three quarters (fraction three quarters)
    '&#190;': '¾',
    '&#xbe;': '¾',
    '&frac34;': '¾',
    // inverted question mark (turned question mark)
    '&#191;': '¿',
    '&#xbf;': '¿',
    '&iquest;': '¿',
    // Latin capital letter A with grave accent (Latin capital letter A grave)
    '&#192;': 'À',
    '&#xc0;': 'À',
    '&Agrave;': 'À',
    // Latin capital letter A with acute accent
    '&#193;': 'Á',
    '&#xc1;': 'Á',
    '&Aacute;': 'Á',
    // Latin capital letter A with circumflex
    '&#194;': 'Â',
    '&#xc2;': 'Â',
    '&Acirc;': 'Â',
    // Latin capital letter A with tilde
    '&#195;': 'Ã',
    '&#xc3;': 'Ã',
    '&Atilde;': 'Ã',
    // Latin capital letter A with diaeresis
    '&#196;': 'Ä',
    '&#xc4;': 'Ä',
    '&Auml;': 'Ä',
    // Latin capital letter A with ring above (Latin capital letter A ring)
    '&#197;': 'Å',
    '&#xc5;': 'Å',
    '&Aring;': 'Å',
    // Latin capital letter AE (Latin capital ligature AE)
    '&#198;': 'Æ',
    '&#xc6;': 'Æ',
    '&AElig;': 'Æ',
    // Latin capital letter C with cedilla
    '&#199;': 'Ç',
    '&#xc7;': 'Ç',
    '&Ccedil;': 'Ç',
    // Latin capital letter E with grave accent
    '&#200;': 'È',
    '&#xc8;': 'È',
    '&Egrave;': 'È',
    // Latin capital letter E with acute accent
    '&#201;': 'É',
    '&#xc9;': 'É',
    '&Eacute;': 'É',
    // Latin capital letter E with circumflex
    '&#202;': 'Ê',
    '&#xca;': 'Ê',
    '&Ecirc;': 'Ê',
    // Latin capital letter E with diaeresis
    '&#203;': 'Ë',
    '&#xcb;': 'Ë',
    '&Euml;': 'Ë',
    // Latin capital letter I with grave accent
    '&#204;': 'Ì',
    '&#xcc;': 'Ì',
    '&Igrave;': 'Ì',
    // Latin capital letter I with acute accent
    '&#205;': 'Í',
    '&#xcd;': 'Í',
    '&Iacute;': 'Í',
    // Latin capital letter I with circumflex
    '&#206;': 'Î',
    '&#xce;': 'Î',
    '&Icirc;': 'Î',
    // Latin capital letter I with diaeresis
    '&#207;': 'Ï',
    '&#xcf;': 'Ï',
    '&Iuml;': 'Ï',
    // Latin capital letter Eth
    '&#208;': 'Ð',
    '&#xd0;': 'Ð',
    '&ETH;': 'Ð',
    // Latin capital letter N with tilde
    '&#209;': 'Ñ',
    '&#xd1;': 'Ñ',
    '&Ntilde;': 'Ñ',
    // Latin capital letter O with grave accent
    '&#210;': 'Ò',
    '&#xd2;': 'Ò',
    '&Ograve;': 'Ò',
    // Latin capital letter O with acute accent
    '&#211;': 'Ó',
    '&#xd3;': 'Ó',
    '&Oacute;': 'Ó',
    // Latin capital letter O with circumflex
    '&#212;': 'Ô',
    '&#xd4;': 'Ô',
    '&Ocirc;': 'Ô',
    // Latin capital letter O with tilde
    '&#213;': 'Õ',
    '&#xd5;': 'Õ',
    '&Otilde;': 'Õ',
    // Latin capital letter O with diaeresis
    '&#214;': 'Ö',
    '&#xd6;': 'Ö',
    '&Ouml;': 'Ö',
    // multiplication sign
    '&#215;': '×',
    '&#xd7;': '×',
    '&times;': '×',
    // Latin capital letter O with stroke (Latin capital letter O slash)
    '&#216;': 'Ø',
    '&#xd8;': 'Ø',
    '&Oslash;': 'Ø',
    // Latin capital letter U with grave accent
    '&#217;': 'Ù',
    '&#xd9;': 'Ù',
    '&Ugrave;': 'Ù',
    // Latin capital letter U with acute accent
    '&#218;': 'Ú',
    '&#xda;': 'Ú',
    '&Uacute;': 'Ú',
    // Latin capital letter U with circumflex
    '&#219;': 'Û',
    '&#xdb;': 'Û',
    '&Ucirc;': 'Û',
    // Latin capital letter U with diaeresis
    '&#220;': 'Ü',
    '&#xdc;': 'Ü',
    '&Uuml;': 'Ü',
    // Latin capital letter Y with acute accent
    '&#221;': 'Ý',
    '&#xdd;': 'Ý',
    '&Yacute;': 'Ý',
    // Latin capital letter THORN
    '&#222;': 'Þ',
    '&#xde;': 'Þ',
    '&THORN;': 'Þ',
    // Latin small letter sharp s (ess-zed); see German Eszett
    '&#223;': 'ß',
    '&#xdf;': 'ß',
    '&szlig;': 'ß',
    // Latin small letter a with grave accent
    '&#224;': 'à',
    '&#xe0;': 'à',
    '&agrave;': 'à',
    // Latin small letter a with acute accent
    '&#225;': 'á',
    '&#xe1;': 'á',
    '&aacute;': 'á',
    // Latin small letter a with circumflex
    '&#226;': 'â',
    '&#xe2;': 'â',
    '&acirc;': 'â',
    // Latin small letter a with tilde
    '&#227;': 'ã',
    '&#xe3;': 'ã',
    '&atilde;': 'ã',
    // Latin small letter a with diaeresis
    '&#228;': 'ä',
    '&#xe4;': 'ä',
    '&auml;': 'ä',
    // Latin small letter a with ring above
    '&#229;': 'å',
    '&#xe5;': 'å',
    '&aring;': 'å',
    // Latin small letter ae (Latin small ligature ae)
    '&#230;': 'æ',
    '&#xe6;': 'æ',
    '&aelig;': 'æ',
    // Latin small letter c with cedilla
    '&#231;': 'ç',
    '&#xe7;': 'ç',
    '&ccedil;': 'ç',
    // Latin small letter e with grave accent
    '&#232;': 'è',
    '&#xe8;': 'è',
    '&egrave;': 'è',
    // Latin small letter e with acute accent
    '&#233;': 'é',
    '&#xe9;': 'é',
    '&eacute;': 'é',
    // Latin small letter e with circumflex
    '&#234;': 'ê',
    '&#xea;': 'ê',
    '&ecirc;': 'ê',
    // Latin small letter e with diaeresis
    '&#235;': 'ë',
    '&#xeb;': 'ë',
    '&euml;': 'ë',
    // Latin small letter i with grave accent
    '&#236;': 'ì',
    '&#xec;': 'ì',
    '&igrave;': 'ì',
    // Latin small letter i with acute accent
    '&#237;': 'í',
    '&#xed;': 'í',
    '&iacute;': 'í',
    // Latin small letter i with circumflex
    '&#238;': 'î',
    '&#xee;': 'î',
    '&icirc;': 'î',
    // Latin small letter i with diaeresis
    '&#239;': 'ï',
    '&#xef;': 'ï',
    '&iuml;': 'ï',
    // Latin small letter eth
    '&#240;': 'ð',
    '&#xf0;': 'ð',
    '&eth;': 'ð',
    // Latin small letter n with tilde
    '&#241;': 'ñ',
    '&#xf1;': 'ñ',
    '&ntilde;': 'ñ',
    // Latin small letter o with grave accent
    '&#242;': 'ò',
    '&#xf2;': 'ò',
    '&ograve;': 'ò',
    // Latin small letter o with acute accent
    '&#243;': 'ó',
    '&#xf3;': 'ó',
    '&oacute;': 'ó',
    // Latin small letter o with circumflex
    '&#244;': 'ô',
    '&#xf4;': 'ô',
    '&ocirc;': 'ô',
    // Latin small letter o with tilde
    '&#245;': 'õ',
    '&#xf5;': 'õ',
    '&otilde;': 'õ',
    // Latin small letter o with diaeresis
    '&#246;': 'ö',
    '&#xf6;': 'ö',
    '&ouml;': 'ö',
    // division sign (obelus)
    '&#247;': '÷',
    '&#xf7;': '÷',
    '&divide;': '÷',
    // Latin small letter o with stroke (Latin small letter o slash)
    '&#248;': 'ø',
    '&#xf8;': 'ø',
    '&oslash;': 'ø',
    // Latin small letter u with grave accent
    '&#249;': 'ù',
    '&#xf9;': 'ù',
    '&ugrave;': 'ù',
    // Latin small letter u with acute accent
    '&#250;': 'ú',
    '&#xfa;': 'ú',
    '&uacute;': 'ú',
    // Latin small letter u with circumflex
    '&#251;': 'û',
    '&#xfb;': 'û',
    '&ucirc;': 'û',
    // Latin small letter u with diaeresis
    '&#252;': 'ü',
    '&#xfc;': 'ü',
    '&uuml;': 'ü',
    // Latin small letter y with acute accent
    '&#253;': 'ý',
    '&#xfd;': 'ý',
    '&yacute;': 'ý',
    // Latin small letter thorn
    '&#254;': 'þ',
    '&#xfe;': 'þ',
    '&thorn;': 'þ',
    // Latin small letter y with diaeresis
    '&#255;': 'ÿ',
    '&#xff;': 'ÿ',
    '&yuml;': 'ÿ',
    // Latin capital ligature oe
    '&#338;': 'Œ',
    '&#x152;': 'Œ',
    '&OElig;': 'Œ',
    // Latin small ligature oe
    '&#339;': 'œ',
    '&#x153;': 'œ',
    '&oelig;': 'œ',
    // Latin capital letter s with caron
    '&#352;': 'Š',
    '&#x160;': 'Š',
    '&Scaron;': 'Š',
    // Latin small letter s with caron
    '&#353;': 'š',
    '&#x161;': 'š',
    '&scaron;': 'š',
    // Latin capital letter w with circumflex
    '&#372;': 'Ŵ',
    '&#x174;': 'Ŵ',
    // Latin small letter w with circumflex
    '&#373;': 'ŵ',
    '&#x175;': 'ŵ',
    // Latin capital letter y with circumflex
    '&#374;': 'Ŷ',
    '&#x176;': 'Ŷ',
    // Latin small letter y with circumflex
    '&#375;': 'ŷ',
    '&#x177;': 'ŷ',
    // Latin capital letter y with diaeresis
    '&#376;': 'Ÿ',
    '&#x178;': 'Ÿ',
    '&Yuml;': 'Ÿ',
    // Latin small letter f with hook (function, florin)
    '&#402;': 'ƒ',
    '&#x192;': 'ƒ',
    '&fnof;': 'ƒ',
    // modifier letter circumflex accent
    '&#710;': 'ˆ',
    '&#x2c6;': 'ˆ',
    '&circ;': 'ˆ',
    // small tilde
    '&#732;': '˜',
    '&#x2dc;': '˜',
    '&tilde;': '˜',
    // Greek capital letter Alpha
    '&#913;': 'Α',
    '&#x391;': 'Α',
    '&Alpha;': 'Α',
    // Greek capital letter Beta
    '&#914;': 'Β',
    '&#x392;': 'Β',
    '&Beta;': 'Β',
    // Greek capital letter Gamma
    '&#915;': 'Γ',
    '&#x393;': 'Γ',
    '&Gamma;': 'Γ',
    // Greek capital letter Delta
    '&#916;': 'Δ',
    '&#x394;': 'Δ',
    '&Delta;': 'Δ',
    // Greek capital letter Epsilon
    '&#917;': 'Ε',
    '&#x395;': 'Ε',
    '&Epsilon;': 'Ε',
    // Greek capital letter Zeta
    '&#918;': 'Ζ',
    '&#x396;': 'Ζ',
    '&Zeta;': 'Ζ',
    // Greek capital letter Eta
    '&#919;': 'Η',
    '&#x397;': 'Η',
    '&Eta;': 'Η',
    // Greek capital letter Theta
    '&#920;': 'Θ',
    '&#x398;': 'Θ',
    '&Theta;': 'Θ',
    // Greek capital letter Iota
    '&#921;': 'Ι',
    '&#x399;': 'Ι',
    '&Iota;': 'Ι',
    // Greek capital letter Kappa
    '&#922;': 'Κ',
    '&#x39a;': 'Κ',
    '&Kappa;': 'Κ',
    // Greek capital letter Lambda
    '&#923;': 'Λ',
    '&#x39b;': 'Λ',
    '&Lambda;': 'Λ',
    // Greek capital letter Mu
    '&#924;': 'Μ',
    '&#x39c;': 'Μ',
    '&Mu;': 'Μ',
    // Greek capital letter Nu
    '&#925;': 'Ν',
    '&#x39d;': 'Ν',
    '&Nu;': 'Ν',
    // Greek capital letter Xi
    '&#926;': 'Ξ',
    '&#x39e;': 'Ξ',
    '&Xi;': 'Ξ',
    // Greek capital letter Omicron
    '&#927;': 'Ο',
    '&#x39f;': 'Ο',
    '&Omicron;': 'Ο',
    // Greek capital letter Pi
    '&#928;': 'Π',
    '&#x3a0;': 'Π',
    '&Pi;': 'Π',
    // Greek capital letter Rho
    '&#929;': 'Ρ',
    '&#x3a1;': 'Ρ',
    '&Rho;': 'Ρ',
    // Greek capital letter Sigma
    '&#931;': 'Σ',
    '&#x3a3;': 'Σ',
    '&Sigma;': 'Σ',
    // Greek capital letter Tau
    '&#932;': 'Τ',
    '&#x3a4;': 'Τ',
    '&Tau;': 'Τ',
    // Greek capital letter Upsilon
    '&#933;': 'Υ',
    '&#x3a5;': 'Υ',
    '&Upsilon;': 'Υ',
    // Greek capital letter Phi
    '&#934;': 'Φ',
    '&#x3a6;': 'Φ',
    '&Phi;': 'Φ',
    // Greek capital letter Chi
    '&#935;': 'Χ',
    '&#x3a7;': 'Χ',
    '&Chi;': 'Χ',
    // Greek capital letter Psi
    '&#936;': 'Ψ',
    '&#x3a8;': 'Ψ',
    '&Psi;': 'Ψ',
    // Greek capital letter Omega
    '&#937;': 'Ω',
    '&#x3a9;': 'Ω',
    '&Omega;': 'Ω',
    // Greek capital letter iota with dialytika
    '&#938;': 'Ϊ',
    '&#x3aa;': 'Ϊ',
    // Greek capital letter upsilon with dialytika
    '&#939;': 'Ϋ',
    '&#x3ab;': 'Ϋ',
    // Greek small letter alpha with tonos
    '&#940;': 'ά',
    '&#x3ac;': 'ά',
    // Greek small letter epsilon with tonos
    '&#941;': 'έ',
    '&#x3ad;': 'έ',
    // Greek small letter eta with tonos
    '&#942;': 'ή',
    '&#x3ae;': 'ή',
    // Greek small letter iota with tonos
    '&#943;': 'ί',
    '&#x3af;': 'ί',
    // Greek small letter upsilon with dialytika and tonos
    '&#944;': 'ΰ',
    '&#x3b0;': 'ΰ',
    // Greek small letter alpha
    '&#945;': 'α',
    '&#x3b1;': 'α',
    '&alpha;': 'α',
    // Greek small letter beta
    '&#946;': 'β',
    '&#x3b2;': 'β',
    '&beta;': 'β',
    // Greek small letter gamma
    '&#947;': 'γ',
    '&#x3b3;': 'γ',
    '&gamma;': 'γ',
    // Greek small letter delta
    '&#948;': 'δ',
    '&#x3b4;': 'δ',
    '&delta;': 'δ',
    // Greek small letter epsilon
    '&#949;': 'ε',
    '&#x3b5;': 'ε',
    '&epsilon;': 'ε',
    // Greek small letter zeta
    '&#950;': 'ζ',
    '&#x3b6;': 'ζ',
    '&zeta;': 'ζ',
    // Greek small letter eta
    '&#951;': 'η',
    '&#x3b7;': 'η',
    '&eta;': 'η',
    // Greek small letter theta
    '&#952;': 'θ',
    '&#x3b8;': 'θ',
    '&theta;': 'θ',
    // Greek small letter iota
    '&#953;': 'ι',
    '&#x3b9;': 'ι',
    '&iota;': 'ι',
    // Greek small letter kappa
    '&#954;': 'κ',
    '&#x3ba;': 'κ',
    '&kappa;': 'κ',
    // Greek small letter lambda
    '&#955;': 'λ',
    '&#x3bb;': 'λ',
    '&lambda;': 'λ',
    // Greek small letter mu
    '&#956;': 'μ',
    '&#x3bc;': 'μ',
    '&mu;': 'μ',
    // Greek small letter nu
    '&#957;': 'ν',
    '&#x3bd;': 'ν',
    '&nu;': 'ν',
    // Greek small letter xi
    '&#958;': 'ξ',
    '&#x3be;': 'ξ',
    '&xi;': 'ξ',
    // Greek small letter omicron
    '&#959;': 'ο',
    '&#x3bf;': 'ο',
    '&omicron;': 'ο',
    // Greek small letter pi
    '&#960;': 'π',
    '&#x3c0;': 'π',
    '&pi;': 'π',
    // Greek small letter rho
    '&#961;': 'ρ',
    '&#x3c1;': 'ρ',
    '&rho;': 'ρ',
    // Greek small letter final sigma
    '&#962;': 'ς',
    '&#x3c2;': 'ς',
    '&sigmaf;': 'ς',
    // Greek small letter sigma
    '&#963;': 'σ',
    '&#x3c3;': 'σ',
    '&sigma;': 'σ',
    // Greek small letter tau
    '&#964;': 'τ',
    '&#x3c4;': 'τ',
    '&tau;': 'τ',
    // Greek small letter upsilon
    '&#965;': 'υ',
    '&#x3c5;': 'υ',
    '&upsilon;': 'υ',
    // Greek small letter phi
    '&#966;': 'φ',
    '&#x3c6;': 'φ',
    '&phi;': 'φ',
    // Greek small letter chi
    '&#967;': 'χ',
    '&#x3c7;': 'χ',
    '&chi;': 'χ',
    // Greek small letter psi
    '&#968;': 'ψ',
    '&#x3c8;': 'ψ',
    '&psi;': 'ψ',
    // Greek small letter omega
    '&#969': 'ω',
    '&#x3c9;': 'ω',
    '&omega;': 'ω',
    // Greek small letter iota with dialytika
    '&#970;': 'ϊ',
    '&#x3ca;': 'ϊ',
    // Greek small letter upsilon with dialytika
    '&#971;': 'ϋ',
    '&#x3cb;': 'ϋ',
    // Greek small letter omicron with tonos
    '&#972;': 'ό',
    '&#x3cc;': 'ό',
    // Greek small letter upsilon with tonos
    '&#973;': 'ύ',
    '&#x3cd;': 'ύ',
    // Greek small letter omega with tonos
    '&#974;': 'ώ',
    '&#x3ce;': 'ώ',
    // Greek capital kai symbol
    '&#975;': 'Ϗ',
    '&#x3cf;': 'Ϗ',
    // Greek beta symbol
    '&#976;': 'ϐ',
    '&#x3d0;': 'ϐ',
    // Greek theta symbol
    '&#977;': 'ϑ',
    '&#x3d1;': 'ϑ',
    '&thetasym;': 'ϑ',
    // Greek upsilon with hook symbol
    '&#978;': 'ϒ',
    '&#x3d2;': 'ϒ',
    '&upsih;': 'ϒ',
    // Greek upsilon with acute and hook symbol
    '&#979;': 'ϓ',
    '&#x3d3;': 'ϓ',
    // Greek upsilon with diaeresis and hook symbol
    '&#980;': 'ϔ',
    '&#x3d4;': 'ϔ',
    // Greek phi symbol
    '&#981;': 'ϕ',
    '&#x3d5;': 'ϕ',
    '&straightphi;': 'ϕ',
    // Greek pi symbol
    '&#982;': 'ϖ',
    '&#x3d6;': 'ϖ',
    '&piv;': 'ϖ',
    '&varpi;': 'ϖ',
    // Latin capital letter w with grave
    '&#7808;': 'Ẁ',
    '&#x1e80;': 'Ẁ',
    // Latin small letter w with grave
    '&#7809;': 'ẁ',
    '&#x1e81;': 'ẁ',
    // Latin capital letter w with acute
    '&#7810;': 'Ẃ',
    '&#x1e82;': 'Ẃ',
    // Latin small letter w with acute
    '&#7811;': 'ẃ',
    '&#x1e83;': 'ẃ',
    // Latin capital letter w with diaeresis
    '&#7812;': 'Ẅ',
    '&#x1e84;': 'Ẅ',
    // Latin small letter w with diaeresis
    '&#7813;': 'ẅ',
    '&#x1e85;': 'ẅ',
    // Latin capital letter y with grave
    '&#7922;': 'Ỳ',
    '&#x1ef2;': 'Ỳ',
    // Latin small letter y with grave
    '&#7923;': 'ỳ',
    '&#x1ef3;': 'ỳ',
    // en space
    '&#8194;': ' ',
    '&#x2002;': ' ',
    '&ensp;': ' ',
    // em space
    '&#8195;': ' ',
    '&#x2003;': ' ',
    '&emsp;': ' ',
    // thin space
    '&#8201;': ' ',
    '&#x2009;': ' ',
    '&thinsp;': ' ',
    // zero-width non-joiner
    '&#8204;': '',
    '&#x200c;': '',
    '&zwnj;': '',
    // zero-width joiner
    '&#8205;': '',
    '&#x200d;': '',
    '&zwj;': '',
    // left-to-right mark
    '&#8206;': '',
    '&#x200e;': '',
    '&lrm;': '',
    // right-to-left mark
    '&#8207;': '',
    '&#x200f;': '',
    '&rlm;': '',
    // en dash
    '&#8211;': '–',
    '&#x2013;': '–',
    '&ndash;': '–',
    // em dash
    '&#8212;': '—',
    '&#x2014;': '—',
    '&mdash;': '—',
    // left single quotation mark
    '&#8216;': '‘',
    '&#x2018;': '‘',
    '&lsquo;': '‘',
    // right single quotation mark
    '&#8217;': '’',
    '&#x2019;': '’',
    '&rsquo;': '’',
    // single low-9 quotation mark
    '&#8218;': '‚',
    '&#x201a;': '‚',
    '&sbquo;': '‚',
    // left double quotation mark
    '&#8220;': '“',
    '&#x201c;': '“',
    '&ldquo;': '“',
    // right double quotation mark
    '&#8221;': '”',
    '&#x201d;': '”',
    '&rdquo;': '”',
    // double low-9 quotation mark
    '&#8222;': '„',
    '&#x201e;': '„',
    '&bdquo;': '„',
    // dagger, obelisk
    '&#8224;': '†',
    '&#x2020;': '†',
    '&dagger;': '†',
    // double dagger (double obelisk)
    '&#8225;': '‡',
    '&#x2021;': '‡',
    '&Dagger;': '‡',
    // bullet (black small circle)
    '&#8226;': '•',
    '&#x2022;': '•',
    '&bull;': '•',
    // horizontal ellipsis (three dot leader)
    '&#8230;': '…',
    '&#x2026;': '…',
    '&hellip;': '…',
    // per mille sign
    '&#8240;': '‰',
    '&#x2030;': '‰',
    '&permil;': '‰',
    // prime (minutes, feet)
    '&#8242;': '′',
    '&#x2032;': '′',
    '&prime;': '′',
    // double prime (seconds, inches)
    '&#8243;': '″',
    '&#x2033;': '″',
    '&Prime;': '″',
    // single left-pointing angle quotation mark
    '&#8249;': '‹',
    '&#x2039;': '‹',
    '&lsaquo;': '‹',
    // single right-pointing angle quotation mark
    '&#8250;': '›',
    '&#x203a;': '›',
    '&rsaquo;': '›',
    // overline (spacing overscore)
    '&#8254;': '‾',
    '&#x203e;': '‾',
    '&oline;': '‾',
    // fraction slash (solidus)
    '&#8260;': '⁄',
    '&#x2044;': '⁄',
    '&frasl;': '⁄',
    // euro sign
    '&#8364;': '€',
    '&#x20ac;': '€',
    '&euro;': '€',
    // black-letter capital I (imaginary part)
    '&#8465;': 'ℑ',
    '&#x2111;': 'ℑ',
    '&image;': 'ℑ',
    // script capital P (power set, Weierstrass p)
    '&#8472;': '℘',
    '&#x2118;': '℘',
    '&weierp;': '℘',
    // black-letter capital R (real part symbol)
    '&#8476;': 'ℜ',
    '&#x211c;': 'ℜ',
    '&real;': 'ℜ',
    // trademark symbol
    '&#8482;': '™',
    '&#x2122;': '™',
    '&trade;': '™',
    // alef symbol (first transfinite cardinal)
    '&#8501;': 'ℵ',
    '&#x2135;': 'ℵ',
    '&alefsym;': 'ℵ',
    // leftwards arrow
    '&#8592;': '←',
    '&#x2190;': '←',
    '&larr;': '←',
    // upwards arrow
    '&#8593;': '↑',
    '&#x2191;': '↑',
    '&uarr;': '↑',
    // rightwards arrow
    '&#8594;': '→',
    '&#x2192;': '→',
    '&rarr;': '→',
    // downwards arrow
    '&#8595;': '↓',
    '&#x2193;': '↓',
    '&darr;': '↓',
    // left right arrow
    '&#8596;': '↔',
    '&#x2194;': '↔',
    '&harr;': '↔',
    // downwards arrow with corner leftwards (carriage return)
    '&#8629;': '↵',
    '&#x21b5;': '↵',
    '&crarr;': '↵',
    // leftwards double arrow
    '&#8656;': '⇐',
    '&#x21d0;': '⇐',
    '&lArr;': '⇐',
    // upwards double arrow
    '&#8657;': '⇑',
    '&#x21d1;': '⇑',
    '&uArr;': '⇑',
    // rightwards double arrow
    '&#8658': '⇒',
    '&#x21d2': '⇒',
    '&rArr;': '⇒',
    // downwards double arrow
    '&#8659;': '⇓',
    '&#x21d3;': '⇓',
    '&dArr;': '⇓',
    // left right double arrow
    '&#8660;': '⇔',
    '&#x21d4;': '⇔',
    '&hArr;': '⇔',
    // for all
    '&#8704;': '∀',
    '&#x2200;': '∀',
    '&forall;': '∀',
    // partial differential
    '&#8706;': '∂',
    '&#x2202;': '∂',
    '&part;': '∂',
    // there exists
    '&#8707;': '∃',
    '&#x2203;': '∃',
    '&exist;': '∃',
    // empty set (null set)
    '&#8709;': '∅',
    '&#x2205;': '∅',
    '&empty;': '∅',
    // del or nabla (vector differential operator)
    '&#8711;': '∇',
    '&#x2207;': '∇',
    '&nabla;': '∇',
    // element of
    '&#8712;': '∈',
    '&#x2208;': '∈',
    '&isin;': '∈',
    // not an element of
    '&#8713;': '∉',
    '&#x2209;': '∉',
    '&notin;': '∉',
    // contains as member
    '&#8715;': '∋',
    '&#x220b;': '∋',
    '&ni;': '∋',
    // n-ary product (product sign)
    '&#8719;': '∏',
    '&#x220f;': '∏',
    '&prod;': '∏',
    // n-ary summation
    '&#8721;': '∑',
    '&#x2211;': '∑',
    '&sum;': '∑',
    // minus sign
    '&#8722;': '−',
    '&#x2212;': '−',
    '&minus;': '−',
    // asterisk operator
    '&#8727;': '∗',
    '&#x2217;': '∗',
    '&lowast;': '∗',
    // square root (radical sign)
    '&#8730;': '√',
    '&#x221a;': '√',
    '&radic;': '√',
    // proportional to
    '&#8733;': '∝',
    '&#x221d;': '∝',
    '&prop;': '∝',
    // infinity
    '&#8734;': '∞',
    '&#x221e;': '∞',
    '&infin;': '∞',
    // angle
    '&#8736;': '∠',
    '&#x2220;': '∠',
    '&ang;': '∠',
    // logical and (wedge)
    '&#8743;': '∧',
    '&#x2227;': '∧',
    '&and;': '∧',
    // logical or (vee)
    '&#8744;': '∨',
    '&#x2228;': '∨',
    '&or;': '∨',
    // intersection (cap)
    '&#8745;': '∩',
    '&#x2229;': '∩',
    '&cap;': '∩',
    // union (cup)
    '&#8746;': '∪',
    '&#x222a;': '∪',
    '&cup;': '∪',
    // integral
    '&#8747;': '∫',
    '&#x222b': '∫',
    '&int;': '∫',
    // therefore sign
    '&#8756;': '∴',
    '&#x2234;': '∴',
    '&there4;': '∴',
    // tilde operator (varies with, similar to)
    '&#8764;': '∼',
    '&#x223c;': '∼',
    '&sim;': '∼',
    // congruent to
    '&#8773;': '≅',
    '&#x2245;': '≅',
    '&cong;': '≅',
    // almost equal to (asymptotic to)
    '&#8776;': '≈',
    '&#x2248;': '≈',
    '&asymp;': '≈',
    // not equal to
    '&#8800;': '≠',
    '&#x2260;': '≠',
    '&ne;': '≠',
    // identical to; sometimes used for 'equivalent to'
    '&#8801;': '≡',
    '&#x2261;': '≡',
    '&equiv;': '≡',
    // less-than or equal to
    '&#8804;': '≤',
    '&#x2264;': '≤',
    '&le;': '≤',
    // greater-than or equal to
    '&#8805;': '≥',
    '&#x2265;': '≥',
    '&ge;': '≥',
    // subset of
    '&#8834;': '⊂',
    '&#x2282;': '⊂',
    '&sub;': '⊂',
    // superset of
    '&#8835;': '⊃',
    '&#x2283;': '⊃',
    '&sup;': '⊃',
    // not a subset of
    '&#8836;': '⊄',
    '&#x2284;': '⊄',
    '&nsub;': '⊄',
    // subset of or equal to
    '&#8838;': '⊆',
    '&#x2286;': '⊆',
    '&sube;': '⊆',
    // superset of or equal to
    '&#8839;': '⊇',
    '&#x2287;': '⊇',
    '&supe;': '⊇',
    // circled plus (direct sum)
    '&#8853;': '⊕',
    '&#x2295;': '⊕',
    '&oplus;': '⊕',
    // circled times (vector product)
    '&#8855;': '⊗',
    '&#x2297;': '⊗',
    '&otimes;': '⊗',
    // up tack (orthogonal to, perpendicular)
    '&#8869;': '⊥',
    '&#x22a5;': '⊥',
    '&perp;': '⊥',
    // dot operator
    '&#8901;': '⋅',
    '&#x22c5;': '⋅',
    '&sdot;': '⋅',
    // vertical ellipsis
    '&#8942;': '⋮',
    '&#x22ee;': '⋮',
    '&vellip;': '⋮',
    // left ceiling (APL upstile)
    '&#8968;': '⌈',
    '&#x2308;': '⌈',
    '&lceil;': '⌈',
    // right ceiling
    '&#8969;': '⌉',
    '&#x2309;': '⌉',
    '&rceil;': '⌉',
    // left floor (APL downstile)
    '&#8970;': '⌊',
    '&#x230a;': '⌊',
    '&lfloor;': '⌊',
    // right floor
    '&#8971;': '⌋',
    '&#x230b;': '⌋',
    '&rfloor;': '⌋',
    // left-pointing angle bracket (bra)
    '&#9001;': '〈',
    '&#x2329;': '〈',
    '&lang;': '〈',
    // right-pointing angle bracket (ket)
    '&#9002;': '〉',
    '&#x232a;': '〉',
    '&rang;': '〉',
    // lozenge
    '&#9674;': '◊',
    '&#x25ca;': '◊',
    '&loz;': '◊',
    // black spade suit
    '&#9824;': '♠',
    '&#x2660;': '♠',
    '&spades;': '♠',
    // black club suit (shamrock)
    '&#9827;': '♣',
    '&#x2663;': '♣',
    '&clubs;': '♣',
    // black heart suit (valentine)
    '&#9829;': '♥',
    '&#x2665;': '♥',
    '&hearts;': '♥',
    // black diamond suit
    '&#9830;': '♦',
    '&#x2666;': '♦',
    '&diams;': '♦',
  };

  /// A map of all symbols with their corresponding non-ASCII code
  /// charcter entities.
  ///
  /// __Note:__ The following characters were left out of this map as
  /// values, as they do not have actual character representations:
  /// zero-width non-joiner (`&zwnj;`), zero-width joiner (`&zwj;`),
  ///  left-to-right mark (`&lrm;`), and right-to-left mark (`&rlm;`).
  static const Map<String, String> entities = <String, String>{
    // double quote
    '"': '&quot;',
    // ampersand
    '&': '&amp;',
    // apostrophe (single quote)
    '\'': '&apos;',
    // less-than
    '<': '&lt;',
    // greater-than
    '>': '&gt;',
    // non-breaking space
    ' ': '&nbsp;',
    // inverted exclamation mark
    '¡': '&iexcl;',
    // cent sign
    '¢': '&cent;',
    // pound sign
    '£': '&pound;',
    // currency sign
    '¤': '&curren;',
    // yen sign (yuan sign)
    '¥': '&yen;',
    // broken bar (broken vertical bar)
    '¦': '&brvbar;',
    // section sign
    '§': '&sect;',
    // diaeresis (spacing diaeresis)
    '¨': '&uml;',
    // copyright symbol
    '©': '&copy;',
    // feminine ordinal indicator
    'ª': '&ordf;',
    // left-pointing double angle quotation mark (left pointing guillemet)
    '«': '&laquo;',
    // not sign
    '¬': '&not;',
    // registered sign (registered trademark symbol)
    '®': '&reg;',
    // macron (spacing macron, overline, APL overbar)
    '¯': '&macr;',
    // degree symbol
    '°': '&deg;',
    // plus-minus sign (plus-or-minus sign)
    '±': '&plusmn;',
    // superscript two (superscript digit two, squared)
    '²': '&sup2;',
    // superscript three (superscript digit three, cubed)
    '³': '&sup3;',
    // acute accent (spacing acute)
    '´': '&acute;',
    // micro sign
    'µ': '&micro;',
    // pilcrow sign (paragraph sign)
    '¶': '&para;',
    // middle dot (Georgian comma, Greek middle dot)
    '·': '&middot;',
    // cedilla (spacing cedilla)
    '¸': '&cedil;',
    // superscript one (superscript digit one)
    '¹': '&sup1;',
    // masculine ordinal indicator
    'º': '&ordm;',
    // right-pointing double angle quotation mark (right pointing guillemet)
    '»': '&raquo;',
    // vulgar fraction one quarter (fraction one quarter)
    '¼': '&frac14;',
    // vulgar fraction one half (fraction one half)
    '½': '&frac12;',
    // vulgar fraction three quarters (fraction three quarters)
    '¾': '&frac34;',
    // inverted question mark (turned question mark)
    '¿': '&iquest;',
    // Latin capital letter A with grave accent (Latin capital letter A grave)
    'À': '&Agrave;',
    // Latin capital letter A with acute accent
    'Á': '&Aacute;',
    // Latin capital letter A with circumflex
    'Â': '&Acirc;',
    // Latin capital letter A with tilde
    'Ã': '&Atilde;',
    // Latin capital letter A with diaeresis
    'Ä': '&Auml;',
    // Latin capital letter A with ring above (Latin capital letter A ring)
    'Å': '&Aring;',
    // Latin capital letter AE (Latin capital ligature AE)
    'Æ': '&AElig;',
    // Latin capital letter C with cedilla
    'Ç': '&Ccedil;',
    // Latin capital letter E with grave accent
    'È': '&Egrave;',
    // Latin capital letter E with acute accent
    'É': '&Eacute;',
    // Latin capital letter E with circumflex
    'Ê': '&Ecirc;',
    // Latin capital letter E with diaeresis
    'Ë': '&Euml;',
    // Latin capital letter I with grave accent
    'Ì': '&Igrave;',
    // Latin capital letter I with acute accent
    'Í': '&Iacute;',
    // Latin capital letter I with circumflex
    'Î': '&Icirc;',
    // Latin capital letter I with diaeresis
    'Ï': '&Iuml;',
    // Latin capital letter Eth
    'Ð': '&ETH;',
    // Latin capital letter N with tilde
    'Ñ': '&Ntilde;',
    // Latin capital letter O with grave accent
    'Ò': '&Ograve;',
    // Latin capital letter O with acute accent
    'Ó': '&Oacute;',
    // Latin capital letter O with circumflex
    'Ô': '&Ocirc;',
    // Latin capital letter O with tilde
    'Õ': '&Otilde;',
    // Latin capital letter O with diaeresis
    'Ö': '&Ouml;',
    // multiplication sign
    '×': '&times;',
    // Latin capital letter O with stroke (Latin capital letter O slash)
    'Ø': '&Oslash;',
    // Latin capital letter U with grave accent
    'Ù': '&Ugrave;',
    // Latin capital letter U with acute accent
    'Ú': '&Uacute;',
    // Latin capital letter U with circumflex
    'Û': '&Ucirc;',
    // Latin capital letter U with diaeresis
    'Ü': '&Uuml;',
    // Latin capital letter Y with acute accent
    'Ý': '&Yacute;',
    // Latin capital letter THORN
    'Þ': '&THORN;',
    // Latin small letter sharp s (ess-zed); see German Eszett
    'ß': '&szlig;',
    // Latin small letter a with grave accent
    'à': '&agrave;',
    // Latin small letter a with acute accent
    'á': '&aacute;',
    // Latin small letter a with circumflex
    'â': '&acirc;',
    // Latin small letter a with tilde
    'ã': '&atilde;',
    // Latin small letter a with diaeresis
    'ä': '&auml;',
    // Latin small letter a with ring above
    'å': '&aring;',
    // Latin small letter ae (Latin small ligature ae)
    'æ': '&aelig;',
    // Latin small letter c with cedilla
    'ç': '&ccedil;',
    // Latin small letter e with grave accent
    'è': '&egrave;',
    // Latin small letter e with acute accent
    'é': '&eacute;',
    // Latin small letter e with circumflex
    'ê': '&ecirc;',
    // Latin small letter e with diaeresis
    'ë': '&euml;',
    // Latin small letter i with grave accent
    'ì': '&igrave;',
    // Latin small letter i with acute accent
    'í': '&iacute;',
    // Latin small letter i with circumflex
    'î': '&icirc;',
    // Latin small letter i with diaeresis
    'ï': '&iuml;',
    // Latin small letter eth
    'ð': '&eth;',
    // Latin small letter n with tilde
    'ñ': '&ntilde;',
    // Latin small letter o with grave accent
    'ò': '&ograve;',
    // Latin small letter o with acute accent
    'ó': '&oacute;',
    // Latin small letter o with circumflex
    'ô': '&ocirc;',
    // Latin small letter o with tilde
    'õ': '&otilde;',
    // Latin small letter o with diaeresis
    'ö': '&ouml;',
    // division sign (obelus)
    '÷': '&divide;',
    // Latin small letter o with stroke (Latin small letter o slash)
    'ø': '&oslash;',
    // Latin small letter u with grave accent
    'ù': '&ugrave;',
    // Latin small letter u with acute accent
    'ú': '&uacute;',
    // Latin small letter u with circumflex
    'û': '&ucirc;',
    // Latin small letter u with diaeresis
    'ü': '&uuml;',
    // Latin small letter y with acute accent
    'ý': '&yacute;',
    // Latin small letter thorn
    'þ': '&thorn;',
    // Latin small letter y with diaeresis
    'ÿ': '&yuml;',
    // Latin capital ligature oe
    'Œ': '&OElig;',
    // Latin small ligature oe
    'œ': '&oelig;',
    // Latin capital letter s with caron
    'Š': '&Scaron;',
    // Latin small letter s with caron
    'š': '&scaron;',
    // Latin capital letter y with diaeresis
    'Ÿ': '&Yuml;',
    // Latin small letter f with hook (function, florin)
    'ƒ': '&fnof;',
    // modifier letter circumflex accent
    'ˆ': '&circ;',
    // small tilde
    '˜': '&tilde;',
    // Greek capital letter Alpha
    'Α': '&Alpha;',
    // Greek capital letter Beta
    'Β': '&Beta;',
    // Greek capital letter Gamma
    'Γ': '&Gamma;',
    // Greek capital letter Delta
    'Δ': '&Delta;',
    // Greek capital letter Epsilon
    'Ε': '&Epsilon;',
    // Greek capital letter Zeta
    'Ζ': '&Zeta;',
    // Greek capital letter Eta
    'Η': '&Eta;',
    // Greek capital letter Theta
    'Θ': '&Theta;',
    // Greek capital letter Iota
    'Ι': '&Iota;',
    // Greek capital letter Kappa
    'Κ': '&Kappa;',
    // Greek capital letter Lambda
    'Λ': '&Lambda;',
    // Greek capital letter Mu
    'Μ': '&Mu;',
    // Greek capital letter Nu
    'Ν': '&Nu;',
    // Greek capital letter Xi
    'Ξ': '&Xi;',
    // Greek capital letter Omicron
    'Ο': '&Omicron;',
    // Greek capital letter Pi
    'Π': '&Pi;',
    // Greek capital letter Rho
    'Ρ': '&Rho;',
    // Greek capital letter Sigma
    'Σ': '&Sigma;',
    // Greek capital letter Tau
    'Τ': '&Tau;',
    // Greek capital letter Upsilon
    'Υ': '&Upsilon;',
    // Greek capital letter Phi
    'Φ': '&Phi;',
    // Greek capital letter Chi
    'Χ': '&Chi;',
    // Greek capital letter Psi
    'Ψ': '&Psi;',
    // Greek capital letter Omega
    'Ω': '&Omega;',
    // Greek small letter alpha
    'α': '&alpha;',
    // Greek small letter beta
    'β': '&beta;',
    // Greek small letter gamma
    'γ': '&gamma;',
    // Greek small letter delta
    'δ': '&delta;',
    // Greek small letter epsilon
    'ε': '&epsilon;',
    // Greek small letter zeta
    'ζ': '&zeta;',
    // Greek small letter eta
    'η': '&eta;',
    // Greek small letter theta
    'θ': '&theta;',
    // Greek small letter iota
    'ι': '&iota;',
    // Greek small letter kappa
    'κ': '&kappa;',
    // Greek small letter lambda
    'λ': '&lambda;',
    // Greek small letter mu
    'μ': '&mu;',
    // Greek small letter nu
    'ν': '&nu;',
    // Greek small letter xi
    'ξ': '&xi;',
    // Greek small letter omicron
    'ο': '&omicron;',
    // Greek small letter pi
    'π': '&pi;',
    // Greek small letter rho
    'ρ': '&rho;',
    // Greek small letter final sigma
    'ς': '&sigmaf;',
    // Greek small letter sigma
    'σ': '&sigma;',
    // Greek small letter tau
    'τ': '&tau;',
    // Greek small letter upsilon
    'υ': '&upsilon;',
    // Greek small letter phi
    'φ': '&phi;',
    // Greek small letter chi
    'χ': '&chi;',
    // Greek small letter psi
    'ψ': '&psi;',
    // Greek small letter omega
    'ω': '&omega;',
    // Greek theta symbol
    'ϑ': '&thetasym;',
    // Greek Upsilon with hook symbol
    'ϒ': '&upsih;',
    // Greek pi symbol
    'ϖ': '&piv;',
    // en space
    ' ': '&ensp;',
    // em space
    ' ': '&emsp;',
    // thin space
    ' ': '&thinsp;',
    // en dash
    '–': '&ndash;',
    // em dash
    '—': '&mdash;',
    // left single quotation mark
    '‘': '&lsquo;',
    // right single quotation mark
    '’': '&rsquo;',
    // single low-9 quotation mark
    '‚': '&sbquo;',
    // left double quotation mark
    '“': '&ldquo;',
    // right double quotation mark
    '”': '&rdquo;',
    // double low-9 quotation mark
    '„': '&bdquo;',
    // dagger, obelisk
    '†': '&dagger;',
    // double dagger (double obelisk)
    '‡': '&Dagger;',
    // bullet (black small circle)
    '•': '&bull;',
    // horizontal ellipsis (three dot leader)
    '…': '&hellip;',
    // per mille sign
    '‰': '&permil;',
    // prime (minutes, feet)
    '′': '&prime;',
    // double prime (seconds, inches)
    '″': '&Prime;',
    // single left-pointing angle quotation mark
    '‹': '&lsaquo;',
    // single right-pointing angle quotation mark
    '›': '&rsaquo;',
    // overline (spacing overscore)
    '‾': '&oline;',
    // fraction slash (solidus)
    '⁄': '&frasl;',
    // euro sign
    '€': '&euro;',
    // black-letter capital I (imaginary part)
    'ℑ': '&image;',
    // script capital P (power set, Weierstrass p)
    '℘': '&weierp;',
    // black-letter capital R (real part symbol)
    'ℜ': '&real;',
    // trademark symbol
    '™': '&trade;',
    // alef symbol (first transfinite cardinal)
    'ℵ': '&alefsym;',
    // leftwards arrow
    '←': '&larr;',
    // upwards arrow
    '↑': '&uarr;',
    // rightwards arrow
    '→': '&rarr;',
    // downwards arrow
    '↓': '&darr;',
    // left right arrow
    '↔': '&harr;',
    // downwards arrow with corner leftwards (carriage return)
    '↵': '&crarr;',
    // leftwards double arrow
    '⇐': '&lArr;',
    // upwards double arrow
    '⇑': '&uArr;',
    // rightwards double arrow
    '⇒': '&rArr;',
    // downwards double arrow
    '⇓': '&dArr;',
    // left right double arrow
    '⇔': '&hArr;',
    // for all
    '∀': '&forall;',
    // partial differential
    '∂': '&part;',
    // there exists
    '∃': '&exist;',
    // empty set (null set)
    '∅': '&empty;',
    // del or nabla (vector differential operator)
    '∇': '&nabla;',
    // element of
    '∈': '&isin;',
    // not an element of
    '∉': '&notin;',
    // contains as member
    '∋': '&ni;',
    // n-ary product (product sign)
    '∏': '&prod;',
    // n-ary summation
    '∑': '&sum;',
    // minus sign
    '−': '&minus;',
    // asterisk operator
    '∗': '&lowast;',
    // square root (radical sign)
    '√': '&radic;',
    // proportional to
    '∝': '&prop;',
    // infinity
    '∞': '&infin;',
    // angle
    '∠': '&ang;',
    // logical and (wedge)
    '∧': '&and;',
    // logical or (vee)
    '∨': '&or;',
    // intersection (cap)
    '∩': '&cap;',
    // union (cup)
    '∪': '&cup;',
    // integral
    '∫': '&int;',
    // therefore sign
    '∴': '&there4;',
    // tilde operator (varies with, similar to)
    '∼': '&sim;',
    // congruent to
    '≅': '&cong;',
    // almost equal to (asymptotic to)
    '≈': '&asymp;',
    // not equal to
    '≠': '&ne;',
    // identical to; sometimes used for 'equivalent to'
    '≡': '&equiv;',
    // less-than or equal to
    '≤': '&le;',
    // greater-than or equal to
    '≥': '&ge;',
    // subset of
    '⊂': '&sub;',
    // superset of
    '⊃': '&sup;',
    // not a subset of
    '⊄': '&nsub;',
    // subset of or equal to
    '⊆': '&sube;',
    // superset of or equal to
    '⊇': '&supe;',
    // circled plus (direct sum)
    '⊕': '&oplus;',
    // circled times (vector product)
    '⊗': '&otimes;',
    // up tack (orthogonal to, perpendicular)
    '⊥': '&perp;',
    // dot operator
    '⋅': '&sdot;',
    // vertical ellipsis
    '⋮': '&vellip;',
    // left ceiling (APL upstile)
    '⌈': '&lceil;',
    // right ceiling
    '⌉': '&rceil;',
    // left floor (APL downstile)
    '⌊': '&lfloor;',
    // right floor
    '⌋': '&rfloor;',
    // left-pointing angle bracket (bra)
    '〈': '&lang;',
    // right-pointing angle bracket (ket)
    '〉': '&rang;',
    // lozenge
    '◊': '&loz;',
    // black spade suit
    '♠': '&spades;',
    // black club suit (shamrock)
    '♣': '&clubs;',
    // black heart suit (valentine)
    '♥': '&hearts;',
    // black diamond suit
    '♦': '&diams;',
  };

  /// A map of all symbols with an ASCII code character entity.
  ///
  /// __Note:__ The space character (` `) will return a non-breaking
  /// space (`&#160;`). As such, the space character code `&#32;` does
  /// not exist as a value in this map.
  ///
  /// The soft hyphen character code (`&#173;`) is also left out of this
  /// map, as it doesn't have an actual character representation.
  static const Map<String, String> asciiCodes = <String, String>{
    // exclamation mark
    '!': '&#33;',
    // double quote
    '"': '&#34;',
    // number sign
    '#': '&#35;',
    // dollar sign
    '\$': '&#36;',
    // percent sign
    '%': '&#37;',
    // ampersand
    '&': '&#38;',
    // apostrophe (single quote)
    '\'': '&#39;',
    // opening parenthesis
    '(': '&#40;',
    // closing parenthesis
    ')': '&#41;',
    // asterisk
    '*': '&#42;',
    // plus sign
    '+': '&#43;',
    // comma
    ',': '&#44;',
    // minus sign (hyphen)
    '-': '&#45;',
    // period
    '.': '&#46;',
    // slash
    '/': '&#47;',
    // zero
    '0': '&#48;',
    // one
    '1': '&#49;',
    // two
    '2': '&#50;',
    // three
    '3': '&#51;',
    // four
    '4': '&#52;',
    // five
    '5': '&#53;',
    // six
    '6': '&#54;',
    // seven
    '7': '&#55;',
    // eight
    '8': '&#56;',
    // nine
    '9': '&#57;',
    // colon
    ':': '&#58;',
    // semicolon
    ';': '&#59;',
    // less-than
    '<': '&#60;',
    // equal sign
    '=': '&#61;',
    // greater-than
    '>': '&#62;',
    // question mark
    '?': '&#63;',
    // at symbol
    '@': '&#64;',
    // uppercase a
    'A': '&#65;',
    // uppercase b
    'B': '&#66;',
    // uppercase c
    'C': '&#67;',
    // uppercase d
    'D': '&#68;',
    // uppercase e
    'E': '&#69;',
    // uppercase f
    'F': '&#70;',
    // uppercase g
    'G': '&#71;',
    // uppercase h
    'H': '&#72;',
    // uppercase i
    'I': '&#73;',
    // uppercase j
    'J': '&#74;',
    // uppercase k
    'K': '&#75;',
    // uppercase l
    'L': '&#76;',
    // uppercase m
    'M': '&#77;',
    // uppercase n
    'N': '&#78;',
    // uppercase o
    'O': '&#79;',
    // uppercase p
    'P': '&#80;',
    // uppercase q
    'Q': '&#81;',
    // uppercase r
    'R': '&#82;',
    // uppercase s
    'S': '&#83;',
    // uppercase t
    'T': '&#84;',
    // uppercase u
    'U': '&#85;',
    // uppercase v
    'V': '&#86;',
    // uppercase w
    'W': '&#87;',
    // uppercase x
    'X': '&#88;',
    // uppercase y
    'Y': '&#89;',
    // uppercase z
    'Z': '&#90;',
    // opening bracket
    '[': '&#91;',
    // backslash
    '\\': '&#92;',
    // closing bracket
    ']': '&#93;',
    // caret (circumflex)
    '^': '&#94;',
    // underscore
    '_': '&#95;',
    // grave accent
    '`': '&#96;',
    // lowercase a
    'a': '&#97;',
    // lowercase b
    'b': '&#98;',
    // lowercase c
    'c': '&#99;',
    // lowercase d
    'd': '&#100;',
    // lowercase e
    'e': '&#101;',
    // lowercase f
    'f': '&#102;',
    // lowercase g
    'g': '&#103;',
    // lowercase h
    'h': '&#104;',
    // lowercase i
    'i': '&#105;',
    // lowercase j
    'j': '&#106;',
    // lowercase k
    'k': '&#107;',
    // lowercase l
    'l': '&#108;',
    // lowercase m
    'm': '&#109;',
    // lowercase n
    'n': '&#110;',
    // lowercase o
    'o': '&#111;',
    // lowercase p
    'p': '&#112;',
    // lowercase q
    'q': '&#113;',
    // lowercase r
    'r': '&#114;',
    // lowercase s
    's': '&#115;',
    // lowercase t
    't': '&#116;',
    // lowercase u
    'u': '&#117;',
    // lowercase v
    'v': '&#118;',
    // lowercase w
    'w': '&#119;',
    // lowercase x
    'x': '&#120;',
    // lowercase y
    'y': '&#121;',
    // lowercase z
    'z': '&#122;',
    // opening brace
    '{': '&#123;',
    // vertical bar
    '|': '&#124;',
    // closing brace
    '}': '&#125;',
    // equivalency sign (tilde)
    '~': '&#126;',
    // non-breaking space
    ' ': '&#160;',
    // inverted exclamation mark
    '¡': '&#161;',
    // cent sign
    '¢': '&#162;',
    // pound sign
    '£': '&#163;',
    // currency sign
    '¤': '&#164;',
    // yen sign (yuan sign)
    '¥': '&#165;',
    // broken bar (broken vertical bar)
    '¦': '&#166;',
    // section sign
    '§': '&#167;',
    // diaeresis (spacing diaeresis)
    '¨': '&#168;',
    // copyright symbol
    '©': '&#169;',
    // feminine ordinal indicator
    'ª': '&#170;',
    // left-pointing double angle quotation mark (left pointing guillemet)
    '«': '&#171;',
    // not sign
    '¬': '&#172;',
    // registered sign (registered trademark symbol)
    '®': '&#174;',
    // macron (spacing macron, overline, APL overbar)
    '¯': '&#175;',
    // degree symbol
    '°': '&#176;',
    // plus-minus sign (plus-or-minus sign)
    '±': '&#177;',
    // superscript two (superscript digit two, squared)
    '²': '&#178;',
    // superscript three (superscript digit three, cubed)
    '³': '&#179;',
    // acute accent (spacing acute)
    '´': '&#180;',
    // micro sign
    'µ': '&#181;',
    // pilcrow sign (paragraph sign)
    '¶': '&#182;',
    // middle dot (Georgian comma, Greek middle dot)
    '·': '&#183;',
    // cedilla (spacing cedilla)
    '¸': '&#184;',
    // superscript one (superscript digit one)
    '¹': '&#185;',
    // masculine ordinal indicator
    'º': '&#186;',
    // right-pointing double angle quotation mark (right pointing guillemet)
    '»': '&#187;',
    // vulgar fraction one quarter (fraction one quarter)
    '¼': '&#188;',
    // vulgar fraction one half (fraction one half)
    '½': '&#189;',
    // vulgar fraction three quarters (fraction three quarters)
    '¾': '&#190;',
    // inverted question mark (turned question mark)
    '¿': '&#191;',
    // Latin capital letter A with grave accent (Latin capital letter A grave)
    'À': '&#192;',
    // Latin capital letter A with acute accent
    'Á': '&#193;',
    // Latin capital letter A with circumflex
    'Â': '&#194;',
    // Latin capital letter A with tilde
    'Ã': '&#195;',
    // Latin capital letter A with diaeresis
    'Ä': '&#196;',
    // Latin capital letter A with ring above (Latin capital letter A ring)
    'Å': '&#197;',
    // Latin capital letter AE (Latin capital ligature AE)
    'Æ': '&#198;',
    // Latin capital letter C with cedilla
    'Ç': '&#199;',
    // Latin capital letter E with grave accent
    'È': '&#200;',
    // Latin capital letter E with acute accent
    'É': '&#201;',
    // Latin capital letter E with circumflex
    'Ê': '&#202;',
    // Latin capital letter E with diaeresis
    'Ë': '&#203;',
    // Latin capital letter I with grave accent
    'Ì': '&#204;',
    // Latin capital letter I with acute accent
    'Í': '&#205;',
    // Latin capital letter I with circumflex
    'Î': '&#206;',
    // Latin capital letter I with diaeresis
    'Ï': '&#207;',
    // Latin capital letter Eth
    'Ð': '&#208;',
    // Latin capital letter N with tilde
    'Ñ': '&#209;',
    // Latin capital letter O with grave accent
    'Ò': '&#210;',
    // Latin capital letter O with acute accent
    'Ó': '&#211;',
    // Latin capital letter O with circumflex
    'Ô': '&#212;',
    // Latin capital letter O with tilde
    'Õ': '&#213;',
    // Latin capital letter O with diaeresis
    'Ö': '&#214;',
    // multiplication sign
    '×': '&#215;',
    // Latin capital letter O with stroke (Latin capital letter O slash)
    'Ø': '&#216;',
    // Latin capital letter U with grave accent
    'Ù': '&#217;',
    // Latin capital letter U with acute accent
    'Ú': '&#218;',
    // Latin capital letter U with circumflex
    'Û': '&#219;',
    // Latin capital letter U with diaeresis
    'Ü': '&#220;',
    // Latin capital letter Y with acute accent
    'Ý': '&#221;',
    // Latin capital letter THORN
    'Þ': '&#222;',
    // Latin small letter sharp s (ess-zed); see German Eszett
    'ß': '&#223;',
    // Latin small letter a with grave accent
    'à': '&#224;',
    // Latin small letter a with acute accent
    'á': '&#225;',
    // Latin small letter a with circumflex
    'â': '&#226;',
    // Latin small letter a with tilde
    'ã': '&#227;',
    // Latin small letter a with diaeresis
    'ä': '&#228;',
    // Latin small letter a with ring above
    'å': '&#229;',
    // Latin small letter ae (Latin small ligature ae)
    'æ': '&#230;',
    // Latin small letter c with cedilla
    'ç': '&#231;',
    // Latin small letter e with grave accent
    'è': '&#232;',
    // Latin small letter e with acute accent
    'é': '&#233;',
    // Latin small letter e with circumflex
    'ê': '&#234;',
    // Latin small letter e with diaeresis
    'ë': '&#235;',
    // Latin small letter i with grave accent
    'ì': '&#236;',
    // Latin small letter i with acute accent
    'í': '&#237;',
    // Latin small letter i with circumflex
    'î': '&#238;',
    // Latin small letter i with diaeresis
    'ï': '&#239;',
    // Latin small letter eth
    'ð': '&#240;',
    // Latin small letter n with tilde
    'ñ': '&#241;',
    // Latin small letter o with grave accent
    'ò': '&#242;',
    // Latin small letter o with acute accent
    'ó': '&#243;',
    // Latin small letter o with circumflex
    'ô': '&#244;',
    // Latin small letter o with tilde
    'õ': '&#245;',
    // Latin small letter o with diaeresis
    'ö': '&#246;',
    // division sign (obelus)
    '÷': '&#247;',
    // Latin small letter o with stroke (Latin small letter o slash)
    'ø': '&#248;',
    // Latin small letter u with grave accent
    'ù': '&#249;',
    // Latin small letter u with acute accent
    'ú': '&#250;',
    // Latin small letter u with circumflex
    'û': '&#251;',
    // Latin small letter u with diaeresis
    'ü': '&#252;',
    // Latin small letter y with acute accent
    'ý': '&#253;',
    // Latin small letter thorn
    'þ': '&#254;',
    // Latin small letter y with diaeresis
    'ÿ': '&#255;',
    // Latin capital ligature oe
    'Œ': '&#338;',
    // Latin small ligature oe
    'œ': '&#339;',
    // Latin capital letter s with caron
    'Š': '&#352;',
    // Latin small letter s with caron
    'š': '&#353;',
    // Latin capital letter w with circumflex
    'Ŵ': '&#372;',
    // Latin small letter w with circumflex
    'ŵ': '&#373;',
    // Latin capital letter y with circumflex
    'Ŷ': '&#374;',
    // Latin small letter y with circumflex
    'ŷ': '&#375;',
    // Latin capital letter y with diaeresis
    'Ÿ': '&#376;',
    // Latin small letter f with hook (function, florin)
    'ƒ': '&#402;',
    // modifier letter circumflex accent
    'ˆ': '&#710;',
    // small tilde
    '˜': '&#732;',
    // Greek capital letter Alpha
    'Α': '&#913;',
    // Greek capital letter Beta
    'Β': '&#914;',
    // Greek capital letter Gamma
    'Γ': '&#915;',
    // Greek capital letter Delta
    'Δ': '&#916;',
    // Greek capital letter Epsilon
    'Ε': '&#917;',
    // Greek capital letter Zeta
    'Ζ': '&#918;',
    // Greek capital letter Eta
    'Η': '&#919;',
    // Greek capital letter Theta
    'Θ': '&#920;',
    // Greek capital letter Iota
    'Ι': '&#921;',
    // Greek capital letter Kappa
    'Κ': '&#922;',
    // Greek capital letter Lambda
    'Λ': '&#923;',
    // Greek capital letter Mu
    'Μ': '&#924;',
    // Greek capital letter Nu
    'Ν': '&#925;',
    // Greek capital letter Xi
    'Ξ': '&#926;',
    // Greek capital letter Omicron
    'Ο': '&#927;',
    // Greek capital letter Pi
    'Π': '&#928;',
    // Greek capital letter Rho
    'Ρ': '&#929;',
    // Greek capital letter Sigma
    'Σ': '&#931;',
    // Greek capital letter Tau
    'Τ': '&#932;',
    // Greek capital letter Upsilon
    'Υ': '&#933;',
    // Greek capital letter Phi
    'Φ': '&#934;',
    // Greek capital letter Chi
    'Χ': '&#935;',
    // Greek capital letter Psi
    'Ψ': '&#936;',
    // Greek capital letter Omega
    'Ω': '&#937;',
    // Greek capital letter iota with dialytika
    'Ϊ': '&#938;',
    // Greek capital letter upsilon with dialytika
    'Ϋ': '&#939;',
    // Greek small letter alpha with tonos
    'ά': '&#940;',
    // Greek small letter epsilon with tonos
    'έ': '&#941;',
    // Greek small letter eta with tonos
    'ή': '&#942;',
    // Greek small letter iota with tonos
    'ί': '&#943;',
    // Greek small letter upsilon with dialytika and tonos
    'ΰ': '&#944;',
    // Greek small letter alpha
    'α': '&#945;',
    // Greek small letter beta
    'β': '&#946;',
    // Greek small letter gamma
    'γ': '&#947;',
    // Greek small letter delta
    'δ': '&#948;',
    // Greek small letter epsilon
    'ε': '&#949;',
    // Greek small letter zeta
    'ζ': '&#950;',
    // Greek small letter eta
    'η': '&#951;',
    // Greek small letter theta
    'θ': '&#952;',
    // Greek small letter iota
    'ι': '&#953;',
    // Greek small letter kappa
    'κ': '&#954;',
    // Greek small letter lambda
    'λ': '&#955;',
    // Greek small letter mu
    'μ': '&#956;',
    // Greek small letter nu
    'ν': '&#957;',
    // Greek small letter xi
    'ξ': '&#958;',
    // Greek small letter omicron
    'ο': '&#959;',
    // Greek small letter pi
    'π': '&#960;',
    // Greek small letter rho
    'ρ': '&#961;',
    // Greek small letter final sigma
    'ς': '&#962;',
    // Greek small letter sigma
    'σ': '&#963;',
    // Greek small letter tau
    'τ': '&#964;',
    // Greek small letter upsilon
    'υ': '&#965;',
    // Greek small letter phi
    'φ': '&#966;',
    // Greek small letter chi
    'χ': '&#967;',
    // Greek small letter psi
    'ψ': '&#968;',
    // Greek small letter omega
    'ω': '&#969',
    // Greek small letter iota with dialytika
    'ϊ': '&#970;',
    // Greek small letter upsilon with dialytika
    'ϋ': '&#971;',
    // Greek small letter omicron with tonos
    'ό': '&#972;',
    // Greek small letter upsilon with tonos
    'ύ': '&#973;',
    // Greek small letter omega with tonos
    'ώ': '&#974;',
    // Greek capital kai symbol
    'Ϗ': '&#975;',
    // Greek beta symbol
    'ϐ': '&#976;',
    // Greek theta symbol
    'ϑ': '&#977;',
    // Greek upsilon with hook symbol
    'ϒ': '&#978;',
    // Greek upsilon with acute and hook symbol
    'ϓ': '&#979;',
    // Greek upsilon with diaeresis and hook symbol
    'ϔ': '&#980;',
    // Greek phi symbol
    'ϕ': '&#981;',
    // Greek pi symbol
    'ϖ': '&#982;',
    // Latin capital letter w with grave
    'Ẁ': '&#7808;',
    // Latin small letter w with grave
    'ẁ': '&#7809;',
    // Latin capital letter w with acute
    'Ẃ': '&#7810;',
    // Latin small letter w with acute
    'ẃ': '&#7811;',
    // Latin capital letter w with diaeresis
    'Ẅ': '&#7812;',
    // Latin small letter w with diaeresis
    'ẅ': '&#7813;',
    // Latin capital letter y with grave
    'Ỳ': '&#7922;',
    // Latin small letter y with grave
    'ỳ': '&#7923;',
    // en space
    ' ': '&#8194;',
    // em space
    ' ': '&#8195;',
    // thin space
    ' ': '&#8201;',
    // en dash
    '–': '&#8211;',
    // em dash
    '—': '&#8212;',
    // left single quotation mark
    '‘': '&#8216;',
    // right single quotation mark
    '’': '&#8217;',
    // single low-9 quotation mark
    '‚': '&#8218;',
    // left double quotation mark
    '“': '&#8220;',
    // right double quotation mark
    '”': '&#8221;',
    // double low-9 quotation mark
    '„': '&#8222;',
    // dagger, obelisk
    '†': '&#8224;',
    // double dagger (double obelisk)
    '‡': '&#8225;',
    // bullet (black small circle)
    '•': '&#8226;',
    // horizontal ellipsis (three dot leader)
    '…': '&#8230;',
    // per mille sign
    '‰': '&#8240;',
    // prime (minutes, feet)
    '′': '&#8242;',
    // double prime (seconds, inches)
    '″': '&#8243;',
    // single left-pointing angle quotation mark
    '‹': '&#8249;',
    // single right-pointing angle quotation mark
    '›': '&#8250;',
    // overline (spacing overscore)
    '‾': '&#8254;',
    // fraction slash (solidus)
    '⁄': '&#8260;',
    // euro sign
    '€': '&#8364;',
    // black-letter capital I (imaginary part)
    'ℑ': '&#8465;',
    // script capital P (power set, Weierstrass p)
    '℘': '&#8472;',
    // black-letter capital R (real part symbol)
    'ℜ': '&#8476;',
    // trademark symbol
    '™': '&#8482;',
    // alef symbol (first transfinite cardinal)
    'ℵ': '&#8501;',
    // leftwards arrow
    '←': '&#8592;',
    // upwards arrow
    '↑': '&#8593;',
    // rightwards arrow
    '→': '&#8594;',
    // downwards arrow
    '↓': '&#8595;',
    // left right arrow
    '↔': '&#8596;',
    // downwards arrow with corner leftwards (carriage return)
    '↵': '&#8629;',
    // leftwards double arrow
    '⇐': '&#8656;',
    // upwards double arrow
    '⇑': '&#8657;',
    // rightwards double arrow
    '⇒': '&#8658',
    // downwards double arrow
    '⇓': '&#8659;',
    // left right double arrow
    '⇔': '&#8660;',
    // for all
    '∀': '&#8704;',
    // partial differential
    '∂': '&#8706;',
    // there exists
    '∃': '&#8707;',
    // empty set (null set)
    '∅': '&#8709;',
    // del or nabla (vector differential operator)
    '∇': '&#8711;',
    // element of
    '∈': '&#8712;',
    // not an element of
    '∉': '&#8713;',
    // contains as member
    '∋': '&#8715;',
    // n-ary product (product sign)
    '∏': '&#8719;',
    // n-ary summation
    '∑': '&#8721;',
    // minus sign
    '−': '&#8722;',
    // asterisk operator
    '∗': '&#8727;',
    // square root (radical sign)
    '√': '&#8730;',
    // proportional to
    '∝': '&#8733;',
    // infinity
    '∞': '&#8734;',
    // angle
    '∠': '&#8736;',
    // logical and (wedge)
    '∧': '&#8743;',
    // logical or (vee)
    '∨': '&#8744;',
    // intersection (cap)
    '∩': '&#8745;',
    // union (cup)
    '∪': '&#8746;',
    // integral
    '∫': '&#8747;',
    // therefore sign
    '∴': '&#8756;',
    // tilde operator (varies with, similar to)
    '∼': '&#8764;',
    // congruent to
    '≅': '&#8773;',
    // almost equal to (asymptotic to)
    '≈': '&#8776;',
    // not equal to
    '≠': '&#8800;',
    // identical to; sometimes used for 'equivalent to'
    '≡': '&#8801;',
    // less-than or equal to
    '≤': '&#8804;',
    // greater-than or equal to
    '≥': '&#8805;',
    // subset of
    '⊂': '&#8834;',
    // superset of
    '⊃': '&#8835;',
    // not a subset of
    '⊄': '&#8836;',
    // subset of or equal to
    '⊆': '&#8838;',
    // superset of or equal to
    '⊇': '&#8839;',
    // circled plus (direct sum)
    '⊕': '&#8853;',
    // circled times (vector product)
    '⊗': '&#8855;',
    // up tack (orthogonal to, perpendicular)
    '⊥': '&#8869;',
    // dot operator
    '⋅': '&#8901;',
    // vertical ellipsis
    '⋮': '&#8942;',
    // left ceiling (APL upstile)
    '⌈': '&#8968;',
    // right ceiling
    '⌉': '&#8969;',
    // left floor (APL downstile)
    '⌊': '&#8970;',
    // right floor
    '⌋': '&#8971;',
    // left-pointing angle bracket (bra)
    '〈': '&#9001;',
    // right-pointing angle bracket (ket)
    '〉': '&#9002;',
    // lozenge
    '◊': '&#9674;',
    // black spade suit
    '♠': '&#9824;',
    // black club suit (shamrock)
    '♣': '&#9827;',
    // black heart suit (valentine)
    '♥': '&#9829;',
    // black diamond suit
    '♦': '&#9830;',
  };

  /// A map of all symbols with a hex code character entities.
  static const Map<String, String> hexCodes = <String, String>{
    // exclamation mark
    '!': '&#x21;',
    // double quote
    '"': '&#x22;',
    // number sign
    '#': '&#x23;',
    // dollar sign
    '\$': '&#x24;',
    // percent sign
    '%': '&#x25;',
    // ampersand
    '&': '&#x26',
    // apostrophe (single quote)
    '\'': '&#x27;',
    // opening parenthesis
    '(': '&#x28;',
    // closing parenthesis
    ')': '&#x29;',
    // asterisk
    '*': '&#x2a;',
    // plus sign
    '+': '&#x2b;',
    // comma
    ',': '&#x2c',
    // minus sign (hyphen)
    '-': '&#x2d',
    // period
    '.': '&#x2e;',
    // slash
    '/': '&#x2f;',
    // zero
    '0': '&#x30;',
    // one
    '1': '&#x31;',
    // two
    '2': '&#x32;',
    // three
    '3': '&#x33',
    // four
    '4': '&#x34',
    // five
    '5': '&#x35',
    // six
    '6': '&#x36',
    // seven
    '7': '&#x37',
    // eight
    '8': '&#x38',
    // nine
    '9': '&#x39',
    // colon
    ':': '&#x3a;',
    // semicolon
    ';': '&#x3b;',
    // less-than
    '<': '&#x3c;',
    // equal sign
    '=': '&#x3d;',
    // greater-than
    '>': '&#x3e;',
    // question mark
    '?': '&#x3f;',
    // at symbol
    '@': '&#x40;',
    // uppercase a
    'A': '&#x41;',
    // uppercase b
    'B': '&#x42;',
    // uppercase c
    'C': '&#x43;',
    // uppercase d
    'D': '&#x44;',
    // uppercase e
    'E': '&#x45;',
    // uppercase f
    'F': '&#x46;',
    // uppercase g
    'G': '&#x47;',
    // uppercase h
    'H': '&#x48;',
    // uppercase i
    'I': '&#x49;',
    // uppercase j
    'J': '&#x4a;',
    // uppercase k
    'K': '&#x4b;',
    // uppercase l
    'L': '&#x4c;',
    // uppercase m
    'M': '&#x4d;',
    // uppercase n
    'N': '&#x4e;',
    // uppercase o
    'O': '&#x4f;',
    // uppercase p
    'P': '&#x50;',
    // uppercase q
    'Q': '&#x51;',
    // uppercase r
    'R': '&#x52;',
    // uppercase s
    'S': '&#x53;',
    // uppercase t
    'T': '&#x54;',
    // uppercase u
    'U': '&#x55;',
    // uppercase v
    'V': '&#x56;',
    // uppercase w
    'W': '&#x57;',
    // uppercase x
    'X': '&#x58;',
    // uppercase y
    'Y': '&#x59;',
    // uppercase z
    'Z': '&#x5a;',
    // opening bracket
    '[': '&#x5b;',
    // backslash
    '\\': '&#x5c;',
    // closing bracket
    ']': '&#x5d;',
    // caret (circumflex)
    '^': '&#x5e;',
    // underscore
    '_': '&#x5f;',
    // grave accent
    '`': '&#x60;',
    // lowercase a
    'a': '&#x61;',
    // lowercase b
    'b': '&#x62;',
    // lowercase c
    'c': '&#x63;',
    // lowercase d
    'd': '&#x64;',
    // lowercase e
    'e': '&#x65;',
    // lowercase f
    'f': '&#x66;',
    // lowercase g
    'g': '&#x67;',
    // lowercase h
    'h': '&#x68;',
    // lowercase i
    'i': '&#x69;',
    // lowercase j
    'j': '&#x6a;',
    // lowercase k
    'k': '&#x6b;',
    // lowercase l
    'l': '&#x6c;',
    // lowercase m
    'm': '&#x6d;',
    // lowercase n
    'n': '&#x6e;',
    // lowercase o
    'o': '&#x6f;',
    // lowercase p
    'p': '&#x70;',
    // lowercase q
    'q': '&#x71;',
    // lowercase r
    'r': '&#x72;',
    // lowercase s
    's': '&#x73;',
    // lowercase t
    't': '&#x74;',
    // lowercase u
    'u': '&#x75;',
    // lowercase v
    'v': '&#x76;',
    // lowercase w
    'w': '&#x77;',
    // lowercase x
    'x': '&#x78;',
    // lowercase y
    'y': '&#x79;',
    // lowercase z
    'z': '&#x7a;',
    // opening brace
    '{': '&#x7b;',
    // vertical bar
    '|': '&#x7c;',
    // closing brace
    '}': '&#x7d;',
    // equivalency sign (tilde)
    '~': '&#x7e;',
    // non-breaking space
    ' ': '&#xa0;',
    // inverted exclamation mark
    '¡': '&#xa1;',
    // cent sign
    '¢': '&#xa2;',
    // pound sign
    '£': '&#xa3;',
    // currency sign
    '¤': '&#xa4;',
    // yen sign (yuan sign)
    '¥': '&#xa5;',
    // broken bar (broken vertical bar)
    '¦': '&#xa6;',
    // section sign
    '§': '&#xa7;',
    // diaeresis (spacing diaeresis)
    '¨': '&#xa8;',
    // copyright symbol
    '©': '&#xa9;',
    // feminine ordinal indicator
    'ª': '&#xaa;',
    // left-pointing double angle quotation mark (left pointing guillemet)
    '«': '&#xab;',
    // not sign
    '¬': '&#xac;',
    // registered sign (registered trademark symbol)
    '®': '&#xae;',
    // macron (spacing macron, overline, APL overbar)
    '¯': '&#xaf;',
    // degree symbol
    '°': '&#xb0;',
    // plus-minus sign (plus-or-minus sign)
    '±': '&#xb1;',
    // superscript two (superscript digit two, squared)
    '²': '&#xb2;',
    // superscript three (superscript digit three, cubed)
    '³': '&#xb3;',
    // acute accent (spacing acute)
    '´': '&#xb4;',
    // micro sign
    'µ': '&#xb5;',
    // pilcrow sign (paragraph sign)
    '¶': '&#xb6;',
    // middle dot (Georgian comma, Greek middle dot)
    '·': '&#xb7;',
    // cedilla (spacing cedilla)
    '¸': '&#xb8;',
    // superscript one (superscript digit one)
    '¹': '&#xb9;',
    // masculine ordinal indicator
    'º': '&#xba;',
    // right-pointing double angle quotation mark (right pointing guillemet)
    '»': '&#xbb;',
    // vulgar fraction one quarter (fraction one quarter)
    '¼': '&#xbc;',
    // vulgar fraction one half (fraction one half)
    '½': '&#xbd;',
    // vulgar fraction three quarters (fraction three quarters)
    '¾': '&#xbe;',
    // inverted question mark (turned question mark)
    '¿': '&#xbf;',
    // Latin capital letter A with grave accent (Latin capital letter A grave)
    'À': '&#xc0;',
    // Latin capital letter A with acute accent
    'Á': '&#xc1;',
    // Latin capital letter A with circumflex
    'Â': '&#xc2;',
    // Latin capital letter A with tilde
    'Ã': '&#xc3;',
    // Latin capital letter A with diaeresis
    'Ä': '&#xc4;',
    // Latin capital letter A with ring above (Latin capital letter A ring)
    'Å': '&#xc5;',
    // Latin capital letter AE (Latin capital ligature AE)
    'Æ': '&#xc6;',
    // Latin capital letter C with cedilla
    'Ç': '&#xc7;',
    // Latin capital letter E with grave accent
    'È': '&#xc8;',
    // Latin capital letter E with acute accent
    'É': '&#xc9;',
    // Latin capital letter E with circumflex
    'Ê': '&#xca;',
    // Latin capital letter E with diaeresis
    'Ë': '&#xcb;',
    // Latin capital letter I with grave accent
    'Ì': '&#xcc;',
    // Latin capital letter I with acute accent
    'Í': '&#xcd;',
    // Latin capital letter I with circumflex
    'Î': '&#xce;',
    // Latin capital letter I with diaeresis
    'Ï': '&#xcf;',
    // Latin capital letter Eth
    'Ð': '&#xd0;',
    // Latin capital letter N with tilde
    'Ñ': '&#xd1;',
    // Latin capital letter O with grave accent
    'Ò': '&#xd2;',
    // Latin capital letter O with acute accent
    'Ó': '&#xd3;',
    // Latin capital letter O with circumflex
    'Ô': '&#xd4;',
    // Latin capital letter O with tilde
    'Õ': '&#xd5;',
    // Latin capital letter O with diaeresis
    'Ö': '&#xd6;',
    // multiplication sign
    '×': '&#xd7;',
    // Latin capital letter O with stroke (Latin capital letter O slash)
    'Ø': '&#xd8;',
    // Latin capital letter U with grave accent
    'Ù': '&#xd9;',
    // Latin capital letter U with acute accent
    'Ú': '&#xda;',
    // Latin capital letter U with circumflex
    'Û': '&#xdb;',
    // Latin capital letter U with diaeresis
    'Ü': '&#xdc;',
    // Latin capital letter Y with acute accent
    'Ý': '&#xdd;',
    // Latin capital letter THORN
    'Þ': '&#xde;',
    // Latin small letter sharp s (ess-zed); see German Eszett
    'ß': '&#xdf;',
    // Latin small letter a with grave accent
    'à': '&#xe0;',
    // Latin small letter a with acute accent
    'á': '&#xe1;',
    // Latin small letter a with circumflex
    'â': '&#xe2;',
    // Latin small letter a with tilde
    'ã': '&#xe3;',
    // Latin small letter a with diaeresis
    'ä': '&#xe4;',
    // Latin small letter a with ring above
    'å': '&#xe5;',
    // Latin small letter ae (Latin small ligature ae)
    'æ': '&#xe6;',
    // Latin small letter c with cedilla
    'ç': '&#xe7;',
    // Latin small letter e with grave accent
    'è': '&#xe8;',
    // Latin small letter e with acute accent
    'é': '&#xe9;',
    // Latin small letter e with circumflex
    'ê': '&#xea;',
    // Latin small letter e with diaeresis
    'ë': '&#xeb;',
    // Latin small letter i with grave accent
    'ì': '&#xec;',
    // Latin small letter i with acute accent
    'í': '&#xed;',
    // Latin small letter i with circumflex
    'î': '&#xee;',
    // Latin small letter i with diaeresis
    'ï': '&#xef;',
    // Latin small letter eth
    'ð': '&#xf0;',
    // Latin small letter n with tilde
    'ñ': '&#xf1;',
    // Latin small letter o with grave accent
    'ò': '&#xf2;',
    // Latin small letter o with acute accent
    'ó': '&#xf3;',
    // Latin small letter o with circumflex
    'ô': '&#xf4;',
    // Latin small letter o with tilde
    'õ': '&#xf5;',
    // Latin small letter o with diaeresis
    'ö': '&#xf6;',
    // division sign (obelus)
    '÷': '&#xf7;',
    // Latin small letter o with stroke (Latin small letter o slash)
    'ø': '&#xf8;',
    // Latin small letter u with grave accent
    'ù': '&#xf9;',
    // Latin small letter u with acute accent
    'ú': '&#xfa;',
    // Latin small letter u with circumflex
    'û': '&#xfb;',
    // Latin small letter u with diaeresis
    'ü': '&#xfc;',
    // Latin small letter y with acute accent
    'ý': '&#xfd;',
    // Latin small letter thorn
    'þ': '&#xfe;',
    // Latin small letter y with diaeresis
    'ÿ': '&#xff;',
    // Latin capital ligature oe
    'Œ': '&#x152;',
    // Latin small ligature oe
    'œ': '&#x153;',
    // Latin capital letter s with caron
    'Š': '&#x160;',
    // Latin small letter s with caron
    'š': '&#x161;',
    // Latin capital letter w with circumflex
    'Ŵ': '&#x174;',
    // Latin small letter w with circumflex
    'ŵ': '&#x175;',
    // Latin capital letter y with circumflex
    'Ŷ': '&#x176;',
    // Latin small letter y with circumflex
    'ŷ': '&#x177;',
    // Latin capital letter y with diaeresis
    'Ÿ': '&#x178;',
    // Latin small letter f with hook (function, florin)
    'ƒ': '&#x192;',
    // modifier letter circumflex accent
    'ˆ': '&#x2c6;',
    // small tilde
    '˜': '&#x2dc;',
    // Greek capital letter Alpha
    'Α': '&#x391;',
    // Greek capital letter Beta
    'Β': '&#x392;',
    // Greek capital letter Gamma
    'Γ': '&#x393;',
    // Greek capital letter Delta
    'Δ': '&#x394;',
    // Greek capital letter Epsilon
    'Ε': '&#x395;',
    // Greek capital letter Zeta
    'Ζ': '&#x396;',
    // Greek capital letter Eta
    'Η': '&#x397;',
    // Greek capital letter Theta
    'Θ': '&#x398;',
    // Greek capital letter Iota
    'Ι': '&#x399;',
    // Greek capital letter Kappa
    'Κ': '&#x39a;',
    // Greek capital letter Lambda
    'Λ': '&#x39b;',
    // Greek capital letter Mu
    'Μ': '&#x39c;',
    // Greek capital letter Nu
    'Ν': '&#x39d;',
    // Greek capital letter Xi
    'Ξ': '&#x39e;',
    // Greek capital letter Omicron
    'Ο': '&#x39f;',
    // Greek capital letter Pi
    'Π': '&#x3a0;',
    // Greek capital letter Rho
    'Ρ': '&#x3a1;',
    // Greek capital letter Sigma
    'Σ': '&#x3a3;',
    // Greek capital letter Tau
    'Τ': '&#x3a4;',
    // Greek capital letter Upsilon
    'Υ': '&#x3a5;',
    // Greek capital letter Phi
    'Φ': '&#x3a6;',
    // Greek capital letter Chi
    'Χ': '&#x3a7;',
    // Greek capital letter Psi
    'Ψ': '&#x3a8;',
    // Greek capital letter Omega
    'Ω': '&#x3a9;',
    // Greek capital letter iota with dialytika
    'Ϊ': '&#x3aa;',
    // Greek capital letter upsilon with dialytika
    'Ϋ': '&#x3ab;',
    // Greek small letter alpha with tonos
    'ά': '&#x3ac;',
    // Greek small letter epsilon with tonos
    'έ': '&#x3ad;',
    // Greek small letter eta with tonos
    'ή': '&#x3ae;',
    // Greek small letter iota with tonos
    'ί': '&#x3af;',
    // Greek small letter upsilon with dialytika and tonos
    'ΰ': '&#x3b0;',
    // Greek small letter alpha
    'α': '&#x3b1;',
    // Greek small letter beta
    'β': '&#x3b2;',
    // Greek small letter gamma
    'γ': '&#x3b3;',
    // Greek small letter delta
    'δ': '&#x3b4;',
    // Greek small letter epsilon
    'ε': '&#x3b5;',
    // Greek small letter zeta
    'ζ': '&#x3b6;',
    // Greek small letter eta
    'η': '&#x3b7;',
    // Greek small letter theta
    'θ': '&#x3b8;',
    // Greek small letter iota
    'ι': '&#x3b9;',
    // Greek small letter kappa
    'κ': '&#x3ba;',
    // Greek small letter lambda
    'λ': '&#x3bb;',
    // Greek small letter mu
    'μ': '&#x3bc;',
    // Greek small letter nu
    'ν': '&#x3bd;',
    // Greek small letter xi
    'ξ': '&#x3be;',
    // Greek small letter omicron
    'ο': '&#x3bf;',
    // Greek small letter pi
    'π': '&#x3c0;',
    // Greek small letter rho
    'ρ': '&#x3c1;',
    // Greek small letter final sigma
    'ς': '&#x3c2;',
    // Greek small letter sigma
    'σ': '&#x3c3;',
    // Greek small letter tau
    'τ': '&#x3c4;',
    // Greek small letter upsilon
    'υ': '&#x3c5;',
    // Greek small letter phi
    'φ': '&#x3c6;',
    // Greek small letter chi
    'χ': '&#x3c7;',
    // Greek small letter psi
    'ψ': '&#x3c8;',
    // Greek small letter omega
    'ω': '&#x3c9;',
    // Greek small letter iota with dialytika
    'ϊ': '&#x3ca;',
    // Greek small letter upsilon with dialytika
    'ϋ': '&#x3cb;',
    // Greek small letter omicron with tonos
    'ό': '&#x3cc;',
    // Greek small letter upsilon with tonos
    'ύ': '&#x3cd;',
    // Greek small letter omega with tonos
    'ώ': '&#x3ce;',
    // Greek capital kai symbol
    'Ϗ': '&#x3cf;',
    // Greek beta symbol
    'ϐ': '&#x3d0;',
    // Greek theta symbol
    'ϑ': '&#x3d1;',
    // Greek upsilon with hook symbol
    'ϒ': '&#x3d2;',
    // Greek upsilon with acute and hook symbol
    'ϓ': '&#x3d3;',
    // Greek upsilon with diaeresis and hook symbol
    'ϔ': '&#x3d4;',
    // Greek phi symbol
    'ϕ': '&#x3d5;',
    // Greek pi symbol
    'ϖ': '&#x3d6;',
    // Latin capital letter w with grave
    'Ẁ': '&#x1e80;',
    // Latin small letter w with grave
    'ẁ': '&#x1e81;',
    // Latin capital letter w with acute
    'Ẃ': '&#x1e82;',
    // Latin small letter w with acute
    'ẃ': '&#x1e83;',
    // Latin capital letter w with diaeresis
    'Ẅ': '&#x1e84;',
    // Latin small letter w with diaeresis
    'ẅ': '&#x1e85;',
    // Latin capital letter y with grave
    'Ỳ': '&#x1ef2;',
    // Latin small letter y with grave
    'ỳ': '&#x1ef3;',
    // en space
    ' ': '&#x2002;',
    // em space
    ' ': '&#x2003;',
    // thin space
    ' ': '&#x2009;',
    // en dash
    '–': '&#x2013;',
    // em dash
    '—': '&#x2014;',
    // left single quotation mark
    '‘': '&#x2018;',
    // right single quotation mark
    '’': '&#x2019;',
    // single low-9 quotation mark
    '‚': '&#x201a;',
    // left double quotation mark
    '“': '&#x201c;',
    // right double quotation mark
    '”': '&#x201d;',
    // double low-9 quotation mark
    '„': '&#x201e;',
    // dagger, obelisk
    '†': '&#x2020;',
    // double dagger (double obelisk)
    '‡': '&#x2021;',
    // bullet (black small circle)
    '•': '&#x2022;',
    // horizontal ellipsis (three dot leader)
    '…': '&#x2026;',
    // per mille sign
    '‰': '&#x2030;',
    // prime (minutes, feet)
    '′': '&#x2032;',
    // double prime (seconds, inches)
    '″': '&#x2033;',
    // single left-pointing angle quotation mark
    '‹': '&#x2039;',
    // single right-pointing angle quotation mark
    '›': '&#x203a;',
    // overline (spacing overscore)
    '‾': '&#x203e;',
    // fraction slash (solidus)
    '⁄': '&#x2044;',
    // euro sign
    '€': '&#x20ac;',
    // black-letter capital I (imaginary part)
    'ℑ': '&#x2111;',
    // script capital P (power set, Weierstrass p)
    '℘': '&#x2118;',
    // black-letter capital R (real part symbol)
    'ℜ': '&#x211c;',
    // trademark symbol
    '™': '&#x2122;',
    // alef symbol (first transfinite cardinal)
    'ℵ': '&#x2135;',
    // leftwards arrow
    '←': '&#x2190;',
    // upwards arrow
    '↑': '&#x2191;',
    // rightwards arrow
    '→': '&#x2192;',
    // downwards arrow
    '↓': '&#x2193;',
    // left right arrow
    '↔': '&#x2194;',
    // downwards arrow with corner leftwards (carriage return)
    '↵': '&#x21b5;',
    // leftwards double arrow
    '⇐': '&#x21d0;',
    // upwards double arrow
    '⇑': '&#x21d1;',
    // rightwards double arrow
    '⇒': '&#x21d2',
    // downwards double arrow
    '⇓': '&#x21d3;',
    // left right double arrow
    '⇔': '&#x21d4;',
    // for all
    '∀': '&#x2200;',
    // partial differential
    '∂': '&#x2202;',
    // there exists
    '∃': '&#x2203;',
    // empty set (null set)
    '∅': '&#x2205;',
    // del or nabla (vector differential operator)
    '∇': '&#x2207;',
    // element of
    '∈': '&#x2208;',
    // not an element of
    '∉': '&#x2209;',
    // contains as member
    '∋': '&#x220b;',
    // n-ary product (product sign)
    '∏': '&#x220f;',
    // n-ary summation
    '∑': '&#x2211;',
    // minus sign
    '−': '&#x2212;',
    // asterisk operator
    '∗': '&#x2217;',
    // square root (radical sign)
    '√': '&#x221a;',
    // proportional to
    '∝': '&#x221d;',
    // infinity
    '∞': '&#x221e;',
    // angle
    '∠': '&#x2220;',
    // logical and (wedge)
    '∧': '&#x2227;',
    // logical or (vee)
    '∨': '&#x2228;',
    // intersection (cap)
    '∩': '&#x2229;',
    // union (cup)
    '∪': '&#x222a;',
    // integral
    '∫': '&#x222b',
    // therefore sign
    '∴': '&#x2234;',
    // tilde operator (varies with, similar to)
    '∼': '&#x223c;',
    // congruent to
    '≅': '&#x2245;',
    // almost equal to (asymptotic to)
    '≈': '&#x2248;',
    // not equal to
    '≠': '&#x2260;',
    // identical to; sometimes used for 'equivalent to'
    '≡': '&#x2261;',
    // less-than or equal to
    '≤': '&#x2264;',
    // greater-than or equal to
    '≥': '&#x2265;',
    // subset of
    '⊂': '&#x2282;',
    // superset of
    '⊃': '&#x2283;',
    // not a subset of
    '⊄': '&#x2284;',
    // subset of or equal to
    '⊆': '&#x2286;',
    // superset of or equal to
    '⊇': '&#x2287;',
    // circled plus (direct sum)
    '⊕': '&#x2295;',
    // circled times (vector product)
    '⊗': '&#x2297;',
    // up tack (orthogonal to, perpendicular)
    '⊥': '&#x22a5;',
    // dot operator
    '⋅': '&#x22c5;',
    // vertical ellipsis
    '⋮': '&#x22ee;',
    // left ceiling (APL upstile)
    '⌈': '&#x2308;',
    // right ceiling
    '⌉': '&#x2309;',
    // left floor (APL downstile)
    '⌊': '&#x230a;',
    // right floor
    '⌋': '&#x230b;',
    // left-pointing angle bracket (bra)
    '〈': '&#x2329;',
    // right-pointing angle bracket (ket)
    '〉': '&#x232a;',
    // lozenge
    '◊': '&#x25ca;',
    // black spade suit
    '♠': '&#x2660;',
    // black club suit (shamrock)
    '♣': '&#x2663;',
    // black heart suit (valentine)
    '♥': '&#x2665;',
    // black diamond suit
    '♦': '&#x2666;',
  };
}