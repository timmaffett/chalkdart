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
      styleNames.remove('ansi-${colorType}-colored');
      if (color != null) {
        styleNames.add('ansi-${colorType}-colored');
      }
    }

    //
    // * Swap foreground and background colors.  Used for color inversion.  Caller should check
    // * [] flag to make sure it is appropriate to turn ON or OFF (if it is already inverted don't call
    // 
    void reverseForegroundAndBackgroundColors() {
      var oldFgColor = customFgColor;
      changeColor('foreground', customBgColor);
      changeColor('background', oldFgColor);
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