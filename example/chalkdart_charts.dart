// ignore_for_file: unnecessary_string_interpolations

import 'dart:math';
import 'package:chalkdart/chalkstrings.dart';

/*
  Some different color charts to both exercise the ColorUtils class and the Chalk'Dart Chalk class.
  @author: tim maffett
*/
class ChalkDartCharts {
  static String _padWithSpace(dynamic i, [int width = 3]) {
    return i.toString().padLeft(width, ' ');
  }

  /// Return a reference table for foreground and background colors.
  static List<String> demo() {
    List<String> lines = [];
    final sb = StringBuffer();

    lines.add('xterm 0-15');
    for (var c = 0; c <= 15; c++) {
      var mychalk = chalk.bold.white.bgAnsi(c);
      if (c == 7 || c == 15) {
        mychalk =
            mychalk.black; // change to black on white instead of white on white
      }
      sb.write(mychalk('${_padWithSpace(c)} '));
      sb.write(chalk.ansi(c)(' ${_padWithSpace(c)} '));
      if (c == 7 || c == 15) {
        lines.add(sb.toString());
        sb.clear();
      }
    }

    lines.add('\nrgb and white() 5x5x5');
    for (var r = 0; r <= 5; r++) {
      for (var g = 0; g <= 5; g++) {
        for (var b = 0; b <= 5; b++) {
          var c = r * 36 + g * 6 + b + 16;
          sb.write(
              chalk.bgRgb(r / 5, g / 5, b / 5).white(' ${_padWithSpace(c)} '));
          sb.write(
              chalk.rgb(r / 5, g / 5, b / 5).onWhite(' ${_padWithSpace(c)} '));
        }
        lines.add(sb.toString());
        sb.clear();
      }
    }

    lines.add('\nrgb and black() 5x5x5');
    for (var r = 0; r <= 5; r++) {
      for (var g = 0; g <= 5; g++) {
        for (var b = 0; b <= 5; b++) {
          var c = r * 36 + g * 6 + b + 16;
          sb.write(
              chalk.black.onRgb(r / 5, g / 5, b / 5)(' ${_padWithSpace(c)} '));
          sb.write(
              chalk.bgBlack.rgb(r / 5, g / 5, b / 5)(' ${_padWithSpace(c)} '));
        }
        lines.add(sb.toString());
        sb.clear();
      }
    }

    lines.add('\nGREYSCALE');
    for (var c = 0; c < 24; c++) {
      if (c != 0 && 0 == c % 8) {
        lines.add(sb.toString());
        sb.clear();
      }
      sb.write(
          chalk.onGreyscale(c / 23).white.bold(' ${_padWithSpace(c + 232)} '));
      sb.write(chalk.greyscale(c / 23)(' ${_padWithSpace(c + 232)} '));
    }
    lines.add(sb.toString());
    sb.clear();

    return lines;
  }

  static List<String> demo16M([List<String>? lines]) {
    lines ??= [];

    final sb16M = StringBuffer();

    const _numDivisions = 15;

    lines.add('16M rgb and white() 16x16x16');
    for (var r = 0; r <= _numDivisions; r++) {
      for (var g = 0; g <= _numDivisions; g++) {
        sb16M.write(('r=${_padWithSpace(r)} g=${_padWithSpace(g)} '));
        for (var b = 0; b <= _numDivisions; b++) {
          sb16M.write(chalk.white
              .onRgb16m(r / _numDivisions, g / _numDivisions, b / _numDivisions)
              .bold(' b=${_padWithSpace(b)} '));
        }
        lines.add(sb16M.toString());
        sb16M.clear();
      }
    }

    lines.add('\n16M  rgb and black() 16x16x16');
    for (var r = 0; r <= _numDivisions; r++) {
      for (var g = 0; g <= _numDivisions; g++) {
        sb16M.write(('r=${_padWithSpace(r)} g=${_padWithSpace(g)} '));
        for (var b = 0; b <= _numDivisions; b++) {
          sb16M.write(chalk.black
              .onRgb16m(r / _numDivisions, g / _numDivisions, b / _numDivisions)
              .bold(' b=${_padWithSpace(b)} '));
        }
        lines.add(sb16M.toString());
        sb16M.clear();
      }
    }

    return lines;
  }

