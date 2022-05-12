/*
   This writes the code for the X11 color table entry points for chalkdart.dart
*/
/*
  @author: tim maffett
*/
import 'dart:io';
import 'package:args/args.dart';
import 'package:chalkdart/colorutils.dart';

const String outputExtensionClassFile = 'lib/src/chalk_x11.g.dart';

void main(List<String> arguments) {
  //arguments = ['-c', '-x', '--out', 'timmy.txt'];
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addFlag('help',
        abbr: 'h', negatable: false, help: 'Print help text and exit.')
    ..addFlag('colorMethods',
        abbr: 'c',
        negatable: false,
        help:
            'Write color methods to $outputExtensionClassFile (override destination with --out)')
    ..addFlag('x11ReadmeTable',
        abbr: 'x',
        negatable: false,
        help: 'Write x11 readme color table to stdout (override with --out)')
    ..addOption('out',
        abbr: 'o', help: 'specify output file to write to instead of stdout');

  ArgResults argResults;

  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    printUsage(parser);
    exit(0);
  }

  if (argResults.wasParsed('help') ||
      (!argResults.wasParsed('colorMethods') &&
          !argResults.wasParsed('x11ReadmeTable'))) {
    printUsage(parser);
    exit(0);
  }

  final bool dumpToOutFile =
      argResults.wasParsed('out') && argResults['out'].isNotEmpty;
  final String outputFileName =
      dumpToOutFile ? argResults['out'] : outputExtensionClassFile;

  final bool dumpColorMethodsFlag = argResults.wasParsed('colorMethods');

  List<String> out = [];

  if (dumpColorMethodsFlag) {
    out = dumpColorMethods();
  } else if (argResults['x11ReadmeTable']) {
    out = dumpX11ReadmeTable();
  }

  if (dumpColorMethodsFlag || dumpToOutFile) {
    File(outputFileName).writeAsStringSync(out.join('\n').toString());
  } else {
    for (String line in out) {
      print(line);
    }
  }

  exit(0);
}

List<String> dumpColorMethods() {
  List<String> out = [];

  out.add(
'// BEGIN GENERATED CODE - DO NOT MODIFY BY HAND - generating code => /tool/makeX11EntryPoints.dart');

  out.add('''
import 'chalk.dart';

/// This extension class adds proper methods to Chalk for all of the 
/// standard X11/CSS/SVG color names for use by Chalk.
/// This extension has the added advantage of providing code completion and type
/// checking at coding/compile time.  Using the dynamic [color] method cannot provide
/// any coding/compile time checks because it works via a dynamic lookup at run time.
/// Example of using this extension for Chalk:
/// `chalk.lightGoldenrodYellow.onCornflowerBlue(...)`
/// versus having to use the `color` (or `css` or `x11`) method to get a `dynamic` so
/// you can use the dynamic lookups: 
/// `chalk.color.lightGoldenrodYellow.onCornflowerBlue(...)`
/// Because of the dynamic lookup is not resolved until run time that method can be
/// prone to errors which would not be detected until run time.
extension ChalkX11 on Chalk {''');

  colorKeywords.forEach((colorKeyword, hexColorValue) {
    if(colorKeyword.startsWith('@')) return; // skip ansi colors
    num red = (hexColorValue >> 16) & 0xFF;
    num green = (hexColorValue >> 8) & 0xFF;
    num blue = hexColorValue & 0xFF;

    String colorHexStr =
        hexColorValue.toRadixString(16).padLeft(6, '0').toUpperCase();
    String entryPoint = colorKeyword;
    String onEntryPoint =
        'on' + colorKeyword[0].toUpperCase() + colorKeyword.substring(1);

    String cssColorCode = colorKeyword.toLowerCase();
    String colorSource = 'X11/CSS';
    if (cssColorCode == 'rebeccapurple' || cssColorCode == 'lightgoldenrod') {
      colorSource = 'X11';
      cssColorCode = 'rgb($red, $green, $blue)'; // these are X11 names
    } else if (cssColorCode == 'lightgoldenrodyellow') {
      colorSource = 'CSS';
    }
    cssColorCode = cssColorCode.replaceAll('x11', '');

    outWithIndent(out,
        "/// set foreground color to $colorSource color $colorKeyword <span style='background-color: $cssColorCode;border: black solid 2px;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x$colorHexStr)/rgb($red, $green, $blue)");
    outWithIndent(
        out, 'Chalk get $entryPoint => makeRGBChalk($red, $green, $blue);');
    outWithIndent(out, '');
    outWithIndent(out,
        "/// set background color to $colorSource color $colorKeyword <span style='background-color: $cssColorCode;border: black solid 2px;'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span> (0x$colorHexStr)/rgb($red, $green, $blue)");
    outWithIndent(out,
        'Chalk get $onEntryPoint => makeRGBChalk($red, $green, $blue, bg: true);');
    outWithIndent(out, '');
  });
  out.add('}');

  out.add('');
  out.add(
'''// END GENERATED CODE - DO NOT MODIFY BY HAND - generating code => /examples/makeX11EntryPoints.dart
''');

  return out;
}

