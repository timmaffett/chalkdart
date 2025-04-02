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

  static void _resetPatternToCurrentESC() {
      pattern = [
                  '[$ESC\\u009B][[\\]()#;?]*(?:(?:(?:[a-zA-Z\\d]*(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\\u0007)',
                  '(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-ntqry=><~]))'
                ].join('|');
  }
  static String pattern = [
    '[$ESC\\u009B][[\\]()#;?]*(?:(?:(?:[a-zA-Z\\d]*(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\\u0007)',
    '(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-ntqry=><~]))'
  ].join('|');

  static final RegExp ansiRegex = RegExp(pattern);

  static String stripAnsi(String source) {
    return source.replaceAll(ansiRegex, '');
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