  static List<String> dumpAllHWBTables() {
    Chalk.ansiColorLevelForNewInstances = chalk.level = 3; // force full color
    List<String> out = [];

    List<String> t1 = [];
    List<String> t2 = [];
    List<String> t3 = [];
    List<String> t4 = [];

    t1 = dumpHWBTable(t1, 'Reds', 0);

    t2 = dumpHWBTable(t2, 'Reds-Yellow (Oranges)', 30);

    t3 = dumpHWBTable(t3, 'Yellow', 60);

    t4 = dumpHWBTable(t4, 'Yellow-Greens', 90);

    t1 = dumpHWBTable(t1, 'Greens', 120);

    t2 = dumpHWBTable(t2, 'Green-Cyans', 150);

    t3 = dumpHWBTable(t3, 'Cyans', 180);

    t4 = dumpHWBTable(t4, 'Cyan-Blues', 210);

    t1 = dumpHWBTable(t1, 'Blues', 240);

    t2 = dumpHWBTable(t2, 'Blue-Magentas', 270);

    t3 = dumpHWBTable(t3, 'Magentas', 300);

    t4 = dumpHWBTable(t4, 'Magenta-Reds', 330);

    for (var i = 0; i < t1.length; i++) {
      out.add(t1[i] + ' ' + t2[i] + ' ' + t3[i] + ' ' + t4[i]);
    }

    Chalk.useFullResetToClose = false;
    final len = chalk.strip(out[0]).length;
    out.insert(0, chalk.black.onWhite(center(chalk.bold('HWB Tables'), len)));

    return out;
  }

  static List<String> dumpHWBTable(List<String> out, String title, num hue) {
    final firstLine = out.length;
    var sb = StringBuffer();
    var hb = StringBuffer();
    final titleLine = '$hue° $title'.htmlSafeEntities;
    for (num w = 0; w <= 1; w += .20) {
      sb.clear();
      for (num b = 0; b <= 1; b += .20) {
        if (w == 0) {
          if (b == 0) hb.write(chalk.black.onWhite(r'W \ B'));
          hb.write(chalk.black
              .onWhite(_padWithSpace((b * 100).toStringAsFixed(0) + '% ', 5)));
        }
        if (b == 0) {
          sb.write(chalk.black
              .onWhite(_padWithSpace((w).toStringAsFixed(0) + '% ', 5)));
        }
        sb.write(chalk.onHwb(hue, w * 100, b * 100)('     '));
      }
      if (w == 0) out.add(hb.toString());

      out.add(sb.toString());
    }

    final len = chalk.strip(out[firstLine]).length;
    out.insert(firstLine, chalk.black.onWhite(center(titleLine, len)));
    return out;
  }

  static List<String> dumpAllHSLTables() {
    Chalk.ansiColorLevelForNewInstances = chalk.level = 3; // force full color
    List<String> out = [];

    List<String> t1 = [];
    List<String> t2 = [];
    List<String> t3 = [];
    List<String> t4 = [];

    t1 = dumpHSLTable(t1, 'Cyan', 180);

    t2 = dumpHSLTable(t2, 'Red', 0, true);

    t3 = dumpHSLTable(t3, 'Blue-Cyan', 210);

    t4 = dumpHSLTable(t4, 'Yellow-red', 30, true);

    t1 = dumpHSLTable(t1, 'Blue', 240);

    t2 = dumpHSLTable(t2, 'Yellow', 60, true);

    t3 = dumpHSLTable(t3, 'Magenta-Blue', 270);

    t4 = dumpHSLTable(t4, 'Green-Yellow', 90, true);

    t1 = dumpHSLTable(t1, 'Magenta', 300);

    t2 = dumpHSLTable(t2, 'Green', 120, true);

    t3 = dumpHSLTable(t3, 'Red-Magenta', 330);

    t4 = dumpHSLTable(t4, 'Cyan-Green', 150, true);

    for (var i = 0; i < t1.length; i++) {
      out.add(t1[i] + t2[i] + ' ' + t3[i] + t4[i]);
    }

    final len = chalk.strip(out[0]).length;
    out.insert(0, chalk.black.onWhite(center(chalk.bold('HSL Tables'), len)));

    return out;
  }