void outWithIndent(List<String> out, String line) {
  if (line.isEmpty) {
    out.add('');
  } else {
    out.add('  $line');
  }
}

String getCSSColorCode(String colorKeyword, int hexColorValue,
    {bool getSource = false, bool builtIn = false}) {
  num red = (hexColorValue >> 16) & 0xFF;
  num green = (hexColorValue >> 8) & 0xFF;
  num blue = hexColorValue & 0xFF;
  String cssColorCode = colorKeyword.toLowerCase();
  String colorSource = 'X11/CSS';
  if (builtIn) {
    cssColorCode =
        '#${hexColorValue.toRadixString(16).padLeft(6, '0').toUpperCase()}';
    cssColorCode = 'rgb($red, $green, $blue)'; // these are X11 names
    colorSource = 'Ansi';
  } else if (cssColorCode == 'rebeccapurple' ||
      cssColorCode == 'lightgoldenrod') {
    colorSource = 'X11';
    cssColorCode = 'rgb($red, $green, $blue)'; // these are X11 names
  } else if (cssColorCode == 'lightgoldenrodyellow') {
    colorSource = 'CSS';
  }
  cssColorCode = cssColorCode.replaceAll('x11', '');
  return !getSource ? cssColorCode : colorSource;
}

String getColorTooltip(String colorKeyword, int hexColorValue) {
  String colorHexStr =
      hexColorValue.toRadixString(16).padLeft(6, '0').toUpperCase();

  List<num> rgb = ColorUtils.hex2rgb(hexColorValue);
  List<int> hsl = ColorUtils.rgb2hsl(rgb);

  String toolTip =
      '0x$colorHexStr rgb(${rgb[0]},${rgb[1]},${rgb[2]}) hsl(${hsl[0]},${hsl[1]},${hsl[2]})';

  return toolTip;
}

num getColorLumin(int hexColorValue) {
  List<num> rgb = ColorUtils.hex2rgb(hexColorValue);
  //List<int> hsl = ColorUtils.rgb2hsl(rgb);

  num lumin = (rgb[0] * 0.375) + (rgb[1] * 0.5) + (rgb[2] * 0.125);

  return lumin;
}

