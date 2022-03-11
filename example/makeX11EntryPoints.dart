/*
   This writes the code for the X11 color table entry points for chalkdart.dart
*/
/*
  @author: tim maffett
*/
import 'dart:io';
import 'dart:developer';
import 'package:args/args.dart';


import 'dart:convert';
import 'package:chalkdart/chalkdart.dart';

void main(List<String> arguments) {
  //arguments = ["-c", "-x", "--out", "timmy.txt"];
  exitCode = 0; // presume success
  final parser = ArgParser()..addFlag("colorMethods", negatable: false, abbr: 'c')
                    ..addFlag("x11ReadmeTable", negatable: false, abbr: 'x')
                    ..addFlag("out", negatable: false, abbr: 'o');


  ArgResults argResults = parser.parse(arguments);
  //final paths = argResults.rest;
  
  inspect(argResults);

 
/*
Connecting to VM Service at http://127.0.0.1:49295/Yoeq_JePmOM=/
<inspected variable>
_parsed: Map (3 items)
0: "colorMethods" -> true
1: "x11ReadmeTable" -> true
2: "out" -> true
_parser: ArgParser
arguments: UnmodifiableListView
_source: List (4 items)
first: "-c"
hashCode: 2364537685
isEmpty: false
isNotEmpty: true
iterator: ListIterator (Instance of 'ListIterator<String>')
last: "timmy.txt"
length: 4
reversed: ReversedListIterable ((timmy.txt, --out, -x, -c))
runtimeType: Type (UnmodifiableListView<String>)
single: <Bad state: Too many elements
#0      ListMixin.single (dart:collection/list.dart:120:21)
#1      UnmodifiableListView.Eval ()
#2      UnmodifiableListView.Eval ()
#3      UnmodifiableListView.Eval ()
#4      UnmodifiableListView.Eval ()
#5      UnmodifiableListView.Eval ()
#6      UnmodifiableListView.Eval ()
#7      main (file:///C:/Users/Tim/AndroidStudioProjects/chalkdart/example/makeX11EntryPoints.dart:28:22)
#8      _delayEntrypointInvocation.<anonymous closure> (dart:isolate-patch/isolate_patch.dart:295:32)
#9      _RawReceivePortImpl._handleMessage (dart:isolate-patch/isolate_patch.dart:192:12)>
command: null
name: null
rest: UnmodifiableListView ([timmy.txt])
_source: List (1 item)
[0]: "timmy.txt"
first: "timmy.txt"
hashCode: 2206177489
isEmpty: false
isNotEmpty: true
iterator: ListIterator (Instance of 'ListIterator<String>')
last: "timmy.txt"
length: 1
reversed: ReversedListIterable ((timmy.txt))
runtimeType: Type (UnmodifiableListView<String>)
single: "timmy.txt"
hashCode: 1722225615
options: _CompactLinkedHashSet ({colorMethods, x11ReadmeTable, out})
[0]: "colorMethods"
[1]: "x11ReadmeTable"
[2]: "out"
runtimeType: Type (ArgResults)

*/

  List<String> out = [];
  //dcat(paths, showLineNumbers: argResults[lineNumber] as bool);    List<String> out = [];

    // out.add("part of 'chalkdart.dart';");
    // out.add("/*");
    // out.add("  @author: tim maffett");
    // out.add("*/");

    out.add("");
    out.add("// BEGIN GENERATED CODE - DO NOT MODIFY BY HAND - generating code => /examples/makeX11EntryPoints.dart");
    out.add("");

    colorKeywords.forEach(
        (colorKeyword,hexColorValue) {
            num red = (hexColorValue >> 16) & 0xFF;
            num green = (hexColorValue >> 8) & 0xFF;
            num blue = hexColorValue & 0xFF;

            String colorHexStr = hexColorValue.toRadixString(16).padLeft(6, '0').toUpperCase();
            String entryPoint = colorKeyword;
            String onEntryPoint = 'on' + colorKeyword[0].toUpperCase() + colorKeyword.substring(1);

            String cssColorCode=colorKeyword.toLowerCase();
            String colorSource = "X11/CSS";
            if( cssColorCode=='rebeccapurple' || cssColorCode=='lightgoldenrod') {
                colorSource="X11";
                cssColorCode = 'rgb($red, $green, $blue)'; // these are X11 names
            } else if (cssColorCode=='lightgoldenrodyellow') {
                colorSource = "CSS";
            }
            cssColorCode = cssColorCode.replaceAll("x11","");

            out.add("/// set foreground color to $colorSource color $colorKeyword <span style='background-color: $cssColorCode;border: black solid thick;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x$colorHexStr)/rgb($red, $green, $blue)");
            out.add("Chalk get $entryPoint => _makeRGBChalk($red, $green, $blue);");
            out.add("");
            out.add("/// set background color to $colorSource color $colorKeyword <span style='background-color: $cssColorCode;border: black solid thick;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x$colorHexStr)/rgb($red, $green, $blue)");
            out.add("Chalk get $onEntryPoint => _makeRGBChalk($red, $green, $blue, bg:true);");
            out.add("");

    });

    out.add("");
    out.add("// END GENERATED CODE - DO NOT MODIFY BY HAND - generating code => /examples/makeX11EntryPoints.dart");
    out.add("");

    for( String line in out ) {
      print( line );
    }
 
    out = X11ColorTable();

    for( String line in out ) {
      print( line );
    }

/*
    var file = File('lib\\src\\chalkdart.g.dart');
    var sink = file.openWrite();
    sink.writeln('// Generated ${DateTime.now()}');

    sink.writeAll( out, '\n' );

    // Close the IOSink to free system resources
    sink.close();

 */
}