  static List<String> dumpHSLTable(List<String> out, String title, num hue,
      [bool secondHalf = false]) {
    final firstLine = out.length;
    var sb = StringBuffer();
    var hb = StringBuffer();
    final titleLine = '${chalk.bold("H=$hue°".htmlSafeEntities)}';
    final titleLine2 = '${chalk.bold.black.onWhite("($title)")}';

    num sStart = secondHalf ? 0 : 1;
    num sEnd = secondHalf ? 1.0 : 0.25;
    num sStep = secondHalf ? 0.25 : -0.25;

    String getColumnHeader(num s) {
      if (s == 1) return '1';
      if (s == 0.75) return '3/4';
      if (s == 0.5) return '1/2';
      if (s == 0.25) return '1/4';
      return '0';
    }

    String getRowHeader(num l) {
      if (l == 1) return '1';
      if (l == 7 / 8) return '7/8';
      if (l == 3 / 4) return '3/4';
      if (l == 5 / 8) return '5/8';
      if (l == 5 / 8) return '5/8';
      if (l == 1 / 2) return '1/2';
      if (l == 3 / 8) return '3/8';
      if (l == 1 / 4) return '1/4';
      if (l == 1 / 8) return '1/8';
      return '0';
    }

    for (num l = 1; l >= 0; l -= (1 / 8)) {
      sb.clear();
      var firstCol = true;
      for (var s = sStart;
          (sStep > 0 && s <= sEnd) || (sStep < 0 && s >= sEnd);
          s += sStep) {
        if (l == 1) {
          if (firstCol && !secondHalf) {
            hb.write(chalk.bold.black.onWhite(r'L \ S'));
          }
          hb.write(chalk.bold.black.onWhite(center(getColumnHeader(s), 5)));
        }
        if (firstCol && !secondHalf) {
          sb.write(chalk.bold.black.onWhite(center(getRowHeader(l), 5)));
          firstCol = false;
        }
        sb.write(chalk.onHsl(hue, s * 100, l * 100)('     '));
      }
      if (l == 1) out.add(hb.toString());

      out.add(sb.toString());
    }

    final len = chalk.strip(out[firstLine]).length;
    out.insert(firstLine, chalk.black.onWhite(center(titleLine, len)));
    out.insert(firstLine + 1, chalk.black.onWhite(center(titleLine2, len)));
    return out;
  }

