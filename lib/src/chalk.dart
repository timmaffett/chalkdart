// Copyright (c) 2020-2025, tim maffett.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:io';
import 'dart:convert';
import 'ansiutils.dart';
import 'colorutils.dart';

import 'chalk_html.dart';

enum ChalkOutputMode {
  ansi,
  html,
}

enum ChalkAnsiColorSet {
  lightBackground,
  darkBackground,
  highContrast
}

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

  // Support for HTML Styling mode

  /// Sets which color set is used for the 8 bit ANSI colors 0-15 
  /// (Dark mode is default, set to false for light mode colors.
  /// These colors match what I use
  /// within DartPad for the standard ANSI colors in the debug console for light/dark mode)
  /// The high contrast set
  /// [ChalkAnsiColorSet.lightBackground], [ChalkAnsiColorSet.darkBackground] or [ChalkAnsiColorSet.highContrast]
  static ChalkAnsiColorSet htmlBasicANSIColorSet = ChalkAnsiColorSet.darkBackground;

  // Chalk instance flag to indicate we are outputting HTML styling codes instead of ANSI styling codes
  bool _htmlOutputModeForThisChalk = false;


  void setOutputMode(ChalkOutputMode outputMode) {
    switch (outputMode) {
      case ChalkOutputMode.ansi:
        _htmlOutputModeForThisChalk = false;
        break;
      case ChalkOutputMode.html:
        _htmlOutputModeForThisChalk = true;
        break;
    }

    _setAllWrapperFunctionsAccordingToMode();
  }

  // static DEFAULT safe ESC code flag for new Chalks 
  static bool _xcodeSafeEscDefaultForNewChalks = false;

  // If true we create new Chalk objects in HTML mode
  static bool _htmlModeDefaultForNewChalks = false;

  /// Set XCode Safe ESC sequence for IOS platform (this is a NO-OP on other platforms)
  /// for new chalk instances as well as the global `chalk` instance.
  /// Use:   Chalk.setXCodeSafeEscDefault = true;
  /// This requires the use of my XCode Flutter Color Debugging extension in VSCode to
  /// automatically convert the XCode safe ESC string `[^ESC]` back to the
  /// ASCII ESC character 27 (\u001B) in all flutter/dart `print()`/`debugPrint()`
  /// statements to the debug console.  The proper ANSI escape sequences will then be present
  /// for the VSCode debug console to display the proper output.
  /// (This is required because XCode filters all use of actual ascii ESC characters and also
  /// this also triggers XCode to truncates the message)
  static set setXCodeSafeEscDefault( bool activate ) {
    if(Platform.isIOS) {
      if(activate != _xcodeSafeEscDefaultForNewChalks) {
        if( activate ) {
          ESC = AnsiUtils.safeESCStringForIOSThatMyXCodeFlutterColorDebuggingWillConvertBackToESC;
        } else {
          ESC = '\u001B';
        }
        _xcodeSafeEscDefaultForNewChalks = activate;
      }
    }
  }

  /// This allows setting the default HTML mode for all subsequent Chalk() objects.
  /// If [newChalksUseHtmlMode] is `true` then HTML will used or styling instead of ANSI codes.
  /// If `false` then the default ANSI codes will be used for styling.
  static set setHTMLModeAsDefault( bool newChalksUseHtmlMode ) {
    _htmlModeDefaultForNewChalks = newChalksUseHtmlMode;
  }


  // Returns the default XCode safe ESC sequence mode for NEW chalk instances 
  static bool get getXCodeSafeEscDefault => _xcodeSafeEscDefaultForNewChalks;

  /// AFFECTS IOS ONLY
  /// Allows checking if the XCode Safe ESC sequences have been turned on or off using Chalk.xcodeSafeEsc = true (or false);
  /// We default to NULL so that it will get the default `_xcodeSafeEscDefaultForNewChalks` the first time it is used
  /// NOTE: WE DO NOT allow this to be changed on other platforms - it is ALWAYS `false`.
  bool? _instanceSpecificXCodeSafeEsc = Platform.isIOS ? null : false;  // The `null` default on IOS will allow us to set it to `_xcodeSafeEscDefaultForNewChalks` the first
                                                        // time it is accessed.  (This allows the default `chalk` instance to get the proper value

  /// Allows checking if the XCode Safe ESC sequences have been turned on or off using Chalk.xcodeSafeEsc = true (or false);
  /// (THIS FLAG IS USED ON IOS ONLY - on other platforms it is ALWAYS `false`.
  bool get xcodeSafeEsc {
    if(_instanceSpecificXCodeSafeEsc==null) {
      if(_xcodeSafeEscDefaultForNewChalks) {
        // USING THE SETTER HERE will ensure that the ESC and other instance variables will also get set
        xcodeSafeEsc = true;
      } else {
        // this just ensures that on IOS (where it could be null) it will get set to false (it would be getting set to 
        // true in the above if statement if `_xcodeSafeEscDefaultForNewChalks` was true
        _instanceSpecificXCodeSafeEsc = false;
      }
    }
    return _instanceSpecificXCodeSafeEsc!;  
  }

  // Chalk instance level call to set xcodeSafeEsc mode - this allows loggers to have the capabilities to 
  // have a chalk instance that outputs via XCode terminal while still logging proper ANSI codes through
  // ANOTHER chalk instance.
  set xcodeSafeEsc( bool activate ) {
    if(Platform.isIOS) {
      if(activate != _instanceSpecificXCodeSafeEsc) {
        if( activate ) {
          ESC = AnsiUtils.safeESCStringForIOSThatMyXCodeFlutterColorDebuggingWillConvertBackToESC;
        } else {
          ESC = '\u001B';
        }
        _instanceSpecificXCodeSafeEsc = activate;
        _resetAnsiCloseStringsToCurrentESC();
      }
    }
  }


  // String representing the ASCII ESC character 27.  This can change if xcodeSafeEsc(true) is set. 
  static String ESC = '\u001B';

  /// Use full resets to close attributes (reset all attributes with SGR 0) ON EACH call to Chalk()
  /// (Not usually desired, this will reset all attributes, but some terminals, like VSCode,
  /// need this because buggy implementations)
  /// (Update:  I have fixed and extended the VSCode support for ANSI control sequences to be complete
  /// and bug free.  All features of Chalk'Dart are now completely supported.
  /// This is now all available in production version of VSCode - timmaffett)
  static bool useFullResetToClose = false;

  String _ansiSGRModiferOpen(dynamic code) {
    if(_htmlOutputModeForThisChalk) {

      return '<span ${ChalkHTML.getStyleFromANSICode( [ code ] )} >';

    } else {
      return '$ESC[${code}m';
    }
  }

  String _ansiSGRModiferClose(dynamic code) {
    if(_htmlOutputModeForThisChalk) {

      return '</span>';

    } else {
      if (useFullResetToClose) code = 0;
      return '$ESC[${code}m';
    }
  }

  String Function(int) _wrapAnsi256([int offset = 0]) {
    if(_htmlOutputModeForThisChalk) {
      int colorTypeCode = 38 + offset;
      final String cssAttrib = (colorTypeCode == 38) ? 'color' : ((colorTypeCode == 48) ? 'background-color' : 'text-decoration-color');
      return (int code) {
        final String color = ChalkHTML.calcAnsi8bitColor(code);
        return '<span style="$cssAttrib:$color;">';
      };
    } else {
      return (int code) => '$ESC[${38 + offset};5;${code}m';
    }    
  }

  String Function(int, int, int) _wrapAnsi16m([int offset = 0]) {
    if(_htmlOutputModeForThisChalk) {
      int colorTypeCode = 38 + offset;
      final String cssAttrib = (colorTypeCode == 38) ? 'color' : ((colorTypeCode == 48) ? 'background-color' : 'text-decoration-color');
      return (int red, int green, int blue) {
        final String color = ChalkHTML.set24BitAnsiColor( red, green, blue);
        return '<span style="$cssAttrib:$color;">';
      };
    } else {    
      return (int red, int green, int blue) =>
          '$ESC[${38 + offset};2;$red;$green;${blue}m';
    }
  }

  String DD_ansiClose = '$ESC[39m';
  String DD_ansiBgClose = '$ESC[49m';
  String DD_ansiUnderlineClose = '$ESC[59m';

  // This switches all of the root level open/close functions over to the HTML Versions
  void _resetEverythingForHTMLOutput() {
    // FOR HTML we do NOTHING special for the close - it is always te same...
    DD_ansiClose = DD_ansiBgClose = DD_ansiUnderlineClose = '</span>';    
  }

  void _resetAnsiCloseStringsToCurrentESC() {
    DD_ansiClose = '$ESC[39m';
    DD_ansiBgClose = '$ESC[49m';
    DD_ansiUnderlineClose = '$ESC[59m';
  }

  String get _ansiClose => DD_ansiClose;
  String get _ansiBgClose => DD_ansiBgClose;
  String get _ansiUnderlineClose => DD_ansiUnderlineClose;

  late String Function(int) _ansi256; // = _wrapAnsi256();
  late String Function(int, int, int) _ansi16m; // = _wrapAnsi16m();
  late String Function(int) _bgAnsi256; // = _wrapAnsi256(ansiBackgroundOffset);
  late String Function(int, int, int) _bgAnsi16m; // = _wrapAnsi16m(ansiBackgroundOffset);
  late String Function(int) _underlineAnsi256; // = _wrapAnsi256(ansiUnderlineOffset);
  late String Function(int, int, int) _underlineAnsi16m; // = _wrapAnsi16m(ansiUnderlineOffset);

  void _setAllWrapperFunctionsAccordingToMode() {
    _ansi256 = _wrapAnsi256();
    _ansi16m = _wrapAnsi16m();
    _bgAnsi256 = _wrapAnsi256(ansiBackgroundOffset);
    _bgAnsi16m = _wrapAnsi16m(ansiBackgroundOffset);
    _underlineAnsi256 = _wrapAnsi256(ansiUnderlineOffset);
    _underlineAnsi16m = _wrapAnsi16m(ansiUnderlineOffset);

    if(_htmlOutputModeForThisChalk) {
      _resetEverythingForHTMLOutput();
    } else {
      _resetAnsiCloseStringsToCurrentESC();
    }

  }


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
    return str.replaceAll('$ESC', '[ESC]');
  }
  */

  /// most useful for debugging to dump the guts
  @override
  String toString() {
    return "Chalk(open:'${_openAll.replaceAll('$ESC', 'ESC')}',close:'${_closeAll.replaceAll('$ESC', 'ESC')}')";
  }

  /// more detailed dump of the guts, following parent links and dumping
  String toStringWalkUp({int level = 0}) {
    String thisOne =
        "[$level] Chalk(open:'${_open.replaceAll('$ESC', 'ESC')}',close:'${_close.replaceAll('$ESC', 'ESC')}')";
    if (level == 0) {
      thisOne +=
          "[$level] ALL Chalk(open:'${_openAll.replaceAll('$ESC', 'ESC')}',close:'${_closeAll.replaceAll('$ESC', 'ESC')}')";
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
  static Chalk instance({int level = -1, ChalkOutputMode outputMode = ChalkOutputMode.ansi}) {
    final instance = Chalk._internal(null, hasStyle: false, outputMode: outputMode);
    if (level != -1) {
      instance.level = level;
    }
    return instance;
  }

  // This is alias for [instance()] for users coming from javascript syntax.
  // ignore: non_constant_identifier_names
  static Chalk Instance({int level = -1, ChalkOutputMode? outputMode}) {
    if(outputMode==null) {
      if(_htmlModeDefaultForNewChalks) {
        outputMode = ChalkOutputMode.html;
      } else {
        outputMode = ChalkOutputMode.ansi;
      }
    }
    return instance(level: level, outputMode: outputMode);
  }

  /// Factory function typically used for creating new 'root' instances of Chalk
  /// (root instances start with no style)
  factory Chalk() {
    late ChalkOutputMode outputMode;
    if(_htmlModeDefaultForNewChalks) {
      outputMode = ChalkOutputMode.html;
    } else {
      outputMode = ChalkOutputMode.ansi;
    }
    return Chalk._internal(null, hasStyle: false, outputMode: outputMode);
  }

  /// private internal Chalk() constructor
  Chalk._internal(Chalk? parent, {bool hasStyle = true, ChalkOutputMode? outputMode}) {
    if(outputMode==null) {
      if(_htmlModeDefaultForNewChalks) {
        outputMode = ChalkOutputMode.html;
      } else {
        outputMode = ChalkOutputMode.ansi;
      }
    }  
    // WE ONLY LOOK AT THE outputMode WHEN we are creating a TOP LEVEL parent - otherwise this is ALWAYS 
    // THE SAME AS IT'S PARENT
    if(parent==null) {
      switch (outputMode) {
        case ChalkOutputMode.ansi:
          _htmlOutputModeForThisChalk = false;
          break;
        case ChalkOutputMode.html:
          _htmlOutputModeForThisChalk = true;
          break;
      }
    }

    _parent = parent;
    if (parent != null) {
      level = parent.level; // inherit level from parent
      _joinString = parent._joinString;
      _htmlOutputModeForThisChalk = parent._htmlOutputModeForThisChalk;
    }
    _hasStyle = hasStyle;

    if(_htmlOutputModeForThisChalk) {
        _resetEverythingForHTMLOutput();
    } else {
      if(Platform.isIOS && _xcodeSafeEscDefaultForNewChalks) {
        if(_xcodeSafeEscDefaultForNewChalks) {
          ESC = AnsiUtils.safeESCStringForIOSThatMyXCodeFlutterColorDebuggingWillConvertBackToESC;
          xcodeSafeEsc = true;
          _resetAnsiCloseStringsToCurrentESC();
        }
      } else {
        xcodeSafeEsc = false;
      }
    }

    _setAllWrapperFunctionsAccordingToMode();
  }



















  final RegExp extractSpanRegex = RegExp(r'style="([^"]*)"');
  final RegExp extractClassRegex = RegExp(r'class="([^"]*)"');

  final RegExp replaceSpanClassRegex = RegExp(r'(?<=class=")[^"]*(?=")');
  final RegExp replaceSpanStyleRegex = RegExp(r'(?<=style=")[^"]*(?=")');


  String removeCssAttributes(String styleString, List<String> attributesToRemove) {
    String result = styleString;
    for (String attribute in attributesToRemove) {
      String regExStr = '(?<!-)$attribute\\s*:\\s*[^;]+;+\\s*';
      final RegExp removeCSSAttributeRegex = RegExp(regExStr);
      result = result.replaceAll(removeCSSAttributeRegex, '');
    }
    return result.trim().replaceAll(RegExp(r';+$'), ''); // Remove trailing semicolons
  }


  String? extractCssAttribute(String styleString, String attributeName) {

    String regExStr='(?<!-)$attributeName\\s*:\\s*([^;]+)(;|\$)';

//print('extractCssAttribute() styleString=`$styleString` regExStr=`$regExStr`');

    final RegExp extractCSSAttributerRegex = RegExp(regExStr);
    final Match? match = extractCSSAttributerRegex.firstMatch(styleString);

//print('match=$match');
    if (match != null) {
      final p1 = match.group(1)?.trim();
      final p2 = match.group(2)?.trim();
      return (p1 ?? '')+(p2 ?? '');
    }
    return null;
  }

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

  String extractSpanStyle(String htmlSpan) {
    final Match? match = extractSpanRegex.firstMatch(htmlSpan);

    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
    } else {
      return '';
    }
  }

  String extractSpanClass(String htmlSpan) {
    final Match? match = extractClassRegex.firstMatch(htmlSpan);

    if (match != null && match.groupCount > 0) {
      return match.group(1) ?? '';
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


      List<String> existingClasses = existingClass.split(' ');
      List<String> newClasses = newClassList.split(' ');

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

  void textRegExes() {
    String htmlSpan1 = '<span style="color:rgb(10,10,10);">';
    String htmlSpan2 = '<span style="font-size:16px; font-weight:bold;">';
    String htmlSpan3 = '<span>No style here</span>';
    String htmlSpan4 = '<span style="background-color:#f0f0f0; border:1px solid black;">';
    String htmlSpan5 = '<span style="color:red">'; //test without semicolon


    print(extractSpanStyle(htmlSpan1)); // Output: color:rgb(10,10,10);
    print(extractSpanStyle(htmlSpan2)); // Output: font-size:16px; font-weight:bold;
    print(extractSpanStyle(htmlSpan3)); // Output: null
    print(extractSpanStyle(htmlSpan4)); // output: background-color:#f0f0f0; border:1px solid black;
    print(extractSpanStyle(htmlSpan5)); // output: color:red

    String htmlSpan1C = '<span class=".red.underline">';
    String htmlSpan2C = '<span class="my-class another-class">';
    String htmlSpan3C = '<span>No class here</span>';
    String htmlSpan4C = '<span class="only-one">';
    String htmlSpan5C = '<span class="">'; // test for empty class attribute

    print(extractSpanClass(htmlSpan1C)); // Output: .red.underline
    print(extractSpanClass(htmlSpan2C)); // Output: my-class another-class
    print(extractSpanClass(htmlSpan3C)); // Output: null
    print(extractSpanClass(htmlSpan4C)); // output: only-one
    print(extractSpanClass(htmlSpan5C)); // output: ""

    String htmlSpan1R = '<span style="color:rgb(10,10,10);">';
    String htmlSpan2R = '<span class="my-class another-class">';
    String htmlSpan3R = '<span>No style or class here</span>';
    String htmlSpan4R = '<span id="test">';
    String htmlSpan5R = '<div> not a span </div>';

    print(extractAndReplaceSpanStyle(htmlSpan1R, "font-weight: bold;"));
    // Output: <span style="font-weight: bold;">

    print(extractAndReplaceSpanClass(htmlSpan2R, "new-class"));
    // Output: <span class="new-class">

    print(extractAndReplaceSpanStyle(htmlSpan3R, "font-weight: bold;"));
    // Output: <span style="font-weight: bold;">No style or class here</span>

    print(extractAndReplaceSpanClass(htmlSpan3R, "new-class"));
    // Output: <span class="new-class">No style or class here</span>

    print(extractAndReplaceSpanStyle(htmlSpan4R, "font-weight: bold;"));
    // Output: <span id="test" style="font-weight: bold;">

    print(extractAndReplaceSpanClass(htmlSpan4R, "new-class"));
    // Output: <span id="test" class="new-class">

    print(extractAndReplaceSpanStyle(htmlSpan5R, "font-weight: bold;"));
    // Output: <div> not a span </div>

    print(extractAndReplaceSpanClass(htmlSpan5R, "new-class"));
    // Output: <div> not a span </div>

    //-------
    String htmlSpan1A = '<span style="color:rgb(10,10,10);">';
    String htmlSpan2A = '<span class="my-class another-class">';
    String htmlSpan3A = '<span>No style or class here</span>';
    String htmlSpan4A = '<span id="test">';
    String htmlSpan5A = '<div> not a span </div>';

    print(extractAndAddSpanStyle(htmlSpan1A, "font-weight: bold;"));
    // Output: <span style="color:rgb(10,10,10);; font-weight: bold;">

    print(extractAndAddSpanClass(htmlSpan2A, "new-class"));
    // Output: <span class="my-class another-class new-class">

    print(extractAndAddSpanStyle(htmlSpan3A, "font-weight: bold;"));
    // Output: <span style="font-weight: bold;">No style or class here</span>

    print(extractAndAddSpanClass(htmlSpan3A, "new-class"));
    // Output: <span class="new-class">No style or class here</span>

    print(extractAndAddSpanStyle(htmlSpan4A, "font-weight: bold;"));
    // Output: <span id="test" style="font-weight: bold;">

    print(extractAndAddSpanClass(htmlSpan4A, "new-class"));
    // Output: <span id="test" class="new-class">

    print(extractAndAddSpanStyle(htmlSpan5A, "font-weight: bold;"));
    // Output: <div> not a span </div>

    print(extractAndAddSpanClass(htmlSpan5A, "new-class"));
    // Output: <div> not a span </div>

  String style = 'color: red; font-size: 16px; background-color: blue;';

  print(extractCssAttribute(style, 'font-size')); // Output: 16px
  print(extractCssAttribute(style, 'padding')); // Output: null

  print(replaceCssAttribute(style, 'font-size', '18px'));
  // Output: color: red; font-size: 18px; background-color: blue;

  print(replaceCssAttribute(style, 'padding', '10px'));
  // Output: color: red; font-size: 16px; background-color: blue; padding: 10px;

  print(replaceCssAttribute('', 'color', 'green'));
  //output: color: green;

  print(replaceCssAttribute('color:red', 'background-color', 'yellow'));
  //output: color:red; background-color: yellow;

  /////----------------
  style = 'color: red; font-size: 16px; background-color: blue; text-decoration: underline;';

  String updatedStyle = removeCssAttributes(style, ['font-size', 'background-color']);
  print(updatedStyle); // Output: color: red; text-decoration: underline;

  updatedStyle = removeCssAttributes(updatedStyle, ['color']);
  print(updatedStyle); // Output: text-decoration: underline;

  updatedStyle = removeCssAttributes(updatedStyle, ['text-decoration']);
  print(updatedStyle); // Output:

  style = 'color: red; font-size: 16px; background-color: blue; text-decoration: underline'; //test without trailing semicolon

  updatedStyle = removeCssAttributes(style, ['font-size', 'background-color']);
  print(updatedStyle); // Output: color: red; text-decoration: underline

  style = 'color: red; font-size: 16px; background-color: blue; text-decoration: underline;';
  updatedStyle = removeCssAttributes(style, ['not-present']);
  print(updatedStyle); //output: color: red; font-size: 16px; background-color: blue; text-decoration: underline;

  style = '';
  updatedStyle = removeCssAttributes(style, ['color']);
  print(updatedStyle); //output: ""

  }

  String setUnderlineColor(String styleString, String color) {
      // text-decoration-color only works if text-decoration is set.
      // so we will add text-decoration: underline; if it does not exist.
      if (extractCssAttribute(styleString, 'text-decoration') == null){
          styleString = replaceCssAttribute(styleString, 'text-decoration', 'underline');
      }
    return replaceCssAttribute(styleString, 'text-decoration-color', color);
  }


  /// Custom Ansi foreground color (or null if none).
  String? _customFgColor;

  /// Custom Ansi background color (or null if none).
  String? _customBgColor;

  /// Custom Ansi underline color (or null if none).
  String? _customUnderlineColor;

  /// Have foreground and background colors been reversed ?
  bool _colorsInverted = false;

  List<String> _customStyles = [];


  /// Set the member variable corresponding to [colorType] to the css
  /// 'rgb(...)' color string computed from [rgbcolor] (or specified by
  /// [colorAsString]).
  /// [colorType] can be `'foreground'`,`'background'` or `'underline'`
  /// if [rgbcolor] is null then [colorAsString] will attempt to be used, if both
  /// are null then the corresponding color will be reset/cleared.
  void changeSpecifiedCustomColor(String colorType, int? rgbcolor,
      [String? colorAsString]) {
    if (colorType == 'foreground') {
      _customFgColor = ChalkHTML.makeCSSColorString(rgbcolor, colorAsString);
    } else if (colorType == 'background') {
      _customBgColor = ChalkHTML.makeCSSColorString(rgbcolor, colorAsString);
    } else if (colorType == 'underline') {
      _customUnderlineColor = ChalkHTML.makeCSSColorString(rgbcolor, colorAsString);
    }
  }

  /// Swap foregfrouned and background colors.  Used for color inversion.
  /// Caller should check [_colorsInverted] flag to make sure it is appropriate
  /// to turn ON or OFF (if it is already inverted don't call.
  void reverseForegroundAndBackgroundColors() {
    final String? oldFgColor = _customFgColor;
    changeSpecifiedCustomColor('foreground', null,
        _customBgColor); // We have strings already, so pass those.
    changeSpecifiedCustomColor('background', null, oldFgColor);
  }

  //OBSOLETEstatic bool doneit=false;

  String combineParentSpanAndThisSpan( String parentSpan, String thisSpan ) {
    //late String combinedSpan = parentSpan;
//OBSOLETE  if(!doneit) {
//OBSOLETE    doneit=true;
//OBSOLETEtextRegExes();
//OBSOLETE  }

    //print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    //print('combineParentSpanAndThisSpan()');
    //print(' parentSpan=`$parentSpan`');
    //print('  thisSpan=`$thisSpan`');

    String existingParentStyle = extractSpanStyle(parentSpan);

    //print('  EXTRACT existingParentStyle=`$existingParentStyle`');

    String? parentForeground;
    String? parentBackground; 
    String? parentUnderline; 
    String? thisForeground;
    String? thisBackground; 
    String? thisUnderline; 

    if(existingParentStyle.isNotEmpty) {
      parentForeground = extractCssAttribute( existingParentStyle, 'color' );
      parentBackground = extractCssAttribute( existingParentStyle, 'background-color' );
      parentUnderline = extractCssAttribute( existingParentStyle, 'text-decoration-color' );

      existingParentStyle = removeCssAttributes( existingParentStyle, ['color', 'background-color', 'text-decoration-color'] );
      //print('parentForeground=`$parentForeground` parentBackground=`$parentBackground` parentUnderline=`$parentUnderline`');
      //print(' striped existingParentStyle=`$existingParentStyle`');
    }
    String existingStyle = extractSpanStyle(thisSpan);
    //print('   EXTRACT existingStyle=`$existingStyle`');
    if(existingStyle.isNotEmpty) {
      thisForeground = extractCssAttribute( existingStyle, 'color' );
      thisBackground = extractCssAttribute( existingStyle, 'background-color' );
      thisUnderline = extractCssAttribute( existingStyle, 'text-decoration-color' );

      //print('thisForeground=`$thisForeground` thisBackground=`$thisBackground` thisUnderline=`$thisUnderline`');
    }

    if(thisForeground==null && parentForeground!=null && parentForeground.isNotEmpty) {
      existingStyle = replaceCssAttribute(existingStyle, 'color', parentForeground);
    }
    if(thisBackground==null && parentBackground!=null && parentBackground.isNotEmpty) {
      existingStyle = replaceCssAttribute(existingStyle, 'background-color', parentBackground);
    }
    if(thisUnderline==null && parentUnderline!=null && parentUnderline.isNotEmpty) {
      existingStyle = replaceCssAttribute(existingStyle, 'text-decoration-color', parentUnderline);
    }

    //print('AFTER PARENT REPLACEMENT OF existingStyle=`$existingStyle`');

    // Combine the style attributes
    String combinedSpan = extractAndReplaceSpanStyle( thisSpan, existingStyle );

    //print('After combining styles combinedSpan=`$combinedSpan`');


    //if(!_htmlOutputModeNoStylesheets) {
      // we are ALSO using class attributes ALSO, combine thoses
      final String parentClasses = extractSpanClass(parentSpan);

      //print('EXTRACT parentClasses=`$parentClasses`');

      combinedSpan = extractAndAddSpanClass( combinedSpan, parentClasses );
    //}
    return combinedSpan;
  }


  Chalk _createStyler(String open, String close, [Chalk? parent]) {
    final chalk = Chalk._internal(parent);

    if(_htmlOutputModeForThisChalk) {

      //print('=====================================');
      //print('_createStyler open=`$open`  close=`$close`');
      //if(parent!=null) print('   parent.openAll = ${parent._openAll}');
        // For HTML mode we are using the open to contain the STYLE or CLASS for this <span> 
        // (depending on _htmlOutputModeNoStylesheets flag)
      chalk._open = open;
      chalk._close = close;
      if (parent == null) {
        chalk._openAll = open;
        chalk._closeAll = '</span noparent>';//close;
      } else {
        chalk._openAll = combineParentSpanAndThisSpan(parent._openAll, open);
        chalk._closeAll = '</span>'; //close;  // ALL CLOSES are ALWAYS the same '</span>'
      }

      //print('_createStyler EXIT openAll=${chalk._openAll} ');

    } else {
      // HANDLE ANSI open and close and getting that information from parent as well
      chalk._open = open;
      chalk._close = close;
      if (parent == null) {
        chalk._openAll = open;
        chalk._closeAll = close;
      } else {
        chalk._openAll = parent._openAll + open;
        chalk._closeAll = close + parent._closeAll;
      }
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

  /// Set foreground base 16 xterm colors black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get black => _createStyler(_ansiSGRModiferOpen(30), _ansiClose, this);

  /// Set foreground base 16 xterm colors red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get red => _createStyler(_ansiSGRModiferOpen(31), _ansiClose, this);

  /// Set foreground base 16 xterm colors green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get green => _createStyler(_ansiSGRModiferOpen(32), _ansiClose, this);

  /// Set foreground base 16 xterm colors yellow
  /// (terminal dependent)![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get yellow => _createStyler(_ansiSGRModiferOpen(33), _ansiClose, this);

  /// Set foreground base 16 xterm colors blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get blue => _createStyler(_ansiSGRModiferOpen(34), _ansiClose, this);

  /// Set foreground base 16 xterm colors magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get magenta => _createStyler(_ansiSGRModiferOpen(35), _ansiClose, this);

  /// Set foreground base 16 xterm colors cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get cyan => _createStyler(_ansiSGRModiferOpen(36), _ansiClose, this);

  /// Set foreground base 16 xterm colors white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get white => _createStyler(_ansiSGRModiferOpen(37), _ansiClose, this);

  /// 8 more 'bright' versions of the lower 8 colors
  /// Set foreground base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get brightBlack =>
      _createStyler(_ansiSGRModiferOpen(90), _ansiClose, this);

  /// Set foreground base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get blackBright =>
      brightBlack; // original chalk library used 'xxxxxBright' (adjective AFTER the color noun), we include alias for compatibility

  /// Set foreground base 16 xterm colors gray  (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get gray => brightBlack;

  /// Set foreground base 16 xterm colors grey (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get grey => brightBlack;

  /// Set foreground base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get brightRed =>
      _createStyler(_ansiSGRModiferOpen(91), _ansiClose, this);

  /// Set foreground base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get redBright => brightRed;

  /// Set foreground base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get brightGreen =>
      _createStyler(_ansiSGRModiferOpen(92), _ansiClose, this);

  /// Set foreground base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get greenBright => brightGreen;

  /// Set foreground base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get brightYellow =>
      _createStyler(_ansiSGRModiferOpen(93), _ansiClose, this);

  /// Set foreground base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get yellowBright => brightYellow;

  /// Set foreground base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get brightBlue =>
      _createStyler(_ansiSGRModiferOpen(94), _ansiClose, this);

  /// Set foreground base 16 xterm colors bright blue
  /// set foreground color to bright blue ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get blueBright => brightBlue;

  /// Set foreground base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get brightMagenta =>
      _createStyler(_ansiSGRModiferOpen(95), _ansiClose, this);

  /// Set foreground base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get magentaBright => brightMagenta;

  /// Set foreground base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get brightCyan =>
      _createStyler(_ansiSGRModiferOpen(96), _ansiClose, this);

  /// Set foreground base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get cyanBright => brightCyan;

  /// Set foreground base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get brightWhite =>
      _createStyler(_ansiSGRModiferOpen(97), _ansiClose, this);

  /// Set foreground base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get whiteBright => brightWhite;

  /// chalkdart favors 'onXXXXX' style of specifying background colors because it makes
  /// chained methods list read better as a sentence (`it's the Dart way`).
  /// We include original Chalk 'bgXXXX' method names for users that prefer that scheme
  /// and for legacy compatibility with original JS Chalk.
  /// Set background base 16 xterm colors black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBlack =>
      _createStyler(_ansiSGRModiferOpen(40), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onBlack.
  /// Set background base 16 xterm colors black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBlack => onBlack;

  /// Set background base 16 xterm colors red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onRed => _createStyler(_ansiSGRModiferOpen(41), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onRed.
  /// Set background base 16 xterm colors red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgRed => onRed;

  /// Set background base 16 xterm colors green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onGreen =>
      _createStyler(_ansiSGRModiferOpen(42), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onGreen.
  /// Set background base 16 xterm colors green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgGreen => onGreen;

  /// Set background base 16 xterm colors yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onYellow =>
      _createStyler(_ansiSGRModiferOpen(43), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onYellow.
  /// Set background base 16 xterm colors yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgYellow => onYellow;

  /// Set background base 16 xterm colors blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBlue =>
      _createStyler(_ansiSGRModiferOpen(44), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onBlue.
  /// Set background base 16 xterm colors blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBlue => onBlue;

  /// Set background base 16 xterm colors magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onMagenta =>
      _createStyler(_ansiSGRModiferOpen(45), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onMagenta.
  /// Set background base 16 xterm colors magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,0,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgMagenta => onMagenta;

  /// Set background base 16 xterm colors cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onCyan =>
      _createStyler(_ansiSGRModiferOpen(46), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onCyan.
  /// Set background base 16 xterm colors cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgCyan => onCyan;

  /// Set background base 16 xterm colors white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onWhite =>
      _createStyler(_ansiSGRModiferOpen(47), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onWhite.
  /// Set background base 16 xterm colors white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28192,192,192%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgWhite => onWhite;

  /// Set background base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBrightBlack =>
      _createStyler(_ansiSGRModiferOpen(100), _ansiBgClose, this);

  /// Set background base 16 xterm colors gray (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onGray => onBrightBlack;

  /// Set background base 16 xterm colors grey (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onGrey => onBrightBlack;

  /// Legacy api, provided only for backwards compatibility, use onBrightBlack.
  /// Set background base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBrightBlack => onBrightBlack;

  /// Legacy api, provided only for backwards compatibility, use onBrightBlack.
  /// Set background base 16 xterm colors bright black
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBlackBright => onBrightBlack;

  /// Legacy api, provided only for backwards compatibility, use onGray.
  /// Set background base 16 xterm colors gray (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgGray => onBrightBlack;

  /// Legacy api, provided only for backwards compatibility, use onGrey.
  /// Set background base 16 xterm colors grey (alternate name for bright black)
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28128,128,128%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgGrey => onBrightBlack;

  /// Set background base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBrightRed =>
      _createStyler(_ansiSGRModiferOpen(101), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onBrightRed.
  /// Set background base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBrightRed => onBrightRed;

  /// Legacy api, provided only for backwards compatibility, use onBrightRed.
  /// Set background base 16 xterm colors bright red
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgRedBright => onBrightRed;

  /// Set background base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBrightGreen =>
      _createStyler(_ansiSGRModiferOpen(102), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onBrightGreen.
  /// Set background base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBrightGreen => onBrightGreen;

  /// Legacy api, provided only for backwards compatibility, use onBrightGreen.
  /// Set background base 16 xterm colors bright green
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgGreenBright => onBrightGreen;

  /// Set background base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBrightYellow =>
      _createStyler(_ansiSGRModiferOpen(103), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onBrightYellow.
  /// Set background base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBrightYellow => onBrightYellow;

  /// Legacy api, provided only for backwards compatibility, use onBrightYellow.
  /// Set background base 16 xterm colors bright yellow
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,0%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgYellowBright => onBrightYellow;

  /// Set background base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBrightBlue =>
      _createStyler(_ansiSGRModiferOpen(104), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onBrightBlue.
  /// Set background base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBrightBlue => onBrightBlue;

  /// Legacy api, provided only for backwards compatibility, use onBrightBlue.
  /// Set background base 16 xterm colors bright blue
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBlueBright => onBrightBlue;

  /// Set background base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBrightMagenta =>
      _createStyler(_ansiSGRModiferOpen(105), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onBrightMagenta.
  /// Set background base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBrightMagenta => onBrightMagenta;

  /// Legacy api, provided only for backwards compatibility, use onBrightMagenta.
  /// Set background base 16 xterm colors bright magenta
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,0,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgMagentaBright => onBrightMagenta;

  /// Set background base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBrightCyan =>
      _createStyler(_ansiSGRModiferOpen(106), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onBrightCyan.
  /// Set background base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBrightCyan => onBrightCyan;

  /// Legacy api, provided only for backwards compatibility, use onBrightCyan.
  /// Set background base 16 xterm colors bright cyan
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%280,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgCyanBright => onBrightCyan;

  /// Set background base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get onBrightWhite =>
      _createStyler(_ansiSGRModiferOpen(107), _ansiBgClose, this);

  /// Legacy api, provided only for backwards compatibility, use onBrightWhite.
  /// Set background base 16 xterm colors bright white
  /// (terminal dependent) ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
  Chalk get bgBrightWhite => onBrightWhite;

  /// Legacy api, provided only for backwards compatibility, use onBrightWhite.
  /// Set background base 16 xterm colors bright white
  /// (terminal dependent)  ![linen](data:image/svg+xml,%3Csvg%20xmlns='http://www.w3.org/2000/svg'%20width='32'%20height='32'%3E%3Crect%20width='32'%20height='32'%20fill='rgb%28255,255,255%29'%20stroke='black'%20stroke-width='2'/%3E%3C/svg%3E|width=32,height=32)
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

  /// underline - Make text underline. (Not as widely supported, supported in VSCode through my PR)
  Chalk get underline =>
      _createStyler(_ansiSGRModiferOpen(4), _ansiSGRModiferClose(24), this);

  /// underlined (alternate name for underline) - Make text underline. (Not as widely supported, supported in VSCode through my PR)
  Chalk get underlined => underline;

  /// doubleunderline - Make text double underlined. (Not as widely supported, supported in VSCode through my PR)
  Chalk get doubleunderline =>
      _createStyler(_ansiSGRModiferOpen(21), _ansiSGRModiferClose(24), this);

  /// doubleunderlined (alternate name for doubleunderline) - Make text double underlined. (Not as widely supported, supported in VSCode through my PR)
  Chalk get doubleunderlined => doubleunderline;

  /// doubleUnderline (alternate name for doubleunderline) - alternate for doubleunderline
  Chalk get doubleUnderline => doubleunderline;

  /// overline - Make text overlined. (Not as widely supported, supported in VSCode through my PR)
  Chalk get overline =>
      _createStyler(_ansiSGRModiferOpen(53), _ansiSGRModiferClose(55), this);

  /// overlined (alternate name for overline) - Make text overlined. (Not as widely supported, supported in VSCode through my PR)
  Chalk get overlined => overline;

  /// blink - Make text blink. (Not as widely supported, supported in VSCode through my PR)
  Chalk get blink =>
      _createStyler(_ansiSGRModiferOpen(5), _ansiSGRModiferClose(25), this);

  /// rapidblink - Make text blink rapidly (>150 times per minute). (Not as widely supported, supported in VSCode through my PR)
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

  /// strikethrough - Puts a horizontal line through the center of the text. (Not as widely supported, supported in VSCode through my PR)
  Chalk get strikethrough =>
      _createStyler(_ansiSGRModiferOpen(9), _ansiSGRModiferClose(29), this);

  /// superscript - Superscript text. (Not as widely supported, supported in VSCode through my PR)
  Chalk get superscript =>
      _createStyler(_ansiSGRModiferOpen(73), _ansiSGRModiferClose(75), this);

  /// subscript - Subscript text. (Not as widely supported, supported in VSCode through my PR)
  Chalk get subscript =>
      _createStyler(_ansiSGRModiferOpen(74), _ansiSGRModiferClose(75), this);

  /// Alternative font 1. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font1 =>
      _createStyler(_ansiSGRModiferOpen(11), _ansiSGRModiferClose(10), this);

  /// Alternative font 2. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font2 =>
      _createStyler(_ansiSGRModiferOpen(12), _ansiSGRModiferClose(10), this);

  ///Alternative font 3. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font3 =>
      _createStyler(_ansiSGRModiferOpen(13), _ansiSGRModiferClose(10), this);

  /// Alternative font 4. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font4 =>
      _createStyler(_ansiSGRModiferOpen(14), _ansiSGRModiferClose(10), this);

  /// Alternative font 5. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font5 =>
      _createStyler(_ansiSGRModiferOpen(15), _ansiSGRModiferClose(10), this);

  /// Alternative font 6. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font6 =>
      _createStyler(_ansiSGRModiferOpen(16), _ansiSGRModiferClose(10), this);

  /// Alternative font 7. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font7 =>
      _createStyler(_ansiSGRModiferOpen(17), _ansiSGRModiferClose(10), this);

  /// Alternative font 8. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font8 =>
      _createStyler(_ansiSGRModiferOpen(18), _ansiSGRModiferClose(10), this);

  /// Alternative font 9. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font9 =>
      _createStyler(_ansiSGRModiferOpen(19), _ansiSGRModiferClose(10), this);

  /// Alternative font 10. (Not as widely supported, supported in VSCode through my PR)
  Chalk get font10 =>
      _createStyler(_ansiSGRModiferOpen(20), _ansiSGRModiferClose(23), this);

  /// blackletter - alternate name for font10, ANSI/ECMA-48 spec refers to font10 specifically as a blackletter or Fraktur (Gothic) font.
  /// (Not as widely supported, supported in VSCode through my PR)
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
  /// The case/capitalization of the color name is not important.
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
  /// The case/capitalization of the color name is not important.
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

  static final RegExp _htmlTagRegex = RegExp(r'<[^>]*>');

  /// Replaces and `<` or `>` characters found within the string their
  /// html safe entities `&lt;` and `&gt;`.
  /// This makes the sure the text is safe for html rendering.
  /// 
  /// NOTE: This method is NOT safe to call on text that contains HTML code, 
  /// as it will deactivate the HTML tags.
  static String htmlSafeGtLt(String text) {
    return HtmlEscape(HtmlEscapeMode.element).convert(text);
  }

  /// Replaces all spaces outside of html tags found within the string
  /// to the html entity `&nbsp;`.
  /// This can be useful to preserve spacing when rendering the string in a
  /// browser where all spacing would otherwise be collapsed.
  /// 
  /// NOTE: This is completely safe to call on text that contains HTML code.
  /// If there are < or > characters present in the string [htmlSafeGtLt] should
  /// be called before any styling is applied and before this method.
  static String htmlSafeSpaces(String htmlString) {
    List<Match> tagMatches = _htmlTagRegex.allMatches(htmlString).toList();

    String result = '';
    int lastEnd = 0;

    for (Match match in tagMatches) {
      result += htmlString.substring(lastEnd, match.start).replaceAll(' ', '&nbsp;');
      result += match.group(0)!;
      lastEnd = match.end;
    }

    result += htmlString.substring(lastEnd).replaceAll(' ', '&nbsp;');

    return result;
  }

  /// Strips any HTML strings present from the string and returns the result
  String stripHtmlTags(String htmlString) {
    return htmlString.replaceAll(_htmlTagRegex, '');
  }

  /// Strip all ANSI SGR commands from the target string and return the 'stripped'
  /// result string.
  /// NOTE:  If HTML mode is activated then this strips all HMTL tags from the input string
  String strip(String target) {
    if(_htmlOutputModeForThisChalk) {
      return stripHtmlTags(target);
    } else {
      return AnsiUtils.stripAnsi(target);
    }
  }

  /// Returns the CSS styles required to render the HTML produced in HTML mode.
  /// NOTE: This returns the *styles* only - Use [inlineStylesheet] to return
  /// the the stylesheet within <style>..styles..</style> tags for use directly in the
  /// output html.
  String get stylesheet => myvsCodeDebugConsoleStylesheet;

  /// Returns the CSS styles required to render the HTML produced in HTML mode
  /// The stylesheet os wrapped within <style>..styles..</style> tags for use directly
  /// in the output html.
  /// Typically when using HMTL mode this would be called at the beginning of your output
  /// with a something like `print(mychalk.inlineStylesheet);`
  String get inlineStylesheet => '<style>\n$myvsCodeDebugConsoleStylesheet\n</style>\n';

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

    if (arg0!.indexOf(ESC) != -1) {
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

  // This funciton is used to ensure that we close the styling ON EACH LINE using the approriate ANSI CLOSE codes and
  // then START the next line with the appropriate ANSI OPEN codes to have the identical styling that was active on
  // the line before it.
  // Close the styling before a linebreak and reopen after next line to fix a bleed issue on
  // macOS: https://github.com/chalk/chalk/pull/92
  // This is called like this 
  // ```    var lfIndex = arg0.indexOf('\n');
  //  if (lfIndex != -1) {
  //    arg0 = _StringUtils.stringEncaseCRLFWithFirstIndex( arg0, _closeAll, _openAll, lfIndex);
  //  }
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

String myDartPadConsoleStylesheet = r'''
.console {
  .ansi-bold	{ font-weight: bold; }
  .ansi-italic	{ font-style: italic; }
  .ansi-underline { text-decoration: underline;  text-decoration-style:solid; }
  .ansi-dim	{ opacity: 0.5; }
  .ansi-hidden { opacity: 0; }
  .ansi-blink { animation: code-blink-key 0.3s cubic-bezier(1, 0, 0, 1) infinite alternate; }
  .ansi-rapid-blink { animation: code-blink-key 0.01s cubic-bezier(1, 0, 0, 1) infinite alternate; }
  @keyframes code-blink-key {
    to { opacity: 0; }
  }
  .ansi-double-underline { text-decoration: underline;  text-decoration-style:double; }
  .ansi-strike-through { text-decoration:line-through;  text-decoration-style:solid; }
  .ansi-overline { text-decoration:overline;  text-decoration-style:solid; }
  .ansi-overline.code-underline.code-line-through { text-decoration: overline underline line-through; text-decoration-style:solid; }
  .ansi-overline.code-underline { text-decoration: overline underline; text-decoration-style:solid; }
  .ansi-overline.code-line-through { text-decoration: overline line-through; text-decoration-style:solid; }
  .ansi-underline.code-line-through { text-decoration: underline line-through; text-decoration-style:solid; }
  .ansi-overline.code-double-underline.code-line-through { text-decoration: overline underline line-through; text-decoration-style:double; }
  .ansi-overline.code-double-underline { text-decoration: overline underline; text-decoration-style:double; }
  .ansi-double-underline.code-line-through { text-decoration: underline line-through; text-decoration-style:double; }
  .ansi-subscript { vertical-align: sub; font-size: smaller; line-height: normal; }
  .ansi-superscript { vertical-align: super; font-size: smaller; line-height: normal; }
  .ansi-font-1 { font-family: Verdana,Arial,sans-serif; }
  .ansi-font-2 { font-family: Georgia,'Times New Roman',serif; }
  .ansi-font-3 { font-family: Papyrus,Impact,fantasy; }
  .ansi-font-4 { font-family: 'Cascadia Mono', 'Apple Chancery','Lucida Calligraphy',cursive; }
  .ansi-font-5 { font-family: 'Courier New', 'Courier', monospace; }
  .ansi-font-6 { font-size: 14px; font-family: 'Cascadia Code PL', 'Segoe WPC', 'Segoe UI',-apple-system, BlinkMacSystemFont, system-ui, "Ubuntu", "Droid Sans", sans-serif; }
  .ansi-font-7 { font-size: 16px; font-family: 'Cascadia Mono PL', Menlo, Monaco, Consolas,"Droid Sans Mono", "Inconsolata", "Courier New", monospace, "Droid Sans Fallback"; }
  .ansi-font-8 { font-size: 18px; font-family: 'Cascadia Code PL',"SF Mono", Monaco, Menlo, Consolas, "Ubuntu Mono", "Liberation Mono", "DejaVu Sans Mono", "Courier New", monospace; }
  .ansi-font-9 { font-size: 20px; font-family: 'JetBrains Mono', "SF Mono", Monaco, Menlo, Consolas, "Ubuntu Mono", "Liberation Mono", "DejaVu Sans Mono", "Courier New", monospace; }
  .ansi-font-10 { font-stretch: ultra-expanded; font-weight: bold; font-family: 'League Mono', 'F25 BlackletterTypewriter', UnifrakturCook, Luminari, Apple Chancery, fantasy, Papyrus; }
}
''';

String myvsCodeDebugConsoleStylesheet = r'''

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
 * Alternate ansi-font-# classes, note the font-family stacks here are somewhat arbitrary but will resolve to different 'standard' css fonts
 * or are font-family stacks found other places in within VSCode.
 * ansi-font-10 is called the 'blackletter' font within ANSI SGR docs so attempt is made to resolve a blackletter font on users system.
 * ('F25 BlackletterTypewriter' is monospaced Blackletter font used or recommended by other terminal emulators (ie. mintty, etc.)
 * None of these fonts are required and all font-family stacks will resolve to some font.
 * User can change the fonts used by these classes custom css using a extension such as Customize UI/Monkey Patch
 */
.ansi-font-1 { font-family: Verdana,Arial,sans-serif; }
.ansi-font-2 { font-family: Georgia,'Times New Roman',serif; }
.ansi-font-3 { font-family: Papyrus,Impact,fantasy; }
.ansi-font-4 { font-family: 'Apple Chancery','Lucida Calligraphy',cursive; }
.ansi-font-5 { font-family: 'Courier New', 'Courier', monospace; }
.ansi-font-6 { font-family: "Segoe WPC", "Segoe UI",-apple-system, BlinkMacSystemFont, system-ui, "Ubuntu", "Droid Sans", sans-serif; }
.ansi-font-7 { font-family: Menlo, Monaco, Consolas,"Droid Sans Mono", "Inconsolata", "Courier New", monospace, "Droid Sans Fallback"; }
.ansi-font-8 { font-family: "SF Mono", Monaco, Menlo, Consolas, "Ubuntu Mono", "Liberation Mono", "DejaVu Sans Mono", "Courier New", monospace; }
.ansi-font-9 { font-family: "SF Mono", Monaco, Menlo, Consolas, "Ubuntu Mono", "Liberation Mono", "DejaVu Sans Mono", "Courier New", monospace; }
.ansi-font-10 { font-family: "F25 BlackletterTypewriter", UnifrakturCook, Luminari, Apple Chancery, fantasy, Papyrus; }

''';