String getCSSColorCode(String colorKeyword, int hexColorValue) {
  num red = (hexColorValue >> 16) & 0xFF;
  num green = (hexColorValue >> 8) & 0xFF;
  num blue = hexColorValue & 0xFF;
  String cssColorCode=colorKeyword.toLowerCase();
  String colorSource = "X11/CSS";
  if( cssColorCode=='rebeccapurple' || cssColorCode=='lightgoldenrod') {
      colorSource="X11";
      cssColorCode = 'rgb($red, $green, $blue)'; // these are X11 names
  } else if (cssColorCode=='lightgoldenrodyellow') {
      colorSource = "CSS";
  }
  cssColorCode = cssColorCode.replaceAll("x11","");
  return cssColorCode;
}

String getColorTooltip(String colorKeyword, int hexColorValue) {
  num red = (hexColorValue >> 16) & 0xFF;
  num green = (hexColorValue >> 8) & 0xFF;
  num blue = hexColorValue & 0xFF;
              
  String colorHexStr = hexColorValue.toRadixString(16).padLeft(6, '0').toUpperCase();

  return '0x$colorHexStr';
}

List<String>
X11ColorTable() {
  List <String> out = [];
  List <String> keys = colorKeywords.keys.toList();

  int numX11s = colorKeywords.length;
  const int numColumns = 3;

  int lenColumn = (numX11s / numColumns).round();

  out.add('<table style="border-style:none;width:100%;text-align:center;font-weight:bold; border-collapse: separate;"><tbody>');
  out.add('<tr><th style="text-align: center;" colspan="${2*numColumns}">Chalk X11/CSS Color Style Methods</th></tr>');
  out.add('<tr style="border-bottom: grey solid 2px;>');
  for(int i=0;i<numColumns;i++) {
    out.add('<th>forground style</th><th>background style</th>');
  }
  out.add('</tr>');
  for(int row=0;row<lenColumn;row++) {
    out.add('<tr style="border: grey solid 2px;outline:none;">');
    for(int c=0;c<numColumns;c++) {
      int entry = (row*numColumns) + c;//(c*lenColumn) + row;
      if(  (entry<numX11s) ) {
        String colorKeyword = (entry<numX11s) ? keys[entry] : '';
        int hex = 0;
        String colorCode='';
        String tooltip='';
        String textColor="black";
        String backgroundColor = "transparent";
        String onEntryPoint = 'on' + colorKeyword[0].toUpperCase() + colorKeyword.substring(1);
        if( entry < numX11s) {
          hex = colorKeywords[colorKeyword]!;
          colorCode = getCSSColorCode( colorKeyword, hex );
          tooltip = getColorTooltip( colorKeyword, hex );
        }
        if( hex==0x000000 ) {
          textColor="white";
          backgroundColor = "white";
        } else if ( hex==0xffffff) {
          backgroundColor="black";
        }
        if( hex != -2) {
          out.add('<td title="$tooltip" style="outline:solid $colorCode 1px;background:$backgroundColor;border: solid $colorCode thick;color: $colorCode;">.$colorKeyword</td>');
          out.add('</td><td style="outline:solid $colorCode 1px;border:solid $colorCode thick;background-color: $colorCode;color: $textColor;">.$onEntryPoint</td>');
        }
      } else {
        out.add('<td></td><td></td>');
      }
    }
    out.add('<tr>');
  }
  out.add('</tbody></table>');

  return out;
}