  static List<String> dumpAllRangeHSVTables(num startHue, num stopHue) {
    Chalk.ansiColorLevelForNewInstances = chalk.level = 3; // force full color
    List<String> out = [];

    List<String> t1 = [];
    List<String> t2 = [];
    List<String> t3 = [];
    List<String> t4 = [];

    final minHue = min(startHue, stopHue);
    final maxHue = max(startHue, stopHue);
    startHue = minHue;
    stopHue = maxHue;
    final hueStep = (stopHue - startHue) / 12;
    var curHue = minHue;

    t1 = dumpHSVTable(t1, '', curHue);
    curHue += hueStep;
    t2 = dumpHSVTable(t2, '', curHue, true);
    curHue += hueStep;
    t3 = dumpHSVTable(t3, '', curHue);
    curHue += hueStep;
    t4 = dumpHSVTable(t4, '', curHue, true);
    curHue += hueStep;
    t1 = dumpHSVTable(t1, '', curHue);
    curHue += hueStep;
    t2 = dumpHSVTable(t2, '', curHue, true);
    curHue += hueStep;
    t3 = dumpHSVTable(t3, '', curHue);
    curHue += hueStep;
    t4 = dumpHSVTable(t4, '', curHue, true);
    curHue += hueStep;
    t1 = dumpHSVTable(t1, '', curHue);
    curHue += hueStep;
    t2 = dumpHSVTable(t2, '', curHue, true);
    curHue += hueStep;
    t3 = dumpHSVTable(t3, '', curHue);
    curHue += hueStep;
    t4 = dumpHSVTable(t4, '', curHue, true);
    curHue += hueStep;
    for (var i = 0; i < t1.length; i++) {
      out.add(t1[i] + t2[i] + ' ' + t3[i] + t4[i]);
    }

    final len = chalk.strip(out[0]).length;
    out.insert(
        0,
        chalk.black.onWhite(
            center(chalk.bold('HSV Tables $startHue - $stopHue'), len)));

    return out;
  }

  static List<String> dumpAllHSVTables() {
    Chalk.ansiColorLevelForNewInstances = chalk.level = 3; // force full color
    List<String> out = [];

    List<String> t1 = [];
    List<String> t2 = [];
    List<String> t3 = [];
    List<String> t4 = [];

    t1 = dumpHSVTable(t1, 'Cyan', 180);

    t2 = dumpHSVTable(t2, 'Red', 0, true);

    t3 = dumpHSVTable(t3, 'Blue-Cyan', 210);

    t4 = dumpHSVTable(t4, 'Yellow-red', 30, true);

    t1 = dumpHSVTable(t1, 'Blue', 240);

    t2 = dumpHSVTable(t2, 'Yellow', 60, true);

    t3 = dumpHSVTable(t3, 'Magenta-Blue', 270);

    t4 = dumpHSVTable(t4, 'Green-Yellow', 90, true);

    t1 = dumpHSVTable(t1, 'Magenta', 300);

    t2 = dumpHSVTable(t2, 'Green', 120, true);

    t3 = dumpHSVTable(t3, 'Red-Magenta', 330);

    t4 = dumpHSVTable(t4, 'Cyan-Green', 150, true);

    for (var i = 0; i < t1.length; i++) {
      out.add(t1[i] + t2[i] + ' ' + t3[i] + t4[i]);
    }

    final len = chalk.strip(out[0]).length;
    out.insert(0, chalk.black.onWhite(center(chalk.bold('HSV Tables'), len)));

    return out;
  }

