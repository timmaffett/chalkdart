import 'package:chalkdart/chalkdart.dart';
import 'package:chalkdart/src/chalkdart.dart';
import 'package:chalkdart/src/ansiutils.dart';
import 'package:chalkdart/src/colorutils.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    setUp(() {});

    test('AnsiUtils tests', () {
      expect(AnsiUtils.hasAnsi('\u001B[4mcake\u001B[0m'), isTrue);
      expect(AnsiUtils.hasAnsi('cake'), isFalse);
    });
  });
}

/*

ansiRegex().test('\u001B[4mcake\u001B[0m');
//=> true
ansiRegex().test('cake');
//=> false
'\u001B[4mcake\u001B[0m'.match(ansiRegex());
//=> ['\u001B[4m', '\u001B[0m']
'\u001B[4mcake\u001B[0m'.match(ansiRegex({onlyFirst: true}));
//=> ['\u001B[4m']
'\u001B]8;;https://github.com\u0007click\u001B]8;;\u0007'.match(ansiRegex());
//=> ['\u001B]8;;https://github.com\u0007', '\u001B]8;;\u0007']
```
*/