final Map<String, int> colorKeywords = <String, int>{
    'aliceBlue': 0xF0F8FF,
    'antiqueWhite': 0xFAEBD7,
    'aqua': 0x00FFFF,
    'aquamarine': 0x7FFFD4,
    'azure': 0xF0FFFF,
    'beige': 0xF5F5DC,
    'bisque': 0xFFE4C4,
    'blackX11': 0x000000,
    'blanchedAlmond': 0xFFEBCD,
    'blueX11': 0x0000FF,
    'blueViolet': 0x8A2BE2,
    'brown': 0xA52A2A,
    'burlywood': 0xDEB887,
    'cadetBlue': 0x5F9EA0,
    'chartreuse': 0x7FFF00,
    'chocolate': 0xD2691E,
    'coral': 0xFF7F50,
    'cornflowerBlue': 0x6495ED,
    'cornsilk': 0xFFF8DC,
    'crimson': 0xDC143C,
    'cyanX11': 0x00FFFF,
    'darkBlue': 0x00008B,
    'darkCyan': 0x008B8B,
    'darkGoldenrod': 0xB8860B,
    'darkGray': 0xA9A9A9,
    'darkGreen': 0x006400,
    'darkGrey': 0xA9A9A9,
    'darkKhaki': 0xBDB76B,
    'darkMagenta': 0x8B008B,
    'darkOliveGreen': 0x556B2F,
    'darkOrange': 0xFF8C00,
    'darkOrchid': 0x9932CC,
    'darkRed': 0x8B0000,
    'darkSalmon': 0xE9967A,
    'darkSeaGreen': 0x8FBC8F,
    'darkSlateBlue': 0x483D8B,
    'darkSlateGray': 0x2F4F4F,
    'darkSlateGrey': 0x2F4F4F,
    'darkTurquoise': 0x00CED1,
    'darkViolet': 0x9400D3,
    'deepPink': 0xFF1493,
    'deepSkyBlue': 0x00BFFF,
    'dimGray': 0x696969,
    'dimGrey': 0x696969,
    'dodgerBlue': 0x1E90FF,
    'fireBrick': 0xB22222,
    'floralWhite': 0xFFFAF0,
    'forestGreen': 0x228B22,
    'fuchsia': 0xFF00FF,
    'gainsboro': 0xDCDCDC,
    'ghostWhite': 0xF8F8FF,
    'gold': 0xFFD700,
    'goldenrod': 0xDAA520,
    'grayX11': 0x808080,
    'greenX11': 0x008000,
    'greenYellow': 0xADFF2F,
    'greyX11': 0x808080,
    'honeydew': 0xF0FFF0,
    'hotPink': 0xFF69B4,
    'indianRed': 0xCD5C5C,
    'indigo': 0x4B0082,
    'ivory': 0xFFFFF0,
    'khaki': 0xF0E68C,
    'lavender': 0xE6E6FA,
    'lavenderBlush': 0xFFF0F5,
    'lawnGreen': 0x7CFC00,
    'lemonChiffon': 0xFFFACD,
    'lightBlue': 0xADD8E6,
    'lightCoral': 0xF08080,
    'lightCyan': 0xE0FFFF,
    'lightGoldenrodYellow': 0xFAFAD2,  // CSS colorname
    'lightGoldenrod': 0xFAFAD2, // X11 name
    'lightGray': 0xD3D3D3,
    'lightGreen': 0x90EE90,
    'lightGrey': 0xD3D3D3,
    'lightPink': 0xFFB6C1,
    'lightSalmon': 0xFFA07A,
    'lightSeaGreen': 0x20B2AA,
    'lightSkyBlue': 0x87CEFA,
    'lightSlateGray': 0x778899,
    'lightSlateGrey': 0x778899,
    'lightSteelBlue': 0xB0C4DE,
    'lightYellow': 0xFFFFE0,
    'lime': 0x00FF00,
    'limeGreen': 0x32CD32,
    'linen': 0xFAF0E6,
    'magentaX11': 0xFF00FF,
    'maroon': 0x800000,
    'mediumAquamarine': 0x66CDAA,
    'mediumBlue': 0x0000CD,
    'mediumOrchid': 0xBA55D3,
    'mediumPurple': 0x9370DB,
    'mediumSeaGreen': 0x3CB371,
    'mediumSlateBlue': 0x7B68EE,
    'mediumSpringGreen': 0x00FA9A,
    'mediumTurquoise': 0x48D1CC,
    'mediumVioletRed': 0xC71585,
    'midnightBlue': 0x191970,
    'mintCream': 0xF5FFFA,
    'mistyRose': 0xFFE4E1,
    'moccasin': 0xFFE4B5,
    'navajoWhite': 0xFFDEAD,
    'navy': 0x000080,
    'oldLace': 0xFDF5E6,
    'olive': 0x808000,
    'oliveDrab': 0x6B8E23,
    'orange': 0xFFA500,
    'orangeRed': 0xFF4500,
    'orchid': 0xDA70D6,
    'paleGoldenrod': 0xEEE8AA,
    'paleGreen': 0x98FB98,
    'paleTurquoise': 0xAFEEEE,
    'paleVioletRed': 0xDB7093,
    'papayaWhip': 0xFFEFD5,
    'peachPuff': 0xFFDAB9,
    'peru': 0xCD853F,
    'pink': 0xFFC0CB,
    'plum': 0xDDA0DD,
    'powderBlue': 0xB0E0E6,
    'purple': 0x800080,
    'rebeccaPurple': 0x663399,
    'RedX11': 0xFF0000,
    'rosyBrown': 0xBC8F8F,
    'royalBlue': 0x4169E1,
    'saddleBrown': 0x8B4513,
    'salmon': 0xFA8072,
    'sandyBrown': 0xF4A460,
    'seaGreen': 0x2E8B57,
    'seashell': 0xFFF5EE,
    'sienna': 0xA0522D,
    'silver': 0xC0C0C0,
    'skyBlue': 0x87CEEB,
    'slateBlue': 0x6A5ACD,
    'slateGray': 0x708090,
    'slateGrey': 0x708090,
    'snow': 0xFFFAFA,
    'springGreen': 0x00FF7F,
    'steelBlue': 0x4682B4,
    'tan': 0xD2B48C,
    'teal': 0x008080,
    'thistle': 0xD8BFD8,
    'tomato': 0xFF6347,
    'turquoise': 0x40E0D0,
    'violet': 0xEE82EE,
    'wheat': 0xF5DEB3,
    'whiteX11': 0xFFFFFF,
    'whiteSmoke': 0xF5F5F5,
    'yellowX11': 0xFFFF00,
    'yellowGreen': 0x9ACD32,
};