List<String> dumpX11ReadmeTable() {
  List<String> out = [];
  List<String> keys = colorKeywords.keys.toList();

  int numX11s = colorKeywords.length;
  const int numColumns = 1;

  int lenColumn = (numX11s / numColumns).round();
  out.add(r'''
  <link rel="preconnect" href="https://fonts.gstatic.com">
  <link href="https://fonts.googleapis.com/css2?family=Roboto+Mono:ital,wght@0,300;0,400;0,500;0,700;1,400&amp;display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
<style type="text/css" media="all">
body {
  -webkit-text-size-adjust: 100%;
  overflow-x: hidden;
  font-family: Roboto, sans-serif;
  font-size: 16px;
  line-height: 1.42857143;
  color: #111111;
  background-color: #fff;
}
.colortable {
  font-size: 14px;
}
table {
  border-collapse: collapse;
  border-top: 1px solid #fff;
  font: 100 1em sans-serif;
  margin: auto;
  cursor: pointer;
}
#x11colors tr {
  border: grey solid 2px;
  outline:none;
}
tr.dark td {
  color: #fff;
  background-color: #fff;
}
tr.light td span {
  padding: 5px 5px;
  background-color: #000;
}
tr.dark td span {
  padding: 5px 5px;
  background-color: #fff;
}
th {
  text-align: center;
}
th, td {
  padding: 0.8em 0.75em 0.5em;
  border-bottom: 1px solid #fff;
}
thead th {
  border-bottom: 1px solid gray;
}
thead th a[href] {
  color: #000;
  text-decoration: none;
  display: block;
}
thead th[id] a:after {
  content: " ⬦";
  color: #CCC;
}
thead th.sortby a:after {
  font-size: 80%;
  color: #333;
}
thead th.sortby.asc a:after {
  content: " ▼";
}
thead th.sortby.dsc a:after {
  content: " ▲";
}
thead th.sortby {
  background: whitesmoke;
  background:
    -webkit-repeating-linear-gradient(
      0deg,
      transparent 3px,
      rgba(0,0,0,0.01) 6px,
      transparent 9px),
    whitesmoke;
  background:
    -moz-repeating-linear-gradient(
      0deg,
      transparent 3px,
      rgba(0,0,0,0.01) 6px,
      transparent 9px),
    whitesmoke;
  background:
    -o-repeating-linear-gradient(
      0deg,
      transparent 3px,
      rgba(0,0,0,0.01) 6px,
      transparent 9px),
    whitesmoke;
  background:
    repeating-linear-gradient(
      0deg,
      transparent 3px,
      rgba(0,0,0,0.01) 6px,
      transparent 9px),
    whitesmoke;
}

tbody th, td {
  font-weight: normal;
  font: 1.1em monospace;
  }
</style>
<script type="text/javascript">

var sortedAnsiIn = false;

function includeAnsiChange() {
  var ansiCheckBox = document.getElementById("includeAnsiBase");

  if(!sortedAnsiIn) {
    // We never showed ansi before so we need to sort into the current sort
    if(document.getElementsByClassName("sortby")) {
      // we are sorted by something
      var s = document.getElementsByClassName("sortby")[0];
      if(s) {
        // get the ID
        var id = s.id;
        var type = id.replace('Sort','');
        // now clear sorting and act like we never have
        resetSortClasses();
        sort(type);
        // var ascending = s.classList.contains(asc);

        // s.classList.remove("sortby");
        // s.classList.remove("asc");
        // s.classList.remove("dsc");
      }
    }
  }

  var hide = !ansiCheckBox.checked;
  ansiRows = document.querySelectorAll(".baseansicolor");
  for (i = 0; i < ansiRows.length; i++) {
    ansiRows[i].hidden = hide;
  }
}

function resetSortClasses() {
  if(document.getElementsByClassName("sortby")) {
    var s = document.getElementsByClassName("sortby")[0];
    if(s) {
      s.classList.remove("sortby");
      s.classList.remove("asc");
      s.classList.remove("dsc");
    }
  }
}

function rewriteTable() {
  function removeAllChildNodes(parent) {
    while (parent.firstChild) {
        parent.removeChild(parent.firstChild);
    }
}
  tbody = document.querySelector("#x11colors");
  removeAllChildNodes(tbody);
  var limit = sorter.length;
  for (i = 0; i < sorter.length; i++) {
    tbody.appendChild(sorter[i].tr);
  }
}

function nameSort(a,b) {
  return a.name.localeCompare(b.name);
}
function rgbSort(a,b) {
  return (a.red - b.red || a.green - b.green || a.blue - b.blue);
}
function hslSort(a,b) {
  return (a.hue - b.hue || a.sat - b.sat || a.light - b.light);
}
function luminSort(a,b) {
  return (a.lumin - b.lumin);
}

function sort(type) {
  if (!type) return false;
  var header = document.getElementById(type+"Sort");
  if (header.classList.contains("sortby")) {
    if(!sortedAnsiIn) {
      sorter.sort(window[type+"Sort"]);
      sortedAnsiIn = true;
    }
    sorter.reverse();
    header.classList.toggle("asc");
    header.classList.toggle("dsc");
  } else {
    sorter.sort(window[type+"Sort"]);
    resetSortClasses();
    header.classList.add("sortby");
    header.classList.add("asc");
  }
  sortedAnsiIn = true;
  rewriteTable();
}

function indexer(rows) {
  var colorRows = [];
  var rownum = rows.length;
  var rgb = '';
  for (i = 0;  i < rownum; i++) {
    if(rows[i].getElementsByTagName("td").length==0) continue;
    var name = rows[i].getElementsByTagName("td")[0].textContent;
    var cells = rows[i].getElementsByTagName("td");
    var title = cells[0].title;
    var parts = title.split(' ');
    var rgbd = parts[1];
    var hsl = parts[2];
    rgb = rgbd.substring(4,rgbd.length-1).split(",");
    hsl = hsl.substring(4,hsl.length-1).split(",")
    var colorProps = [];
    colorProps["row"] = i;
    colorProps["name"] = name;
    colorProps["red"] = parseInt(rgb[0]);
    colorProps["green"] = parseInt(rgb[1]);
    colorProps["blue"] = parseInt(rgb[2]);
    colorProps["hue"] = parseInt(hsl[0]);
    colorProps["sat"] = parseFloat(hsl[1]);
    colorProps["light"] = parseFloat(hsl[2]);
    colorProps["lumin"] = (rgb[0]*0.375) + (rgb[1]*0.5) + (rgb[2]*0.125);

    colorProps["tr"] = rows[i];
    colorRows.push(colorProps);
  }
  return colorRows;
}

function startup() {
  tbody = document.querySelector("#x11colors");
  rows = tbody.getElementsByTagName("tr");
  sorter = indexer(rows);
}

var sorter = [];

</script>
''');

  out.add('''
<table class="colortable" style="border-style:none;
  width:90%;text-align:center;font-weight:bold; border-collapse: separate;">
<thead>
<tr><th style="font-size: 150%;" colspan="${2 * numColumns}">Chalk X11/CSS/SVG Color Style Methods
<span style="margin-left: 20px;"><label style="font-size:50%" for="includeAnsiBase">Include basic ansi colors</label>
<input type="checkbox" id="includeAnsiBase" name="includeAnsiBase" value="off" onchange="includeAnsiChange();"></span>
</th></tr>
<tr>
<th id="nameSort"  colspan="${2 * numColumns}"class="sortby asc"><a href="javascript:sort('name');">Name sort</a></th>
</tr>
<tr>
<th id="rgbSort" colspan="${2 * numColumns}"><a href="javascript:sort('rgb');">RGB sort</a></th>
</tr>
<tr>
<th id="hslSort" colspan="${2 * numColumns}"><a href="javascript:sort('hsl');">HSL sort</a></th>
</tr>
<tr>
<th id="luminSort" colspan="${2 * numColumns}"><a href="javascript:sort('lumin');">Brightness sort</a></th>
</tr>
''');

  out.add('');
  out.add('<tr style="border-bottom: grey solid 2px;">');
  for (int i = 0; i < numColumns; i++) {
    out.add(
        '<th>Method name to set as forground color</th><th>Method name to set as background color</th>');
  }
  out.add('</tr>');
  out.add('''
</thead>
<tbody id="x11colors">
''');
  for (int row = 0; row < lenColumn; row++) {
    for (int c = 0; c < numColumns; c++) {
      int entry = (row * numColumns) + c; //(c*lenColumn) + row;
      if ((entry < numX11s)) {
        bool builtInColor = false;
        String colorKeyword = (entry < numX11s) ? keys[entry] : '';
        String keyColorKeyword = colorKeyword;
        if (colorKeyword.startsWith('@')) {
          // built in color, NOT x11 color
          colorKeyword = colorKeyword.substring(1);
          builtInColor = true;
        }
        int hex = 0;
        late final String colorCode;
        late final String tooltip;
        //String textColor = 'black';
        String backgroundColorCmd = '';
        String onEntryPoint =
            'on' + colorKeyword[0].toUpperCase() + colorKeyword.substring(1);
        if (entry < numX11s) {
          hex = colorKeywords[keyColorKeyword]!;
          colorCode = getCSSColorCode(colorKeyword, hex, builtIn: builtInColor);
          tooltip = getColorTooltip(colorKeyword, hex);
        }
        String rowClass = 'light';
        if (getColorLumin(hex) < 120) {
          rowClass = 'dark';
        }
        if (c == 0) {
          out.add(
              '<tr class="$rowClass${builtInColor ? ' baseansicolor' : ''}" ${builtInColor ? 'hidden' : ''}>');
        }

        if (hex != -2) {
          out.add(
              '<td title="$tooltip" style="outline:solid $colorCode 1px; $backgroundColorCmd border: solid $colorCode 7px;color: $colorCode;background-color: $colorCode;"><span>.$colorKeyword</span></td>');
          out.add(
              '</td><td title="$tooltip" style="outline:solid $colorCode 1px;border:solid $colorCode thick;background-color: $colorCode;">.$onEntryPoint</td>');
        }
      } else {
        out.add('<td></td><td></td>');
      }
    }
    out.add('<tr>');
  }
  out.add('</tbody></table>');
  out.add('<script>startup();</script>');
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
  'lightGoldenrodYellow': 0xFAFAD2, // CSS colorname
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
  'redX11': 0xFF0000,
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

// `built in` ansi colors
  '@brightRed': 0xff0000,
  '@brightGreen': 0x00ff00,
  '@brightBlue': 0x0000ff,
  '@brightCyan': 0x00ffff,
  '@brightYellow': 0xffff00,
  '@brightMagenta': 0xff00ff,
  '@brightWhite': 0xffffff,
  '@brightBlack': 0x888888,
  '@red': 0x880000,
  '@green': 0x008800,
  '@blue': 0x000088,
  '@cyan': 0x008888,
  '@yellow': 0x888800,
  '@magenta': 0x880088,
  '@white': 0x888888,
  '@black': 0x000000,
};

