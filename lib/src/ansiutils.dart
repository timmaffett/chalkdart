/*
  @author: tim maffett
*/

// ansi regex from
import 'dart:io';

class AnsiUtils {

  static String safeESCStringForIOSThatMyXCodeFlutterColorDebuggingWillConvertBackToESC = '[^ESC]';

  static void setActivateXCodeSafeESCString( bool activate ) {
    if(Platform.isIOS) {
      if(activate) {
        ESC = safeESCStringForIOSThatMyXCodeFlutterColorDebuggingWillConvertBackToESC;
      } else {
        // Switch back to DIRECT ascii ESC output
        ESC = '\\x1B';
      }
      _resetPatternToCurrentESC();
    }
  }

  // ignore: non_constant_identifier_names
  static String ESC = '\\x1B';

  /// Matches ANSI escape sequences: both CSI and OSC forms.
  ///
  /// CSI (Control Sequence Introducer) — based on ECMA-48:
  /// \x1b           : The literal ESC character (ASCII 27).
  /// \[             : The literal '[' character (together with ESC, this forms the CSI).
  /// [\x30-\x3f]*   : Parameter Bytes (0-9:;<=>?).
  /// [\x20-\x2f]*   : Intermediate Bytes ( !"#$%&'()*+,-./).
  /// [\x40-\x7e]    : Final Byte (@A-Z[\]^_`a-z{|}~).
  ///   Examples: \x1b[31m (red), \x1b[1m (bold), \x1b[0m (reset)
  ///
  /// OSC (Operating System Command) — used for hyperlinks, window titles, etc.:
  /// \x1b           : The literal ESC character (ASCII 27).
  /// \]             : The literal ']' character (together with ESC, this forms the OSC).
  /// [^\x07]*       : Any payload characters until the terminator.
  /// \x07           : BEL character — the OSC string terminator.
  ///   Examples: \x1b]8;;https://example.com\x07 (hyperlink open)
  ///             \x1b]8;;\x07 (hyperlink close)
  ///
  ///   REGEX = r'\x1b(?:\[[\x30-\x3f]*[\x20-\x2f]*[\x40-\x7e]|\][^\x07]*\x07)'
  static void _resetPatternToCurrentESC() {
      if( ESC == '\\x1B') {
        pattern = r'\x1b(?:\[[\x30-\x3f]*[\x20-\x2f]*[\x40-\x7e]|\][^\x07]*\x07)';
      } else {
        pattern = ESC + r'(?:\[[\x30-\x3f]*[\x20-\x2f]*[\x40-\x7e]|\][^\x07]*\x07)';
      }
      ansiRegex = RegExp(pattern);
      //OLD CODE WITH OVERLY COMPLEX REGEX PATTERN//pattern = [
      //OLD CODE WITH OVERLY COMPLEX REGEX PATTERN//            '[$ESC\\u009B][[\\]()#;?]*(?:(?:(?:[a-zA-Z\\d]*(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\\u0007)',
      //OLD CODE WITH OVERLY COMPLEX REGEX PATTERN//            '(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-ntqry=><~]))'
      //OLD CODE WITH OVERLY COMPLEX REGEX PATTERN//          ].join('|');
  }

  //OLD CODE WITH OVERLY COMPLEX REGEX PATTERN//static String pattern = [
  //OLD CODE WITH OVERLY COMPLEX REGEX PATTERN//  '[$ESC\\u009B][[\\]()#;?]*(?:(?:(?:[a-zA-Z\\d]*(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\\u0007)',
  //OLD CODE WITH OVERLY COMPLEX REGEX PATTERN//  '(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-ntqry=><~]))'
  //OLD CODE WITH OVERLY COMPLEX REGEX PATTERN//].join('|');
  static String pattern = r'\x1b(?:\[[\x30-\x3f]*[\x20-\x2f]*[\x40-\x7e]|\][^\x07]*\x07)';

  static RegExp ansiRegex = RegExp(pattern);

  static String stripAnsi(String source) {
    if(hasAnsi(source)) {
    return source.replaceAll(ansiRegex, '');
    }
    return source;
  }

  static bool hasAnsi(String source) {
    return ansiRegex.hasMatch(source);
  }

  /*
     This simulates how VS Code parses ansi codes out of strings.   I used this when implementing complete 
     ANSI support within the VSCode code base.  
     My work on VSCode is merged into production and VSCode now supports virtually the complete ansi command set

  static final String vscodeAnsiMatchPattern = r'^(?:[34][0-8]|9[0-7]|10[0-7]|[013]|4|[34]9)(?:;[349][0-7]|10[0-7]|[013]|[245]|[34]9)?(?:;[012]?[0-9]?[0-9])*;?m$';
	static final RegExp vscodeAnsiMatcher = RegExp(vscodeAnsiMatchPattern);
  

  static Iterable<int>? vsCodeAnsiCodeSimulator( String text ) {
    var textLength = text.length;
    var sequenceFound = false;
    for(var currentPos=0;currentPos<textLength;currentPos++) {
      if (text.codeUnitAt(currentPos) == 27 && text[currentPos + 1] == '[') {
        var startPos = currentPos;
        currentPos += 2; // Ignore 'Esc[' as it's in every sequence.

        var ansiSequence = '';

        while (currentPos < textLength) {
          var char = text[currentPos];
          ansiSequence += char;

          currentPos++;
          var regexp = RegExp(r'^[ABCDHIJKfhmpsu]$');
          // Look for a known sequence terminating character.
          if (regexp.hasMatch(char)) {
            sequenceFound = true;
            break;
          }
        }

        if( sequenceFound) {
          if( vscodeAnsiMatcher.hasMatch( ansiSequence ) ) {
            ansiSequence = ansiSequence.substring(0,ansiSequence.length-1);  // Remove final 'm' character.
            var styleCodes = ansiSequence
                .split(';')										   // Separate style codes.
                .where( (elem) => elem != '')			           // Filter empty elems as '34;m' -> ['34', ''].
                .map( (elem) => int.parse(elem, radix:10));		  // Convert to numbers.
            
            print('ansiSeq=$ansiSequence');
            styleCodes.forEach( (code) => print('VSCode finds code $code'));
            
            
            return styleCodes;
          } else {
            print('STRING [$ansiSequence] DID NOT GET CAUGHT BY VSCODE REGEX');
          }
        }
      }
    }
    return null;
  }
  */
}

/// A utility extension on [String] to provide ANSI code stripping and length
/// calculation without ANSI codes.
extension AnsiStringUtils on String {
  /// Returns the length of the string without ANSI codes.
  int get lengthWithoutAnsi {
    if (!AnsiUtils.hasAnsi(this)) return length;
    return AnsiUtils.stripAnsi(this).length;
  }

  /// Returns the string with ANSI codes stripped.
  String get stripAnsi => AnsiUtils.stripAnsi(this);
}