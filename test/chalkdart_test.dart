import 'package:chalkdart/src/ansiutils.dart';
//import 'package:chalkdart/chalk.dart';
//import 'package:chalkdart/chalk_x11.dart';
//import 'package:chalkdart/colorutils.dart';

import 'package:test/test.dart';

void main() {
  group('Test utiltity classes', () {
    setUp(() {});

    test('AnsiUtils tests', () {
      expect(AnsiUtils.hasAnsi('\x1B[4mcake\x1B[0m'), isTrue);
      expect(AnsiUtils.hasAnsi('cake'), isFalse);
      List<RegExpMatch> m =
          AnsiUtils.ansiRegex.allMatches('\x1B[4mcake\x1B[0m').toList();
      expect(m[0].group(0), '\x1B[4m');
      expect(m[1].group(0), '\x1B[0m');
      List<RegExpMatch> m2 = AnsiUtils.ansiRegex
          .allMatches('\x1B]8;;https://github.com\u0007click\x1B]8;;\u0007')
          .toList();
      expect(m2[0].group(0), '\x1B]8;;https://github.com\u0007');
      expect(m2[1].group(0), '\x1B]8;;\u0007');
    });
  });
}