  static List<String> dumpHSVTable(List<String> out, String title, num hue,
      [bool secondHalf = false]) {
    final firstLine = out.length;
    var sb = StringBuffer();
    var hb = StringBuffer();
    final titleLine = '${chalk.bold("H=$hue°".htmlSafeEntities)}';
    final titleLine2 =
        title != '' ? '${chalk.bold.black.onWhite("($title)")}' : '';

    num sStart = secondHalf ? 0 : 1;
    num sEnd = secondHalf ? 1.0 : 0.25;
    num sStep = secondHalf ? 0.25 : -0.25;

    String getColumnHeader(num s) {
      if (s == 1) return '1';
      if (s == 0.75) return '3/4';
      if (s == 0.5) return '1/2';
      if (s == 0.25) return '1/4';
      return '0';
    }

    String getRowHeader(num v) {
      if (v == 1) return '1';
      if (v == 7 / 8) return '7/8';
      if (v == 3 / 4) return '3/4';
      if (v == 5 / 8) return '5/8';
      if (v == 5 / 8) return '5/8';
      if (v == 1 / 2) return '1/2';
      if (v == 3 / 8) return '3/8';
      if (v == 1 / 4) return '1/4';
      if (v == 1 / 8) return '1/8';
      return '0';
    }

    for (num v = 1; v >= 0; v -= (1 / 8)) {
      sb.clear();
      var firstCol = true;
      for (var s = sStart;
          (sStep > 0 && s <= sEnd) || (sStep < 0 && s >= sEnd);
          s += sStep) {
        if (v == 1) {
          if (firstCol && !secondHalf) {
            hb.write(chalk.black.onWhite(r'V \ S'));
          }
          hb.write(chalk.black.onWhite(center(getColumnHeader(s), 5)));
        }
        if (firstCol && !secondHalf) {
          sb.write(chalk.bold.black.onWhite(center(getRowHeader(v), 5)));
          firstCol = false;
        }
        sb.write(chalk.onHsv(hue, s * 100, v * 100)('     '));
      }
      if (v == 1) out.add(hb.toString());

      out.add(sb.toString());
    }

    final len = chalk.strip(out[firstLine]).length;
    out.insert(firstLine, chalk.black.onWhite(center(titleLine, len)));
    if (titleLine2 != '') {
      out.insert(firstLine + 1, chalk.black.onWhite(center(titleLine2, len)));
    }
    return out;
  }

  static String center(String s, int width) {
    final len = chalk.strip(s).length;
    final pad = width - len;
    final iLeft = (pad / 2).floor();
    final iRight = (pad / 2).ceil();

    return "${''.padLeft(iLeft, ' ')}$s${''.padRight(iRight, ' ')}";
  }

  static List<String> dumpLabChart(int l) {
    List<String> lines = [];
    StringBuffer sb = StringBuffer();

    final bRange = 108;
    final aRange = 100;
    final w = 100;
    //int h=13;
    final bStep = 6; //((b_range*2)/h).floor();
    final aStep = ((aRange * 2) / w).floor();
    final chartWidth = w + 1 + 6 + 6;

    lines.add(chalk.bold.black
        .onWhite("${center('L.a.b. Chart for L(ightness) = $l', chartWidth)}"));

    lines.add(chalk.bold.black.onWhite(center('Yellow', chartWidth)));
    lines.add(chalk.bold.black.onWhite(center('+b', chartWidth)));
    lines.add(chalk.bold.black.onWhite(center('+$bRange', chartWidth)));

    for (var b = bRange; b >= -bRange; b -= bStep) {
      for (var a = -aRange; a <= aRange; a += aStep) {
        if (a == -aRange) {
          if (b == bStep) {
            sb.write(chalk.bold.black.onWhite('  -a  '));
          } else if (b == 0) {
            sb.write(chalk.bold.black.onWhite('${-aRange} '.padLeft(6)));
          } else if (b == -bStep) {
            sb.write(chalk.bold.black.onWhite('Green '));
          } else {
            sb.write(chalk.black.onWhite('      '));
          }
        }
        sb.write(chalk.bold.black.onLab(l, a, b)((b == 0)
            ? (a == 0 ? '+' : chalk.strikethrough('-'))
            : (a == 0 ? '|' : ' ')));
        if (a == aRange) {
          if (b == bStep) {
            sb.write(chalk.bold.black.onWhite('  +a  '));
          } else if (b == 0) {
            sb.write(chalk.bold.black.onWhite(' +$aRange'.padRight(6)));
          } else if (b == -bStep) {
            sb.write(chalk.bold.black.onWhite('  Red'.padRight(6)));
          } else {
            sb.write(chalk.black.onWhite('      '));
          }
        }
      }
      lines.add(sb.toString());
      sb.clear();
    }
    lines.add(chalk.bold.black.onWhite(center('Blue', chartWidth)));
    lines.add(chalk.bold.black.onWhite(center('-b', chartWidth)));
    lines.add(chalk.bold.black.onWhite(center('(${-bRange})', chartWidth)));

    return lines;
  }
}
