import 'package:chalkdart/src/ansiutils.dart';
//import 'package:chalkdart/chalk.dart';
//import 'package:chalkdart/chalk_x11.dart';
//import 'package:chalkdart/colorutils.dart';

import 'package:test/test.dart';

void main() {
  group('Test utiltity classes', () {
    setUp(() {});

    test('AnsiUtils tests', () {
      expect(AnsiUtils.hasAnsi('\u001B[4mcake\u001B[0m'), isTrue);
      expect(AnsiUtils.hasAnsi('cake'), isFalse);
      List<RegExpMatch> m =
          AnsiUtils.ansiRegex.allMatches('\u001B[4mcake\u001B[0m').toList();
      expect(m[0].group(0), '\u001B[4m');
      expect(m[1].group(0), '\u001B[0m');
      List<RegExpMatch> m2 = AnsiUtils.ansiRegex
          .allMatches('\u001B]8;;https://github.com\u0007click\u001B]8;;\u0007')
          .toList();
      expect(m2[0].group(0), '\u001B]8;;https://github.com\u0007');
      expect(m2[1].group(0), '\u001B]8;;\u0007');
    });
  });
}
