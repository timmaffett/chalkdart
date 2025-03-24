// This file contains the utility class for handling transformation of ANSI codes to HTML styles or classes


import 'package:chalkdart/chalkdart.dart';

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
          colorRGBAInt = switch(Chalk.htmlBasicANSIColorSet) {
                              ChalkAnsiColorSet.darkBackground => darkModeAnsiColors[colorIndex],
                              ChalkAnsiColorSet.lightBackground => lightModeAnsiColors[colorIndex],
                              ChalkAnsiColorSet.highContrast => highContrastModeAnsiColors[colorIndex] };
          return makeCSSColorString(colorRGBAInt,null) ?? 'cyan';
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

      return 'rgb(${red.toInt()}, ${green.toInt()}, ${blue.toInt()})';
    } else if (ansiColorNumber >= 232 && ansiColorNumber <= 255) {
      // Converts to a grayscale value.
      ansiColorNumber -= 232;
      final int colorLevel = (ansiColorNumber / 23 * 255).round();
      return 'rgb($colorLevel, $colorLevel, $colorLevel)';
    } else {
      return 'purple';  // RETURN CSS 'red' when we have a erroneous value
    }
  }

  static String set24BitAnsiColor(int red, int green, int blue) {
     return 'rgb($red, $green, $blue)';
  }

/// Convert the passed in rgbcolor int value to a CSS 'rgb(r,g,b)' string.
  /// The passed [rgbcolor] int can be null, in which case the fallback
  /// passed in [colorAsString] is returned (this could also be null,
  /// but in cases of swapping foreground/background colors for the inverse
  /// operation is is the previously computed rgb string for the colors).
  static String? makeCSSColorString(int? rgbcolor, String? colorAsString) {
    if (rgbcolor == null) {
      return colorAsString; // Caller may have passed color as string.
    }
    return 'rgb(${(rgbcolor >> 16) & 0xFF},${(rgbcolor >> 8) & 0xFF},${rgbcolor & 0xFF})';
  }


  static String getStyleFromANSICode( List<int> codes ) {
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
          colorRGBAInt = switch(Chalk.htmlBasicANSIColorSet) {
                              ChalkAnsiColorSet.darkBackground => darkModeAnsiColors[colorIndex],
                              ChalkAnsiColorSet.lightBackground => lightModeAnsiColors[colorIndex],
                              ChalkAnsiColorSet.highContrast => highContrastModeAnsiColors[colorIndex] };
        }
        changeColor(colorType, makeCSSColorString(colorRGBAInt,null));
      }
    }


    for(int code in codes) {
      switch (code) {
        case 0: {  // reset (everything)
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
					if (!colorsInverted) {
						colorsInverted = true;
						reverseForegroundAndBackgroundColors();
					}
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
					//styleNames = styleNames.filter(style => !style.startsWith('ansi-font'));
					break;
				}
				case 11: case 12: case 13: case 14: case 15: case 16: case 17: case 18: case 19: case 20: { // font codes (and 20 is 'blackletter' font code)
          styleNames.removeWhere((entry) => entry.startsWith('ansi-font'));
					//styleNames = styleNames.filter(style => !style.startsWith('ansi-font'));
					styleNames.add('ansi-font-${code - 10}');
					break;
				}
				case 21: { // double underline
           styleNames.removeWhere((entry) => (entry=='ansi-underline' || entry=='ansi-double-underline'));
          //styleNames = styleNames.filter(style => (style !== 'ansi-underline' && style !== 'ansi-double-underline'));
					styleNames.add('ansi-double-underline');
					break;
				}
				case 22: { // normal intensity (bold off and dim off)
          styleNames.removeWhere((entry) => (entry=='ansi-bold' || entry=='ansi-dim'));
					//styleNames = styleNames.filter(style => (style !== 'ansi-bold' && style !== 'ansi-dim'));
					break;
				}
				case 23: { // Neither italic or blackletter (font 10)
          styleNames.removeWhere((entry) => (entry=='ansi-italic' || entry=='ansi-font-10'));
					//styleNames = styleNames.filter(style => (style !== 'ansi-italic' && style !== 'ansi-font-10'));
					break;
				}
				case 24: { // not underlined (Neither singly nor doubly underlined)
          styleNames.removeWhere((entry) => (entry=='ansi-underline' || entry=='ansi-double-underline'));
					//styleNames = styleNames.filter(style => (style !== 'ansi-underline' && style !== 'ansi-double-underline'));
					break;
				}
				case 25: { // not blinking
          styleNames.removeWhere((entry) => (entry=='ansi-blink' || entry=='ansi-rapid-blink'));
					//styleNames = styleNames.filter(style => (style !== 'ansi-blink' && style !== 'ansi-rapid-blink'));
					break;
				}
				case 27: { // not reversed/inverted
					if (colorsInverted) {
						colorsInverted = false;
						reverseForegroundAndBackgroundColors();
					}
					break;
				}
				case 28: { // not hidden (reveal)
					styleNames.remove('ansi-hidden');
					break;
				}
				case 29: { // not crossed-out
					styleNames.remove('ansi-strike-through');
					break;
				}
				case 53: { // overlined
					styleNames.remove('ansi-overline');
					styleNames.add('ansi-overline');
					break;
				}
				case 55: { // not overlined
					styleNames.remove('ansi-overline');
					break;
				}
				case 39: {  // default foreground color
					changeColor('foreground', null);
					break;
				}
				case 49: {  // default background color
					changeColor('background', null);
					break;
				}
				case 59: {  // default underline color
					changeColor('underline', null);
					break;
				}
				case 73: { // superscript
          styleNames.removeWhere((entry) => (entry=='ansi-superscript' || entry=='ansi-subscript'));
					//styleNames = styleNames.filter(style => (style !== 'ansi-superscript' && style !== 'ansi-subscript'));
					styleNames.add('ansi-superscript');
					break;
				}
				case 74: { // subscript
          styleNames.removeWhere((entry) => (entry=='ansi-superscript' || entry=='ansi-subscript'));
					//styleNames = styleNames.filter(style => (style !== 'ansi-superscript' && style !== 'ansi-subscript'));
					styleNames.add('ansi-subscript');
					break;
				}
				case 75: { // neither superscript or subscript
          styleNames.removeWhere((entry) => (entry=='ansi-superscript' || entry=='ansi-subscript'));
					//styleNames = styleNames.filter(style => (style !== 'ansi-superscript' && style !== 'ansi-subscript'));
					break;
				}
				default: {
					setBasicColor(code);
					break;
				}
			}
		}
    String outstyle = "";
    if(customFgColor!=null) {
      outstyle += 'color: $customFgColor;';
    }
    if(customBgColor!=null) {
      outstyle += 'background-color: $customBgColor;';
    }
    if(customUnderlineColor!=null) {
      outstyle += 'text-decoration-color: $customUnderlineColor;';
    }
    return 'class="${styleNames.join(' ')}" style="$outstyle"';
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
}