List<String>
X11ColorTableColorSwatch() {
  List <String> out = [];
  List <String> keys = colorKeywords.keys.toList();

  int numX11s = colorKeywords.length;
  const int numColumns = 4;

  int lenColumn = (numX11s / numColumns).round();

  out.add('<table style="border-style:none;width:100%;text-align:center;font-weight:bold; border-collapse: separate;"><tbody>');
  out.add('<tr><th style="text-align: center;" colspan="${3*numColumns}">Chalk X11/CSS Colors</th></tr>');
  out.add('<tr style="border-bottom: grey solid 2px;>');
  for(int i=0;i<numColumns;i++) {
    out.add('<th>&nbsp;</th><th>Name</th><th>&nbsp;</th>');
  }
  out.add('</tr>');
  for(int row=0;row<lenColumn;row++) {
    out.add('<tr style="border: grey solid 2px;outline:none;">');
    for(int c=0;c<numColumns;c++) {
      int entry = (c*lenColumn) + row;
      String colorKeyword = (entry<numX11s) ? keys[entry] : '';
      int hex = -2;
      String colorCode='';
      String tooltip='';
      String textColor="black";
      if( entry < numX11s) {
        hex = colorKeywords[colorKeyword]!;
        colorCode = getCSSColorCode( colorKeyword, hex );
        tooltip = getColorTooltip( colorKeyword, hex );
      }
      if( hex==0 ) textColor="white";
      if( hex != -2) {
        out.add('<td title="$tooltip" style="outline:solid $colorCode 1px;background:$colorCode;border-left: solid $colorCode thick;border-top:solid $colorCode thick;border-bottom: solid $colorCode thick;border-right:solid $colorCode thick;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>');
        out.add('</td><td style="outline:solid $colorCode 1px;border:solid $colorCode thick;background-color: $colorCode;color: $textColor;">$colorKeyword</td>');
        out.add('<td title="$tooltip" style="outline:solid $colorCode 1px;background:$colorCode;border-right: solid $colorCode thick;border-top:solid $colorCode thick;border-bottom: solid $colorCode thick;border-left:solid $colorCode thick;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>');
      } else {
        out.add('<td></td><td></td><td></td>');
      }
    }
    out.add('<tr>');
  }
  out.add('</tbody></table>');

  return out;
}