List<String> x11ColorTableColorSwatch() {
  List<String> out = [];
  List<String> keys = colorKeywords.keys.toList();

  int numX11s = colorKeywords.length;
  const int numColumns = 4;

  int lenColumn = (numX11s / numColumns).round();

  out.add(
      '<table style="border-style:none;width:100%;text-align:center;font-weight:bold; border-collapse: separate;"><tbody>');
  out.add(
      '<tr><th style="text-align: center;" colspan="${3 * numColumns}">Chalk X11/CSS Colors</th></tr>');
  out.add('<tr style="border-bottom: grey solid 2px;>');
  for (int i = 0; i < numColumns; i++) {
    out.add('<th>&nbsp;</th><th>Name</th><th>&nbsp;</th>');
  }
  out.add('</tr>');
  for (int row = 0; row < lenColumn; row++) {
    out.add('<tr style="border: grey solid 2px;outline:none;">');
    for (int c = 0; c < numColumns; c++) {
      int entry = (c * lenColumn) + row;
      String colorKeyword = (entry < numX11s) ? keys[entry] : '';
      if (colorKeyword.startsWith('@')) {
        row = lenColumn; // force being DONE
        break; // We are at end of X11 colors
      }
      int hex = -2;
      String colorCode = '';
      String tooltip = '';
      String textColor = 'black';
      if (entry < numX11s) {
        hex = colorKeywords[colorKeyword]!;
        colorCode = getCSSColorCode(colorKeyword, hex);
        tooltip = getColorTooltip(colorKeyword, hex);
      }
      if (hex == 0) textColor = 'white';
      if (hex != -2) {
        out.add(
            '<td title="$tooltip" style="outline:solid $colorCode 1px;background:$colorCode;border-left: solid $colorCode thick;border-top:solid $colorCode thick;border-bottom: solid $colorCode thick;border-right:solid $colorCode thick;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>');
        out.add(
            '</td><td style="outline:solid $colorCode 1px;border:solid $colorCode thick;background-color: $colorCode;color: $textColor;">$colorKeyword</td>');
        out.add(
            '<td title="$tooltip" style="outline:solid $colorCode 1px;background:$colorCode;border-right: solid $colorCode thick;border-top:solid $colorCode thick;border-bottom: solid $colorCode thick;border-left:solid $colorCode thick;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>');
      } else {
        out.add('<td></td><td></td><td></td>');
      }
    }
    out.add('<tr>');
  }
  out.add('</tbody></table>');

  return out;
}

void printUsage(ArgParser parser) {
  print('''Usage: make_css_x11_methods.dart
${parser.usage}
''');
}
